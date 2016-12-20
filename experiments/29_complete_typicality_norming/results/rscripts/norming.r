library(dplyr)
library(ggplot2)
library(bootstrap)
library(lme4)
library(tidyr)

theme_set(theme_bw(18))
#setwd("/Users/elisakreiss/Documents/stanford/study/overinformativeness/experiments/25_object_norming/results")
setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/29_complete_typicality_norming/results")

theme_set(theme_bw(18))
source("rscripts/helpers.r")

d = read.table(file="data/norming.csv",sep=",", header=T)#, quote="")
head(d)
nrow(d)

totalnrow = nrow(d)
d$Trial = d$slide_number_in_experiment - 1
length(unique(d$workerid))
d$Item = sapply(strsplit(as.character(d$object),"_"), "[", 1)
d$Color = sapply(strsplit(as.character(d$object),"_"), "[", 2)
d$utterance = gsub("^ ","",as.character(d$utterance))
# look at turker comments
unique(d[,c("workerid","comments")])
d$UttColor = sapply(strsplit(as.character(d$utterance)," "), "[", 1)
d$UttType = sapply(strsplit(as.character(d$utterance)," "), "[", 2)
d$Utterance = paste(d$UttColor,d$UttType,sep="_")
d$InvUtterance = paste(d$UttType,d$UttColor,sep="_")
d$Third = ifelse(d$Trial < 110/3, 1, ifelse(d$Trial < 2*(110/3),2,3))

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

# sanity check
d[d$object == d$InvUtterance & d$response < .6,c("workerid","Third","object","utterance","response")]
table(d[d$object == d$InvUtterance & d$response < .6,]$Third)
d = droplevels(d[d$workerid != 12,])
  
items = as.data.frame(table(d$Utterance,d$object))
nrow(items)
colnames(items) = c("Utterance","Object","Freq")
items = items[order(items[,c("Freq")]),]

agr = d %>% 
  group_by(Item,Color,Utterance) %>%
  summarise(MeanTypicality = mean(response), ci.low=ci.low(response),ci.high=ci.high(response))
agr = as.data.frame(agr)
agr$YMin = agr$MeanTypicality - agr$ci.low
agr$YMax = agr$MeanTypicality + agr$ci.high

agr$Combo = paste(agr$Color,agr$Item,sep="_")
agr$Color = as.factor(as.character(agr$Color))

ggplot(agr, aes(x=Combo,y=MeanTypicality,color=Color)) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~Utterance,scales="free_x",nrow=4) +
  scale_color_manual(values=levels(agr$Color)) +
  theme(axis.text.x = element_text(angle=45,size=5,vjust=1,hjust=1))
ggsave("graphs/typicalities.png",height=20, width=35)

# do something awful:
for (u in unique(agr$Utterance)) {
  cat(paste("\"",u,"\" : {\n",sep=""))
  cat(paste(paste(agr[agr$Utterance == u,]$Combo,agr[agr$Utterance == u,]$MeanTypicality,sep=":"),",\n",sep=""))
  cat("},\n")
}


ggplot(d, aes(x=response)) +
  geom_histogram() +
  facet_wrap(~workerid)
ggsave("graphs/subject_variability.png",height=10, width=15)
