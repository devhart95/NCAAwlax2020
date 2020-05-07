#2020 Schedule uploads to find streams / begin tracking

#Upload csv files
data_dir <- "NCAA2020 copy"
fs::dir_ls(data_dir)

csv_files <- fs::dir_ls(data_dir, regexp = "\\.csv$")
csv_files

ncaa2020 <- csv_files %>% 
  map_dfr(read_csv)

#Delete empty location column
ncaa2020 <- ncaa2020[,-(8)]

#Get only complete rows
ncaawlax2020 <- ncaa2020[complete.cases(ncaa2020), ]

#Delete empty alternating rows
toDelete <- seq(1, nrow(ncaa2020), 2)
ncaa2020 <- ncaa2020[-toDelete ,]

#Add in empty columns for printout
ncaawlax2020$Stream <- ""
ncaawlax2020$Tracked <- ""

#Filter only wins to eliminate potential duplicate games
wins <- ncaawlax2020 %>%
  filter(Result == "W")

#Print out to begin tracking streaming locations / completions
write.csv(wins,"NCAA2020 copy\\StreamTracker.csv", row.names = FALSE)
