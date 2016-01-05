theme_set(theme_bw(18))
setwd("/Users/cocolab/overinformativeness/models/basic_level_reference/")
#setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/basic_level_reference/")

source("rscripts/helpers.r")
d = read.csv("modelOutput_priorWeight0.05/modelOutput_car_0.05.csv",quote="")
head(d)
str(d)
d$Utterance = factor(x=ifelse(d$label == "basicLevel","basic",ifelse(d$label == "superDomain","super","sub")),levels=c("sub","basic","super"))
  
ggplot(d, aes(x=Utterance,y=prob,color=as.factor(priorWeight))) +
  geom_point() +
  facet_wrap(~condition)
ggsave("graphs/priorWeight_0.05/uttprob-bycondition-byutterance_car.pdf",width=12)

ggplot(d, aes(x=condition,y=prob,color=target)) +
  geom_point() +
  facet_wrap(~Utterance)
ggsave("graphs/priorWeight_0.05/uttprob-byutterance-bycondition_car.pdf",width=12)

agr = d %>% 
  group_by(Utterance,condition,priorWeight) %>%
  summarise(MeanProb=mean(prob),ci.low=ci.low(prob),ci.high=ci.high(prob))
agr = as.data.frame(agr)
agr$YMin = agr$MeanProb - agr$ci.low
agr$YMax = agr$MeanProb + agr$ci.high

ggplot(agr, aes(x=Utterance,y=MeanProb,color=as.factor(priorWeight))) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~condition)
ggsave("graphs/priorWeight_0.05/uttprob-bycondition-byutterance-errbars_car.pdf",width=12)

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
ggsave("graphs/priorWeight_0.05/uttprob-byutterance-bycondition-errbars_car.pdf",width=12)



# graphs for different priorWeights:

all = read.csv("modelOutput_all.csv",quote="")
head(all)
str(all)
all$Utterance = factor(x=ifelse(all$label == "basicLevel","basic",ifelse(all$label == "superDomain","super","sub")),levels=c("sub","basic","super"))

ggplot(all, aes(x=Utterance,y=prob,color=as.factor(priorWeight))) +
  geom_point() +
  facet_wrap(~condition)
ggsave("graphs/uttprob-bycondition-byutterance_all.pdf",width=12)

ggplot(all, aes(x=condition,y=prob,color=as.factor(priorWeight))) +
  geom_point() +
  facet_wrap(~Utterance)
ggsave("graphs/uttprob-byutterance-bycondition_all.pdf",width=12)

agr = all %>% 
  group_by(Utterance,condition,priorWeight) %>%
  summarise(MeanProb=mean(prob),ci.low=ci.low(prob),ci.high=ci.high(prob))
agr = as.data.frame(agr)
agr$YMin = agr$MeanProb - agr$ci.low
agr$YMax = agr$MeanProb + agr$ci.high

ggplot(agr, aes(x=Utterance,y=MeanProb,color=as.factor(priorWeight))) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~condition)
ggsave("graphs/uttprob-bycondition-byutterance-errbars_all.pdf",width=12)

agr = all %>% 
  group_by(Utterance,condition,priorWeight) %>%
  summarise(MeanProb=mean(prob),ci.low=ci.low(prob),ci.high=ci.high(prob))
agr = as.data.frame(agr)
agr$YMin = agr$MeanProb - agr$ci.low
agr$YMax = agr$MeanProb + agr$ci.high

ggplot(agr, aes(x=condition,y=MeanProb,color=as.factor(priorWeight))) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~Utterance)
ggsave("graphs/uttprob-byutterance-bycondition-errbars_all.pdf",width=12)

# including domain:

ggplot(all, aes(x=Utterance,y=prob,color=as.factor(priorWeight))) +
  geom_point() +
  facet_grid(domain~condition)
ggsave("graphs/uttprob-bycondition-byutterance-bydomain_all.pdf",width=12)

ggplot(all, aes(x=condition,y=prob,color=as.factor(priorWeight))) +
  geom_point() +
  facet_grid(domain~Utterance)
ggsave("graphs/uttprob-byutterance-bycondition-bydomain_all.pdf",width=12)

agr = all %>% 
  group_by(Utterance,condition,priorWeight, domain) %>%
  summarise(MeanProb=mean(prob),ci.low=ci.low(prob),ci.high=ci.high(prob))
agr = as.data.frame(agr)
agr$YMin = agr$MeanProb - agr$ci.low
agr$YMax = agr$MeanProb + agr$ci.high

ggplot(agr, aes(x=Utterance,y=MeanProb,color=as.factor(priorWeight))) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(domain~condition)
ggsave("graphs/uttprob-bycondition-byutterance-bydomain-errbars_all.pdf",width=12)

agr = all %>% 
  group_by(Utterance,condition,priorWeight, domain) %>%
  summarise(MeanProb=mean(prob),ci.low=ci.low(prob),ci.high=ci.high(prob))
agr = as.data.frame(agr)
agr$YMin = agr$MeanProb - agr$ci.low
agr$YMax = agr$MeanProb + agr$ci.high

ggplot(agr, aes(x=condition,y=MeanProb,color=as.factor(priorWeight))) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(domain~Utterance)
ggsave("graphs/uttprob-byutterance-bycondition-bydomain-errbars_all.pdf",width=12)

