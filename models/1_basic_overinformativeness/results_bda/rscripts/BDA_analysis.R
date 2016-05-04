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
# modelversion = "fixed-reducedconditions"
# modelversion = "fixed-reducedconditions-fullutts"
# modelversion = "fixed-reducedconditions-nospeaker"
# modelversion = "fixed-reducedconditions-fullutts-nospeaker"
# modelversion = "fixed-reducedconditions-fullutts-nospeaker-noother"

# modelversion = "fixed-fullconditions"
#modelversion = "fixed-fullconditions-fullutts"
# modelversion = "fixed-fullconditions-nospeaker"
# modelversion = "fixed-fullconditions-fullutts-nospeakeropt"
# modelversion = "fixed-fullconditions-fullutts-nospeaker-noother"

# modelversion = "empirical-fullconditions"
# modelversion = "empirical-fullconditions-fullutts"
# modelversion = "empirical-fullconditions-nospeaker"
# modelversion = "empirical-fullconditions-fullutts-nospeaker"
# modelversion = "empirical-fullconditions-fullutts-nospeaker-noother"
modelversion = "empirical-fullconditions-fullutts-nospeaker-noother-scaledtyp"

params<-read.csv(paste("bdaOutput/bda-",modelversion,"Params.csv",sep=""), sep = ",", row.names = NULL)
# samples = 3000
samples = 2000
param_sample_test = params %>%
  group_by(parameter) %>%
  summarise(Sum=sum(MCMCprob))
param_sample_test
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

typTypeSubset = params.samples %>% 
  filter(parameter == "typicality_type") %>%
  #mutate(value = as.numeric(levels(value))[value]) %>%
  group_by(parameter) %>%
  summarize(md = estimate_mode(value),
            md_hi = round(HPDhi(value), 3),
            md_low = round(HPDlo(value), 3))
cat("typicality_type = ", typTypeSubset$md) 
cat("95% HPD interval = [", typTypeSubset$md_low, ",", typTypeSubset$md_hi, "]")

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

costTypeSubset = params.samples %>% 
  filter(parameter == "cost_type") %>%
  #mutate(value = as.numeric(levels(value))[value]) %>%
  group_by(parameter) %>%
  summarize(md = estimate_mode(value),
            md_hi = round(HPDhi(value), 3),
            md_low = round(HPDlo(value), 3))
cat("cost_type = ", costTypeSubset$md) 
cat("95% HPD interval = [", costTypeSubset$md_low, ",", costTypeSubset$md_hi, "]")

numericSubset = params.samples %>% 
  filter(parameter %in% c("alpha", "lengthWeight", "typicality_color","typicality_size","typicality_type","cost_color","cost_size","cost_type","typWeight")) #%>%
numericSubset$parameter = as.character(numericSubset$parameter)
#numericSubset[numericSubset$parameter == "alpha",]$parameter = "lambda"
numericSubset[numericSubset$parameter == "lengthWeight",]$parameter = "beta_l"
numericSubset[numericSubset$parameter == "typWeight",]$parameter = "beta_t"

ggplot(numericSubset, aes(x=value)) +
    geom_histogram(data=subset(numericSubset, parameter == "alpha"), 
                   binwidth = .1, colour="black", fill="white")+
    geom_histogram(data=subset(numericSubset, parameter == "beta_l"),
                 binwidth = .1, colour="black", fill="white")+
   geom_histogram(data=subset(numericSubset, parameter == "beta_t"),
                binwidth = .05, colour="black", fill="white")+
  geom_histogram(data=subset(numericSubset, parameter == "typicality_color"),
                 binwidth = .01, colour="black", fill="white")+  
  geom_histogram(data=subset(numericSubset, parameter == "typicality_size"),
                 binwidth = .01, colour="black", fill="white")+ 
  geom_histogram(data=subset(numericSubset, parameter == "typicality_type"),
                 binwidth = .01, colour="black", fill="white")+ 
  geom_histogram(data=subset(numericSubset, parameter == "cost_color"),
                 binwidth = .01, colour="black", fill="white")+  
  geom_histogram(data=subset(numericSubset, parameter == "cost_size"),
                 binwidth = .01, colour="black", fill="white")+   
  geom_histogram(data=subset(numericSubset, parameter == "cost_type"),
                 binwidth = .01, colour="black", fill="white")+
    facet_grid(~ parameter, scales = "free_x") +
    theme_bw() +
  theme(plot.margin=unit(c(0,0,0,0),"cm"))
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/1_basic_overinformativeness/results_bda/graphs/parameterposteriors-",modelversion,".pdf",sep=""),height=3,width=15)


### Predictives

# Import empirical data
source("results_bda/rscripts/helpers.R")
#empirical = read.table("bdaInput/data_bda_modifiers_reduced.csv",sep=",",col.names=c("gameID","bla","condition","size","color","utterance"))
empirical = read.table("bdaInput/data_bda_modifiers_noother.csv",sep=",",col.names=c("gameID","bla","condition","size","color","othercolor","item","utterance"))
head(empirical)
empirical$actualcolor = empirical$color
empirical$color = ifelse(empirical$utterance %in% c("brown","red","black","blue","green","white","purple","pink","yellow","orange"),1,0)
empirical$size = ifelse(empirical$utterance == "size",1,0)
#empirical$size_color = ifelse(empirical$utterance == "size_color",1,0)
empirical$size_color = 0
empirical[grep("_",as.character(empirical$utterance)),]$size_color = 1
empirical$NumDistractors = as.numeric(as.character(substr(as.character(empirical$condition), nchar(as.character(empirical$condition)) -1,nchar(as.character(empirical$condition)) -1)))
empirical$NumSame = as.numeric(as.character(substr(as.character(empirical$condition), nchar(as.character(empirical$condition)),nchar(as.character(empirical$condition)))))
empirical$SufficientDimension = as.factor(as.character(ifelse(substr(empirical$condition,1,5) == "color","color","size")))
empirical$NumDiff = empirical$NumDistractors - empirical$NumSame
empirical$SceneVariation = empirical$NumDiff/empirical$NumDistractors
empirical$ColorItem = as.factor(paste(empirical$actualcolor,empirical$item,sep="_"))

# Import predictives data
predictive<-read.csv(paste("bdaOutput/bda-",modelversion,"Predictives.csv",sep=""), sep = ",", row.names = NULL) 
head(predictive)
predictive$utterance = "other"
predictive[as.character(predictive$value) == paste("size",predictive$item,sep="_"),]$utterance = "size"
predictive[as.character(predictive$value) == paste(predictive$color,predictive$item,sep="_"),]$utterance = "color"
predictive[as.character(predictive$value) == paste("size",predictive$color,predictive$item,sep="_"),]$utterance = "size_color"
predictive$ColorItem = as.factor(paste(predictive$color,predictive$item,sep="_"))

## first plot at the item level, without collapsing (only for non-reduced condition runs)
agre = empirical %>%
  select(color,size,size_color,condition,ColorItem) %>%
  gather(Utterance,Mentioned,-condition,-ColorItem) %>%
  group_by(condition,ColorItem,Utterance) %>%
  summarise(Probability=mean(Mentioned),
            cilow=ci.low(Mentioned),
            cihigh=ci.high(Mentioned)) %>%
  ungroup() %>%
  #  mutate(refLevel = factor(x = ifelse(agr$Utterance == "typeMentioned","sub", ifelse(agr$Utterance == "basiclevelMentioned","basic","super")), levels=c("sub","basic","super"))) %>%
  mutate(YMax = Probability + cihigh) %>%
  mutate(YMin = Probability - cilow) %>%
  select(condition,ColorItem, Utterance, Probability, YMax, YMin)
agre = as.data.frame(agre)
head(agre)
summary(agre)
agre$NumDistractors = substr(as.character(agre$condition), nchar(as.character(agre$condition)) - 1, nchar(as.character(agre$condition)) - 1)
agre$NumSame = substr(as.character(agre$condition), nchar(as.character(agre$condition)), nchar(as.character(agre$condition)))


predictive.samples <- predictive[rep(row.names(predictive), 
                                     predictive$MCMCprob*samples), 1:10] %>%
  mutate(Utterance = utterance) %>%
  group_by(Utterance, condition, ColorItem) %>%
  summarize(Prob = estimate_mode(prob),
            YMax = HPDhi(prob),
            YMin = HPDlo(prob)) %>%
  group_by(Utterance, condition, ColorItem) %>%
  summarize(ModelProbability = mean(Prob),
            ModelYMax = mean(Prob) + ci.high(Prob),
            ModelYMin = mean(Prob) - ci.low(Prob))
predictive.samples = as.data.frame(predictive.samples)
predictive.samples = droplevels(predictive.samples[predictive.samples$Utterance %in% c("color","size","size_color"),])
head(predictive.samples)

if(length(grep("reducedconditions",modelversion)) > 0) {
  row.names(predictive.samples) = paste(predictive.samples$Utterance,predictive.samples$condition)
  toplot = agre
  toplot$ModelProbability = predictive.samples[paste(toplot$Utterance,toplot$condition),]$ModelProbability
  toplot$ModelYMax = predictive.samples[paste(toplot$Utterance,toplot$condition),]$ModelYMax  
  toplot$ModelYMin = predictive.samples[paste(toplot$Utterance,toplot$condition),]$ModelYMin    
} else {
  toplot = merge(agre, predictive.samples, by=c("condition","Utterance","ColorItem"),all.y=T) 
  toplot$SufficientDimension = ifelse(substr(toplot$condition,1,5) == "color","color","size")
  toplot$NumDistractors = as.factor(as.character(toplot$NumDistractors))
  toplot$NumSame = as.factor(as.character(toplot$NumSame))
}

ggplot(toplot, aes(x=ModelProbability,y=Probability,color=NumDistractors,shape=NumSame)) +
  geom_point() +
#   geom_text(aes(label=ColorItem),size=3) +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax)) +
#   geom_errorbarh(aes(xmin=ModelYMin,xmax=ModelYMax)) +
  geom_abline(intercept=0,slope=1,color="gray60") 
#   facet_grid(SufficientDimension~Utterance)
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/1_basic_overinformativeness/results_bda/graphs/predictives-byitem-",modelversion,".pdf",sep=""),height=3,width=5)

cor(toplot$ModelProbability,toplot$Probability) # .82 with "TYPE" utt, .81 with and without "tYPe" and empirical typicalities but without speaker optimality param, .8 without "TYPE" or speaker optimality but empirical typicalities; r=.83 with reduced conditions!! -- ie empirical typicality (unscaled) messes things up!!


## collapse across targets and domains

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


predictive.samples <- predictive[rep(row.names(predictive), 
                                     predictive$MCMCprob*samples), 1:9] %>%
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
head(predictive.samples)

toplot = merge(agr, predictive.samples, by.x=c("condition","Utterance"),all.y=T) 
toplot$SufficientDimension = ifelse(substr(toplot$condition,1,5) == "color","color","size")
toplot$NumDistractors = as.factor(as.character(toplot$NumDistractors))
toplot$NumSame = as.factor(as.character(toplot$NumSame))
toplot$NumDiff = as.factor(as.character(as.numeric(as.character(toplot$NumDistractors)) - as.numeric(as.character(toplot$NumSame))))

ggplot(toplot, aes(x=ModelProbability,y=Probability,color=NumDistractors,shape=NumDiff)) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax)) +
  geom_errorbarh(aes(xmin=ModelYMin,xmax=ModelYMax)) +
  geom_abline(intercept=0,slope=1,color="gray60") +
  facet_grid(SufficientDimension~Utterance)
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/1_basic_overinformativeness/results_bda/graphs/predictives-",modelversion,".pdf",sep=""),height=5,width=9)

ggplot(toplot, aes(x=ModelProbability,y=Probability,color=NumDistractors,shape=NumDiff)) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax)) +
  geom_errorbarh(aes(xmin=ModelYMin,xmax=ModelYMax)) +
  ylab("Empirical proportion") +
  xlab("Model probability") +
  guides(shape=guide_legend("Number of\ndifferent distractors"),color=guide_legend("Number of\ndistractors")) +
  geom_abline(intercept=0,slope=1,color="gray60")
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/1_basic_overinformativeness/results_bda/graphs/predictives-collapsed-",modelversion,".pdf",sep=""),height=3,width=5)

cor(toplot$ModelProbability,toplot$Probability) #r=.98 fixed reduced (both with and without "TYPE" utterance, with and without speaker opt parameter); r=.95 fixed full; r=.96 fixed full with "TYPE"; r=.96 with empirical and 'TYPE"; r=.95 with empirical and no "TYPE" or speaker-opt

# plot scene variation effect, both model and empirical
agr = empirical %>%
  select(color,size,size_color,SufficientDimension,SceneVariation,NumDistractors) %>%
  gather(Utterance,Mentioned,-SufficientDimension,-SceneVariation,-NumDistractors) %>%
  group_by(SufficientDimension,SceneVariation,NumDistractors,Utterance) %>%
  summarise(Probability=mean(Mentioned),
            cilow=ci.low(Mentioned),
            cihigh=ci.high(Mentioned)) %>%
  ungroup() %>%
  #  mutate(refLevel = factor(x = ifelse(agr$Utterance == "typeMentioned","sub", ifelse(agr$Utterance == "basiclevelMentioned","basic","super")), levels=c("sub","basic","super"))) %>%
  mutate(YMax = Probability + cihigh) %>%
  mutate(YMin = Probability - cilow) %>%
  select(SufficientDimension,SceneVariation, NumDistractors,Utterance, Probability, YMax, YMin)
agr = as.data.frame(agr)

predictive.samples$NumDistractors = as.numeric(as.character(substr(as.character(predictive.samples$condition), nchar(as.character(predictive.samples$condition)) - 1, nchar(as.character(predictive.samples$condition)) - 1)))
predictive.samples$NumSame = as.numeric(as.character(substr(as.character(predictive.samples$condition), nchar(as.character(predictive.samples$condition)),nchar(as.character(predictive.samples$condition)))))
predictive.samples$SufficientDimension = as.factor(as.character(ifelse(substr(predictive.samples$condition,1,5) == "color","color","size")))
predictive.samples$NumDiff = predictive.samples$NumDistractors - predictive.samples$NumSame
predictive.samples$SceneVariation = predictive.samples$NumDiff/predictive.samples$NumDistractors

pr = predictive.samples %>%
  mutate(Probability = ModelProbability, YMin = ModelYMin, YMax = ModelYMax) %>%
  select(SufficientDimension,SceneVariation,NumDistractors,Utterance,Probability,YMax,YMin)
head(pr)
pr$Data = "model"
agr$Data = "empirical"
m = rbind(agr,pr)
m$NumDistractors = as.factor(as.character(m$NumDistractors)) 

ggplot(m, aes(x=SceneVariation,y=Probability,color=Data,group=Data,shape=NumDistractors)) +
  geom_point() +
  ylab("Utterance probability") +
  xlab("Scene variation") +
  guides(shape = guide_legend("Number of\ndistractors")) +
#  geom_smooth(method="lm") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax)) +
  facet_grid(SufficientDimension~Utterance)
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/1_basic_overinformativeness/results_bda/graphs/scenevariation-",modelversion,".pdf",sep=""),height=5,width=9)




# deal with item-wise typicality
maxdiffcases = read.csv("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/9_norming_colordescription_typicality/results/data/maxdiffitems.csv")
row.names(maxdiffcases) = paste(maxdiffcases$Color,maxdiffcases$Item)
predictive$TypicalityDiff = maxdiffcases[paste(predictive$color,predictive$item),]$Diff
predictive$combo = paste(predictive$color,predictive$item)

pr <- predictive[rep(row.names(predictive), predictive$MCMCprob*samples), 1:12] %>%
  mutate(Utterance = utterance) %>%
  group_by(Utterance, condition, combo, TypicalityDiff) %>%
  summarize(Prob = estimate_mode(prob),
            YMax = HPDhi(prob),
            YMin = HPDlo(prob)) %>%
  group_by(Utterance, condition, combo, TypicalityDiff) %>%
  summarize(ModelProbability = mean(Prob),
            ModelYMax = mean(Prob) + ci.high(Prob),
            ModelYMin = mean(Prob) - ci.low(Prob))
pr = as.data.frame(pr)
pr = droplevels(pr[pr$Utterance %in% c("color","size","size_color"),])
head(pr)
pr$SufficientDimension = ifelse(substr(pr$condition,1,5) == "color","color","size")
pr$condition = gsub("(color|size)","",as.character(pr$condition))
pr$NumDistractors = substr(pr$condition,1,1)
pr$NumSame = substr(pr$condition,2,2)
pr$ProportionSame = as.numeric(as.character(pr$NumSame))/as.numeric(as.character(pr$NumDistractors))
pr$Color = sapply(strsplit(as.character(pr$combo)," "), "[", 1)
pr$Item = sapply(strsplit(as.character(pr$combo)," "), "[", 2)
maxitems = droplevels(pr[pr$Item %in% maxdiffcases$Item[1:4],]) %>%
  group_by(combo,Item,SufficientDimension,Utterance,TypicalityDiff) %>%
  summarise(ModelProbability=mean(ModelProbability))
maxitems = as.data.frame(maxitems)

ggplot(maxitems, aes(x=TypicalityDiff,y=ModelProbability, color=Item, group=Item)) +
  geom_point() +
  geom_line() +
#   geom_text(aes(label=combo)) +
  facet_grid(SufficientDimension~Utterance)

ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/1_basic_overinformativeness/results_bda/graphs/maxtypicalitydiffcases-",modelversion,".pdf",sep=""),height=6,width=10)




# test
predictive$complete_item = paste(predictive$size,predictive$color,predictive$item)
test = predictive  %>%
  group_by(complete_item,value,condition) %>%
  summarize(NumSamples=length(prob))
head(test)

m = lm(ModelProbability~Probability,data=toplot)
summary(m) # R2=.85

m = lm(ModelProbability~Probability,data=toplot[toplot$SufficientDimension == "color",])
summary(m) # R2=.99

m = lm(ModelProbability~Probability,data=toplot[toplot$SufficientDimension == "size",])
summary(m) # R2=.59

# check golf ball
# golfball = droplevels(predictive[predictive$item == "golfball",])
# predictive.golfball <- golfball[rep(row.names(golfball), 
#                                     golfball$MCMCprob*samples), 1:9] %>%
#   #predictive.samples <- predictive[rep(row.names(predictive), 
#   #                                     predictive$MCMCprob*samples), 1:6] %>%
#   mutate(Utterance = utterance) %>%
#   group_by(Utterance, condition, color) %>%
#   summarize(Prob = estimate_mode(prob),
#             YMax = HPDhi(prob),
#             YMin = HPDlo(prob)) %>%
#   group_by(Utterance, condition, color) %>%
#   summarize(ModelProbability = mean(Prob),
#             ModelYMax = mean(Prob) + ci.high(Prob),
#             ModelYMin = mean(Prob) - ci.low(Prob))
# predictive.golfball = as.data.frame(predictive.golfball)
# #predictive.samples$ModelType = "model"
# predictive.golfball = droplevels(predictive.golfball[predictive.golfball$Utterance %in% c("color","size","size_color"),])
# 
# predictive.golfball$SufficientDimension = ifelse(substr(predictive.golfball$condition,1,5) == "color","color","size")
# predictive.golfball$condition = gsub("(color|size)","",as.character(predictive.golfball$condition))
# predictive.golfball$NumDistractors = substr(predictive.golfball$condition,1,1)
# predictive.golfball$NumSame = substr(predictive.golfball$condition,2,2)
# predictive.golfball$ProportionSame = as.numeric(as.character(predictive.golfball$NumSame))/as.numeric(as.character(predictive.golfball$NumDistractors))
# 
# ggplot(predictive.golfball, aes(x=ProportionSame,y=ModelProbability,color=color)) +
#   geom_point() +
#   facet_grid(Utterance~SufficientDimension)
