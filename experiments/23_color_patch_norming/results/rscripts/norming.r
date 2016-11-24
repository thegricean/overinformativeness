library(dplyr)
library(ggplot2)
library(bootstrap)
library(lme4)
library(tidyr)

theme_set(theme_bw(18))
setwd("/Users/elisakreiss/Documents/stanford/study/overinformativeness/experiments/23_color_patch_norming/results")
setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/23_color_patch_norming/results")

theme_set(theme_bw(18))
source("rscripts/helpers.r")

d = read.table(file="data/norming.csv",sep=",", header=T)#, quote="")
d1 = read.table(file="/Users/elisakreiss/Documents/stanford/study/overinformativeness/experiments/27_23_added_items/results/data/norming.csv",sep=",", header=T)#, quote="")
head(d)
nrow(d)
nrow(d1)

d1$workerid = d1$workerid + 60
d = rbind(d,d1)
summary(d)

totalnrow = nrow(d)
d$Trial = d$slide_number_in_experiment - 1
length(unique(d$workerid))
d$Item = sapply(strsplit(as.character(d$item_color),"_"), "[", 1)
d$Color = sapply(strsplit(as.character(d$item_color),"_"), "[", 2)
# look at turker comments
unique(d[,c("workerid","comments")])

# exclude one worker who did the hit wrong
# d = d[d$workerid != 16,]
nrow(d)
#d = subset(d, workerid != 16)

ggplot(d, aes(rt)) +
  geom_histogram() +
  scale_x_continuous(limits=c(0,10000))

ggplot(d, aes(log(rt))) +
  geom_histogram() 

summary(d$Answer.time_in_minutes)
ggplot(d, aes(Answer.time_in_minutes)) +
  geom_histogram()

ggplot(d, aes(gender)) +
  stat_count()

ggplot(d, aes(asses)) +
  stat_count()

ggplot(d, aes(age)) +
  geom_histogram()
table(d$age)

ggplot(d, aes(education)) +
  stat_count()

ggplot(d, aes(language)) +
  stat_count()

ggplot(d, aes(enjoyment)) +
  stat_count()

ggplot(d, aes(Item)) +
  stat_count()

ggplot(d, aes(Color)) +
  stat_count()


items = as.data.frame(table(d$color_utterance,d$item_color))
nrow(items)
colnames(items) = c("Utterance","Object","Freq")
items = items[order(items[,c("Freq")]),]
items = items[grep("cup",items$Object,invert=T),]
items = items[grep("purple",items$Object,invert=T),]
items = items[grep("pepper_green",items$Object,invert=T),]
items = items[grep("cup",items$Utterance,invert=T),]
nrow(items)
write.csv(items[1:74,c("Utterance","Object")],file="data/rerun.csv",row.names=F,quote=F)

nocups = d[grep("cup",d$item_color,invert=T),]
nocups = nocups[grep("cup",nocups$item_color,invert=T),]
nocups = nocups[grep("pepper_green",nocups$item_color,invert=T),]
nocups = nocups[grep("purple",nocups$item_color,invert=T),]
nocups = nocups[grep("purple",nocups$color_utterance,invert=T),]
nocups = droplevels(nocups)

agr = nocups %>% 
  group_by(Item,Color,color_utterance) %>%
  summarise(MeanTypicality = mean(response), ci.low=ci.low(response),ci.high=ci.high(response))
agr = as.data.frame(agr)
agr$YMin = agr$MeanTypicality - agr$ci.low
agr$YMax = agr$MeanTypicality + agr$ci.high

agr$Combo = paste(agr$Color,agr$Item)
agr$Color = as.factor(as.character(agr$Color))
#agr$OrdCombo = factor(agr$Combo, levels=agr[order(agr$MeanTypicality), "Combo"])
#agr$OrdCombo = factor(x=as.character(agr$Combo), levels=agr[order(agr$MeanTypicality,decreasing=T), "Combo"])
#agr = agr[order(agr[,c("MeanTypicality")],decreasing=T),]

ggplot(agr, aes(x=Combo,y=MeanTypicality,color=Color)) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~color_utterance,scales="free_x",nrow=4) +
  scale_color_manual(values=levels(agr$Color)) +
  theme(axis.text.x = element_text(angle=45,size=5,vjust=1,hjust=1))
ggsave("graphs/merged_typicalities.png",height=9, width=15)
