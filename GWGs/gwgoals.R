#GWG for NCAA 2020 analysis

#Input dataset
gwg2020 <- read.csv(file = "GWGs/GWGs2020.csv")

#Rename team column to winning_team, as the school listed is the team that scores the GWG
names(gwg2020)[names(gwg2020) == "team"] <- "winning_team"
names(gwg2020)[names(gwg2020) == "time_setup"] <- "time_elapsed"

#Change half from numeric to character
gwg2020$half <- as.character(gwg2020$half)

#Eliminate unnecessary time columns, as they are columns used to calculate time in Excel
gwg2020 <- gwg2020[ , -which(names(gwg2020) %in% c("ot_time","half_time", "total_time_formula", "minutes", "seconds", "time_formula"))]

#Change abbreviated goal types to full words
gwg2020$goal_type <- as.character(gwg2020$goal_type)
gwg2020$goal_type[gwg2020$goal_type == "UA"] <- "Unassisted"
gwg2020$goal_type[gwg2020$goal_type == "A"] <- "Assisted"
gwg2020$goal_type[gwg2020$goal_type == "FP"] <- "Free Position"

#Graph of GWGs based on time, goal number on y
ggplot(gwg2020, aes(time_in_game, goal_number)) +
  #Show differences in goal types
  geom_point(aes(color = goal_type)) +
  scale_x_continuous("Game Time", breaks = seq(0, 70, 10)) +
  scale_y_continuous("Game Winning Goal", breaks = seq(0,25,by = 5)) +
  theme_bw() + 
  scale_colour_manual(values = c("turquoise", "deeppink", "darkolivegreen2")) +
  labs(title="Game Winning Goal by Goal Type (D1)", colour = "Goal Type" ) +
  #separate into 3 graphs for clearer graphs since > 400 games
  facet_wrap(~ goal_type)

ggplot(gwg2020, aes(time_in_game, goal_number)) +
  geom_point(aes(color = goal_type)) +
  scale_x_continuous("Game Time (min)", breaks = seq(0, 70, 10)) +
  scale_y_continuous("Game Winning Goal", breaks = seq(0,25, by = 5)) +
  scale_colour_manual(values = c("turquoise", "deeppink", "darkolivegreen2")) +
  theme(axis.line = element_line(colour = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank()) +
  labs(title = "Time of Game Winning Goals (D1)", colour = "Goal Type")

#Histogram of how many additional goals were scored for winning team after GWG is scored
ggplot(gwg2020, aes(x = additional_goals)) +
  geom_histogram(binwidth = 1, color = "black", fill = "darkolivegreen2") +
  theme(axis.line = element_line(colour = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank()) +
  labs(title = "Distribution of Winning Team Additional Goals (D1)")+
  xlab("Additional Goals")


#Divided by 1st and 2nd half (3, 4, and 5) will only have 1 additional goal for overtime periods

#Subset into halfs (1 and 2)
fullgame <- gwg2020 %>%
  group_by(half) %>%
  filter(half < 3)

#Calculate mean by group
fullgame_mean <- ddply(fullgame, "half", summarise, grp.mean=mean(additional_goals))
  

ggplot(fullgame, aes(x=additional_goals, fill = half, color=half)) +
  geom_histogram(binwidth = 1, alpha=0.5, position="identity") +
  geom_vline(data=fullgame_mean, aes(xintercept=grp.mean, color=half),
             linetype="dashed") +
  scale_color_manual(values=c("#40e0d0", "#FF1493", "#9966CC")) +
  scale_fill_manual(values=c("#40e0d0", "#FF1493", "#9966CC")) +
  labs(title="Additional Goals after GWG",x="Additional Goals", y = "Count") +
  theme_classic() +
  theme(axis.line = element_line(colour = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank())
  