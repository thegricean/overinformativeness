library(ggplot2)
library(plyr)
theme_set(theme_bw(18))
setwd("~/cogsci/projects/stanford/projects/overinformativeness/Caroline/3_OI_Final_interactive_replication/results/")
source("rscripts/helpers.r")

#load("data/r.RData")
d = read.table(file="data/results.csv",sep="\t", header=T, quote="")
head(d)
nrow(d)
d$speakerMessages
summary(d)
