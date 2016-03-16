setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/1_basic_overinformativeness/")
library(ggplot2)
library(dplyr)
library(coda)
library(purrr)
library(gridExtra)
library(lme4)
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
params<-read.csv("bdaOutput/bdaCombinedParams.csv", sep = ",", row.names = NULL)
samples = 4000
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

typColorSubset = params.samples %>% 
  filter(parameter == "typicality_color") %>%
  #mutate(value = as.numeric(levels(value))[value]) %>%
  group_by(parameter) %>%
  summarize(md = estimate_mode(value),
            md_hi = round(HPDhi(value), 3),
            md_low = round(HPDlo(value), 3))
cat("typicality_color = ", typColorSubset$md) 
cat("95% HPD interval = [", typColorSubset$md_low, ",", typColorSubset$md_hi, "]")

typSizeSubset = params.samples %>% 
  filter(parameter == "typicality_size") %>%
  #mutate(value = as.numeric(levels(value))[value]) %>%
  group_by(parameter) %>%
  summarize(md = estimate_mode(value),
            md_hi = round(HPDhi(value), 3),
            md_low = round(HPDlo(value), 3))
cat("typicality_size = ", typSizeSubset$md) 
cat("95% HPD interval = [", typSizeSubset$md_low, ",", typSizeSubset$md_hi, "]")

numericSubset = params.samples %>% 
  filter(parameter %in% c("alpha", "lengthWeight", "typicality_color","typicality_size")) #%>%
  #mutate(lambda=alpha,beta_f=freqWeight,beta_l=lengthWeight,beta_t=typWeight)
  #mutate(value = as.numeric(levels(value))[value])
numericSubset$parameter = as.character(numericSubset$parameter)
numericSubset[numericSubset$parameter == "alpha",]$parameter = "lambda"
numericSubset[numericSubset$parameter == "lengthWeight",]$parameter = "beta_l"
#numericSubset[numericSubset$parameter == "typWeight",]$parameter = "beta_t"

ggplot(numericSubset, aes(x=value)) +
    geom_histogram(data=subset(numericSubset, parameter == "lambda"), 
                   binwidth = .1, colour="black", fill="white")+
    geom_histogram(data=subset(numericSubset, parameter == "beta_l"),
                 binwidth = .1, colour="black", fill="white")+
#    geom_histogram(data=subset(numericSubset, parameter == "beta_t"),
 #                binwidth = .05, colour="black", fill="white")+
  geom_histogram(data=subset(numericSubset, parameter == "typicality_color"),
                 binwidth = .01, colour="black", fill="white")+  
  geom_histogram(data=subset(numericSubset, parameter == "typicality_size"),
                 binwidth = .01, colour="black", fill="white")+    
  #geom_histogram(data=subset(numericSubset, parameter == "typScale"),
   #              binwidth = .1, colour="black", fill="white")+  
    geom_density(aes(y=.18*..count..), data =subset(numericSubset, parameter == "lambda"), adjust = 3.5,
                 alpha=.2, fill="#FF6666")+
    geom_density(aes(y=.15*..count..),data=subset(numericSubset, parameter == "beta_l"),adjust = 3.5,
                 alpha=.2, fill="#FF6666")+
#    geom_density(aes(y=.01*..count..),data=subset(numericSubset, parameter == "beta_t"),adjust=2,
 #               alpha=.2, fill="#FF6666")+
  geom_density(aes(y=.01*..count..),data=subset(numericSubset, parameter == "typicality_color"),adjust = 3.5,
               alpha=.2, fill="#FF6666")+  
  geom_density(aes(y=.008*..count..),data=subset(numericSubset, parameter == "typicality_size"),adjust = 3.5,
               alpha=.2, fill="#FF6666")+  
#  ylim(0,100) +
  #geom_density(aes(y=.1*..count..),data=subset(numericSubset, parameter == "typScale"),adjust=2,
   #            alpha=.2, fill="#FF6666")+  
    #ggtitle("Questioner Parameter Posteriors (1000 iterations)") +
    facet_grid(~ parameter, scales = "free_x") +
    theme_bw() +
  theme(plot.margin=unit(c(0,0,0,0),"cm"))
ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/1_basic_overinformativeness/results_bda/graphs/parameterposteriors.pdf",height=2,width=7)


### Predictives

# Import empirical data

source("results_bda/rscripts/helpers.R")
empirical = read.table("bdaInput/data_bda_modifiers_reduced.csv",sep=",",col.names=c("gameID","bla","condition","size","color","utterance"))
head(empirical)
predictive<-read.csv("bdaOutput/bdaCombinedPredictives.csv", sep = ",", row.names = NULL) 
head(predictive)

## collapse across targets and domains
empirical$color = ifelse(empirical$utterance == "color",1,0)
empirical$size = ifelse(empirical$utterance == "size",1,0)
empirical$size_color = ifelse(empirical$utterance == "size_color",1,0)
agr = empirical %>%
  select(color,size,size_color,condition) %>%
  gather(Utterance,Mentioned,-condition) %>%
  group_by(condition,Utterance) %>%
  summarise(Probability=mean(Mentioned),
            cilow=ci.low(Mentioned),
            cihigh=ci.high(Mentioned)) %>%
  ungroup() %>%
#  mutate(refLevel = factor(x = ifelse(agr$Utterance == "typeMentioned","sub", ifelse(agr$Utterance == "basiclevelMentioned","basic","super")), levels=c("sub","basic","super"))) %>%
  mutate(YMax = Probability + cihigh) %>%
  mutate(YMin = Probability - cilow) %>%
  select(condition, Utterance, Probability, YMax, YMin)
agr = as.data.frame(agr)
head(agr)
summary(agr)
agr$ModelType = "empirical"

predictive.samples <- predictive[rep(row.names(predictive), 
                                     predictive$MCMCprob*samples), 1:6] %>%
  mutate(Utterance = value) %>%
  group_by(Utterance, condition) %>%
  summarize(Prob = estimate_mode(prob),
            YMax = HPDhi(prob),
            YMin = HPDlo(prob)) %>%
  group_by(Utterance, condition) %>%
  summarize(ModelProbability = mean(Prob),
            ModelYMax = mean(Prob) + ci.high(Prob),
            ModelYMin = mean(Prob) - ci.low(Prob))
predictive.samples = as.data.frame(predictive.samples)
predictive.samples$ModelType = "model"
predictive.samples = droplevels(predictive.samples[predictive.samples$Utterance %in% c("color","size","size_color"),])

toplot = merge(agr, predictive.samples, by.x=c("condition","Utterance"),all.y=T) 
toplot$SufficientDimension = ifelse(substr(toplot$condition,1,5) == "color","color","size")
toplot$NumDistractors = substr(toplot$condition,length(toplot$condition)-2,length(toplot$condition)-1)

ggplot(toplot, aes(x=ModelProbability,y=Probability,color=condition)) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax)) +
  geom_errorbarh(aes(xmin=ModelYMin,xmax=ModelYMax)) +
  geom_abline(intercept=0,slope=1,color="gray60") +
  facet_wrap(~SufficientDimension)

cor(toplot$ModelProbability,toplot$Probability) #r=.92


