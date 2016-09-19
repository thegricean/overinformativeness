setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/basic_level_reference/")
library(ggplot2)
library(dplyr)
library(coda)
library(purrr)
library(gridExtra)
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

### Load in model results (parameters)

<<<<<<< HEAD
# params<-read.csv("bdaOutput/INTERPOLATEbdaOutputParams.csv", sep = ",", row.names = NULL)
#params<-read.csv("bdaOutput/NOTYPbdaOutputParams.csv", sep = ",", row.names = NULL)
# params<-read.csv("bdaOutput/FULLONTYPbdaOutputParams.csv", sep = ",", row.names = NULL)
# params<-read.csv("bdaOutput/bdaCombined-logtypicalitiesParams.csv", sep = ",", row.names = NULL)
# modelversion = "fulldataset-typicalities"
modelversion = "fulldataset-detfit"
# modelversion = "fulldataset-detfit-hmc"
#modelversion = "FULLONTYP"
=======
#params<-read.csv("bdaOutput/INTERPOLATEbdaOutputParams.csv", sep = ",", row.names = NULL)
#params<-read.csv("bdaOutput/NOTYPbdaOutputParams.csv", sep = ",", row.names = NULL)
# params<-read.csv("bdaOutput/FULLONTYPbdaOutputParams.csv", sep = ",", row.names = NULL)
# params<-read.csv("bdaOutput/bdaCombined-logtypicalitiesParams.csv", sep = ",", row.names = NULL)
modelversion = "fulldataset-typicalities"
# modelversion = "fulldataset-detfit"
modelversion = "fulldataset-detfit-hmc"
>>>>>>> df080bffb41e084391dd1d71abbfe7df07e1843f
params<-read.csv(paste("bdaOutput/bda-",modelversion,"Params.csv",sep=""), sep = ",", row.names = NULL)

samples = nrow(params)/length(levels(params$parameter))
print(paste("Number of samples:",samples))

str(params)
params.samples <- params[rep(row.names(params), params$MCMCprob*samples), 1:2]
params.samples = params

# test whether probs add up to 1
param_sample_test = params %>%
  group_by(parameter) %>%
  summarise(Sum=sum(MCMCprob))
param_sample_test
summary(params)
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
  summarise(md = estimate_mode(value),
            md_hi = round(HPDhi(value), 3),
            md_low = round(HPDlo(value), 3))
cat("freqWeight = ", freqWeightSubset$md) 
cat("95% HPD interval = [", freqWeightSubset$md_low, ",", freqWeightSubset$md_hi, "]")

lengthWeightSubset = params.samples %>% 
  filter(parameter == "lengthWeight") %>%
  #mutate(value = as.numeric(levels(value))[value]) %>%
  group_by(parameter) %>%
  summarise(md = estimate_mode(value),
            md_hi = round(HPDhi(value), 3),
            md_low = round(HPDlo(value), 3))
cat("lengthWeight = ", lengthWeightSubset$md) 
cat("95% HPD interval = [", lengthWeightSubset$md_low, ",", lengthWeightSubset$md_hi, "]")

typWeightSubset = params.samples %>% 
  filter(parameter == "typWeight") %>%
  #mutate(value = as.numeric(levels(value))[value]) %>%
  group_by(parameter) %>%
  summarise(md = estimate_mode(value),
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

bw = 10

ggplot(numericSubset[numericSubset$parameter != "beta_t",], aes(x=value)) +
    geom_histogram(data=subset(numericSubset, parameter == "lambda"), 
                   binwidth = (range(numericSubset[numericSubset$parameter == "lambda",]$value)[2] - range(numericSubset[numericSubset$parameter == "lambda",]$value)[1])/bw, colour="black", fill="white")+
    geom_histogram(data=subset(numericSubset, parameter == "beta_f"),
                   binwidth = (range(numericSubset[numericSubset$parameter == "beta_f",]$value)[2] - range(numericSubset[numericSubset$parameter == "beta_f",]$value)[1])/bw, colour="black", fill="white")+
    geom_histogram(data=subset(numericSubset, parameter == "beta_l"),
                   binwidth = (range(numericSubset[numericSubset$parameter == "beta_l",]$value)[2] - range(numericSubset[numericSubset$parameter == "beta_l",]$value)[1])/bw, colour="black", fill="white")+
#    geom_histogram(data=subset(numericSubset, parameter == "beta_t"),
 #                binwidth = .05, colour="black", fill="white")+
  #geom_histogram(data=subset(numericSubset, parameter == "typScale"),
   #              binwidth = .1, colour="black", fill="white")+  
    # geom_density(aes(y=.5*..count..), data =subset(numericSubset, parameter == "lambda"), adjust = 3.5,
    #              alpha=.2, fill="#FF6666")+
    # geom_density(aes(y=.25*..count..),data=subset(numericSubset, parameter == "beta_f"), adjust = 3.5,
    #              alpha=.2, fill="#FF6666")+
    # geom_density(aes(y=.25*..count..),data=subset(numericSubset, parameter == "beta_l"),adjust = 3.5,
    #              alpha=.2, fill="#FF6666")+
    #geom_density(aes(y=.05*..count..),data=subset(numericSubset, parameter == "beta_t"),adjust=2,
                #alpha=.2, fill="#FF6666")+
  #geom_density(aes(y=.1*..count..),data=subset(numericSubset, parameter == "typScale"),adjust=2,
   #            alpha=.2, fill="#FF6666")+  
    #ggtitle("Questioner Parameter Posteriors (1000 iterations)") +
    facet_grid(~ parameter, scales = "free_x") +
    theme_bw() +
  theme(plot.margin=unit(c(0,0,0,0),"cm"))
# ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/cogsci/graphs/parameterposteriors-",modelversion,".pdf",sep=""),height=1.5,width=5)
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/basic_level_reference/graphs/parameterposteriors-",modelversion,".pdf",sep=""),height=1.5,width=5)

### Predictives

# Import empirical data

source("rscripts/helpers.R")
#d_noattr = read.csv("~/Repos/overinformativeness/experiments/4_numdistractors_basiclevel_newitems/results/noAttr.csv")
# d_noattr = read.csv("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/4_numdistractors_basiclevel_newitems/results/noAttr.csv")
conditions = read.csv("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/7_overinf_basiclevel_biggersample/results/data/basiclevCor_manModified.csv") %>%
  select(gameid,roundNum,condition,sub,basic,super)

d_noattr = read.csv("bdaInput/basicLevelResultsExp7.csv")
tmp = merge(d_noattr,conditions,by.x=c("gameid","roundNum"))

# d_noattr$nameClickedObj = as.character(d_noattr$targetName)
# d_noattr$sub = conditions[d_noattr]
# # d_noattr$nameClickedObj = as.character(d_noattr$nameClickedObj)
# d_noattr$nameClickedObj = tolower(d_noattr$nameClickedObj)
# d_noattr$nameClickedObj = as.factor(as.character(d_noattr$nameClickedObj))
# 
# tmp = d_noattr %>%
#   select(speakerMessages,condition,nameClickedObj,basiclevelClickedObj,
#          superdomainClickedObj,typeMentioned,basiclevelMentioned,superClassMentioned,
#          typeAttributeMentioned,basiclevelAttributeMentioned,superclassattributeMentioned)

# some cases are marked as having type and attribute mentions at different levels of the hierarchy. i'll interpret all mentions as type mentions of the lowest compatible category -- doesn't apply to the bigger dataset
# tmp[tmp$basiclevelMentioned & tmp$typeMentioned,]$basiclevelMentioned = F


# combine with model fits

#predictive.inter<-read.csv("bdaOutput/INTERPOLATEbdaOutputPredictives.csv", sep = ",", row.names = NULL) 
#predictive.notyp<-read.csv("bdaOutput/NOTYPbdaOutputPredictives.csv", sep = ",", row.names = NULL) 
# predictive<-read.csv("bdaOutput/FULLONTYPbdaOutputPredictives.csv", sep = ",", row.names = NULL) 
# predictive<-read.csv("bdaOutput/bdaCombined-logtypicalitiesPredictives.csv", sep = ",", row.names = NULL) 
predictive<-read.csv(paste("bdaOutput/bda-",modelversion,"Predictives.csv",sep=""),sep=",",row.names=NULL)

## collapse across targets and domains
agr = tmp %>%
  select(condition,sub,basic,super) %>%
  gather(Utterance, Mentioned,-condition) %>%
  group_by(Utterance,condition) %>%
  summarise(Probability=mean(Mentioned),
            cilow=ci.low(Mentioned),
            cihigh=ci.high(Mentioned)) %>%
  ungroup() %>%
  mutate(YMax = Probability + cihigh) %>%
  mutate(YMin = Probability - cilow) %>%
  select(condition,Utterance, Probability, YMax, YMin)
agr = as.data.frame(agr)
head(agr)

agr_noattr = agr
nrow(agr_noattr) # 12 datapoints
agr_noattr$condition = gsub("basic","item",as.character(agr_noattr$condition))
agr_noattr$ModelType = "empirical"

<<<<<<< HEAD
## for cogsci talk collapse across targets and domains and use reduced condition
tmp$redCondition = as.factor(ifelse(tmp$condition == "distr12","sub_necessary",ifelse(tmp$condition == "distr33","super_sufficient","basic_sufficient")))
tmp$sub = tmp$typeMentioned
tmp$basic = tmp$basiclevelMentioned
tmp$super = tmp$superClassMentioned
agr = tmp %>%
  select(redCondition,sub,basic,super) %>%
  gather(Utterance, Mentioned,-redCondition) %>%
  group_by(Utterance,redCondition) %>%
  summarise(Probability=mean(Mentioned),
            cilow=ci.low(Mentioned),
            cihigh=ci.high(Mentioned)) %>%
  ungroup() %>%
  mutate(YMax = Probability + cihigh) %>%
  mutate(YMin = Probability - cilow) %>%
  select(redCondition,Utterance, Probability, YMax, YMin)
agr = as.data.frame(agr)
head(agr)

agr_noattr = agr
nrow(agr_noattr) # 12 datapoints
agr_noattr$condition = gsub("basic","item",as.character(agr_noattr$condition))
agr_noattr$ModelType = "empirical"


=======
>>>>>>> df080bffb41e084391dd1d71abbfe7df07e1843f
# get means by item so we can see which ones are most different with and without typicality
itemmeans = predictive %>%
  mutate(Utterance = value) %>%
  group_by(Utterance, condition, target, alt1, alt2) %>%
  summarise(Prob = estimate_mode(prob),
            YMax = HPDhi(prob),
            YMin = HPDlo(prob)) %>%
  group_by(Utterance, condition, target, alt1, alt2) %>%
  summarise(Probability = mean(Prob),
            YMax = mean(Prob) + ci.high(Prob),
            YMin = mean(Prob) - ci.low(Prob))
itemmeans = as.data.frame(itemmeans)
head(itemmeans)
write.csv(itemmeans,file=paste("data/itemmeans-",modelversion,".csv",sep=""),row.names=F,quote=F)

# predictive.samples <- predictive[rep(row.names(predictive), 
                                     # predictive$MCMCprob*samples), 1:6] %>%
<<<<<<< HEAD
#predictive.samples for cogsci talk, collapsing across basic_sufficient conditiosn
predictive$redCondition = as.factor(ifelse(predictive$condition == "item12","sub_necessary",ifelse(predictive$condition == "item33","super_sufficient","basic_sufficient")))
predictive.samples = predictive %>%
  mutate(Utterance = value) %>%
  group_by(Utterance, redCondition, target) %>%
  summarise(Prob = estimate_mode(prob),
            YMax = HPDhi(prob),
            YMin = HPDlo(prob)) %>%
  group_by(Utterance, redCondition) %>%
  summarise(Probability = mean(Prob),
            YMax = mean(Prob) + ci.high(Prob),
            YMin = mean(Prob) - ci.low(Prob))
predictive.samples = as.data.frame(predictive.samples)
predictive.samples$ModelType = "model"

# regular predictive.sampels
=======
>>>>>>> df080bffb41e084391dd1d71abbfe7df07e1843f
predictive.samples = predictive %>%
  mutate(Utterance = value) %>%
  group_by(Utterance, condition, target) %>%
  summarise(Prob = estimate_mode(prob),
            YMax = HPDhi(prob),
            YMin = HPDlo(prob)) %>%
  group_by(Utterance, condition) %>%
  summarise(Probability = mean(Prob),
            YMax = mean(Prob) + ci.high(Prob),
            YMin = mean(Prob) - ci.low(Prob))
predictive.samples = as.data.frame(predictive.samples)
predictive.samples$ModelType = "model"

# predictive.samples.notyp <- predictive.notyp[rep(row.names(predictive.notyp), 
#                                      predictive.notyp$MCMCprob*samples), 1:6] %>%
#   mutate(refLevel = value) %>%
#   group_by(refLevel, condition, target) %>%
#   summarise(Prob = estimate_mode(prob),
#             YMax = HPDhi(prob),
#             YMin = HPDlo(prob)) %>%
#   group_by(refLevel, condition) %>%
#   summarise(Probability = mean(Prob),
#             YMax = mean(Prob) + ci.high(Prob),
#             YMin = mean(Prob) - ci.low(Prob))
# predictive.samples.notyp = as.data.frame(predictive.samples.notyp)
# predictive.samples.notyp$ModelType = "info+cost"
# 
# predictive.samples.typ <- predictive.typ[rep(row.names(predictive.typ), 
#                                                  predictive.typ$MCMCprob*samples), 1:6] %>%
#   mutate(refLevel = value) %>%
#   group_by(refLevel, condition, target) %>%
#   summarise(Prob = estimate_mode(prob),
#             YMax = HPDhi(prob),
#             YMin = HPDlo(prob)) %>%
#   group_by(refLevel, condition) %>%
#   summarise(Probability = mean(Prob),
#             YMax = mean(Prob) + ci.high(Prob),
#             YMin = mean(Prob) - ci.low(Prob))
# predictive.samples.typ = as.data.frame(predictive.samples.typ)
# predictive.samples.typ$ModelType = "info+cost+fulltyp"

# include only empirical and final (full typicality) model in "blue" plot
toplot = merge(agr_noattr, predictive.samples, all=T)
#toplot = merge(toplot, predictive.samples.notyp, all=T)
#toplot = merge(toplot, predictive.samples.typ, all=T)

colors = scale_colour_brewer()[1:2]

toplot$Utt = factor(x=toplot$Utterance,levels=c("sub","basic","super"))
ggplot(toplot, aes(x=condition,y=Probability,fill=ModelType)) +
  geom_bar(stat="identity",color="black") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  scale_fill_brewer(guide=F) +
  ylab("Utterance probability") +
  xlab("Condition") +
  facet_grid(ModelType~Utt) +
  theme(axis.text.x=element_text(angle=45,vjust=1,hjust=1),plot.margin=unit(c(0,0,0,0),"cm"))
# ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/cogsci/graphs/qualitativepattern.pdf",height=3.5,width=4.7)
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/basic_level_reference/graphs/qualitativepattern-",modelversion,".pdf",sep=""),height=3.5,width=5)

<<<<<<< HEAD
# for cogsci talk
toplot$Utt = factor(x=toplot$Utterance,levels=c("sub","basic","super"))
toplot$Condition = factor(x=toplot$redCondition,levels=c("sub_necessary","basic_sufficient","super_sufficient"))
ggplot(toplot, aes(x=Condition,y=Probability,fill=ModelType)) +
  geom_bar(stat="identity",color="black") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  scale_fill_brewer(guide=F) +
  ylab("Utterance probability") +
  xlab("Condition") +
  facet_grid(ModelType~Utt) +
  theme(axis.text.x=element_text(angle=45,vjust=1,hjust=1),plot.margin=unit(c(0,0,0,0),"cm"))
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/cogsci/graphs/qualitativepattern-",modelversion,".png",sep=""),height=4.5,width=6.5)
#ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/basic_level_reference/graphs/qualitativepattern-",modelversion,".pdf",sep=""),height=3.5,width=5)

toplot$Utt = factor(x=toplot$Utterance,levels=c("sub","basic","super"))
toplot$Condition = factor(x=toplot$redCondition,levels=c("sub_necessary","basic_sufficient","super_sufficient"))
ggplot(toplot, aes(x=Condition,y=Probability,fill=ModelType)) +
  geom_bar(stat="identity",position=dodge,color="black") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  facet_wrap(~Utt) +
  ylim(c(0,1)) +
  ylab("Probability of utterance") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/cogsci/graphs/results-empirical-fullmodel.png",height=4.5,width=9)

agzero = toplot
agzero[agzero$ModelType=="empirical",]$Probability = 0
agzero[agzero$ModelType=="empirical",]$YMin = 0
agzero[agzero$ModelType=="empirical",]$YMax = 0
ggplot(agzero, aes(x=Condition,y=Probability,fill=ModelType)) +
  geom_bar(stat="identity",position=dodge,color="black") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  facet_wrap(~Utt) +
  ylim(c(0,1)) +
  ylab("Probability of utterance") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/cogsci/graphs/results-empirical-fullmodel-noemp.png",height=4.5,width=9)

=======
>>>>>>> df080bffb41e084391dd1d71abbfe7df07e1843f
### ANALYZE RESIDUALS
row.names(agr_noattr) = paste(agr_noattr$condition,agr_noattr$Utterance)

predictive.samples = predictive %>%
  mutate(Utterance = value) %>%
  group_by(Utterance, condition, target) %>%
  summarise(Prob = estimate_mode(prob),
            YMax = HPDhi(prob),
            YMin = HPDlo(prob)) %>%
  group_by(Utterance, condition) %>%
  summarise(MAP = mean(Prob),
            credHigh = mean(Prob) + ci.high(Prob),
            credLow = mean(Prob) - ci.low(Prob)) %>%
  inner_join(agr_noattr, by = c("Utterance", "condition"))
View(predictive.samples)

ggplot(predictive.samples, aes(x=MAP,y=Probability,shape=condition,color=Utterance)) +
  geom_point() +
  xlim(c(0,1)) +
  ylim(c(0,1)) +
  #  geom_errorbar(aes(ymax = YMax, ymin = YMin))+
  #  geom_errorbarh(aes(xmax = credHigh, xmin = credLow)) +
  ylab("Empirical proportion") +
  xlab("Model predicted probability") +
  geom_abline(intercept=0,slope=1,color="gray60") #+
#facet_wrap(~ domain)
ggsave(paste("graphs/reparameterized/model_empirical_bycond-",modelversion,".pdf",sep=""),width=8.4,height=6)

predictive.samples = as.data.frame(predictive.samples)
cor(predictive.samples$MAP,predictive.samples$Probability) # r = .89 ( without typicality) vs .95 (with typicality)

# comparison of means with and without typicality
# d_without = read.csv("data/itemmeans-fulldataset-detfit.csv")
d_without = read.csv("data/itemmeans-fulldataset-detfit-hmc.csv")
d_with = read.csv("data/itemmeans-fulldataset-typicalities.csv")

nrow(d_without)
nrow(d_with)
d_with$withoutProbability = d_without$Probability
# i'm somehow computing kl-divergence wrongly, because i get some negative values
# d = d_with %>%
#   group_by(condition,target,alt1,alt2) %>%
#   summarise(kl=sum(Probability[1]*log(Probability[1]/withoutProbability[1]),Probability[2]*log(Probability[2]/withoutProbability[2]),Probability[3]*log(Probability[3]/withoutProbability[3])))
# d = as.data.frame(d)
# d = d[order(d[,c("kl")]),]
# head(d)
d_with$Diff = d_with$Probability - d_without$Probability
summary(d_with)
d_with = d_with[order(d_with[,c("Diff")]),]
head(d_with,6)
tail(d_with)

maxdiff = d_with[(d_with$condition == "item23" & d_with$target == "bedsidetable" & d_with$alt1 == "ambulance" & d_with$alt2 == "bed" | d_with$condition == "item12" & d_with$target == "diningtable" & d_with$alt1 == "bookcase" & d_with$alt2 == "sidetable" | d_with$condition == "item12" & d_with$target == "hummingbird" & d_with$alt1 == "chick" & d_with$alt2 == "snake" | d_with$condition == "item12" & d_with$target == "hummingbird" & d_with$alt1 == "chick" & d_with$alt2 == "crocodile" | d_with$condition == "item12" & d_with$target == "hummingbird" & d_with$alt1 == "bed" & d_with$alt2 == "chick" | d_with$condition == "item12" & d_with$target == "diningtable" & d_with$alt1 == "bed" & d_with$alt2 == "sidetable"),c("Utterance","condition","target","alt1","alt2","Probability","withoutProbability","Diff")]
nrow(maxdiff)
maxdiff = maxdiff[order(maxdiff[,c("target")]),]
maxdiff
write.csv(maxdiff,file="data/typicality-maxdiff.csv",row.names=F,quote=F)

toplot = maxdiff %>%
  gather(probType,Probability,-Utterance,-condition,-target,-alt1,-alt2,-Diff)
head(toplot)  
toplot$Typicality = as.factor(ifelse(toplot$probType == "Probability","with","without"))
toplot$Condition = paste(toplot$condition,toplot$target,toplot$alt1,toplot$alt2)
toplot$Utt = factor(x=toplot$Utterance,levels=c("sub","basic","super"))

ggplot(toplot, aes(x=Utt,y=Probability,color=Typicality,group=Typicality)) +
  geom_point() +
  geom_line() +
  facet_wrap(~Condition)
ggsave("graphs/typicality-maxdiff.pdf",width=10,height=6)

# collapse across targets but not domains -- recode to fit scheme
# agr = tmp %>%
#   select(condition,basiclevelClickedObj,typeMentioned,basiclevelMentioned,superClassMentioned) %>%
#   gather(Utterance, Mentioned,-condition,-basiclevelClickedObj) %>%
#   group_by(Utterance,condition,basiclevelClickedObj) %>%
#   summarise(Probability=mean(Mentioned),
#             cilow=ci.low(Mentioned),
#             cihigh=ci.high(Mentioned)) %>%
#   ungroup() %>%
#   mutate(refLevel = factor(x = ifelse(Utterance == "typeMentioned","sub", ifelse(Utterance == "basiclevelMentioned","basic","super")), levels=c("sub","basic","super"))) %>%
#   mutate(domain=basiclevelClickedObj) %>%
#   mutate(YMin = Probability + cihigh) %>%
#   mutate(YMax = Probability - cilow) %>%
#   select(condition, domain, refLevel, Probability, YMax, YMin)
# agr = as.data.frame(agr)
# head(agr)
# 
# agr_noattr = agr
# nrow(agr_noattr) # 108 datapoints
# agr_noattr$condition = gsub("distr","item",as.character(agr_noattr$condition))
# 
# domains = unique(tmp[,c("nameClickedObj","basiclevelClickedObj")])
# row.names(domains) = domains$nameClickedObj

### ANALYZE RESIDUALS -- need to redo everything following this
row.names(agr_noattr) = paste(agr_noattr$condition,agr_noattr$domain,agr_noattr$Utterance)
#

predictive$domain = domains[as.character(predictive$target),]$basiclevelClickedObj
predictive.samples <- predictive[rep(row.names(predictive), 
                                     predictive$MCMCprob*samples), c(seq(1,6),8)] %>%
  mutate(refLevel = value) %>%
  group_by(refLevel, condition, target, domain) %>%
  summarise(Prob = estimate_mode(prob),
            YMax = HPDhi(prob),
            YMin = HPDlo(prob)) %>%
  group_by(refLevel, condition, domain) %>%
  summarise(MAP = mean(Prob),
            credHigh = mean(Prob) + ci.high(Prob),
            credLow = mean(Prob) - ci.low(Prob)) %>%
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

predictive.samples = as.data.frame(predictive.samples)
cor(predictive.samples$MAP,predictive.samples$Probability) # r = .88 ( without typicality)


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
  summarise(MAP = estimate_mode(prob),
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








