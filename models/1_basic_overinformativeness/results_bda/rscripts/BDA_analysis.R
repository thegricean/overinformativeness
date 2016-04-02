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
#params<-read.csv("bdaOutput/bdaCombinedParams.csv", sep = ",", row.names = NULL)
#params<-read.csv("bdaOutput/bdaCombined-costsParams.csv", sep = ",", row.names = NULL)
params<-read.csv("bdaOutput/bdaCombined-costs-typicalitiesParams.csv", sep = ",", row.names = NULL)
#samples = 100
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

costColorSubset = params.samples %>% 
  filter(parameter == "cost_color") %>%
  #mutate(value = as.numeric(levels(value))[value]) %>%
  group_by(parameter) %>%
  summarize(md = estimate_mode(value),
            md_hi = round(HPDhi(value), 3),
            md_low = round(HPDlo(value), 3))
cat("cost_color = ", costColorSubset$md) 
cat("95% HPD interval = [", costColorSubset$md_low, ",", costColorSubset$md_hi, "]")

costSizeSubset = params.samples %>% 
  filter(parameter == "cost_size") %>%
  #mutate(value = as.numeric(levels(value))[value]) %>%
  group_by(parameter) %>%
  summarize(md = estimate_mode(value),
            md_hi = round(HPDhi(value), 3),
            md_low = round(HPDlo(value), 3))
cat("cost_size = ", costSizeSubset$md) 
cat("95% HPD interval = [", costSizeSubset$md_low, ",", costSizeSubset$md_hi, "]")

numericSubset = params.samples %>% 
#  filter(parameter %in% c("alpha", "lengthWeight", "typicality_color","typicality_size")) #%>%
  filter(parameter %in% c("alpha", "lengthWeight", "typicality_color","typicality_size","cost_color","cost_size")) #%>%
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
  geom_histogram(data=subset(numericSubset, parameter == "cost_color"),
                 binwidth = .01, colour="black", fill="white")+  
  geom_histogram(data=subset(numericSubset, parameter == "cost_size"),
                 binwidth = .01, colour="black", fill="white")+   
  #geom_histogram(data=subset(numericSubset, parameter == "typScale"),
   #              binwidth = .1, colour="black", fill="white")+  
    geom_density(aes(y=.18*..count..), data =subset(numericSubset, parameter == "lambda"), adjust = 3.5,
                 alpha=.2, fill="#FF6666")+
    geom_density(aes(y=.03*..count..),data=subset(numericSubset, parameter == "beta_l"),adjust = 3.5,
                 alpha=.2, fill="#FF6666")+
#    geom_density(aes(y=.01*..count..),data=subset(numericSubset, parameter == "beta_t"),adjust=2,
 #               alpha=.2, fill="#FF6666")+
  geom_density(aes(y=.001*..count..),data=subset(numericSubset, parameter == "typicality_color"),adjust = 3.5,
               alpha=.2, fill="#FF6666")+  
  geom_density(aes(y=.03*..count..),data=subset(numericSubset, parameter == "typicality_size"),adjust = 3.5,
               alpha=.2, fill="#FF6666")+  
  geom_density(aes(y=.1*..count..),data=subset(numericSubset, parameter == "cost_color"),adjust = 3.5,
               alpha=.2, fill="#FF6666")+  
  geom_density(aes(y=.05*..count..),data=subset(numericSubset, parameter == "cost_size"),adjust = 3.5,
               alpha=.2, fill="#FF6666")+  
  #  ylim(0,100) +
  #geom_density(aes(y=.1*..count..),data=subset(numericSubset, parameter == "typScale"),adjust=2,
   #            alpha=.2, fill="#FF6666")+  
    #ggtitle("Questioner Parameter Posteriors (1000 iterations)") +
    facet_grid(~ parameter, scales = "free_x") +
    theme_bw() +
  theme(plot.margin=unit(c(0,0,0,0),"cm"))
#ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/1_basic_overinformativeness/results_bda/graphs/parameterposteriors.pdf",height=2,width=7)
ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/1_basic_overinformativeness/results_bda/graphs/parameterposteriors-costs-typicalities.pdf",height=2,width=7)



### Predictives

# Import empirical data

source("results_bda/rscripts/helpers.R")
#empirical = read.table("bdaInput/data_bda_modifiers_reduced.csv",sep=",",col.names=c("gameID","bla","condition","size","color","utterance"))
empirical = read.table("bdaInput/data_bda_modifiers.csv",sep=",",col.names=c("gameID","bla","condition","size","color","othercolor","item","utterance"))
head(empirical)
#predictive<-read.csv("bdaOutput/bdaCombined-costsPredictives.csv", sep = ",", row.names = NULL) 
predictive<-read.csv("bdaOutput/bdaCombined-costs-typicalitiesPredictives.csv", sep = ",", row.names = NULL) 
head(predictive)

## collapse across targets and domains
#empirical$color = ifelse(empirical$utterance == "color",1,0)
empirical$color = ifelse(empirical$utterance %in% c("brown","red","black","blue","green","white","purple","pink","yellow","orange"),1,0)
empirical$size = ifelse(empirical$utterance == "size",1,0)
#empirical$size_color = ifelse(empirical$utterance == "size_color",1,0)
empirical$size_color = 0
empirical[grep("_",as.character(empirical$utterance)),]$size_color = 1
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
agr$NumDistractors = substr(as.character(agr$condition), nchar(as.character(agr$condition)) - 1, nchar(as.character(agr$condition)) - 1)
agr$NumSame = substr(as.character(agr$condition), nchar(as.character(agr$condition)), nchar(as.character(agr$condition)))
#agr$ModelType = "empirical"

predictive$utterance = "other"
predictive[predictive$value %in% c("size"),]$utterance = "size"
predictive[as.character(predictive$value) == as.character(predictive$color),]$utterance = "color"
predictive[as.character(predictive$value) == paste("size",predictive$color,sep="_"),]$utterance = "size_color"
#predictive[grep("_",as.character(predictive$value)),]$utterance = "size_color"
predictive.samples <- predictive[rep(row.names(predictive), 
                                     predictive$MCMCprob*samples), 1:9] %>%
#predictive.samples <- predictive[rep(row.names(predictive), 
#                                     predictive$MCMCprob*samples), 1:6] %>%
  mutate(Utterance = utterance) %>%
  group_by(Utterance, condition) %>%
  summarize(Prob = estimate_mode(prob),
            YMax = HPDhi(prob),
            YMin = HPDlo(prob)) %>%
  group_by(Utterance, condition) %>%
  summarize(ModelProbability = mean(Prob),
            ModelYMax = mean(Prob) + ci.high(Prob),
            ModelYMin = mean(Prob) - ci.low(Prob))
predictive.samples = as.data.frame(predictive.samples)
#predictive.samples$ModelType = "model"
predictive.samples = droplevels(predictive.samples[predictive.samples$Utterance %in% c("color","size","size_color"),])

toplot = merge(agr, predictive.samples, by.x=c("condition","Utterance"),all.y=T) 
toplot$SufficientDimension = ifelse(substr(toplot$condition,1,5) == "color","color","size")
toplot$NumDistractors = as.factor(as.character(toplot$NumDistractors))
toplot$NumSame = as.factor(as.character(toplot$NumSame))

ggplot(toplot, aes(x=ModelProbability,y=Probability,color=NumDistractors,shape=NumSame)) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax)) +
  geom_errorbarh(aes(xmin=ModelYMin,xmax=ModelYMax)) +
  geom_abline(intercept=0,slope=1,color="gray60") +
  facet_wrap(~SufficientDimension)
#ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/1_basic_overinformativeness/results_bda/graphs/predictives-costs.pdf",height=3,width=7)
ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/1_basic_overinformativeness/results_bda/graphs/predictives-costs-typicalities.pdf",height=3,width=7)

cor(toplot$ModelProbability,toplot$Probability) #r=.92

m = lm(ModelProbability~Probability,data=toplot)
summary(m) # R2=.85

m = lm(ModelProbability~Probability,data=toplot[toplot$SufficientDimension == "color",])
summary(m) # R2=.99

m = lm(ModelProbability~Probability,data=toplot[toplot$SufficientDimension == "size",])
summary(m) # R2=.59

# check golf ball
golfball = droplevels(predictive[predictive$item == "golfball",])
predictive.golfball <- golfball[rep(row.names(golfball), 
                                    golfball$MCMCprob*samples), 1:9] %>%
  #predictive.samples <- predictive[rep(row.names(predictive), 
  #                                     predictive$MCMCprob*samples), 1:6] %>%
  mutate(Utterance = utterance) %>%
  group_by(Utterance, condition, color) %>%
  summarize(Prob = estimate_mode(prob),
            YMax = HPDhi(prob),
            YMin = HPDlo(prob)) %>%
  group_by(Utterance, condition, color) %>%
  summarize(ModelProbability = mean(Prob),
            ModelYMax = mean(Prob) + ci.high(Prob),
            ModelYMin = mean(Prob) - ci.low(Prob))
predictive.golfball = as.data.frame(predictive.golfball)
#predictive.samples$ModelType = "model"
predictive.golfball = droplevels(predictive.golfball[predictive.golfball$Utterance %in% c("color","size","size_color"),])

predictive.golfball$SufficientDimension = ifelse(substr(predictive.golfball$condition,1,5) == "color","color","size")
predictive.golfball$condition = gsub("(color|size)","",as.character(predictive.golfball$condition))
predictive.golfball$NumDistractors = substr(predictive.golfball$condition,1,1)
predictive.golfball$NumSame = substr(predictive.golfball$condition,2,2)
predictive.golfball$ProportionSame = as.numeric(as.character(predictive.golfball$NumSame))/as.numeric(as.character(predictive.golfball$NumDistractors))

ggplot(predictive.golfball, aes(x=ProportionSame,y=ModelProbability,color=color)) +
  geom_point() +
  facet_grid(Utterance~SufficientDimension)
