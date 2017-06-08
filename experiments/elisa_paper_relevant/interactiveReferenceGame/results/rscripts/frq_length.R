library(dplyr)
library(ggplot2)
library(bootstrap)
library(lme4)
library(tidyr)
library(rjson)

theme_set(theme_bw(18))
setwd("/Users/elisakreiss/Documents/Stanford/overinformativeness/experiments/elisa_paper_relevant/interactiveReferenceGame/results")
source("rscripts/helpers.r")

frq = t(as.data.frame(fromJSON(file='../../../../models/11_visualization/refModule/json/frequencies.json')))
length = t(as.data.frame(fromJSON(file='../../../../models/11_visualization/refModule/json/lengths.json')))
d = as.data.frame(rownames(frq))
d$target = d$`rownames(frq)`
d$frq = frq[,1]
d$length = length[,1]

agr = d %>%
  select(target,frq,length)

blub = round(cor.test(agr$frq,agr$length)$estimate,4)*100
blub2 = paste("correlation: ",blub,"%")

ggplot(agr,aes(x=length,y=frq)) +
  geom_point() +
  annotate("text", x=12.5, y=-3.5, label= blub2)
ggsave("graphs/frq_length_corr.png",height=8.0,width=12)
