library(dplyr)
library(ggplot2)
library(bootstrap)
library(lme4)
library(tidyr)

theme_set(theme_bw(18))
setwd("/Users/elisakreiss/Documents/Stanford/overinformativeness/experiments/elisa_paper_relevant/norming_comp_object/results")
source("rscripts/helpers.r")

d = read.table(file="../part1/results/data/norming.csv",sep=",", header=T)#, quote="")
d$fit = TRUE
d1 = read.table(file="../part2/results/data/norming.csv",sep=",", header=T)#, quote="")
d1$fit = FALSE
head(d)
nrow(d)
nrow(d1)
d1$workerid = d1$workerid + 60
d = rbind(d,d1)
summary(d)

totalnrow = nrow(d)
d$Trial = d$slide_number_in_experiment - 1
length(unique(d$workerid))
d$Item = sapply(strsplit(as.character(d$object),"_"), "[", 1)
d$Color = sapply(strsplit(as.character(d$object),"_"), "[", 2)
# look at turker comments
unique(d[,c("workerid","comments")])

# exclude one worker who did the hit wrong
d = d[d$workerid != 16,]
nrow(d)
#d = subset(d, workerid != 16)

ggplot(d, aes(x=response,fill=Color)) +
  geom_histogram(position="dodge") +
  geom_density(alpha=.4,color="gray80") +
  facet_wrap(~Item,nrow=2,scales="free")
ggsave("graphs/typicalities_histograms.pdf",height=5,width=10)

nocups = d[grep("cup",d$object,invert=T),]
nocups = nocups[grep("purple",nocups$object,invert=T),]
# nocups = nocups[grep("pepper_green",nocups$object,invert=T),]
nocups = nocups[grep("cup",nocups$utterance,invert=T),]
nocups = nocups[grep("fruit",nocups$utterance,invert=T),]
nocups = nocups[grep("vegetable",nocups$utterance,invert=T),]
nocups = droplevels(nocups)

df = nocups
df$Color = ifelse(df$Color == 'pink', 'purple', df$Color)


agr = df %>% 
  group_by(Item,Color,utterance,fit) %>%
  summarise(MeanTypicality = mean(response), ci.low=ci.low(response),ci.high=ci.high(response))
agr = as.data.frame(agr)
agr$YMin = agr$MeanTypicality - agr$ci.low
agr$YMax = agr$MeanTypicality + agr$ci.high

agr$Combo = paste(agr$Color,agr$Item)
agr$Color = as.factor(as.character(agr$Color))
# agr$OrdCombo = factor(agr$Combo, levels=agr[order(agr$MeanTypicality), "Combo"])
# agr$OrdCombo = factor(x=as.character(agr$Combo), levels=agr[order(agr$MeanTypicality,decreasing=T), "Combo"])
# agr = agr[order(agr[,c("MeanTypicality")],decreasing=T),]

ggplot(agr, aes(x=Combo,y=MeanTypicality,color=fit)) +
  geom_point(size=2) +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~utterance,scales="free_x",nrow=4) +
  xlab("Objects") +
  ylab("Typicality") +
  theme(axis.title.y = element_text(margin = margin(t = 0, r = 55, b = 0, l = 0))) +
  theme(axis.title=element_text(size=40,colour="#757575")) +
  theme(axis.text.x=element_text(size=28,colour="#757575",angle=45,vjust=1,hjust=1)) +
  theme(axis.text.y=element_text(size=20,colour="#757575")) +
  theme(axis.ticks=element_line(size=.25,colour="#757575"), axis.ticks.length=unit(.75,"mm")) +
  theme(legend.title=element_text(size=35,color="#757575")) +
  theme(legend.text=element_text(size=30,colour="#757575")) +
  theme(strip.text.x=element_text(size=28)) +
  theme(strip.background=element_rect(colour="#939393",fill="lightgrey")) +
  theme(legend.position = "top") +
  labs(color = "Consistent Trials") +
  theme(panel.background=element_rect(colour="#939393")) 
# ggsave("graphs/typicalities_fitvsnonfit.png",height=11, width=15)
ggsave("../../../../../../Uni/BachelorThesis/graphs/typnounobj_fitvsnonfit.png",height=16.5, width=25)

