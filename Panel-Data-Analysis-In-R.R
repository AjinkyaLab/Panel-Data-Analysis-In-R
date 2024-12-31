


library(tidyverse)
library(readxl)
library(dplyr)

dia_bp_data <- read_csv("C:/Users/Ajinkyaa/OneDrive/Stata to R/New folder/My_First_Project/Dia_BP.csv", col_names = T)

head(dia_bp_data)



# Reshape the data
reshaped_data <- dia_bp_data %>%
  pivot_longer(cols = starts_with("dbp"),
               names_to = "time",
               values_to = "dbp") %>%
  pivot_longer(cols = starts_with("hypertension"),
               names_to = "time_hypertension",
               values_to = "hypertension") %>%
  separate(time, into = c("type", "num"), sep = "_") %>%
  separate(time_hypertension, into = c("type_hypertension", "num_hypertension"), sep = "_") %>%
  filter(num == num_hypertension)

# View the reshaped data
print(reshaped_data)



library(ggplot2)



# Filter the data for treatment A
treatment_A_data <- reshaped_data %>% filter(treatment == "A")

# Plot for treatment A
plot_A <- ggplot(treatment_A_data, aes(x = num, y = dbp, group = id, color = treatment)) +
  geom_line() +  # Line plot to show DBP trend over time
  geom_point(aes(shape = hypertension), size = 3) +  # Add points with different shapes for hypertension stages
  labs(x = "Time Points", y = "DBP", title = "DBP for Each Individual Across Time Points (Treatment A)") +
  facet_wrap(~ id, scales = "free_y") +  # Facet by individual (id)
  theme_minimal() +  # Minimal theme for better appearance
  theme(legend.position = "bottom")  # Position legend at the bottom

# Print plot for treatment A
print(plot_A)

# Filter the data for treatment B
treatment_B_data <- reshaped_data %>% filter(treatment == "B")

# Plot for treatment B
plot_B <- ggplot(treatment_B_data, aes(x = num, y = dbp, group = id, color = treatment)) +
  geom_line() +  # Line plot to show DBP trend over time
  geom_point(aes(shape = hypertension), size = 3) +  # Add points with different shapes for hypertension stages
  labs(x = "Time Points", y = "DBP", title = "DBP for Each Individual Across Time Points (Treatment B)") +
  facet_wrap(~ id, scales = "free_y") +  # Facet by individual (id)
  theme_minimal() +  # Minimal theme for better appearance
  theme(legend.position = "bottom")  # Position legend at the bottom

# Print plot for treatment B
print(plot_B)



library(lattice)
xyplot(dbp ~ as.factor(num) | factor(id),
       data = reshaped_data,
       type = "o",
       lwd = 1.5,
       layout = c(10, 5),
       xlab = "Time Points",
       ylab = "Diastolic Blood Pressure",
       groups = reshaped_data$treatment, # Color lines by treatment group'
       shape = reshaped_data$hypertension,
       auto.key = list(space = "right", title = "Treatment", lines = TRUE, points = FALSE),
       par.settings = list(superpose.line = list(col = c("blue", "red"))) # Define colors for the groups
)


#Let us plot the average DBP at the 5 time points separately for treatment A and B and plot it against time.
mean_dbp <- reshaped_data %>%
  group_by(num, treatment) %>%
  summarise(meandbp = mean(dbp)) %>%
  ungroup()


ggplot(mean_dbp, aes(x = num, y = meandbp, color = treatment, group = treatment)) +
  geom_line(size = 1) +                    
  geom_point(size = 2) +                    
  labs(x = "Time Point",
       y = "Average Diastolic Blood Pressure",
       color = "Treatment") +                 # Label the plot
  theme_bw()


# Load the necessary package
#install.packages("plm")
library(plm)

# Fit the fixed effects model
model1.fe <- plm(dbp ~ num, data = reshaped_data, index = c("id", "num"), 
                 model = "within")

# Summarize the model
summary(model1.fe)



# Interaction between time and treatment
# Treatment "B" as the reference 

reshaped_data$treatment <- relevel(factor(reshaped_data$treatment), ref = "B")

#running the model with interaction term
model2.fe <- plm(dbp ~ num*treatment, data = reshaped_data, index = c("id", "num"), 
                 model = "within")
summary(model2.fe)


# Random Effect Regression Model
# with time and treatment as co variate

model1.re <- plm(dbp ~ num + treatment, data = reshaped_data, index = c("id", "num"), 
                 model = "random")
summary(model1.re)


# Interaction between time and treatment
model2.re <- plm(dbp ~ num*treatment, data = reshaped_data, index = c("id", "num"), 
                 model = "random")
summary(model2.re)


# sex and age as covariates
model3.re <- plm(dbp ~ num*treatment + age + sex, data = reshaped_data, index = c("id", "num"), 
                 model = "random")
summary(model3.re)


# Hausman Test Example
data("Grunfeld", package = "plm")



# Fixed effects model
fe_model <- plm(inv ~ value + capital, data = Grunfeld, model = "within")

# Random effects model
re_model <- plm(inv ~ value + capital, data = Grunfeld, model = "random")

# Hausman test
hausman_test <- phtest(model2.fe, model3.re)
print(hausman_test)



# Load necessary libraries
library(dplyr)
library(ggplot2)
library(ggalluvial)

# Prepare the data for the Sankey diagram
sankey_data <- dia_bp_data %>%
  select(hypertension_1, hypertension_2, hypertension_3, hypertension_4, hypertension_5) %>%
  mutate(id = row_number()) %>%
  pivot_longer(cols = starts_with("hypertension"), 
               names_to = "time_point", values_to = "stage") %>%
  mutate(time_point = factor(time_point, 
                             levels = c("hypertension_1", "hypertension_2", 
                                        "hypertension_3", "hypertension_4", 
                                        "hypertension_5")))

# Add counts for clear flow
transition_counts <- sankey_data %>%
  group_by(time_point, stage) %>%
  summarise(count = n(), .groups = "drop")

# Plot Sankey diagram with numbers
ggplot(sankey_data, aes(x = time_point, stratum = stage, alluvium = id, fill = stage, label = stage)) +
  geom_flow(stat = "alluvium", aes.bind = "alluvia") +
  geom_stratum() +
  geom_text(stat = "stratum", aes(label = after_stat(count)), size = 3, color = "black") +
  scale_fill_brewer(type = "qual", palette = "Set3") +
  theme_minimal() +
  labs(title = "Sankey Diagram of Hypertension Stages Over Time",
       x = "Time Points",
       y = "Count") +
  theme(legend.position = "bottom",
        plot.title = element_text(hjust = 0.5, size = 14),
        axis.text.x = element_text(size = 12))












