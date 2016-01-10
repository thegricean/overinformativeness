theme_set(theme_bw(18))
setwd("/home/caroline/cocolab/overinformativeness/models/basic_level_reference/")
#setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/basic_level_reference/")

source("rscripts/helpers.R")
d = read.csv("modelOutput_antiSuperBias_car_0.05.csv",quote="")
head(d)
str(d)
d$Utterance = factor(x=ifelse(d$label == "basicLevel","basic",ifelse(d$label == "superDomain","super","sub")),levels=c("sub","basic","super"))
  
ggplot(d, aes(x=Utterance,y=prob,color=as.factor(priorWeight))) +
  geom_point() +
  facet_wrap(~condition)
ggsave("graphs/antiSuperBias_pW_0.05/antiSuperBias_uttprob-bycondition-byutterance_car_0.05.pdf",width=12)

ggplot(d, aes(x=condition,y=prob,color=target)) +
  geom_point() +
  facet_wrap(~Utterance)
ggsave("graphs/antiSuperBias_pW_0.05/antiSuperBias_uttprob-byutterance-bycondition_car_0.05.pdf",width=12)

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
ggsave("graphs/antiSuperBias_pW_0.05/antiSuperBias_uttprob-bycondition-byutterance-errbars_car_0.05.pdf",width=12)

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
ggsave("graphs/antiSuperBias_pW_0.05/antiSuperBias_uttprob-byutterance-bycondition-errbars_car_0.05.pdf",width=12)



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



# superBiasModelExploration

d = read.csv("superBiasModelExploration.csv",quote="")
head(d)
str(d)
d$Utterance = factor(x=ifelse(d$label == "basicLevel","basic",ifelse(d$label == "superDomain","super","sub")),levels=c("sub","basic","super"))

# including alpha (averaged over domains and over superBias)

ggplot(d, aes(x=Utterance,y=modelProb,color=as.factor(alpha))) +
  geom_point() +
  facet_wrap(~condition)
ggsave("graphs/superBiasModelExploration/uttmodelProb-bycondition-byutterance-byalpha.pdf",width=12)

ggplot(d, aes(x=condition,y=modelProb,color=as.factor(alpha))) +
  geom_point() +
  facet_wrap(~Utterance)
ggsave("graphs/superBiasModelExploration/uttmodelProb-byutterance-bycondition-byalpha.pdf",width=12)

agr = d %>% 
  group_by(Utterance,condition,alpha) %>%
  summarise(MeanmodelProb=mean(modelProb),ci.low=ci.low(modelProb),ci.high=ci.high(modelProb))
agr = as.data.frame(agr)
agr$YMin = agr$MeanmodelProb - agr$ci.low
agr$YMax = agr$MeanmodelProb + agr$ci.high

ggplot(agr, aes(x=Utterance,y=MeanmodelProb,color=as.factor(alpha))) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~condition)
ggsave("graphs/superBiasModelExploration/uttmodelProb-bycondition-byutterance-byalpha-errbars.pdf",width=12)

agr = d %>% 
  group_by(Utterance,condition,alpha) %>%
  summarise(MeanmodelProb=mean(modelProb),ci.low=ci.low(modelProb),ci.high=ci.high(modelProb))
agr = as.data.frame(agr)
agr$YMin = agr$MeanmodelProb - agr$ci.low
agr$YMax = agr$MeanmodelProb + agr$ci.high

ggplot(agr, aes(x=condition,y=MeanmodelProb,color=as.factor(alpha))) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~Utterance)
ggsave("graphs/superBiasModelExploration/uttmodelProb-byutterance-bycondition-byalpha-errbars.pdf",width=12)

# including superbias (averaged over alpha and domains)

ggplot(d, aes(x=Utterance,y=modelProb,color=as.factor(superProb))) +
  geom_point() +
  facet_wrap(~condition)
ggsave("graphs/superBiasModelExploration/uttmodelProb-bycondition-byutterance-bysuperProb.pdf",width=12)

ggplot(d, aes(x=condition,y=modelProb,color=as.factor(superProb))) +
  geom_point() +
  facet_wrap(~Utterance)
ggsave("graphs/superBiasModelExploration/uttmodelProb-byutterance-bycondition-bysuperProb.pdf",width=12)

agr = d %>% 
  group_by(Utterance,condition,superProb) %>%
  summarise(MeanmodelProb=mean(modelProb),ci.low=ci.low(modelProb),ci.high=ci.high(modelProb))
agr = as.data.frame(agr)
agr$YMin = agr$MeanmodelProb - agr$ci.low
agr$YMax = agr$MeanmodelProb + agr$ci.high

ggplot(agr, aes(x=Utterance,y=MeanmodelProb,color=as.factor(superProb))) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~condition)
ggsave("graphs/superBiasModelExploration/uttmodelProb-bycondition-byutterance-bysuperProb-errbars.pdf",width=12)

agr = d %>% 
  group_by(Utterance,condition,superProb) %>%
  summarise(MeanmodelProb=mean(modelProb),ci.low=ci.low(modelProb),ci.high=ci.high(modelProb))
agr = as.data.frame(agr)
agr$YMin = agr$MeanmodelProb - agr$ci.low
agr$YMax = agr$MeanmodelProb + agr$ci.high

ggplot(agr, aes(x=condition,y=MeanmodelProb,color=as.factor(superProb))) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~Utterance)
ggsave("graphs/superBiasModelExploration/uttmodelProb-byutterance-bycondition-bysuperProb-errbars.pdf",width=12)


# ggplot(d, aes(x=Utterance,y=modelProb,color=as.factor(alpha))) +
#   geom_point() +
#   facet_grid(superProb~condition)
# ggsave("graphs/superBiasModelExploration/uttmodelProb-bycondition-byutterance-bysuperProb.pdf",width=12)
# 
# ggplot(d, aes(x=condition,y=modelProb,color=as.factor(alpha))) +
#   geom_point() +
#   facet_grid(superProb~Utterance)
# ggsave("graphs/superBiasModelExploration/uttmodelProb-byutterance-bycondition-bysuperProb.pdf",width=12)
# 
# agr = d %>% 
#   group_by(Utterance,condition,alpha, superProb) %>%
#   summarise(MeanmodelProb=mean(modelProb),ci.low=ci.low(modelProb),ci.high=ci.high(modelProb))
# agr = as.data.frame(agr)
# agr$YMin = agr$MeanmodelProb - agr$ci.low
# agr$YMax = agr$MeanmodelProb + agr$ci.high
# 
# ggplot(agr, aes(x=Utterance,y=MeanmodelProb,color=as.factor(alpha))) +
#   geom_point() +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(superProb~condition)
# ggsave("graphs/superBiasModelExploration/uttmodelProb-bycondition-byutterance-bysuperProb-errbars.pdf",width=12)
# 
# agr = d %>% 
#   group_by(Utterance,condition,alpha, superProb) %>%
#   summarise(MeanmodelProb=mean(modelProb),ci.low=ci.low(modelProb),ci.high=ci.high(modelProb))
# agr = as.data.frame(agr)
# agr$YMin = agr$MeanmodelProb - agr$ci.low
# agr$YMax = agr$MeanmodelProb + agr$ci.high
# 
# ggplot(agr, aes(x=condition,y=MeanmodelProb,color=as.factor(alpha))) +
#   geom_point() +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(superProb~Utterance)
# ggsave("graphs/superBiasModelExploration/uttmodelProb-byutterance-bycondition-bysuperProb-errbars.pdf",width=12)


# including domain:

ggplot(d, aes(x=Utterance,y=modelProb,color=as.factor(alpha))) +
  geom_point() +
  facet_grid(domain~condition)
ggsave("graphs/superBiasModelExploration/uttmodelProb-bycondition-byutterance-bydomain.pdf",width=12)

ggplot(d, aes(x=condition,y=modelProb,color=as.factor(alpha))) +
  geom_point() +
  facet_grid(domain~Utterance)
ggsave("graphs/superBiasModelExploration/uttmodelProb-byutterance-bycondition-bydomain.pdf",width=12)

agr = d %>% 
  group_by(Utterance,condition,alpha, domain) %>%
  summarise(MeanmodelProb=mean(modelProb),ci.low=ci.low(modelProb),ci.high=ci.high(modelProb))
agr = as.data.frame(agr)
agr$YMin = agr$MeanmodelProb - agr$ci.low
agr$YMax = agr$MeanmodelProb + agr$ci.high

ggplot(agr, aes(x=Utterance,y=MeanmodelProb,color=as.factor(alpha))) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(domain~condition)
ggsave("graphs/superBiasModelExploration/uttmodelProb-bycondition-byutterance-bydomain-errbars.pdf",width=12)

agr = d %>% 
  group_by(Utterance,condition,alpha, domain) %>%
  summarise(MeanmodelProb=mean(modelProb),ci.low=ci.low(modelProb),ci.high=ci.high(modelProb))
agr = as.data.frame(agr)
agr$YMin = agr$MeanmodelProb - agr$ci.low
agr$YMax = agr$MeanmodelProb + agr$ci.high

ggplot(agr, aes(x=condition,y=MeanmodelProb,color=as.factor(alpha))) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(domain~Utterance)
ggsave("graphs/superBiasModelExploration/uttmodelProb-byutterance-bycondition-bydomain-errbars.pdf",width=12)

