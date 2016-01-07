theme_set(theme_bw(18))
setwd("/home/caroline/cocolab/overinformativeness/models/basic_level_reference/")
#setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/basic_level_reference/")

source("rscripts/helpers.R")
d = read.csv("superBiasModelExploration.csv",quote="")
head(d)
summary(d)
d$Utterance = factor(x=ifelse(d$label == "basicLevel","basic",ifelse(d$label == "superDomain","super","sub")),levels=c("sub","basic","super"))
table(d$alpha)  
table(d$superProb)  

agr = d[d$alpha %in% c(.01,.05,.1,.31,.91) & d$superProb %in% c(.01,.02,.1,.2,.32),] %>%
  group_by(condition,alpha,superProb,Utterance) %>%
  summarise(Probability=mean(modelProb),ci.low=ci.low(modelProb),ci.high=ci.high(modelProb))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
dodge = position_dodge(.9)

p = ggplot(agr, aes(x=Utterance,y=Probability,fill=condition)) +
  geom_bar(stat="identity",position=dodge) +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),position=dodge,width=.25) +
  facet_grid(alpha~superProb)
ggsave("graphs/antisuper/probs.pdf",width=10,height=10)
