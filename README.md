# Panel-Data-Analysis-In-R

**Panel Data Analysis in R**

**Overview**

This project explores the impact of two treatments (A and B) on diastolic blood pressure (DBP) using panel data regression models. The analysis utilizes both fixed and random effects models to compare treatments over time.

**Features**

•	Reshaping and preparing panel data for analysis.

•	Visualization of DBP trends and hypertension stages across individuals and time points.

•	Implementation of Fixed Effects and Random Effects models.

•	Hausman test for model selection.

•	Sankey diagram to visualize transitions in hypertension stages over time.

**Tools and Libraries**

•	R Programming Language

•	Libraries:

o	tidyverse

o	ggplot2

o	plm

o	ggalluvial

**Workflow**

Step 1: Data Import

The dataset Dia_BP.csv was imported for analysis.

**Step 2: Data Reshaping**

•	Reshaped DBP and hypertension data for panel data structure.

•	Merged columns into a long format for easier analysis.

**Step 3: Data Visualization**

•	Created individual DBP trends for treatments A and B.

•	Visualized mean DBP across time points for both treatments.

**Step 4: Regression Modeling**

•	Fixed Effects Model: Assessed within-individual variations.

•	Random Effects Model: Evaluated between-individual variations.

•	Hausman Test: Determined the preferred model.

**Step 5: Advanced Visualizations**

•	Sankey diagram illustrating transitions in hypertension stages over time.

**Results**

•	Fixed Effects Model: Revealed significant within-individual DBP trends.

•	Random Effects Model: Provided insights into the influence of treatment and time.

•	Hausman Test: Supported the Fixed Effects model as the preferred choice.

•	Sankey diagram showcased clear transitions in hypertension stages.

**How to Run**

1.	Clone the repository: git clone https://github.com/AjinkyaLab/panel-data-analysis.git

2.	Ensure you have R and the necessary libraries installed.

3.	Run the panel_data_analysis.R script.

