base_dir = "~/Code/opendatapamplona/"
setwd(base_dir)

load("processed_data/dataset.RData")


barrios <- unique(df_bse_summary$barrio)

years <- unique(df_bse_summary$year)
print(barrios)