setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/Elisa_colortypicality")
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

source("results_bda/rscripts/helpers.R")
### Load in model results (parameters)
modelversion = "hmc-seed8"
modelversion = "hmc-seed10"

params<-read.csv(paste("bdaOutput/bda-",modelversion,"Params.csv",sep=""), sep = ",", row.names = NULL)
samples = nrow(params)/length(levels(params$parameter))
print(paste("Number of samples:",samples))
param_sample_test = params %>%
  group_by(parameter) %>%
  summarise(Sum=sum(MCMCprob))
param_sample_test
summary(params)
params.samples <- params[rep(row.names(params), params$MCMCprob*samples), 1:2] # this gets you only the ones with non-zero probability

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
  # mutate(value = as.numeric(levels(value))[value]) %>%
  group_by(parameter) %>%
  summarise(md = estimate_mode(value),
            md_hi = round(HPDhi(value), 3),
            md_low = round(HPDlo(value), 3))
cat("lengthWeight = ", lengthWeightSubset$md) 
cat("95% HPD interval = [", lengthWeightSubset$md_low, ",", lengthWeightSubset$md_hi, "]")

typColorSubset = params.samples %>% 
  filter(parameter == "cost_color") %>%
  #mutate(value = as.numeric(levels(value))[value]) %>%
  group_by(parameter) %>%
  summarise(md = estimate_mode(value),
            md_hi = round(HPDhi(value), 3),
            md_low = round(HPDlo(value), 3))
cat("cost_color = ", typColorSubset$md) 
cat("95% HPD interval = [", typColorSubset$md_low, ",", typColorSubset$md_hi, "]")

typSizeSubset = params.samples %>% 
  filter(parameter == "cost_type") %>%
  #mutate(value = as.numeric(levels(value))[value]) %>%
  group_by(parameter) %>%
  summarise(md = estimate_mode(value),
            md_hi = round(HPDhi(value), 3),
            md_low = round(HPDlo(value), 3))
cat("cost_type = ", typSizeSubset$md) 
cat("95% HPD interval = [", typSizeSubset$md_low, ",", typSizeSubset$md_hi, "]")


costColorSubset = params.samples %>% 
  filter(parameter == "color_only_cost") %>%
  #mutate(value = as.numeric(levels(value))[value]) %>%
  group_by(parameter) %>%
  summarise(md = estimate_mode(value),
            md_hi = round(HPDhi(value), 3),
            md_low = round(HPDlo(value), 3))
cat("color_only_cost = ", costColorSubset$md) 
cat("95% HPD interval = [", costColorSubset$md_low, ",", costColorSubset$md_hi, "]")

numericSubset = params.samples %>% 
  filter(parameter %in% c("alpha", "lengthWeight", "cost_color","cost_type","color_only_cost")) #%>%
numericSubset$parameter = as.character(numericSubset$parameter)
numericSubset[numericSubset$parameter == "alpha",]$parameter = "lambda"
numericSubset[numericSubset$parameter == "lengthWeight",]$parameter = "beta_c"
numericSubset[numericSubset$parameter == "cost_color",]$parameter = "cost_color"
numericSubset[numericSubset$parameter == "cost_type",]$parameter = "cost_type"
numericSubset[numericSubset$parameter == "color_only_cost",]$parameter = "color_only_cost"

numericSubset$param = factor(x=numericSubset$parameter,levels=c("lambda","beta_c","cost_color","cost_type","color_only_cost"))

bw = 10

ggplot(numericSubset, aes(x=value)) +
    geom_histogram(data=subset(numericSubset, parameter == "lambda"), 
                   binwidth = (range(numericSubset[numericSubset$parameter == "lambda",]$value)[2] - range(numericSubset[numericSubset$parameter == "lambda",]$value)[1])/bw, colour="black", fill="white")+
    geom_histogram(data=subset(numericSubset, parameter == "beta_c"),
                 binwidth = (range(numericSubset[numericSubset$parameter == "beta_c",]$value)[2] - range(numericSubset[numericSubset$parameter == "beta_c",]$value)[1])/bw, colour="black", fill="white")+
  geom_histogram(data=subset(numericSubset, parameter == "cost_color"),
                 binwidth = (range(numericSubset[numericSubset$parameter == "cost_color",]$value)[2] - range(numericSubset[numericSubset$parameter == "cost_color",]$value)[1])/bw, colour="black", fill="white")+  
  geom_histogram(data=subset(numericSubset, parameter == "cost_type"),
                 binwidth = (range(numericSubset[numericSubset$parameter == "cost_type",]$value)[2] - range(numericSubset[numericSubset$parameter == "cost_type",]$value)[1])/bw, colour="black", fill="white")+ 
  geom_histogram(data=subset(numericSubset, parameter == "color_only_cost"),
                 binwidth = (range(numericSubset[numericSubset$parameter == "color_only_cost",]$value)[2] - range(numericSubset[numericSubset$parameter == "color_only_cost",]$value)[1])/bw, colour="black", fill="white")+  
    facet_grid(~ param, scales = "free_x") +
    theme_bw() +
  theme(plot.margin=unit(c(0,0,0,0),"cm"))
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/Elisa_colortypicality/results_bda/graphs/parameterposteriors-",modelversion,".pdf",sep=""),height=2,width=13)

### Predictives

# Import empirical data
source("results_bda/rscripts/helpers.R")
empirical = read.table("bdaInput/bda_data.csv",sep=",",col.names=c("condition","target_color","target_type","dist1_color","dist1_type","dist2_color","dist2_type","utterance"))
head(empirical)
empirical$target_item = paste(empirical$target_color,empirical$target_type,sep="_")
empirical$color = ifelse(as.character(empirical$utterance) == as.character(empirical$target_color),1,0)
empirical$type = ifelse(as.character(empirical$utterance) == as.character(empirical$target_type),1,0)
empirical$color_type = ifelse(as.character(empirical$utterance) == as.character(empirical$target_item),1,0) 

# Import predictives data
predictive<-read.csv(paste("bdaOutput/bda-",modelversion,"Predictives.csv",sep=""), sep = ",", row.names = NULL) 
head(predictive)
predictive$utterance = "other"

predictive$UtteranceColor = sapply(strsplit(as.character(predictive$value),split="_"),"[",1)
predictive$UtteranceType = sapply(strsplit(as.character(predictive$value),split="_"),"[",2)

predictive[predictive$UtteranceColor %in% levels(predictive$TargetType),]$UtteranceType = predictive[predictive$UtteranceColor %in% levels(predictive$TargetType),]$UtteranceColor
predictive[predictive$UtteranceColor %in% levels(predictive$TargetType),]$UtteranceColor = NA

predictive$CorrectColor = ifelse(as.character(predictive$TargetColor) == as.character(predictive$UtteranceColor),1,0)
predictive$CorrectType = ifelse(as.character(predictive$TargetType) == as.character(predictive$UtteranceType),1,0)
predictive[is.na(predictive$CorrectColor),]$CorrectColor = -1
predictive[is.na(predictive$CorrectType),]$CorrectType = -1

predictive[predictive$CorrectColor == 1 & predictive$CorrectType == -1,]$utterance = "color"
predictive[predictive$CorrectColor == 1 & predictive$CorrectType == 1,]$utterance = "color_type"
predictive[predictive$CorrectColor == -1 & predictive$CorrectType == 1,]$utterance = "type"

predictive$target_item = paste(predictive$TargetColor,predictive$TargetType,sep="_")
head(predictive)

# ## first plot at the item level, without collapsing (only for non-reduced condition runs) --> FIXME
# agre = empirical %>%
#   select(target_color,target_type,dist1_color,condition,target_item) %>%
#   gather(Utterance,Mentioned,-condition,-ColorItem) %>%
#   group_by(condition,ColorItem,Utterance) %>%
#   summarise(Probability=mean(Mentioned),
#             cilow=ci.low(Mentioned),
#             cihigh=ci.high(Mentioned)) %>%
#   ungroup() %>%
#   #  mutate(refLevel = factor(x = ifelse(agr$Utterance == "typeMentioned","sub", ifelse(agr$Utterance == "basiclevelMentioned","basic","super")), levels=c("sub","basic","super"))) %>%
#   mutate(YMax = Probability + cihigh) %>%
#   mutate(YMin = Probability - cilow) %>%
#   select(condition,ColorItem, Utterance, Probability, YMax, YMin)
# agre = as.data.frame(agre)
# head(agre)
# summary(agre)
# agre$NumDistractors = substr(as.character(agre$condition), nchar(as.character(agre$condition)) - 1, nchar(as.character(agre$condition)) - 1)
# agre$NumSame = substr(as.character(agre$condition), nchar(as.character(agre$condition)), nchar(as.character(agre$condition)))
# 
# 
# predictive.samples <- predictive[rep(row.names(predictive), 
#                                      predictive$MCMCprob*samples), 1:10] %>%
#   mutate(Utterance = utterance) %>%
#   group_by(Utterance, condition, ColorItem) %>%
#   summarise(Prob = estimate_mode(prob),
#             YMax = HPDhi(prob),
#             YMin = HPDlo(prob)) %>%
#   group_by(Utterance, condition, ColorItem) %>%
#   summarise(ModelProbability = mean(Prob),
#             ModelYMax = mean(Prob) + ci.high(Prob),
#             ModelYMin = mean(Prob) - ci.low(Prob))
# predictive.samples = as.data.frame(predictive.samples)
# predictive.samples = droplevels(predictive.samples[predictive.samples$Utterance %in% c("color","size","size_color"),])
# head(predictive.samples)
# 
# if(length(grep("reducedconditions",modelversion)) > 0) {
#   row.names(predictive.samples) = paste(predictive.samples$Utterance,predictive.samples$condition)
#   toplot = agre
#   toplot$ModelProbability = predictive.samples[paste(toplot$Utterance,toplot$condition),]$ModelProbability
#   toplot$ModelYMax = predictive.samples[paste(toplot$Utterance,toplot$condition),]$ModelYMax  
#   toplot$ModelYMin = predictive.samples[paste(toplot$Utterance,toplot$condition),]$ModelYMin    
# } else {
#   toplot = merge(agre, predictive.samples, by=c("condition","Utterance","ColorItem"),all.y=T) 
#   toplot$SufficientDimension = ifelse(substr(toplot$condition,1,5) == "color","color","size")
#   toplot$NumDistractors = as.factor(as.character(toplot$NumDistractors))
#   toplot$NumSame = as.factor(as.character(toplot$NumSame))
# }
# 
# ggplot(toplot, aes(x=ModelProbability,y=Probability,color=NumDistractors,shape=NumSame)) +
#   geom_point() +
# #   geom_text(aes(label=ColorItem),size=3) +
# #   geom_errorbar(aes(ymin=YMin,ymax=YMax)) +
# #   geom_errorbarh(aes(xmin=ModelYMin,xmax=ModelYMax)) +
#   geom_abline(intercept=0,slope=1,color="gray60") 
# #   facet_grid(SufficientDimension~Utterance)
# ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/1b_bda_typicality/results_bda/graphs/predictives-byitem-",modelversion,".pdf",sep=""),height=3,width=5)
# 
# cor(toplot$ModelProbability,toplot$Probability) 
# empirical typicality, round 1: .84
# empirical typicality, seed 8: .83
# raw empirical typicality, seed 8: .49


## collapse across distractors

agr = empirical %>%
  select(color,type,color_type,condition,target_item) %>%
  gather(Utterance,Mentioned,-condition,-target_item) %>%
  group_by(condition,Utterance,target_item) %>%
  summarise(Probability=mean(Mentioned),
            cilow=ci.low(Mentioned),
            cihigh=ci.high(Mentioned)) %>%
  ungroup() %>%
#  mutate(refLevel = factor(x = ifelse(agr$Utterance == "typeMentioned","sub", ifelse(agr$Utterance == "basiclevelMentioned","basic","super")), levels=c("sub","basic","super"))) %>%
  mutate(YMax = Probability + cihigh) %>%
  mutate(YMin = Probability - cilow) %>%
  select(condition, target_item, Utterance, Probability, YMax, YMin)
agr = as.data.frame(agr)
head(agr)
summary(agr)
agr$Data="empirical"

predictive.samples <- predictive[rep(row.names(predictive), 
                                     predictive$MCMCprob*samples), ] %>%
  mutate(Utterance = utterance) %>%
  group_by(Utterance, condition, target_item) %>%
  summarise(Prob = estimate_mode(prob),
            YMax = HPDhi(prob),
            YMin = HPDlo(prob)) %>%
  group_by(Utterance, condition, target_item) %>%
  summarise(ModelProbability = mean(Prob),
            ModelYMax = mean(Prob) + ci.high(Prob),
            ModelYMin = mean(Prob) - ci.low(Prob))
predictive.samples = as.data.frame(predictive.samples)
predictive.samples$Data = "model"
predictive.samples = droplevels(predictive.samples[predictive.samples$Utterance %in% c("color","type","color_type"),])
head(predictive.samples)
nrow(predictive.samples)
row.names(predictive.samples) = paste(predictive.samples$Utterance,predictive.samples$condition,predictive.samples$target_item)

toplot = agr
toplot$ModelProbability = predictive.samples[paste(agr$Utterance,agr$condition,agr$target_item),]$ModelProbability
toplot$ModelYMin = predictive.samples[paste(agr$Utterance,agr$condition,agr$target_item),]$ModelYMin
toplot$ModelYMax = predictive.samples[paste(agr$Utterance,agr$condition,agr$target_item),]$ModelYMax
# toplot = merge(predictive.samples,agr, by.x=c("condition","Utterance","target_item"),all.y=T) 

ggplot(toplot, aes(x=ModelProbability,y=Probability,color=condition)) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax)) +
  geom_errorbarh(aes(xmin=ModelYMin,xmax=ModelYMax)) +
  geom_abline(intercept=0,slope=1,color="gray60") +
  facet_wrap(~Utterance)
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/Elisa_colortypicality/results_bda/graphs/predictives-",modelversion,".pdf",sep=""),height=4,width=14)

cor(toplot$ModelProbability,toplot$Probability) 

