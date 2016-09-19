setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/1b_bda_typicality")
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
modelversion = "empirical-scaledtyp-maxdifftyp-hmc"
modelversion = "empirical-scaledtyp-maxdifftyp-seed10"

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

typWeightSubset = params.samples %>% 
  filter(parameter == "typWeight") %>%
  #mutate(value = as.numeric(levels(value))[value]) %>%
  group_by(parameter) %>%
  summarise(md = estimate_mode(value),
            md_hi = round(HPDhi(value), 3),
            md_low = round(HPDlo(value), 3))
cat("typWeight = ", typWeightSubset$md) 
cat("95% HPD interval = [", typWeightSubset$md_low, ",", typWeightSubset$md_hi, "]")

typColorSubset = params.samples %>% 
  filter(parameter == "typicality_color") %>%
  #mutate(value = as.numeric(levels(value))[value]) %>%
  group_by(parameter) %>%
  summarise(md = estimate_mode(value),
            md_hi = round(HPDhi(value), 3),
            md_low = round(HPDlo(value), 3))
cat("typicality_color = ", typColorSubset$md) 
cat("95% HPD interval = [", typColorSubset$md_low, ",", typColorSubset$md_hi, "]")

typSizeSubset = params.samples %>% 
  filter(parameter == "typicality_size") %>%
  #mutate(value = as.numeric(levels(value))[value]) %>%
  group_by(parameter) %>%
  summarise(md = estimate_mode(value),
            md_hi = round(HPDhi(value), 3),
            md_low = round(HPDlo(value), 3))
cat("typicality_size = ", typSizeSubset$md) 
cat("95% HPD interval = [", typSizeSubset$md_low, ",", typSizeSubset$md_hi, "]")

# typTypeSubset = params.samples %>% 
#   filter(parameter == "typicality_type") %>%
#   #mutate(value = as.numeric(levels(value))[value]) %>%
#   group_by(parameter) %>%
#   summarise(md = estimate_mode(value),
#             md_hi = round(HPDhi(value), 3),
#             md_low = round(HPDlo(value), 3))
# cat("typicality_type = ", typTypeSubset$md) 
# cat("95% HPD interval = [", typTypeSubset$md_low, ",", typTypeSubset$md_hi, "]")

costColorSubset = params.samples %>% 
  filter(parameter == "cost_color") %>%
  #mutate(value = as.numeric(levels(value))[value]) %>%
  group_by(parameter) %>%
  summarise(md = estimate_mode(value),
            md_hi = round(HPDhi(value), 3),
            md_low = round(HPDlo(value), 3))
cat("cost_color = ", costColorSubset$md) 
cat("95% HPD interval = [", costColorSubset$md_low, ",", costColorSubset$md_hi, "]")

costSizeSubset = params.samples %>% 
  filter(parameter == "cost_size") %>%
  #mutate(value = as.numeric(levels(value))[value]) %>%
  group_by(parameter) %>%
  summarise(md = estimate_mode(value),
            md_hi = round(HPDhi(value), 3),
            md_low = round(HPDlo(value), 3))
cat("cost_size = ", costSizeSubset$md) 
cat("95% HPD interval = [", costSizeSubset$md_low, ",", costSizeSubset$md_hi, "]")

# costTypeSubset = params.samples %>% 
#   filter(parameter == "cost_type") %>%
#   #mutate(value = as.numeric(levels(value))[value]) %>%
#   group_by(parameter) %>%
#   summarise(md = estimate_mode(value),
#             md_hi = round(HPDhi(value), 3),
#             md_low = round(HPDlo(value), 3))
# cat("cost_type = ", costTypeSubset$md) 
# cat("95% HPD interval = [", costTypeSubset$md_low, ",", costTypeSubset$md_hi, "]")

numericSubset = params.samples %>% 
  filter(parameter %in% c("alpha", "lengthWeight", "typicality_color","typicality_size","cost_color","cost_size","typWeight")) #%>%
numericSubset$parameter = as.character(numericSubset$parameter)
numericSubset[numericSubset$parameter == "alpha",]$parameter = "lambda"
# numericSubset[numericSubset$parameter == "lengthWeight",]$parameter = "beta_l"
numericSubset[numericSubset$parameter == "lengthWeight",]$parameter = "beta_c"
numericSubset[numericSubset$parameter == "typWeight",]$parameter = "beta_t"
numericSubset[numericSubset$parameter == "typicality_color",]$parameter = "fidelity_color"
numericSubset[numericSubset$parameter == "typicality_size",]$parameter = "fidelity_size"
numericSubset[numericSubset$parameter == "cost_color",]$parameter = "cost_color"
numericSubset[numericSubset$parameter == "cost_size",]$parameter = "cost_size"

numericSubset$param = factor(x=numericSubset$parameter,levels=c("fidelity_size","fidelity_color","cost_size","cost_color","beta_c","lambda"))

bw = 10

ggplot(numericSubset, aes(x=value)) +
    geom_histogram(data=subset(numericSubset, parameter == "lambda"), 
                   binwidth = (range(numericSubset[numericSubset$parameter == "lambda",]$value)[2] - range(numericSubset[numericSubset$parameter == "lambda",]$value)[1])/bw, colour="black", fill="white")+
    geom_histogram(data=subset(numericSubset, parameter == "beta_c"),
                 binwidth = (range(numericSubset[numericSubset$parameter == "beta_c",]$value)[2] - range(numericSubset[numericSubset$parameter == "beta_c",]$value)[1])/bw, colour="black", fill="white")+
#    geom_histogram(data=subset(numericSubset, parameter == "beta_t"),
#                 binwidth = (range(numericSubset[numericSubset$parameter == "beta_t",]$value)[2] - range(numericSubset[numericSubset$parameter == "beta_t",]$value)[1])/20, colour="black", fill="white")+
  geom_histogram(data=subset(numericSubset, parameter == "fidelity_color"),
                 binwidth = (range(numericSubset[numericSubset$parameter == "fidelity_color",]$value)[2] - range(numericSubset[numericSubset$parameter == "fidelity_color",]$value)[1])/bw, colour="black", fill="white")+  
  geom_histogram(data=subset(numericSubset, parameter == "fidelity_size"),
                 binwidth = (range(numericSubset[numericSubset$parameter == "fidelity_size",]$value)[2] - range(numericSubset[numericSubset$parameter == "fidelity_size",]$value)[1])/bw, colour="black", fill="white")+ 
#   geom_histogram(data=subset(numericSubset, parameter == "typicality_type"),
#                  binwidth = .01, colour="black", fill="white")+ 
  geom_histogram(data=subset(numericSubset, parameter == "cost_color"),
                 binwidth = (range(numericSubset[numericSubset$parameter == "cost_color",]$value)[2] - range(numericSubset[numericSubset$parameter == "cost_color",]$value)[1])/bw, colour="black", fill="white")+  
  geom_histogram(data=subset(numericSubset, parameter == "cost_size"),
                 binwidth = (range(numericSubset[numericSubset$parameter == "cost_size",]$value)[2] - range(numericSubset[numericSubset$parameter == "cost_size",]$value)[1])/bw, colour="black", fill="white")+   
#   geom_histogram(data=subset(numericSubset, parameter == "cost_type"),
#                  binwidth = .01, colour="black", fill="white")+
    facet_grid(~ param, scales = "free_x") +
    theme_bw() +
  theme(plot.margin=unit(c(0,0,0,0),"cm"))
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/1b_bda_typicality/results_bda/graphs/parameterposteriors-",modelversion,".pdf",sep=""),height=2,width=13)

# look at joint distributions of typicality and size
params$SampleNum = rep(seq(1,nrow(params)/8),each=8)
spreadparams = params %>%
  spread(parameter,value)
spreadparams$TypColorMinusSize = spreadparams$typicality_color - spreadparams$typicality_size
head(spreadparams)

costs = spreadparams %>%
  select(MCMCprob,SampleNum,cost_color,cost_size) %>%
  gather(Cost,Value,-MCMCprob,-SampleNum)

ggplot(costs, aes(x=Cost,y=Value,color=MCMCprob,group=SampleNum)) +
  geom_line() +
  ylab("Parameter value") 
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/1b_bda_typicality/results_bda/graphs/joint-cost-",modelversion,".pdf",sep=""),height=4,width=8)

spreadparams$AlphaBin = cut_number(spreadparams$alpha,n=2)
spreadparams = spreadparams %>%
  group_by(AlphaBin) %>%
  mutate(Median=median(TypColorMinusSize))
spreadparams = as.data.frame(spreadparams)

ggplot(spreadparams, aes(x=TypColorMinusSize))+ #,color=MCMCprob,group=SampleNum)) +
  #geom_line() +
#   ylab("Parameter value") +
  geom_histogram() +
#   geom_density() +
 geom_vline(xintercept = 0,color="red") +
#  geom_vline(xintercept = spreadparams$Median,color="blue") +
  facet_wrap(~AlphaBin)
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/1b_bda_typicality/results_bda/graphs/joint-typicality-alpha-",modelversion,".pdf",sep=""),height=5,width=8)

spreadparams$LengthWeightBin = cut_number(spreadparams$lengthWeight,n=2)
ggplot(spreadparams, aes(x=TypColorMinusSize)) +
#   geom_line() +
#   ylab("Parameter value") +
  geom_histogram() +
  geom_vline(xintercept = 0,color="red") +
  facet_wrap(~LengthWeightBin)
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/1b_bda_typicality/results_bda/graphs/joint-typicality-lengthweight-",modelversion,".pdf",sep=""),height=5,width=8)

ggplot(spreadparams, aes(x=TypColorMinusSize)) +
  geom_histogram() +
  geom_vline(xintercept = 0,color="red") +
  facet_grid(AlphaBin~LengthWeightBin)
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/1b_bda_typicality/results_bda/graphs/joint-",modelversion,".pdf",sep=""),height=5,width=8)

ubound = as.numeric(gsub("]","",strsplit(levels(spreadparams$LengthWeightBin)[1],",")[[1]][2]))

ggplot(spreadparams, aes(x=TypColorMinusSize, y=lengthWeight))+
  geom_rect(xmin=-Inf,xmax=0,ymin=ubound,ymax=Inf,fill="darkolivegreen3",alpha=.5) +
  geom_rect(xmin=-Inf,xmax=0,ymin=-Inf,ymax=ubound,fill="darksalmon",alpha=.5) +
  geom_point(aes(size=MCMCprob,color=MCMCprob)) +
  geom_vline(xintercept=0) +
  geom_segment(x = -Inf, y = ubound , xend = 0, yend = ubound) +
  ylab("Cost weight") +
  xlab("Fidelity difference between color and size") +
  guides(color=guide_legend(title="MCMC\nprobability"), size=guide_legend(title="MCMC\nprobability")) +
  scale_size(range = c(0, 5))
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/1b_bda_typicality/results_bda/graphs/fidelity-outliers-",modelversion,".pdf",sep=""),height=6,width=9) 

# To report in paper:
print(paste("Proportion of the ",samples," samples with a color fidelity smaller than size fidelity:"))
nrow(spreadparams[spreadparams$TypColorMinusSize < 0,])/samples

print(paste("Probability of color fidelity smaller than size fidelity:"))
sum(spreadparams[spreadparams$TypColorMinusSize < 0,]$MCMCprob)

print(paste("Proportion of the ",samples," samples with a color fidelity smaller than size fidelity AND low cost weight:"))
nrow(spreadparams[spreadparams$TypColorMinusSize < 0 & spreadparams$LengthWeightBin == levels(spreadparams$LengthWeightBin)[1],])/samples

print(paste("Probability of color fidelity smaller than size fidelity AND low cost weight:"))
sum(spreadparams[spreadparams$TypColorMinusSize < 0 & spreadparams$LengthWeightBin == levels(spreadparams$LengthWeightBin)[1],]$MCMCprob)

print(paste("Probability of low cost weight, given that color fidelity is smaller than size fidelity:"))
sum(spreadparams[spreadparams$TypColorMinusSize < 0 & spreadparams$LengthWeightBin == levels(spreadparams$LengthWeightBin)[1],]$MCMCprob)/sum(spreadparams[spreadparams$TypColorMinusSize < 0,]$MCMCprob)




### Predictives

# Import empirical data
source("results_bda/rscripts/helpers.R")
#empirical = read.table("bdaInput/data_bda_modifiers_reduced.csv",sep=",",col.names=c("gameID","bla","condition","size","color","utterance"))
empirical = read.table("bdaInput/data_bda_modifiers_maxdifftypicality.csv",sep=",",col.names=c("gameID","bla","condition","size","color","othercolor","item","utterance"))
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
  summarise(Prob = estimate_mode(prob),
            YMax = HPDhi(prob),
            YMin = HPDlo(prob)) %>%
  group_by(Utterance, condition, ColorItem) %>%
  summarise(ModelProbability = mean(Prob),
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
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/1b_bda_typicality/results_bda/graphs/predictives-byitem-",modelversion,".pdf",sep=""),height=3,width=5)

cor(toplot$ModelProbability,toplot$Probability) 
# empirical typicality: .85


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
  summarise(Prob = estimate_mode(prob),
            YMax = HPDhi(prob),
            YMin = HPDlo(prob)) %>%
  group_by(Utterance, condition) %>%
  summarise(ModelProbability = mean(Prob),
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
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/1b_bda_typicality/results_bda/graphs/predictives-",modelversion,".pdf",sep=""),height=5,width=9)

ggplot(toplot, aes(x=ModelProbability,y=Probability,color=NumDistractors,shape=NumDiff)) +
  geom_abline(intercept=0,slope=1,color="gray60") +
  geom_point(size=3) +
  geom_errorbar(aes(ymin=YMin,ymax=YMax)) +
  geom_errorbarh(aes(xmin=ModelYMin,xmax=ModelYMax)) +
  ylab("Empirical proportion") +
  xlab("Model probability") +
  guides(shape=guide_legend("Different\ndistractors"),color=guide_legend("Distractors")) 
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/1b_bda_typicality/results_bda/graphs/predictives-collapsed-",modelversion,".pdf",sep=""),height=5,width=7)

cor(toplot$ModelProbability,toplot$Probability) 
# empirical typicality, round 1: .9 

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
pr$YMin = NA
pr$YMax = NA
agr$Data = "empirical"
m = rbind(agr,pr)
m$NumDistractors = as.factor(as.character(m$NumDistractors)) 

ggplot(m, aes(x=SceneVariation,y=Probability,color=Data,group=Data,shape=NumDistractors)) +
  geom_errorbar(aes(ymin=YMin,ymax=YMax)) +
  geom_point(size=2) +
  # scale_shape_manual(values = c(21,22,23)) +
  ylab("Utterance probability") +
  xlab("Scene variation") +
  guides(shape = guide_legend("Number of\ndistractors")) +
#  geom_smooth(method="lm") +
  facet_grid(SufficientDimension~Utterance)
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/1b_bda_typicality/results_bda/graphs/scenevariation-",modelversion,".pdf",sep=""),height=5,width=9)



