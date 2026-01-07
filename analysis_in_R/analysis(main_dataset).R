library(tidyverse)
library(readxl)

symptom_raw <- read_xlsx(
  "C:/Users/lenovo/OneDrive/Desktop/dataset/datasett.xlsx"
)

glimpse(symptom_raw)

names(symptom_raw)
symptom_cols <- grep("^Symptom_", names(symptom_raw), value = TRUE)
symptom_clean <- symptom_raw %>%
  mutate(across(
    all_of(symptom_cols),
    ~ .x %>%
      as.character() %>%
      str_to_lower() %>%
      str_trim() %>%
      na_if("na") %>%
      na_if("nan") %>%
      na_if("") %>%
      na_if("none")
  ))

long_df <- symptom_clean %>%
  pivot_longer(
    cols = all_of(symptom_cols),
    names_to = "symptom_order",
    values_to = "symptom"
  ) %>%
  filter(!is.na(symptom))

long_df <- long_df %>%
  distinct(Disease, symptom)
symptom_matrix <- long_df %>%
  mutate(value = 1) %>%
  pivot_wider(
    names_from = symptom,
    values_from = value,
    values_fill = 0
  )

nrow(symptom_matrix)

ncol(symptom_matrix)

sum(is.na(symptom_matrix))

long_df
print(long_df,n = 300)
write_csv(
  long_df,
  "C:/Users/lenovo/OneDrive/Desktop/dataset/symptoms_clean_long.csv"
)
write_csv(
  symptom_matrix,
  "C:/Users/lenovo/OneDrive/Desktop/dataset/symptoms_matrix_wide.csv"
)
install.packages("writexl")
library(writexl)
write_xlsx(
  list(
    long_data = long_df,
    symptom_matrix = symptom_matrix
  ),
  "C:/Users/lenovo/OneDrive/Desktop/dataset/symptoms_cleaned.xlsx"
)

