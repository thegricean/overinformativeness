theme_set(theme_bw(18))
setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/basic_level_reference/")

source("rscripts/helpers.r")
d = read.csv("modelOutput_dog.csv",quote="")
head(d)
str(d)
d$Utterance = factor(x=ifelse(d$label == "basicLevel","basic",ifelse(d$label == "superDomain","super","sub")),levels=c("sub","basic","super"))
  
ggplot(d, aes(x=Utterance,y=prob,color=as.factor(priorWeight))) +
  geom_point() +
  facet_wrap(~condition)
ggsave("graphs/uttprob-bycondition-byutterance.pdf")

ggplot(d, aes(x=condition,y=prob,color=as.factor(priorWeight))) +
  geom_point() +
  facet_wrap(~Utterance)
ggsave("graphs/uttprob-byutterance-bycondition.pdf",width=12)

agr = d %>% 
  group_by(Utterance,condition,priorWeight) %>%
  summarise(MeanProb=mean(prob),ci.low=ci.low(prob),ci.high=ci.high(prob))
agr = as.data.frame(agr)
agr$YMin = agr$MeanProb - agr$ci.low
agr$YMax = agr$MeanProb + agr$ci.high

ggplot(agr, aes(x=condition,y=MeanProb,color=as.factor(priorWeight))) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~Utterance)
ggsave("graphs/uttprob-byutterance-bycondition-errbars.pdf",width=12)