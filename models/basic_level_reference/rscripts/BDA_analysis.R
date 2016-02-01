# TODO: make code for generating big gblue plot (ie comparing empirical, model, and model sans typicality, collapsing over everything except utterance and condition)

setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/basic_level_reference/")
library(ggplot2)
library(dplyr)
library(coda)
library(purrr)
estimate_mode <- function(s) {
  d <- density(s)
  return(d$x[which.max(d$y)])
}
HPDhi<- function(s){
  m <- HPDinterval(mcmc(s))
  return(m["var1","upper"])
}
HPDlo<- function(s){
  m <- HPDinterval(mcmc(s))
  return(m["var1","lower"])
}
options("scipen"=10) 

### Load in model results

#params<-read.csv("DRIFTbdaOutputParams.csv", sep = ",", row.names = NULL)
#params<-read.csv("DRIFTbdaOutputParams.csv", sep = ",", row.names = NULL)
params<-read.csv("bdaOutput/INTERPOLATEbdaOutputParams.csv", sep = ",", row.names = NULL)
params<-read.csv("bdaOutput/NOTYPbdaOutputParams.csv", sep = ",", row.names = NULL)
samples = 10000
str(params)
params.samples <- params[rep(row.names(params), params$MCMCprob*samples), 1:2]

alphaSubset = params.samples %>% 
  filter(parameter == "alpha") %>%
  #mutate(value = as.numeric(levels(value))[value]) %>%
  group_by(parameter) %>%
  summarise(md = estimate_mode(value),
            md_hi = round(HPDhi(value), 3),
            md_low = round(HPDlo(value), 3))
cat("alpha = ", alphaSubset$md) 
cat("95% HPD interval = [", alphaSubset$md_low, ",", alphaSubset$md_hi, "]")

freqWeightSubset = params.samples %>% 
  filter(parameter == "freqWeight") %>%
  #mutate(value = as.numeric(levels(value))[value]) %>%
  group_by(parameter) %>%
  summarize(md = estimate_mode(value),
            md_hi = round(HPDhi(value), 3),
            md_low = round(HPDlo(value), 3))
cat("freqWeight = ", freqWeightSubset$md) 
cat("95% HPD interval = [", freqWeightSubset$md_low, ",", freqWeightSubset$md_hi, "]")

lengthWeightSubset = params.samples %>% 
  filter(parameter == "lengthWeight") %>%
  #mutate(value = as.numeric(levels(value))[value]) %>%
  group_by(parameter) %>%
  summarize(md = estimate_mode(value),
            md_hi = round(HPDhi(value), 3),
            md_low = round(HPDlo(value), 3))
cat("lengthWeight = ", lengthWeightSubset$md) 
cat("95% HPD interval = [", lengthWeightSubset$md_low, ",", lengthWeightSubset$md_hi, "]")

typWeightSubset = params.samples %>% 
  filter(parameter == "typWeight") %>%
  #mutate(value = as.numeric(levels(value))[value]) %>%
  group_by(parameter) %>%
  summarize(md = estimate_mode(value),
            md_hi = round(HPDhi(value), 3),
            md_low = round(HPDlo(value), 3))
cat("typWeight = ", typWeightSubset$md) 
cat("95% HPD interval = [", typWeightSubset$md_low, ",", typWeightSubset$md_hi, "]")

numericSubset = params.samples %>% 
  filter(parameter %in% c("alpha", "freqWeight", "lengthWeight", "typWeight")) #%>%
  #mutate(lambda=alpha,beta_f=freqWeight,beta_l=lengthWeight,beta_t=typWeight)
  #mutate(value = as.numeric(levels(value))[value])
numericSubset$parameter = as.character(numericSubset$parameter)
numericSubset[numericSubset$parameter == "alpha",]$parameter = "lambda"
numericSubset[numericSubset$parameter == "freqWeight",]$parameter = "beta_f"
numericSubset[numericSubset$parameter == "lengthWeight",]$parameter = "beta_l"
numericSubset[numericSubset$parameter == "typWeight",]$parameter = "beta_t"

ggplot(numericSubset, aes(x=value)) +
    geom_histogram(data=subset(numericSubset, parameter == "lambda"), 
                   binwidth = .5, colour="black", fill="white")+
    geom_histogram(data=subset(numericSubset, parameter == "beta_f"),
                   binwidth = .25, colour="black", fill="white")+
    geom_histogram(data=subset(numericSubset, parameter == "beta_l"),
                 binwidth = .25, colour="black", fill="white")+
    geom_histogram(data=subset(numericSubset, parameter == "beta_t"),
                 binwidth = .05, colour="black", fill="white")+
  #geom_histogram(data=subset(numericSubset, parameter == "typScale"),
   #              binwidth = .1, colour="black", fill="white")+  
    geom_density(aes(y=.5*..count..), data =subset(numericSubset, parameter == "lambda"), adjust = 3.5,
                 alpha=.2, fill="#FF6666")+
    geom_density(aes(y=.25*..count..),data=subset(numericSubset, parameter == "beta_f"), adjust = 3.5,
                 alpha=.2, fill="#FF6666")+
    geom_density(aes(y=.25*..count..),data=subset(numericSubset, parameter == "beta_l"),adjust = 3.5,
                 alpha=.2, fill="#FF6666")+
    geom_density(aes(y=.05*..count..),data=subset(numericSubset, parameter == "beta_t"),adjust=2,
                alpha=.2, fill="#FF6666")+
  #geom_density(aes(y=.1*..count..),data=subset(numericSubset, parameter == "typScale"),adjust=2,
   #            alpha=.2, fill="#FF6666")+  
    #ggtitle("Questioner Parameter Posteriors (1000 iterations)") +
    facet_grid(~ parameter, scales = "free_x") +
    theme_bw() +
  theme(plot.margin=unit(c(0,0,0,0),"cm"))
ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/cogsci/graphs/parameterposteriors.pdf",height=2.5,width=10)

ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/cogsci/graphs/parameterposteriors-notypicality.pdf",height=3,width=11)


### Predictives

# Import emp data

source("rscripts/helpers.R")
#d_noattr = read.csv("~/Repos/overinformativeness/experiments/4_numdistractors_basiclevel_newitems/results/noAttr.csv")
d_noattr = read.csv("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/4_numdistractors_basiclevel_newitems/results/noAttr.csv")
d_noattr$nameClickedObj = as.character(d_noattr$nameClickedObj)
d_noattr$nameClickedObj = tolower(d_noattr$nameClickedObj)
d_noattr$nameClickedObj = as.factor(as.character(d_noattr$nameClickedObj))

tmp = d_noattr %>%
  select(speakerMessages,condition,nameClickedObj,basiclevelClickedObj,
         superdomainClickedObj,typeMentioned,basiclevelMentioned,superClassMentioned,
         typeAttributeMentioned,basiclevelAttributeMentioned,superclassattributeMentioned)

# some cases are marked as having type and attribute mentions at different levels of the hierarchy. i'll interpret all mentions as type mentions of the lowest compatible category
tmp[tmp$basiclevelMentioned & tmp$typeMentioned,]$basiclevelMentioned = F


# combine with model fits

predictive<-read.csv("bdaOutput/INTERPOLATEbdaOutputPredictives.csv", sep = ",", row.names = NULL) 
predictive.notyp<-read.csv("bdaOutput/NOTYPbdaOutputPredictives.csv", sep = ",", row.names = NULL) 
predictive.typ<-read.csv("bdaOutput/FULLONTYPbdaOutputPredictives.csv", sep = ",", row.names = NULL) 


## collapse across targets and domains
agr = tmp %>%
  select(condition,typeMentioned,basiclevelMentioned,superClassMentioned) %>%
  gather(Utterance, Mentioned,-condition) %>%
  group_by(Utterance,condition) %>%
  summarise(Probability=mean(Mentioned),
            cilow=ci.low(Mentioned),
            cihigh=ci.high(Mentioned)) %>%
  ungroup() %>%
  mutate(refLevel = factor(x = ifelse(agr$Utterance == "typeMentioned","sub", ifelse(agr$Utterance == "basiclevelMentioned","basic","super")), levels=c("sub","basic","super"))) %>%
  mutate(YMax = Probability + cihigh) %>%
  mutate(YMin = Probability - cilow) %>%
  select(condition, refLevel, Probability, YMax, YMin)
agr = as.data.frame(agr)
head(agr)

agr_noattr = agr
nrow(agr_noattr) # 12 datapoints
agr_noattr$condition = gsub("distr","item",as.character(agr_noattr$condition))
agr_noattr$ModelType = "empirical"

predictive.samples <- predictive[rep(row.names(predictive), 
                                     predictive$MCMCprob*samples), 1:6] %>%
  mutate(refLevel = value) %>%
  group_by(refLevel, condition) %>%
  summarize(Probability = estimate_mode(prob),
            YMax = HPDhi(prob),
            YMin = HPDlo(prob))
predictive.samples = as.data.frame(predictive.samples)
predictive.samples$ModelType = "info+cost"

predictive.samples.notyp <- predictive.notyp[rep(row.names(predictive.notyp), 
                                     predictive.notyp$MCMCprob*samples), 1:6] %>%
  mutate(refLevel = value) %>%
  group_by(refLevel, condition) %>%
  summarize(Probability = estimate_mode(prob),
            YMax = HPDhi(prob),
            YMin = HPDlo(prob))
predictive.samples.notyp = as.data.frame(predictive.samples.notyp)
predictive.samples.notyp$ModelType = "info+cost+intertyp"

predictive.samples.typ <- predictive.typ[rep(row.names(predictive.typ), 
                                                 predictive.typ$MCMCprob*samples), 1:6] %>%
  mutate(refLevel = value) %>%
  group_by(refLevel, condition) %>%
  summarize(Probability = estimate_mode(prob),
            YMax = HPDhi(prob),
            YMin = HPDlo(prob))
predictive.samples.typ = as.data.frame(predictive.samples.typ)
predictive.samples.typ$ModelType = "info+cost+fulltyp"

toplot = merge(agr_noattr, predictive.samples, all=T)
toplot = merge(toplot, predictive.samples.notyp, all=T)
toplot = merge(toplot, predictive.samples.typ, all=T)

colors = scale_colour_brewer()[1:4]

ggplot(toplot, aes(x=condition,y=Probability,fill=ModelType)) +
  geom_bar(stat="identity",color="black") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  scale_fill_brewer(guide=F) +
  ylab("Utterance probability") +
  xlab("Condition") +
  facet_grid(ModelType~refLevel) +
  theme(axis.text.x=element_text(angle=45,vjust=1,hjust=1))
ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/cogsci/graphs/qualitativepattern.pdf",height=5,width=4.5)

### ANALYZE RESIDUALS
row.names(agr_noattr) = paste(agr_noattr$condition,agr_noattr$refLevel)

predictive.samples <- predictive[rep(row.names(predictive), 
                                     predictive$MCMCprob*samples), 1:6] %>%
  mutate(refLevel = value) %>%
  group_by(refLevel, condition) %>%
  summarize(MAP = estimate_mode(prob),
            credHigh = HPDhi(prob),
            credLow = HPDlo(prob)) %>%
  inner_join(agr_noattr, by = c("refLevel", "condition"))
View(predictive.samples)

ggplot(predictive.samples, aes(x=MAP,y=Probability,shape=condition,color=refLevel)) +
  geom_point() +
  xlim(c(0,1)) +
  ylim(c(0,1)) +
  #  geom_errorbar(aes(ymax = YMax, ymin = YMin))+
  #  geom_errorbarh(aes(xmax = credHigh, xmin = credLow)) +
  ylab("Empirical proportion") +
  xlab("Model predicted probability") +
  geom_abline(xintercept=0,yintercept=0,slope=1,color="gray60") #+
#facet_wrap(~ domain)
ggsave("graphs/reparameterized/model_empirical_bycond.pdf",width=8.4,height=6)

predictive.samples = as.data.frame(predictive.samples)
cor(predictive.samples$MAP,predictive.samples$Probability) # r = .93 ( without typicality)

# collapse across targets but not domains
agr = tmp %>%
  select(condition,basiclevelClickedObj,typeMentioned,basiclevelMentioned,superClassMentioned) %>%
  gather(Utterance, Mentioned,-condition,-basiclevelClickedObj) %>%
  group_by(Utterance,condition,basiclevelClickedObj) %>%
  summarise(Probability=mean(Mentioned),
            cilow=ci.low(Mentioned),
            cihigh=ci.high(Mentioned)) %>%
  ungroup() %>%
  mutate(refLevel = factor(x = ifelse(Utterance == "typeMentioned","sub", ifelse(Utterance == "basiclevelMentioned","basic","super")), levels=c("sub","basic","super"))) %>%
  mutate(domain=basiclevelClickedObj) %>%
  mutate(YMin = Probability + cihigh) %>%
  mutate(YMax = Probability - cilow) %>%
  select(condition, domain, refLevel, Probability, YMax, YMin)
agr = as.data.frame(agr)
head(agr)

agr_noattr = agr
nrow(agr_noattr) # 108 datapoints
agr_noattr$condition = gsub("distr","item",as.character(agr_noattr$condition))

domains = unique(tmp[,c("nameClickedObj","basiclevelClickedObj")])
row.names(domains) = domains$nameClickedObj

### ANALYZE RESIDUALS
row.names(agr_noattr) = paste(agr_noattr$condition,agr_noattr$domain,agr_noattr$refLevel)
#

predictive$domain = domains[as.character(predictive$target),]$basiclevelClickedObj
predictive.samples <- predictive[rep(row.names(predictive), 
                                     predictive$MCMCprob*samples), c(seq(1,6),8)] %>%
  mutate(refLevel = value) %>%
  group_by(refLevel, domain, condition) %>%
  summarize(MAP = estimate_mode(prob),
            credHigh = HPDhi(prob),
            credLow = HPDlo(prob)) %>%
  inner_join(agr_noattr, by = c("refLevel", "domain", "condition"))
#View(predictive.samples)

ggplot(predictive.samples, aes(x=MAP,y=Probability,shape=condition,color=refLevel)) +
  #ggplot(predictive.samples, aes(x=MAP,y=Probability,color=domain,shape=refLevel)) +
  geom_point() +
  xlim(c(0,1)) +
  ylim(c(0,1)) +
  geom_errorbar(aes(ymax = YMax, ymin = YMin))+
  geom_errorbarh(aes(xmax = credHigh, xmin = credLow)) +
  ylab("Empirical proportion") +
  xlab("Model predicted probability") +
  geom_abline(xintercept=0,yintercept=0,slope=1,color="gray60") +
  facet_wrap(~ domain)
ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/cogsci/graphs/scatterplot-bydomain.pdf",height=3.5,width=5)
ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/cogsci/graphs/scatterplot-bydomain-notypicality.pdf",height=3.5,width=5)
#ggsave("graphs/reparameterized/model_empirical_noattr_bydomain_multiplicative.pdf",width=8.4,height=6)

predictive.samples = as.data.frame(predictive.samples)
cor(predictive.samples$MAP,predictive.samples$Probability) # r = .84 (.77 without typicality)


# don't collapse across targets and domains
agr = tmp %>%
  select(nameClickedObj,condition,basiclevelClickedObj,typeMentioned,basiclevelMentioned,superClassMentioned) %>%
  gather(Utterance, Mentioned,-condition,-basiclevelClickedObj,-nameClickedObj) %>%
  group_by(Utterance,condition,basiclevelClickedObj,nameClickedObj) %>%
  summarise(Probability=mean(Mentioned),
            cilow=ci.low(Mentioned),
            cihigh=ci.high(Mentioned)) %>%
  ungroup() %>%
  mutate(refLevel = factor(x = ifelse(Utterance == "typeMentioned","sub", ifelse(Utterance == "basiclevelMentioned","basic","super")), levels=c("sub","basic","super"))) %>%
  mutate(target = nameClickedObj) %>%
  mutate(YMax = Probability + cihigh) %>%
  mutate(YMin = Probability - cilow) %>%
  select(condition, target, refLevel, Probability, YMax, YMin)
agr = as.data.frame(agr)
head(agr)

agr_noattr = agr
nrow(agr_noattr) # 432 datapoints
agr_noattr$condition = gsub("distr","item",as.character(agr_noattr$condition))

### ANALYZE RESIDUALS
row.names(agr_noattr) = paste(agr_noattr$condition,agr_noattr$target,agr_noattr$refLevel)
#

predictive.samples <- predictive[rep(row.names(predictive), 
                                       predictive$MCMCprob*samples), 1:6] %>%
  mutate(refLevel = value) %>%
  group_by(refLevel, target, condition) %>%
  summarize(MAP = estimate_mode(prob),
            credHigh = HPDhi(prob),
            credLow = HPDlo(prob)) %>%
  inner_join(agr_noattr, by = c("refLevel", "target", "condition"))
View(predictive.samples)

ggplot(predictive.samples, aes(x=MAP,y=Probability,shape=condition,color=refLevel)) +
  geom_point() +
  xlim(c(0,1)) +
  ylim(c(0,1)) +
#  geom_errorbar(aes(ymax = YMax, ymin = YMin))+
#  geom_errorbarh(aes(xmax = credHigh, xmin = credLow)) +
  ylab("Empirical proportion") +
  xlab("Model predicted probability") +
  geom_abline(xintercept=0,yintercept=0,slope=1,color="gray60") #+
  #facet_wrap(~ domain)
ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/cogsci/graphs/scatterplot.pdf",height=3.5,width=5)
ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/cogsci/graphs/scatterplot-notypicality.pdf",height=3.5,width=5)
#ggsave("graphs/reparameterized/model_empirical_noattr_bydomain_multiplicative.pdf",width=8.4,height=6)

predictive.samples = as.data.frame(predictive.samples)
cor(predictive.samples$MAP,predictive.samples$Probability) # r = .79 (.7 without typicality)


# find particularly good and bad examples
worst = predictive.samples %>%
  group_by(target) %>%
  summarise(Cor=cor(MAP,Probability))
worst = as.data.frame(worst)
worst = worst[order(worst[,c("Cor")]),]
head(worst)
tail(worst)

#jellybeans PREDICTIONS
predictive.samples$UtteranceType = factor(x=as.character(predictive.samples$refLevel),levels=c("sub","basic","super"))
jellybeans = predictive.samples[predictive.samples$target == "jellybeans",] %>%
  mutate(model=MAP) %>%
  mutate(empirical=Probability) %>%
  select(UtteranceType,condition,model,empirical,YMax,YMin) %>%
  gather(ProbType,Probability,-UtteranceType,-condition,-YMax,-YMin)
jellybeans[jellybeans$ProbType == "model",]$YMax = 0
jellybeans[jellybeans$ProbType == "model",]$YMin = 0
head(jellybeans)
dodge=position_dodge(.9)
ggplot(jellybeans, aes(x=condition,y=Probability,fill=ProbType)) +
  geom_bar(stat="identity",position=dodge) +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),position=dodge,width=.25) +
  facet_wrap(~UtteranceType)
ggsave("graphs/jellybeans.pdf",height=3.5)

#gummybears PREDICTIONS
predictive.samples$UtteranceType = factor(x=as.character(predictive.samples$refLevel),levels=c("sub","basic","super"))
gummybears = predictive.samples[predictive.samples$target == "gummybears",] %>%
  mutate(model=MAP) %>%
  mutate(empirical=Probability) %>%
  select(UtteranceType,condition,model,empirical,YMax,YMin) %>%
  gather(ProbType,Probability,-UtteranceType,-condition,-YMax,-YMin)
gummybears[gummybears$ProbType == "model",]$YMax = 0
gummybears[gummybears$ProbType == "model",]$YMin = 0
head(gummybears)
dodge=position_dodge(.9)
ggplot(gummybears, aes(x=condition,y=Probability,fill=ProbType)) +
  geom_bar(stat="identity",position=dodge) +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),position=dodge,width=.25) +
  facet_wrap(~UtteranceType)
ggsave("graphs/gummybears.pdf",height=3.5)

#pandabear PREDICTIONS
predictive.samples$UtteranceType = factor(x=as.character(predictive.samples$refLevel),levels=c("sub","basic","super"))
pandabear = predictive.samples[predictive.samples$target == "pandabear",] %>%
  mutate(model=MAP) %>%
  mutate(empirical=Probability) %>%
  select(UtteranceType,condition,model,empirical,YMax,YMin) %>%
  gather(ProbType,Probability,-UtteranceType,-condition,-YMax,-YMin)
pandabear[pandabear$ProbType == "model",]$YMax = 0
pandabear[pandabear$ProbType == "model",]$YMin = 0
head(pandabear)
dodge=position_dodge(.9)
ggplot(pandabear, aes(x=condition,y=Probability,fill=ProbType)) +
  geom_bar(stat="identity",position=dodge) +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),position=dodge,width=.25) +
  facet_wrap(~UtteranceType)
ggsave("graphs/pandabear.pdf",height=3.5)

#polarbear PREDICTIONS
predictive.samples$UtteranceType = factor(x=as.character(predictive.samples$refLevel),levels=c("sub","basic","super"))
polarbear = predictive.samples[predictive.samples$target == "polarbear",] %>%
  mutate(model=MAP) %>%
  mutate(empirical=Probability) %>%
  select(UtteranceType,condition,model,empirical,YMax,YMin) %>%
  gather(ProbType,Probability,-UtteranceType,-condition,-YMax,-YMin)
polarbear[polarbear$ProbType == "model",]$YMax = 0
polarbear[polarbear$ProbType == "model",]$YMin = 0
head(polarbear)
dodge=position_dodge(.9)
ggplot(polarbear, aes(x=condition,y=Probability,fill=ProbType)) +
  geom_bar(stat="identity",position=dodge) +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),position=dodge,width=.25) +
  facet_wrap(~UtteranceType)
ggsave("graphs/polarbear.pdf",height=3.5)



#bedsidetable PREDICTIONS
predictive.samples$UtteranceType = factor(x=as.character(predictive.samples$refLevel),levels=c("sub","basic","super"))
bedsidetable = predictive.samples[predictive.samples$target == "bedsidetable",] %>%
  mutate(model=MAP) %>%
  mutate(empirical=Probability) %>%
  select(UtteranceType,condition,model,empirical,YMax,YMin) %>%
  gather(ProbType,Probability,-UtteranceType,-condition,-YMax,-YMin)
bedsidetable[bedsidetable$ProbType == "model",]$YMax = 0
bedsidetable[bedsidetable$ProbType == "model",]$YMin = 0
head(bedsidetable)
dodge=position_dodge(.9)
ggplot(bedsidetable, aes(x=condition,y=Probability,fill=ProbType)) +
  geom_bar(stat="identity",position=dodge) +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),position=dodge,width=.25) +
  facet_wrap(~UtteranceType)
ggsave("graphs/bedsidetable.pdf",height=3.5)




## BEST CASES
#germanshepherd PREDICTIONS
predictive.samples$UtteranceType = factor(x=as.character(predictive.samples$refLevel),levels=c("sub","basic","super"))
germanshepherd = predictive.samples[predictive.samples$target == "germanshepherd",] %>%
  mutate(model=MAP) %>%
  mutate(empirical=Probability) %>%
  select(UtteranceType,condition,model,empirical,YMax,YMin) %>%
  gather(ProbType,Probability,-UtteranceType,-condition,-YMax,-YMin)
germanshepherd[germanshepherd$ProbType == "model",]$YMax = 0
germanshepherd[germanshepherd$ProbType == "model",]$YMin = 0
#head(germanshepherd)
dodge=position_dodge(.9)
ggplot(germanshepherd, aes(x=condition,y=Probability,fill=ProbType)) +
  geom_bar(stat="identity",position=dodge) +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),position=dodge,width=.25) +
  facet_wrap(~UtteranceType)
ggsave("graphs/germanshepherd.pdf",height=3.5)

#grizzlybear PREDICTIONS
predictive.samples$UtteranceType = factor(x=as.character(predictive.samples$refLevel),levels=c("sub","basic","super"))
grizzlybear = predictive.samples[predictive.samples$target == "grizzlybear",] %>%
  mutate(model=MAP) %>%
  mutate(empirical=Probability) %>%
  select(UtteranceType,condition,model,empirical,YMax,YMin) %>%
  gather(ProbType,Probability,-UtteranceType,-condition,-YMax,-YMin)
grizzlybear[grizzlybear$ProbType == "model",]$YMax = 0
grizzlybear[grizzlybear$ProbType == "model",]$YMin = 0
head(grizzlybear)
dodge=position_dodge(.9)
ggplot(grizzlybear, aes(x=condition,y=Probability,fill=ProbType)) +
  geom_bar(stat="identity",position=dodge) +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),position=dodge,width=.25) +
  facet_wrap(~UtteranceType)
ggsave("graphs/grizzlybear.pdf",height=3.5)


#coffeetable PREDICTIONS
predictive.samples$UtteranceType = factor(x=as.character(predictive.samples$refLevel),levels=c("sub","basic","super"))
coffeetable = predictive.samples[predictive.samples$target == "coffeetable",] %>%
  mutate(model=MAP) %>%
  mutate(empirical=Probability) %>%
  select(UtteranceType,condition,model,empirical,YMax,YMin) %>%
  gather(ProbType,Probability,-UtteranceType,-condition,-YMax,-YMin)
coffeetable[coffeetable$ProbType == "model",]$YMax = 0
coffeetable[coffeetable$ProbType == "model",]$YMin = 0
head(coffeetable)
dodge=position_dodge(.9)
ggplot(coffeetable, aes(x=condition,y=Probability,fill=ProbType)) +
  geom_bar(stat="identity",position=dodge) +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),position=dodge,width=.25) +
  facet_wrap(~UtteranceType)
ggsave("graphs/coffeetable.pdf",height=3.5)




#convertible PREDICTIONS
predictive.samples$UtteranceType = factor(x=as.character(predictive.samples$refLevel),levels=c("sub","basic","super"))
convertible = predictive.samples[predictive.samples$target == "convertible",] %>%
  mutate(model=MAP) %>%
  mutate(empirical=Probability) %>%
  select(UtteranceType,condition,model,empirical,YMax,YMin) %>%
  gather(ProbType,Probability,-UtteranceType,-condition,-YMax,-YMin)
convertible[convertible$ProbType == "model",]$YMax = 0
convertible[convertible$ProbType == "model",]$YMin = 0
head(convertible)
dodge=position_dodge(.9)
ggplot(convertible, aes(x=condition,y=Probability,fill=ProbType)) +
  geom_bar(stat="identity",position=dodge) +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),position=dodge,width=.25) +
  facet_wrap(~UtteranceType)
ggsave("graphs/convertible.pdf",height=3.5)



#tulip PREDICTIONS
predictive.samples$UtteranceType = factor(x=as.character(predictive.samples$refLevel),levels=c("sub","basic","super"))
tulip = predictive.samples[predictive.samples$target == "tulip",] %>%
  mutate(model=MAP) %>%
  mutate(empirical=Probability) %>%
  select(UtteranceType,condition,model,empirical,YMax,YMin) %>%
  gather(ProbType,Probability,-UtteranceType,-condition,-YMax,-YMin)
tulip[tulip$ProbType == "model",]$YMax = 0
tulip[tulip$ProbType == "model",]$YMin = 0
head(tulip)
dodge=position_dodge(.9)
ggplot(tulip, aes(x=condition,y=Probability,fill=ProbType)) +
  geom_bar(stat="identity",position=dodge) +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),position=dodge,width=.25) +
  facet_wrap(~UtteranceType)
ggsave("graphs/tulip.pdf",height=3.5)

#parrot PREDICTIONS
predictive.samples$UtteranceType = factor(x=as.character(predictive.samples$refLevel),levels=c("sub","basic","super"))
parrot = predictive.samples[predictive.samples$target == "parrot",] %>%
  mutate(model=MAP) %>%
  mutate(empirical=Probability) %>%
  select(UtteranceType,condition,model,empirical,YMax,YMin) %>%
  gather(ProbType,Probability,-UtteranceType,-condition,-YMax,-YMin)
parrot[parrot$ProbType == "model",]$YMax = 0
parrot[parrot$ProbType == "model",]$YMin = 0
head(parrot)
dodge=position_dodge(.9)
ggplot(parrot, aes(x=condition,y=Probability,fill=ProbType)) +
  geom_bar(stat="identity",position=dodge) +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),position=dodge,width=.25) +
  facet_wrap(~UtteranceType)
ggsave("graphs/parrot.pdf",height=3.5)








