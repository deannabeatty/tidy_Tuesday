# TidyTuesday Dubois Challenge

# load packages
library(tidyverse)
library(dplyr)
library(tidytuesdayR)
library(extrafont)
#library(ggTimeSeries)

# install streamgraph
# devtools::install_github("hrbrmstr/streamgraph")
# load package
#library(streamgraph)

# Read in data with tidytuesdayR package 
# Install from CRAN via: install.packages("tidytuesdayR")
# This loads the readme and all the datasets for the week of interest

# Either ISO-8601 date or year/week works!

tuesdata <- tidytuesdayR::tt_load('2021-02-16')
#tuesdata <- tidytuesdayR::tt_load(2021, week = 8)

georgia_pop <- tuesdata$georgia_pop
census <- tuesdata$census
furniture <- tuesdata$furniture
city_rural <- tuesdata$city_rural
income <- tuesdata$income
freed_slaves <- tuesdata$freed_slaves
occupation <- tuesdata$occupation
conjugal <- tuesdata$conjugal

font = "Andale Mono"

# structure of object
str(freed_slaves)

# make year a factor
# freed_slaves$Year <-  as.factor(freed_slaves$Year)

# create column total (sum of free & enslaved)
freed_slaves$Total <- freed_slaves$Slave + freed_slaves$Free

# convert from wide to long format with gather function
freed_slaves_gather <-  gather(freed_slaves, status, proportion, Slave, Free)

# invert scale
# freed_slaves_gather$inverse_proportion <- freed_slaves_gather$Total - freed_slaves_gather$proportion
# freed_slaves_gather %>% 
#   select(status) %>% 
#   mutate(status=recode_factor(status, 'Free' = 'Slave', 'Slave' = 'Free'))

DuboisPlot <- ggplot(freed_slaves_gather,
       aes(x = Year,
           y = proportion,
           group = status,
           fill = status)) +
  #stat_steamgraph(show.legend = FALSE) +
  geom_area() +
  scale_fill_manual(values = c("darkgreen", "black")) + 
  annotate("text", label = "SLAVES \n ESCLAVES", x = 1828, y = 50, 
           color = "white", family = font, size = 5.5) +
  annotate("text", label = "FREE - LIBRE", x = 1828, y = 93, 
           color = "Black", family = font, size = 5.5) +
  scale_color_manual(values=c("darkgreen", "black")) +
  scale_x_continuous(breaks = c(unique(freed_slaves_gather$Year)), position= "top") + 
  theme(axis.title=element_blank(),
         # axis.text.y=element_blank(),
         # axis.ticks.y=element_blank(),
        plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5),
        panel.background = element_blank(), 
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        text = element_text(family = "Arial"),
        legend.position = "none") +
  labs(title = "PROPORTION OF FREEMEN AND SLAVES AMONG AMERICAN NEGROES . \n\n 
          PROPORTION DES NEGRES LIBRES ET DES ESCLAVES EN AMERIQUE . \n\n", 
          subtitle = "DONE BY ATLANTA UNIVERSITY \n", hjust = 0.5 )

DuboisPlot

ggsave(DuboisPlot, filename = "plot/Dubois_freed_slaves.png", device = "png", dpi = 300, width = 11, height = 8.5)

# try out streamgraph for interactive plot
sg <- streamgraph(freed_slaves_gather, key="status", value="proportion",
            date="Year", height="300px", width="1000px") %>% 
  sg_annotate(label = "FREE", x = 1840, y = 40) %>% 
  sg_fill_manual(c("black", "darkgreen"))
sg
