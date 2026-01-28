## Script to produce box plots of currents 
## April 29, 2022
## Created by Ashwini Petchiappan

## Libraries
library(ggplot2)
library(dplyr)
library(MetBrewer)

setwd("/Users/ash/Documents/Academic/Turtles/Telemetry/Currents/")

# Data --------------------
tracks = read.csv(file.path("values/currents_turtles.csv"))
tracks$id <- paste("T",tracks$id)
tracks$diff <- abs(tracks$track_azimuth - tracks$currents_azimuth)
tracks = tracks %>%
  mutate(diff = if_else(diff > 180.0, 360.0-diff, diff))
tracks$date = as.Date(tracks$date, format = "%Y-%m-%d %H:%M:%OS")
tracks$year <- as.numeric(format(tracks$date,'%Y'))
tracks$month <- as.character(format(tracks$date,'%m'))

tracks_east = subset(tracks, tracks$Direction == 'East')
tracks_west = subset(tracks, tracks$Direction == 'West')

caz_mean_e = mean(tracks_east$currents_azimuth, na.rm=TRUE)
taz_mean_e = mean(tracks_east$turtle_azimuth, na.rm=TRUE)
traz_mean_e = mean(tracks_east$track_azimuth, na.rm=TRUE)

caz_mean_w = mean(tracks_west$currents_azimuth, na.rm=TRUE)
taz_mean_w = mean(tracks_west$turtle_azimuth, na.rm=TRUE)
traz_mean_w = mean(tracks_west$track_azimuth, na.rm=TRUE)



# Plots------------------
aspect_ratio <- 0.7

#currents azimuth
p <- ggplot(tracks, aes(x = currents_azimuth, fill=Direction))
p + geom_histogram(binwidth=10, boundary=0) +
  coord_polar(start=0) +
  scale_x_continuous(breaks = seq(0, 270, by = 90),
                     labels = c('0', '90', '180', '270')) +
  #scale_y_continuous(breaks = seq(0, 300, by = 150)) +
  scale_fill_manual(values=met.brewer("Java",2),
                    labels = c("East-heading turtle", "West-heading turtle")) +
  
  geom_segment(aes(x = caz_mean_e, y = 349, xend = caz_mean_e, yend = 350),
               arrow = arrow(angle=20, type="closed"), size=0.1, colour="#52205e") +
  geom_segment(aes(x = caz_mean_w, y = 349, xend = caz_mean_w, yend = 350),
               arrow = arrow(angle=20, type="closed"), size=0.1, colour="#e25e1f") +
  
  #guides(fill="none") +
  theme_bw() +
  theme(panel.border = element_blank(),
        panel.grid.minor = element_blank(),
        axis.text.x = element_text(family='Avenir', color="black", size=8),
        axis.text.y = element_text(family='Avenir', color="black", size=6),
        legend.position="bottom") +
  labs(x = element_blank(), y = element_blank(), fill = element_blank())

file_name <- paste("polar_plots/polarhist_ecurrents", ".png", sep="")
ggsave(file_name, dpi="print", height = 4 , width = 4 / aspect_ratio)


#turtle azimuth
p <- ggplot(tracks, aes(x = turtle_azimuth, fill=Direction))
p + geom_histogram(binwidth=10, boundary=0) +
  coord_polar(start=0) +
  scale_x_continuous(breaks = seq(0, 270, by = 90),
                     labels = c('0', '90', '180', '270')) +
  #scale_y_continuous(breaks = NULL) +
  scale_fill_manual(values=met.brewer("Java",2),
                    labels = c("East-heading turtle", "West-heading turtle")) +
  
  geom_segment(aes(x = taz_mean_e, y = 349, xend = taz_mean_e, yend = 350),
               arrow = arrow(angle=20, type="closed"), size=0.1, colour="#52205e") +
  geom_segment(aes(x = taz_mean_w, y = 349, xend = taz_mean_w, yend = 350),
               arrow = arrow(angle=20, type="closed"), size=0.1, colour="#e25e1f") +
  
  theme_bw() +
  theme(panel.border = element_blank(),
        panel.grid.minor = element_blank(),
        axis.text.x = element_text(family='Avenir', color="black", size=8),
        legend.position="bottom") +
  labs(x = element_blank(), y = element_blank(), fill = element_blank())

file_name <- paste("polar_plots/polarhist_turtles", ".png", sep="")
ggsave(file_name, dpi="print", height = 4 , width = 4 / aspect_ratio)

#track azimuth
p <- ggplot(tracks, aes(x = track_azimuth, fill=Direction))
p + geom_histogram(binwidth=10, boundary=0) +
  coord_polar(start=0) +
  scale_x_continuous(breaks = seq(0, 270, by = 90),
                     labels = c('0', '90', '180', '270')) +
  #scale_y_continuous(breaks = NULL) +
  scale_fill_manual(values=met.brewer("Java",2),
                    labels = c("East-heading turtle", "West-heading turtle")) +
  
  geom_segment(aes(x = traz_mean_e, y = 349, xend = traz_mean_e, yend = 350),
               arrow = arrow(angle=20, type="closed"), size=0.1, colour="#52205e") +
  geom_segment(aes(x = traz_mean_w, y = 349, xend = traz_mean_w, yend = 350),
               arrow = arrow(angle=20, type="closed"), size=0.1, colour="#e25e1f") +
  
  theme_bw() +
  theme(panel.border = element_blank(),
        panel.grid.minor = element_blank(),
        axis.text.x = element_text(family='Avenir', color="black", size=8),
        legend.position="bottom") +
  labs(x = element_blank(), y = element_blank(), fill = element_blank())

file_name <- paste("polar_plots/polarhist_ew_tracks", ".png", sep="")
ggsave(file_name, dpi="print", height = 4 , width = 4 / aspect_ratio)


