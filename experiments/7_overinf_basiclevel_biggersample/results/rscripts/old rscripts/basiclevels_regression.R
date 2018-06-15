theme_set(theme_bw(18))

#setwd("/home/caroline/cocolab/overinformativeness/experiments/4_numdistractors_basiclevel_newitems/results")
source("rscripts/helpers.R")
source("rscripts/createLaTeXTable.R")

##############################################################################################
## This is an old and cluttered script, the up-to-date and clean version is analysis_exp3.R ##
##############################################################################################

d = read.csv(file="data/basiclev_manModified_allAttr.csv",sep=",")
d$clickedType = as.factor(tolower(as.character(d$clickedType)))
d[,48] = NULL
table(d$sub,d$basic,d$super) # 294 cases of attribute rather than level mentions
#unique(bdCorrect[,c("onlyAttrMentioned","subAllAttr","basicAllAttr","superAllAttr")])
nrow(d)
bdCorrect = droplevels(d[!(!d$sub & !d$basic & !d$super),]) # retain only cases where a level was mentioned
nrow(bdCorrect)

bdCorrect$subLength = nchar(as.character(bdCorrect$clickedType))
bdCorrect$basicLength = nchar(as.character(bdCorrect$basiclevelClickedObj))

frequencies = read.table(file="data/frequencyChart.csv",sep=",", header=T, quote="")
row.names(frequencies) = tolower(as.character(frequencies$noun))

bdCorrect$subFreq = as.numeric(as.character(frequencies[as.character(bdCorrect$clickedType),]$relFreq))
bdCorrect$basicFreq = frequencies[as.character(bdCorrect$basiclevelClickedObj),]$relFreq
bdCorrect$superFreq = frequencies[as.character(bdCorrect$superdomainClickedObj),]$relFreq

targets = droplevels(subset(bdCorrect,targetStatusClickedObj == "target"))
# for the moment exclude cases where target wasn't chosen, because you don't have the right info recorded for those cases
bdCorrect = targets

bdCorrect$subLength = nchar(as.character(bdCorrect$clickedType))
bdCorrect$basicLength = nchar(as.character(bdCorrect$basiclevelClickedObj))
bdCorrect$superLength = nchar(as.character(bdCorrect$superdomainClickedObj))
#bdCorrect$logsubLength = log(bdCorrect$subLength)
#bdCorrect$logbasicLength = log(bdCorrect$basicLength)
#bdCorrect$logsuperLength = log(bdCorrect$superLength)

bdCorrect$logsubFreq = log(bdCorrect$subFreq)
bdCorrect$logbasicFreq = log(bdCorrect$basicFreq)
bdCorrect$logsuperFreq = log(bdCorrect$superFreq)

bdCorrect$binnedlogsubFreq = cut_number(bdCorrect$logsubFreq,2,labels=c("low-frequency","high-frequency"))
bdCorrect$ratioTypeToBasicLength = bdCorrect$subLength/bdCorrect$basicLength
bdCorrect$ratioTypeTosuperLength = bdCorrect$subLength/bdCorrect$superLength
#bdCorrect$ratioTypeToBasicFreq = bdCorrect$subFreq/bdCorrect$basicFreq
#bdCorrect$ratioTypeTosuperFreq = bdCorrect$subFreq/bdCorrect$superFreq
bdCorrect$ratioTypeToBasicFreq = bdCorrect$logsubFreq - bdCorrect$logbasicFreq
bdCorrect$ratioTypeTosuperFreq = bdCorrect$logsubFreq - bdCorrect$logsuperFreq

# add average empirical lengths (YOU NEED TO UPDATE THIS!! SO FAR IT'S LOADING THE OLD EMPIRICAL MEAN LENGTHS)
lengths = read.csv("data/lengthChart_uniformLabels.csv")
row.names(lengths) = lengths$noun
lengths$totalLength = nchar(as.character(lengths$noun))
ggplot(lengths, aes(x=totalLength,y=average_length)) +
  geom_point() +
  geom_abline(slope=1,xintercept=0) +
  geom_text(aes(label=noun))
ggsave("graphs_basiclevel/total-vs-average-item-length.pdf")
bdCorrect$meansubLength = lengths[tolower(as.character(bdCorrect$clickedType)),]$average_length
bdCorrect$meanBasicLength =  lengths[as.character(bdCorrect$basiclevelClickedObj),]$average_length
bdCorrect$meansuperLength =  lengths[as.character(bdCorrect$superdomainClickedObj),]$average_length
bdCorrect$ratioTypeToBasicMeanLength = bdCorrect$meansubLength/bdCorrect$meanBasicLength
bdCorrect$ratioTypeToSuperMeanLength = bdCorrect$meansubLength/bdCorrect$meansuperLength
bdCorrect$redCondition = as.factor(ifelse(bdCorrect$condition == "basic12","sub_necessary",ifelse(bdCorrect$condition == "basic33","super_sufficient","basic_sufficient")))

# add typicality values
typs = read.table("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/5_norming_object_typicality_phrasing1/results/data/itemtypicalities.txt",header=T,quote="",sep="\t")
head(typs)
ttyps = droplevels(subset(typs, itemtype == "target"))
row.names(ttyps) = paste(ttyps$labeltype, ttyps$item)
bdCorrect$SubTyp = ttyps[paste("sub",as.character(bdCorrect$clickedType)),]$meanresponse
bdCorrect$BasicTyp = ttyps[paste("basic",as.character(bdCorrect$clickedType)),]$meanresponse
bdCorrect$SuperTyp = ttyps[paste("super",as.character(bdCorrect$clickedType)),]$meanresponse
bdCorrect$ratioTypeToBasicTypicality = bdCorrect$SubTyp/bdCorrect$BasicTyp
bdCorrect$ratioTypeToSuperTypicality = bdCorrect$SubTyp/bdCorrect$SuperTyp

# find examples for cogsci paper
t = ttyps[ttyps$labeltype != "super",]
agr = t %>%
  group_by(item) %>%
  summarise(ratio=meanresponse[labeltype == "sub"]/meanresponse[labeltype == "basic"])
agr[agr$ratio == max(agr$ratio),] # bedside table
agr[agr$ratio == min(agr$ratio),] # daisy

# get length/frequency correlation for cogsci paper
freqs = bdCorrect %>%
  select(subFreq,basicFreq,superFreq) %>%
  gather(Level,Freq)
nrow(freqs)  

lengths = bdCorrect %>%
  select(subLength,basicLength,superLength) %>%
  gather(Level,Length)
nrow(lengths)  

full = cbind(freqs,lengths)
full$logFreq = log(full$Freq)
cor(full$Freq,full$Length) # -.36
cor(full$logFreq,full$Length) # -.53

#### MIXED EFFECTS MODEL ANALYSIS FOR TYPE MENTION WITH DOMAIN-LEVEL RANDOM EFFECTS

centered = cbind(bdCorrect, myCenter(bdCorrect[,c("subLength","basicLength","superLength","subFreq","basicFreq","superFreq","logsubFreq","logbasicFreq","logsuperFreq","ratioTypeToBasicFreq","ratioTypeToBasicLength","ratioTypeTosuperLength","ratioTypeTosuperFreq","ratioTypeToBasicMeanLength","ratioTypeToSuperMeanLength")]))

#pairscor.fnc(centered[,c("subLength","basicLength","superLength","logsubLength","logbasicLength","logsuperLength","subFreq","basicFreq","superFreq","logsubFreq","logbasicFreq","logsuperFreq","ratioTypeToBasicFreq","ratioTypeTosuperFreq","ratioTypeToBasicLength","ratioTypeTosuperLength")])

#contrasts(bdCorrect$condition) = cbind(c(1,0,0,0),c(0,0,1,0),c(0,0,0,1))
contrasts(centered$condition) = cbind("12.vs.rest"=c(3/4,-1/4,-1/4,-1/4),"22.vs.3"=c(0,2/3,-1/3,-1/3),"23.vs.33"=c(0,0,1/2,-1/2))

# only absolute type length/freq
m = glmer(sub ~ condition * csubLength * clogsubFreq + (1 + clogsubFreq|gameid) + (1|basiclevelClickedObj), family="binomial",data=centered)
summary(m)

# ratio of type to basic level freq
m = glmer(sub ~ condition + cratioTypeToBasicLength + cratioTypeToBasicFreq +  cratioTypeTosuperLength + cratioTypeTosuperFreq + cratioTypeToBasicLength:cratioTypeToBasicFreq + cratioTypeTosuperLength:cratioTypeTosuperFreq + condition:cratioTypeToBasicLength + condition:cratioTypeToBasicFreq + condition:cratioTypeTosuperLength + condition:cratioTypeTosuperFreq + condition:cratioTypeToBasicLength:cratioTypeToBasicFreq + condition:cratioTypeTosuperLength:cratioTypeTosuperFreq + (1|gameid), family="binomial",data=centered)
summary(m)


# collapse across 22 and 23 conditions
bdCorrect$redCondition = as.factor(ifelse(bdCorrect$condition == "basic12","sub_necessary",ifelse(bdCorrect$condition == "basic33","super_sufficient","basic_sufficient")))
bdCorrect$binaryCondition = as.factor(ifelse(bdCorrect$condition == "basic12","sub_necessary","nonsub_sufficient"))
table(bdCorrect$redCondition)
table(bdCorrect$binaryCondition)

# exclude frequency outliers? there are none if you do difference of logs
#tmp = bdCorrect[bdCorrect$ratioTypeToBasicFreq > 2*sd(bdCorrect$ratioTypeToBasicFreq),]
tmp = bdCorrect[bdCorrect$ratioTypeToBasicTypicality < mean(bdCorrect$ratioTypeToBasicTypicality) + 3*sd(bdCorrect$ratioTypeToBasicTypicality),]

centered = cbind(bdCorrect, myCenter(bdCorrect[,c("subLength","basicLength","superLength","subFreq","basicFreq","superFreq","logsubFreq","logbasicFreq","logsuperFreq","ratioTypeToBasicFreq","ratioTypeTosuperFreq","ratioTypeToBasicLength","ratioTypeTosuperLength","ratioTypeToBasicMeanLength","ratioTypeToSuperMeanLength","ratioTypeToBasicTypicality","ratioTypeToSuperTypicality","binaryCondition")]))

contrasts(centered$redCondition) = cbind("sub.vs.rest"=c(-1/3,2/3,-1/3),"basic.vs.super"=c(1/2,0,-1/2))
contrasts(centered$condition) = cbind("12.vs.rest"=c(3/4,-1/4,-1/4,-1/4),"22.vs.3"=c(0,2/3,-1/3,-1/3),"23.vs.33"=c(0,0,1/2,-1/2))

# m = glmer(sub ~ redCondition * csubLength * clogsubFreq + (1|gameid) + (1|basiclevelClickedObj), family="binomial",data=centered)
# summary(m)
# 
# m.1 = glmer(sub ~ redCondition * csubLength * clogsubFreq + (1|gameid) + (1+csubLength|basiclevelClickedObj), family="binomial",data=centered)
# summary(m.1)
# 
# anova(m,m.1) # adding by-item slopes for length doesn't do anything
# 
# m.2 = glmer(sub ~ redCondition * csubLength * clogsubFreq + (1|gameid) + (1+clogsubFreq|basiclevelClickedObj), family="binomial",data=centered)
# summary(m.2)
# 
# anova(m,m.2)
# 
# m.3 = glmer(sub ~ redCondition * csubLength * clogsubFreq + (1|gameid) + (1+clogsubFreq+csubLength|basiclevelClickedObj), family="binomial",data=centered)
# summary(m.3)
# 
# anova(m.2,m.3) # nope, useless

# ratio of type to basic freq & length (pre-coded)
m = glmer(sub ~ redCondition + cratioTypeToBasicLength + cratioTypeToBasicFreq + cratioTypeToBasicLength:cratioTypeToBasicFreq + (1|gameid) + (1|basiclevelClickedObj) , family="binomial",data=centered) 
summary(m)
createLatexTable(m,predictornames=c("Intercept","Condition sub.vs.rest","Condition basic.vs.super","Length","Frequency","Length:Frequency"))

m.nointer = glmer(sub ~ redCondition + cratioTypeToBasicLength + cratioTypeToBasicFreq + (1|gameid) + (1|basiclevelClickedObj) , family="binomial",data=centered) 
summary(m.nointer)

anova(m.nointer,m) # interaction important

m.sup2 = glmer(sub ~ redCondition + cratioTypeToBasicLength + cratioTypeToBasicFreq + cratioTypeToBasicLength:cratioTypeToBasicFreq + cratioTypeTosuperLength + cratioTypeTosuperFreq + (1|gameid) + (1|basiclevelClickedObj) , family="binomial",data=centered) 
summary(m.sup2)

anova(m,m.sup2) #nope

m.allconds = glmer(sub ~ condition + cratioTypeToBasicLength + cratioTypeToBasicFreq + cratioTypeToBasicLength:cratioTypeToBasicFreq + (1|gameid) + (1|basiclevelClickedObj) , family="binomial",data=centered) 
summary(m)
summary(m.allconds)
# the BIC of this model is higher than that of simple m (886 vs 881) -- ie, adding the extra condition predictor isn't justified.

m.1 = glmer(sub ~ redCondition + cratioTypeToBasicLength + cratioTypeToBasicFreq + cratioTypeToBasicLength:cratioTypeToBasicFreq + redCondition:cratioTypeToBasicLength + redCondition:cratioTypeToBasicFreq +  (1|gameid) + (1|basiclevelClickedObj), family="binomial",data=centered) 
summary(m.1)

anova(m,m.1) # nope

m.2 = glmer(sub ~ redCondition + cratioTypeToBasicLength + cratioTypeToBasicFreq + cratioTypeToBasicLength:cratioTypeToBasicFreq + redCondition:cratioTypeToBasicLength + redCondition:cratioTypeToBasicFreq + redCondition:cratioTypeToBasicLength:cratioTypeToBasicFreq +  (1|gameid) + (1|basiclevelClickedObj), family="binomial",data=centered) 
summary(m.2)

anova(m,m.2) # nope

m.sup1 = glmer(sub ~ redCondition + cratioTypeToBasicLength + cratioTypeToBasicFreq + cratioTypeToBasicLength:cratioTypeToBasicFreq + cratioTypeTosuperLength + cratioTypeTosuperFreq + cratioTypeTosuperLength:cratioTypeTosuperFreq + (1|gameid) + (1|basiclevelClickedObj) , family="binomial",data=centered) 
summary(m.sup1)

anova(m,m.sup1) # nope



m.noitem = glmer(sub ~ redCondition + cratioTypeToBasicLength + cratioTypeToBasicFreq + cratioTypeToBasicLength:cratioTypeToBasicFreq + (1|gameid) , family="binomial",data=centered) 
summary(m.noitem)

anova(m.noitem,m) # definitely by-item variation

m.nosubj = glmer(sub ~ redCondition + cratioTypeToBasicLength + cratioTypeToBasicFreq + cratioTypeToBasicLength:cratioTypeToBasicFreq + (1|basiclevelClickedObj) , family="binomial",data=centered) 
summary(m.nosubj)

anova(m.nosubj,m) # definitely by-subject variation


# ratio of type to basic freq & length (empirical means)
m.m = glmer(sub ~ redCondition + cratioTypeToBasicMeanLength + cratioTypeToBasicFreq + cratioTypeToBasicMeanLength:cratioTypeToBasicFreq + (1|gameid) + (1|basiclevelClickedObj) , family="binomial",data=centered) 
summary(m.m)

m.m.nointer = glmer(sub ~ redCondition + cratioTypeToBasicMeanLength + cratioTypeToBasicFreq + (1|gameid) + (1|basiclevelClickedObj) , family="binomial",data=centered) 
summary(m.m.nointer)

anova(m.m.nointer,m.m) # interaction important

m.m.1 = glmer(sub ~ redCondition + cratioTypeToBasicMeanLength + cratioTypeToBasicFreq + cratioTypeToBasicMeanLength:cratioTypeToBasicFreq + redCondition:cratioTypeToBasicMeanLength + redCondition:cratioTypeToBasicFreq +  (1|gameid) + (1|basiclevelClickedObj), family="binomial",data=centered) 
summary(m.m.1)

anova(m.m,m.m.1) # nope

# add typicality
m.m.t = glmer(sub ~ redCondition + cratioTypeToBasicMeanLength + cratioTypeToBasicFreq + cratioTypeToBasicTypicality + cratioTypeToBasicMeanLength:cratioTypeToBasicFreq + (1|gameid) + (1|basiclevelClickedObj) , family="binomial",data=centered) 
summary(m.m.t)
createLatexTable(m.m.t,predictornames=c("Intercept","Condition sub.vs.rest","Condition basic.vs.super","Length","Frequency","Typicality","Length:Frequency"))

anova(m.m,m.m.t) # typicality very important!

library(MuMIn)
r.squaredGLMM(m.m)
r.squaredGLMM(m.m.t)

m.m.t.norandom = glm(sub ~ redCondition + cratioTypeToBasicMeanLength + cratioTypeToBasicFreq + cratioTypeToBasicTypicality + cratioTypeToBasicMeanLength:cratioTypeToBasicFreq, family="binomial",data=centered) 
summary(m.m.t.norandom)

empirical = centered %>%
  select(sub)
empirical$Fitted = fitted(m.m.t.norandom)
empirical$Prediction = ifelse(empirical$Fitted >= .5, T, F)
empirical$FittedM = fitted(m.m.t)
empirical$PredictionM = ifelse(empirical$FittedM >= .5, T, F)
cor(empirical$sub,empirical$Prediction)
cor(empirical$sub,empirical$PredictionM) # better correlation with than without random effects


# plot model predictions without cost or typicality
agr = data.frame(Utt = rep(c("sub","basic","super"),4),condition = rep(c("item12","item22","item23","item33"),each=3),Probability = c(1,0,0,.5,.5,0,.5,.5,0,.333,.333,.333))
agr$Utterance = factor(x=as.character(agr$Utt),levels=c("sub","basic","super"))
ggplot(agr, aes(x=condition,y=Probability)) +
  geom_bar(stat="identity",position=dodge) +
  facet_wrap(~Utterance) +
  ylab("Proportion of utterance choice") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/results-info-only.pdf",height=4.1,width=7)

### plots for cogsci paper
# overall, fig 1
agr = bdCorrect %>%
  select(sub,basic,super, condition) %>%
  gather(Utt,Mentioned,-condition) %>%
  group_by(Utt,condition) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
summary(agr)
dodge = position_dodge(.9)
agr$Utt = as.factor(ifelse(agr$Utt == "sub","sub",ifelse(agr$Utt == "basic","basic","super")))
agr$Utterance = factor(x=as.character(agr$Utt),levels=c("sub","basic","super"))

ggplot(agr, aes(x=condition,y=Probability)) +
  geom_bar(stat="identity",position=dodge) +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  facet_wrap(~Utterance) +
  ylab("Proportion of utterance choice") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/results-collapsed.pdf",height=4.1,width=7)

# overall, fig 1
agr = bdCorrect %>%
  select(sub,basic,super, condition, basiclevelClickedObj) %>%
  gather(Utt,Mentioned,-condition, -basiclevelClickedObj) %>%
  group_by(Utt,condition,basiclevelClickedObj) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
summary(agr)
dodge = position_dodge(.9)
agr$Utt = as.factor(ifelse(agr$Utt == "sub","sub",ifelse(agr$Utt == "basic","basic","super")))
agr$Utterance = factor(x=as.character(agr$Utt),levels=c("sub","basic","super"))

ggplot(agr, aes(x=condition,y=Probability)) +
  geom_bar(stat="identity",position=dodge) +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  facet_grid(basiclevelClickedObj~Utterance) +
  ylab("Proportion of utterance choice") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/results-bydomain.pdf",height=10,width=7)

# for all random effects structures that allow the model to converge, the interaction between frequency and length is significant at (at most) <.01
#bdCorrect$cutlogsubLength = cut(bdCorrect$logsubLength,breaks=quantile(bdCorrect$logsubLength,probs=c(0,.5,1)))
bdCorrect$binnedsubLength = cut_number(bdCorrect$ratioTypeToBasicLength,3,labels=c("short","mid","long"))
bdCorrect$binnedlogsubFreq = cut_number(bdCorrect$ratioTypeToBasicFreq,2)#,labels=c("low","high"))
summary(bdCorrect)

agr = bdCorrect %>%
  select(sub, redCondition, binnedsubLength, binnedlogsubFreq) %>%
  group_by(redCondition, binnedsubLength, binnedlogsubFreq) %>%
  summarise(Probability=mean(sub),ci.low=ci.low(sub),ci.high=ci.high(sub))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
summary(agr)
dodge = position_dodge(.9)
agr$Condition = factor(x=as.character(agr$redCondition),levels=c("sub_necessary","basic_sufficient","super_sufficient"))

ggplot(agr, aes(x=binnedlogsubFreq,y=Probability,fill=binnedsubLength)) +
  geom_bar(stat="identity",position=dodge) +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  ylab("Probability of sub level mention") +
  xlab("Frequency  bin") +
  facet_wrap(~Condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel//freq-length-interaction-bycond.pdf",height=5,width=9)

bdCorrect$binnedsubLength = cut(bdCorrect$ratioTypeToBasicLength,c(0,1,2,max(bdCorrect$ratioTypeToBasicLength)),labels=c("short","mid","long"))#,labels=c("short","mid","long"))
bdCorrect$binnedlogsubFreq = cut_number(bdCorrect$ratioTypeToBasicFreq,2,labels=c("low","high"))
summary(bdCorrect)
table(bdCorrect$binnedsubLength,bdCorrect$binnedlogsubFreq)

agr = bdCorrect %>%
  select(sub, binnedsubLength, binnedlogsubFreq) %>%
  group_by(binnedsubLength, binnedlogsubFreq) %>%
  summarise(Probability=mean(sub),ci.low=ci.low(sub),ci.high=ci.high(sub))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
summary(agr)
dodge = position_dodge(.9)

library(wesanderson)

ggplot(agr, aes(x=binnedlogsubFreq,y=Probability,fill=binnedsubLength)) +
  geom_bar(stat="identity",position=dodge,color="black") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  xlab("Frequency") +
  scale_fill_manual(values=wes_palette("Darjeeling2"),name="Length") +
  scale_y_continuous(name="Probability of sub level mention") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel//freq-length-interaction.pdf",height=4.2,width=6)

# switch x and y axis
bdCorrect$binnedsubLength = cut(bdCorrect$ratioTypeToBasicLength,c(0,mean(bdCorrect$ratioTypeToBasicLength),4.67),labels=c("short","long"))#,labels=c("short","mid","long"))
bdCorrect$binnedlogsubFreq = cut(bdCorrect$ratioTypeToBasicFreq,c(-12,mean(bdCorrect$ratioTypeToBasicFreq),0),labels=c("low","high"))
summary(bdCorrect)
table(bdCorrect$binnedsubLength,bdCorrect$binnedlogsubFreq)

agr = bdCorrect %>%
  select(sub, binnedsubLength, binnedlogsubFreq) %>%
  group_by(binnedsubLength, binnedlogsubFreq) %>%
  summarise(Probability=mean(sub),ci.low=ci.low(sub),ci.high=ci.high(sub))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
summary(agr)
dodge = position_dodge(.9)

library(wesanderson)

ggplot(agr, aes(x=binnedsubLength,y=Probability,fill=binnedlogsubFreq)) +
  geom_bar(stat="identity",position=dodge,color="black") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  xlab("Length") +
  scale_fill_manual(values=wes_palette("Darjeeling2"),name="Frequency") +
  scale_y_continuous(name="Probability of sub level mention") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel//freq-length-interaction.pdf",height=4.2,width=6)


# main effect of length
bdCorrect$binnedsubLength = cut_number(bdCorrect$ratioTypeToBasicLength,2,labels=c("short","long"))#,labels=c("short","mid","long"))
bdCorrect$binnedsubLength = cut(bdCorrect$ratioTypeToBasicLength,2,labels=c("short","long"))#,labels=c("short","mid","long"))

agr = bdCorrect %>%
  select(sub, binnedsubLength,redCondition) %>%
  group_by(binnedsubLength,redCondition) %>%
  summarise(Probability=mean(sub),ci.low=ci.low(sub),ci.high=ci.high(sub))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
summary(agr)
dodge = position_dodge(.9)
agr$Condition = factor(x=gsub("_","\n",as.character(agr$redCondition)),levels=c("sub\nnecessary","basic\nsufficient","super\nsufficient"))

library(wesanderson)

pl = ggplot(agr, aes(x=binnedsubLength,y=Probability)) +
  geom_bar(stat="identity",position=dodge,color="black") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  scale_x_discrete(name="Sub level length",breaks=c("short","long"),labels=c("short\n ","long\n ")) +
  scale_fill_manual(values=wes_palette("Darjeeling2"),name="Length") +
  scale_y_continuous(name="Proportion of sub level mention",breaks=seq(0,1,.2)) +
  facet_wrap(~Condition) +
  theme(axis.title.y = element_blank(),axis.title.x = element_text(size=16),axis.text.y = element_text(size=12),plot.margin=unit(c(0,0,0,0), "cm"))
  #theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
#ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/cogsci/graphs/length-effect.pdf",height=4.2,width=6)


# main effect of typicality
bdCorrect$binnedSubTypicality = cut_number(bdCorrect$ratioTypeToBasicTypicality,2,labels=c("less typical","more typical"))#,labels=c("short","mid","long"))


agr = bdCorrect %>%
  select(sub, binnedSubTypicality,redCondition) %>%
  group_by(binnedSubTypicality,redCondition) %>%
  summarise(Probability=mean(sub),ci.low=ci.low(sub),ci.high=ci.high(sub))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
summary(agr)
dodge = position_dodge(.9)
agr$Condition = factor(x=gsub("_","\n",as.character(agr$redCondition)),levels=c("sub\nnecessary","basic\nsufficient","super\nsufficient"))
#agr$Condition = factor(x=as.character(agr$redCondition),levels=c("sub_necessary","basic_sufficient","super_sufficient"))
agr$Typicality = factor(x=as.character(agr$binnedSubTypicality),levels=c("more typical","less typical"))
library(wesanderson)

pt = ggplot(agr, aes(x=Typicality,y=Probability)) +
  geom_bar(stat="identity",position=dodge,color="black") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  scale_x_discrete(name="Sub level typicality",breaks=c("more typical","less typical"),labels=c("more\ntypical","less\ntypical")) +
  #scale_fill_manual(values=wes_palette("Darjeeling2"),name="Length") +
  scale_y_continuous(name="Proportion of sub level mention",breaks=seq(0,1,.2)) +
  facet_wrap(~Condition) +
  theme(axis.title.y = element_blank(),axis.title.x = element_text(size=16),axis.text.y = element_text(size=12),plot.margin=unit(c(0,0,0,0), "cm"))
  #theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1, size=7))
#ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/cogsci/graphs/typicality-effect.pdf",height=4.2,width=6)

# pairscor.fnc(centered[,c("ratioTypeToBasicLength","ratioTypeToBasicFreq","ratioTypeToBasicTypicality")])
# bdCorrect[bdCorrect$ratioTypeToBasicTypicality > 1.5,]

# main effect of frequency
bdCorrect$binnedsubFreq = cut_number(bdCorrect$ratioTypeToBasicFreq,2,labels=c("low","high"))#,labels=c("short","mid","long"))
agr = bdCorrect %>%
  select(sub, binnedsubFreq,redCondition) %>%
  group_by(binnedsubFreq,redCondition) %>%
  summarise(Probability=mean(sub),ci.low=ci.low(sub),ci.high=ci.high(sub))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
summary(agr)
dodge = position_dodge(.9)
agr$Condition = factor(x=gsub("_","\n",as.character(agr$redCondition)),levels=c("sub\nnecessary","basic\nsufficient","super\nsufficient"))
#agr$Condition = factor(x=as.character(agr$redCondition),levels=c("sub_necessary","basic_sufficient","super_sufficient"))
agr$Frequency = factor(x=as.character(agr$binnedsubFreq),levels=c("high","low"))
library(wesanderson)

pf = ggplot(agr, aes(x=Frequency,y=Probability)) +
  geom_bar(stat="identity",position=dodge,color="black") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  scale_x_discrete(name="Sub level frequency",breaks=c("high","low"),labels=c("high","low")) +
  #scale_fill_manual(values=wes_palette("Darjeeling2"),name="Length") +
  scale_y_continuous(name="Proportion of sub level mention",breaks=seq(0,1,.2)) +
  facet_wrap(~Condition) +
  theme(axis.title.y = element_blank(),axis.title.x = element_text(size=16),axis.text.y = element_text(size=12),plot.margin=unit(c(0,0,0,0), "cm"))


library(gridExtra)
pdf("graphs_basiclevel/length-typicality-frequency.pdf",height=4.5,width=10.5)
grid.arrange(pl,pt,pf,nrow=1, left = textGrob("Proportion of sub level mention", rot = 90, vjust = 1,gp = gpar(cex = 1.3)))
dev.off()

t = as.data.frame(table(bdCorrect$clickedType,bdCorrect$condition))
nrow(t[t$Freq < 4,])

eagle = bdCorrect[bdCorrect$clickedType == "eagle",]
nrow(eagle)
agre = eagle %>%
  select(sub,basic,super, condition) %>%
  gather(Utt,Mentioned,-condition) %>%
  group_by(Utt,condition) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agre = as.data.frame(agre)
agre$YMin = agre$Probability - agre$ci.low
agre$YMax = agre$Probability + agre$ci.high
summary(agre)
dodge = position_dodge(.9)
agre$Utt = as.factor(ifelse(agre$Utt == "sub","sub",ifelse(agre$Utt == "basic","basic","super")))
agre$Utterance = factor(x=as.character(agre$Utt),levels=c("sub","basic","super"))

ggplot(agre, aes(x=condition,y=Probability)) +
  geom_bar(stat="identity",position=dodge,color="black") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax)) +
  facet_wrap(~Utterance)
ggsave("graphs_basiclevel/individual_cases/eagle-empirical.pdf",width=9,height=4.5)  

hummingbird = bdCorrect[bdCorrect$clickedType == "hummingbird",]
nrow(hummingbird)
agre = hummingbird %>%
  select(sub,basic,super, condition) %>%
  gather(Utt,Mentioned,-condition) %>%
  group_by(Utt,condition) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agre = as.data.frame(agre)
agre$YMin = agre$Probability - agre$ci.low
agre$YMax = agre$Probability + agre$ci.high
summary(agre)
dodge = position_dodge(.9)
agre$Utt = as.factor(ifelse(agre$Utt == "sub","sub",ifelse(agre$Utt == "basic","basic","super")))
agre$Utterance = factor(x=as.character(agre$Utt),levels=c("sub","basic","super"))

ggplot(agre, aes(x=condition,y=Probability)) +
  geom_bar(stat="identity",position=dodge,color="black") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax)) +
  facet_wrap(~Utterance)
ggsave("graphs_basiclevel/individual_cases/hummingbird-empirical.pdf",width=7,height=3.5) 


jellybeans = bdCorrect[bdCorrect$clickedType == "jellybeans",]
nrow(jellybeans)
agre = jellybeans %>%
  select(sub,basic,super, condition) %>%
  gather(Utt,Mentioned,-condition) %>%
  group_by(Utt,condition) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agre = as.data.frame(agre)
agre$YMin = agre$Probability - agre$ci.low
agre$YMax = agre$Probability + agre$ci.high
summary(agre)
dodge = position_dodge(.9)
agre$Utt = as.factor(ifelse(agre$Utt == "sub","sub",ifelse(agre$Utt == "basic","basic","super")))
agre$Utterance = factor(x=as.character(agre$Utt),levels=c("sub","basic","super"))

ggplot(agre, aes(x=condition,y=Probability)) +
  geom_bar(stat="identity",position=dodge,color="black") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax)) +
  facet_wrap(~Utterance)
ggsave("graphs_basiclevel/individual_cases/jellybeans-empirical.pdf",width=7,height=3.5) 

bedsidetable = bdCorrect[bdCorrect$clickedType == "bedsidetable",]
nrow(bedsidetable)
agre = bedsidetable %>%
  select(sub,basic,super, condition) %>%
  gather(Utt,Mentioned,-condition) %>%
  group_by(Utt,condition) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agre = as.data.frame(agre)
agre$YMin = agre$Probability - agre$ci.low
agre$YMax = agre$Probability + agre$ci.high
summary(agre)
dodge = position_dodge(.9)
agre$Utt = as.factor(ifelse(agre$Utt == "sub","sub",ifelse(agre$Utt == "basic","basic","super")))
agre$Utterance = factor(x=as.character(agre$Utt),levels=c("sub","basic","super"))

ggplot(agre, aes(x=condition,y=Probability)) +
  geom_bar(stat="identity",position=dodge,color="black") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax)) +
  facet_wrap(~Utterance)
ggsave("graphs_basiclevel/individual_cases/bedsidetable-empirical.pdf",width=7,height=3.5) 

eagle[,c("alt1Name","alt2Name")]
hummingbird[,c("alt1Name","alt2Name","condition")]#,"sub")]
jellybeans[,c("alt1Name","alt2Name","condition")]#,"sub")]
bedsidetable[,c("alt1Name","alt2Name","condition")]#,"sub")]

# get unique combinations of distractors
bdCorrect$DistractorCombo = as.factor(ifelse(as.character(bdCorrect$alt1Name) < as.character(bdCorrect$alt2Name), paste(bdCorrect$alt1Name, bdCorrect$alt2Name), paste(bdCorrect$alt2Name, bdCorrect$alt1Name)))

write.csv(unique(bdCorrect[,c("clickedType","condition","DistractorCombo")]),file="unique_conditions.csv",row.names=F,quote=F)

# get unique domains and targets
uniquetargets = unique(d[d$targetStatusClickedObj == "target",c("nameClickedObj","basiclevelClickedObj")])
uniquetargets$length = nchar(as.character(uniquetargets$nameClickedObj))
uniquetargets = uniquetargets[order(uniquetargets[,c("basiclevelClickedObj")],uniquetargets[,c("length")]),]
