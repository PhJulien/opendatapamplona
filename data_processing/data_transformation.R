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

#### Summary data

df_bse_summary <- df_bse %>%
  group_by(year,barrio) %>%
  summarise(mean = sum(n*age,na.rm=TRUE) / sum(n, na.rm=TRUE))


df_bse_summary_sex <- df_bse %>%
  group_by(year,barrio,sex) %>%
  summarise(mean = sum(n*age,na.rm=TRUE) / sum(n, na.rm=TRUE))

head(df_bse_summary)
head(df_bse_summary_sex)


save(df_bse, df_bse_summary, df_bse_summary_sex, file="processed_data/dataset.RData")

