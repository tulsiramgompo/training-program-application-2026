# ---------------------------------------------------------

# Melbourne Bioinformatics Training Program

# This exercise to assess your familiarity with R and git. Please follow
# the instructions on the README page and link to your repo in your application.
# If you do not link to your repo, your application will be automatically denied.

# Leave all code you used in this R script with comments as appropriate.
# Let us know if you have any questions!


# You can use the resources available on our training website for help:
# Intro to R: https://mbite.org/intro-to-r
# Version Control with Git: https://mbite.org/intro-to-git/

# ----------------------------------------------------------

# Load libraries -------------------
library(tidyverse)
library(readr)
library(dplyr)

# Load data here ----------------------
# Load each file with a meaningful variable name.
gene_count<-read_csv("https://raw.githubusercontent.com/tulsiramgompo/training-program-application-2026/refs/heads/main/data/GSE60450_GeneLevel_Normalized(CPM.and.TMM)_data.csv")

info_data<-read_csv("https://raw.githubusercontent.com/tulsiramgompo/training-program-application-2026/refs/heads/main/data/GSE60450_filtered_metadata.csv")

# Inspect the data -------------------------
# What are the dimensions of each data set? (How many rows/columns in each?)
#gene_count has  23,735 rows and  14 columns
#info_data has  12 rows and  4 columns
# Keep the code here for each file.
## Expression data
dim(gene_count)
## Metadata
dim(info_data)

# Prepare/combine the data for plotting ------------------------
#Ans: Need to make gene_count in long format to match the meta data as follows.
gene_data <- pivot_longer(gene_count, cols = starts_with("GSM"), 
                       names_to = "Sample", values_to = "Count")
# How can you combine this data into one data.frame?
#Ans: we can combine data matching "unique sample_ID" of both the data. For this we need to use full_join() function and give command to join two data sets as follows.
final_data <- full_join(gene_data, info_data, by = join_by(Sample == sample_id))
head(final_data)

# Plot the data --------------------------
## Plot the expression by cell type
#Making box Plot for the data
p1 <- final_data %>%
  rename(cell_type=characteristics) %>%
  ggplot(aes(x= cell_type, y=Count)) +
  geom_boxplot()

#Tidy way of making Plot, we can take log count of genes because this data has wider ranges which need normalisation of the counts. 
p2 <-ggplot(data = final_data,  aes(x = Sample, y = log2(Count))) + 
  geom_boxplot()

## Save the plot
### Show code for saving the plot with ggsave() or a similar function
library(ggplot2)
ggsave("boxplot.png", plot = p2, width = 6, height = 4, dpi = 300)
