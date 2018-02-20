#### This files takes the original opem data files and transform them into a more suitable format for the application


### Setting from which dir the files should be loaded. Change this for new local installations.

base_dir = "~/Code/opendatapamplona/"
setwd(base_dir)

library(dplyr)
library(reshape2)


##### Barrio ~ Sexo + Edad

#### Reshaping
df_bse_raw <- read.csv("data/barrio_edad_sexo.csv", sep=";")

df_bse_raw <- df_bse_raw %>%
  mutate(BARRIO = as.character(BARRIO),
        BARRIO = gsub('\xd1','Ñ', BARRIO),
         BARRIO = gsub('\xf1', 'ñ', BARRIO),
        BARRIO = gsub('AZPILAGAÑA', 'Azpilagaña', BARRIO),
        BARRIO = as.factor(BARRIO))

df_bse <- melt(df_bse_raw, id.vars=c("ANYO", "BARRIO", "SEXO"))
colnames(df_bse) <- c("year", "barrio", "gender", "age", "n")

df_bse <- df_bse %>%
  mutate(sex = ifelse(gender=='Mujer', "M", "H"),
         age = as.numeric(gsub("X", "", age)),
         n = as.numeric(n))

head(df_bse)

### Age pyramid data

get_age_category <- function(a) {
  category = '100+'
  if(a >= 0 & a < 5) {category <- "0 - 4"}
  if(a >= 5 & a < 10) {category <- "5 - 9"}
  if(a >= 10 & a < 15) {category <- "10 - 14"}
  if(a >= 15 & a < 20) {category <- "15 - 19"}
  if(a >= 20 & a < 25) {category <- "20 - 24"}
  if(a >= 25 & a < 30) {category <- "25 - 29"}
  if(a >= 30 & a < 35) {category <- "30 - 34"}
  if(a >= 35 & a < 40) {category <- "35 - 39"}
  if(a >= 40 & a < 45) {category <- "40 - 44"}
  if(a >= 45 & a < 50) {category <- "45 - 49"}
  if(a >= 50 & a < 55) {category <- "50 - 54"}
  if(a >= 55 & a < 60) {category <- "55 - 59"}
  if(a >= 60 & a < 65) {category <- "60 - 64"}
  if(a >= 65 & a < 70) {category <- "65 - 69"}
  if(a >= 70 & a < 75) {category <- "70 - 74"}
  if(a >= 75 & a < 80) {category <- "75 - 79"}
  if(a >= 80 & a < 85) {category <- "80 - 84"}
  if(a >= 85 & a < 90) {category <- "85 - 89"}
  if(a >= 90 & a < 95) {category <- "90 - 94"}
  if(a >= 95 & a < 100) {category <- "95 - 99"}  
  
  return(category)
  }

df_bse_pyramid <- df_bse %>%
  filter(!is.na(n)) %>%
  mutate(age = round(as.numeric(age))) %>%
  mutate(age_category = sapply(age, get_age_category)) %>%
  group_by(year, barrio, sex, age_category) %>%
  summarise(n=sum(n, na.rm=TRUE)) %>%
  ungroup() %>%
  mutate(age_category = ordered(age_category, levels = c("0 - 4", "5 - 9", "10 - 14", "15 - 19", "20 - 24", "25 - 29", "30 - 34", "35 - 39", "40 - 44", "45 - 49", "50 - 54",
                                                        "55 - 59", "60 - 64", "65 - 69", "70 - 74", "75 - 79", "80 - 84", "85 - 89", "90 - 94", "95 - 99", '100+')))

#### Summary data

df_bse_summary <- df_bse %>%
  group_by(year,barrio) %>%
  summarise(mean = sum(n*age,na.rm=TRUE) / sum(n, na.rm=TRUE))


df_bse_summary_sex <- df_bse %>%
  group_by(year,barrio,sex) %>%
  summarise(mean = sum(n*age,na.rm=TRUE) / sum(n, na.rm=TRUE))

head(df_bse_summary)
head(df_bse_summary_sex)


save(df_bse, df_bse_summary, df_bse_summary_sex, df_bse_pyramid, file="processed_data/dataset.RData")

