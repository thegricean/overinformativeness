library(dplyr)
library(ggplot2)
library(bootstrap)
library(lme4)

theme_set(theme_bw(18))
setwd("/Users/elisakreiss/Documents/stanford/study/overinformativeness/experiments/11_color_norming/results")

theme_set(theme_bw(18))
# setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/11_color_norming/results")
source("rscripts/helpers.r")

d = read.table(file="data/norming.csv",sep=",", header=T)#, quote="")
head(d)
nrow(d)
summary(d)
totalnrow = nrow(d)
d$Trial = d$slide_number_in_experiment - 1
length(unique(d$workerid))
d$Item = sapply(strsplit(as.character(d$item),"_"), "[", 1)
d$Color = sapply(strsplit(as.character(d$item),"_"), "[", 2)
# look at turker comments
unique(d$comments)

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

ggplot(d, aes(item)) +
  stat_count() +
  theme(axis.text.x = element_text(angle=45,hjust=1,vjust=1))
  
ggplot(d, aes(x=response,fill=Color)) +
  geom_histogram(position="dodge") +
  geom_density(alpha=.4,color="gray80") +
  facet_wrap(~Item,nrow=2,scales="free")
ggsave("graphs/typicalities_histograms.pdf",height=5,width=10)

agr = d %>% 
  group_by(Item,Color) %>%
  summarise(MeanTypicality = mean(response), ci.low=ci.low(response),ci.high=ci.high(response))
agr = as.data.frame(agr)
agr$YMin = agr$MeanTypicality - agr$ci.low
agr$YMax = agr$MeanTypicality + agr$ci.high

ggplot(agr, aes(MeanTypicality)) +
  geom_histogram()

agr$Combo = paste(agr$Color,agr$Item)
agr$OrdCombo = factor(agr$Combo, levels=agr[order(agr$MeanTypicality), "Combo"])

ggplot(agr, aes(x=OrdCombo,y=MeanTypicality)) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~Item,scales="free_x",nrow=2) +
  theme(axis.text.x = element_text(angle=45,vjust=1,hjust=1))
ggsave("graphs/typicalities.png",height=5.5)

agr$Typicality = agr$MeanTypicality
write.csv(agr[,c("Item","Color","Typicality","YMin","YMax")], file="data/meantypicalities.csv",row.names=F,quote=F)

