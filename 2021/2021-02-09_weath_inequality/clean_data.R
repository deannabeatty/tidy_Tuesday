library(tidyverse)
library(readxl)

### Urban Institute

# Student Debt ------------------------------------------------------------

student_debt_raw <- read_excel("raw/StudentLoans.xlsx", skip = 1)

student_debt_val <- student_debt_raw %>%
  rename(year = 1) %>%
  slice(1:10) %>%
  arrange(desc(year)) %>%
  pivot_longer(cols = -year, names_to = "race", values_to = "loan_debt") %>%
  mutate(across(c(year, loan_debt), as.double))

student_debt_pct <- student_debt_raw %>%
  rename(year = 1) %>%
  slice(14:23) %>%
  arrange(desc(year)) %>%
  pivot_longer(cols = -year, names_to = "race", values_to = "loan_debt_pct") %>%
  mutate(across(c(year, loan_debt_pct), as.double))

student_debt <- left_join(student_debt_val, student_debt_pct, by = c("year", "race"))

student_debt 

student_debt %>% 
  write_csv("clean/student_debt.csv")


# Retirement --------------------------------------------------------------


retirement_raw <- read_excel("raw/Retirement.xlsx", skip = 1)

retirement <- retirement_raw %>%
  rename(year = 1) %>%
  slice(1:10) %>%
  mutate(across(everything(), as.double)) %>%
  pivot_longer(-year, names_to = "race", values_to = "retirement")

retirement %>% 
  write_csv("clean/retirement.csv")


# Home Ownership ----------------------------------------------------------

home_raw <- read_excel("raw/Homeownership.xlsx", skip = 1)

home_owner <- home_raw %>%
  rename(year = 1) %>%
  filter(!is.na(Black)) %>%
  mutate(across(everything(), as.double)) %>%
  pivot_longer(-year, names_to = "race", values_to = "home_owner_pct")

home_owner %>% 
  write_csv("clean/home_owner.csv")
