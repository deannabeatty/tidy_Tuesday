library(tidyverse)
library(tidytuesdayR)
library(readxl)
library(ggplot2)
library(cowplot)
library(scales)

# Get the Data

# Read in with tidytuesdayR package 
# Install from CRAN via: install.packages("tidytuesdayR")
# This loads the readme and all the datasets for the week of interest

# Either ISO-8601 date or year/week works!

tuesdata <- tidytuesdayR::tt_load('2021-02-09')
#tuesdata <- tidytuesdayR::tt_load(2021, week = 7)

# Or read in the data manually

# lifetime_earn <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-02-09/lifetime_earn.csv')
# student_debt <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-02-09/student_debt.csv')
# retirement <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-02-09/retirement.csv')
# home_owner <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-02-09/home_owner.csv')
# race_wealth <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-02-09/race_wealth.csv')
# income_time <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-02-09/income_time.csv')
# income_limits <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-02-09/income_limits.csv')
# income_aggregate <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-02-09/income_aggregate.csv')
# income_distribution <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-02-09/income_distribution.csv')
# income_mean <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-02-09/income_mean.csv')

#view readme.md file associated with tidytuesday github repo 
tuesdata

student_debt <- tuesdata$student_debt
student_debt$year <- as.factor(student_debt$year)
student_debt$Race <- as.factor(student_debt$race)

ggplot(data = student_debt,mapping = aes(x = year, y = loan_debt, color = race)) + geom_point() +
  geom_line() +
  ylab("Student loan debt (avg. per family)") +
  labs(fill="Race")

retirement <- tuesdata$retirement
retirement$Race <- as.factor(retirement$race)  
       
plot_retirement <- ggplot(data = retirement,aes(x = year, y = retirement, color = race)) + 
  geom_point() +
  ylab("Family liquid retirement savings (avg. USD) \n normalized to 2016 dollars") +
  labs(color = "Race") 
  
plot_retirement

home_owner <- tuesdata$home_owner
home_owner$Race <- as.factor(home_owner$race)  

plot_home <-  ggplot(data = home_owner,aes(x = year, y = home_owner_pct, color = race)) + 
  geom_point() +
  ylab("Home ownership percentage") +
  labs(color = "Race") +
  scale_y_continuous(labels = percent) 

plot_home

plot_grid(plot_home,plot_retirement, labels = c("A","B"))

ggsave(file = "plots/cowplot_home_ownership_retirement_savings.png", 
       dpi = 1000, device = "png", width = 11, height = 8.5, units = "in")

