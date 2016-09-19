setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/5c_bda_nom_full_nocost/")
library(ggplot2)
library(dplyr)
library(coda)
library(purrr)
library(gridExtra)
library(hydroGOF)
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
# modelversion = "fulldataset-detfit"
modelversion = "fulldataset-typicalities-nocost-hmc"
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
# params.samples <- params[rep(row.names(params), params$MCMCprob*samples), 1:2]
params.samples = params

alphaSubset = params.samples %>% 
  filter(parameter == "alpha") %>%
  #mutate(value = as.numeric(levels(value))[value]) %>%
  group_by(parameter) %>%
  summarise(md = estimate_mode(value),
            md_hi = round(HPDhi(value), 3),
            md_low = round(HPDlo(value), 3))
cat("alpha = ", alphaSubset$md) 
cat("95% HPD interval = [", alphaSubset$md_low, ",", alphaSubset$md_hi, "]")

numericSubset = params.samples %>% 
  filter(parameter %in% c("alpha"))
numericSubset$parameter = as.character(numericSubset$parameter)
numericSubset[numericSubset$parameter == "alpha",]$parameter = "lambda"

bw = 10

ggplot(numericSubset[numericSubset$parameter != "beta_t",], aes(x=value)) +
    geom_histogram(data=subset(numericSubset, parameter == "lambda"), 
                   binwidth = (range(numericSubset[numericSubset$parameter == "lambda",]$value)[2] - range(numericSubset[numericSubset$parameter == "lambda",]$value)[1])/bw, colour="black", fill="white")+
    facet_grid(~ parameter, scales = "free_x") +
    theme_bw() +
  theme(plot.margin=unit(c(0,0,0,0),"cm"))
# ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/cogsci/graphs/parameterposteriors-",modelversion,".pdf",sep=""),height=1.5,width=5)
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/5c_bda_nom_full_nocost/graphs/parameterposteriors-",modelversion,".pdf",sep=""),height=1.5,width=2)

### Predictives

# Import empirical data

source("rscripts/helpers.R")
# load this dataset (without exclusions!) to re-merge condition names
conditions = read.csv("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/7_overinf_basiclevel_biggersample/results/data/basiclevCor_manModified.csv") %>%
  select(gameid,roundNum,condition,sub,basic,super)
row.names(conditions) = paste(conditions$gameid,conditions$roundNum,sep=" ")

d_noattr = read.csv("bdaInput/basicLevelResultsExp7.csv")
d_noattr$condition = conditions[paste(d_noattr$gameid,d_noattr$roundNum),]$condition
tmp = d_noattr %>%
  mutate(sub = ifelse(d_noattr$refLevel == "sub",1,0),basic = ifelse(d_noattr$refLevel == "basic",1,0),super = ifelse(d_noattr$refLevel == "super",1,0))

# combine with model fits
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

# regular predictive.sampels
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
predictive.samples$ModelType = "nondet-nocost"

write.table(predictive.samples,paste("predictive-barplot-",modelversion,".txt",sep=""),sep="\t",row.names=F,quote=F)

predictive.samples$ModelType = "model"

# get correlation
gof(agr_noattr$Probability,predictive.samples$Probability) #r=.86,r2=.74

# merge empirical and model for "blue" plot
toplot = merge(agr_noattr, predictive.samples, all=T)

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
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/5c_bda_nom_full_nocost/graphs/qualitativepattern-",modelversion,".pdf",sep=""),height=3.5,width=5)


### ANALYZE RESIDUALS
## don't collapse across targets and domains
agr = tmp %>%
  mutate(target=targetName) %>%
  select(condition,sub,basic,super,target) %>%
  gather(Utterance, Mentioned,-condition,-target) %>%
  group_by(Utterance,condition,target) %>%
  summarise(Probability=mean(Mentioned),
            cilow=ci.low(Mentioned),
            cihigh=ci.high(Mentioned)) %>%
  ungroup() %>%
  mutate(YMax = Probability + cihigh) %>%
  mutate(YMin = Probability - cilow) %>%
  select(condition,Utterance, Probability, YMax, YMin,target)
agr = as.data.frame(agr)
head(agr)

agr_noattr = agr
nrow(agr_noattr) # 432 datapoints
agr_noattr$condition = gsub("basic","item",as.character(agr_noattr$condition))
row.names(agr_noattr) = paste(agr_noattr$condition,agr_noattr$target,agr_noattr$Utterance)

predictive.samples = predictive %>%
  mutate(Utterance = value) %>%
  group_by(Utterance, condition, target) %>%
  summarise(Prob = estimate_mode(prob),
            YMax = HPDhi(prob),
            YMin = HPDlo(prob)) %>%
  group_by(Utterance, condition,target) %>%
  summarise(MAP = mean(Prob),
            credHigh = mean(Prob) + ci.high(Prob),
            credLow = mean(Prob) - ci.low(Prob))

predictive.samples = as.data.frame(predictive.samples)
predictive.samples$EmpProportion = agr_noattr[paste(predictive.samples$condition,predictive.samples$target,predictive.samples$Utterance),]$Probability
predictive.samples$EmpYMin = agr_noattr[paste(predictive.samples$condition,predictive.samples$target,predictive.samples$Utterance),]$YMin
predictive.samples$EmpYMax = agr_noattr[paste(predictive.samples$condition,predictive.samples$target,predictive.samples$Utterance),]$YMax

predictive.samples$ModelType = "nondet-nocost"

write.table(predictive.samples,paste("predictive-scatterplot-",modelversion,".txt",sep=""),sep="\t",row.names=F,quote=F)

# get correlation
gof(predictive.samples$EmpProportion,predictive.samples$MAP) #r=.71,r2=.51

ggplot(predictive.samples, aes(x=MAP,y=EmpProportion,shape=condition,color=Utterance)) +
  geom_point() +
  xlim(c(0,1)) +
  ylim(c(0,1)) +
   # geom_errorbar(aes(ymax = EmpYMax, ymin = EmpYMin))+
   # geom_errorbarh(aes(xmax = EmpYMax, xmin = EmpYMin)) +
  ylab("Empirical proportion") +
  xlab("Model predicted probability") +
  geom_abline(intercept=0,slope=1,color="gray60") 
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/5c_bda_nom_full_nocost/graphs/scatterplot-",modelversion,".pdf",sep=""),height=3.5,width=5)
