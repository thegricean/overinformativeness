theme_set(theme_bw(18))
setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/basic_level_reference/")
source("rscripts/helpers.R")

# first make plots of data with vs without attribute rather than type mentions
# without attribute mentions
d_noattr = read.csv("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/4_numdistractors_basiclevel_newitems/results/noAttr.csv")
nrow(d_noattr) # only 781 obs, vs 868 with attribute mentions (exclusion of 1-% data)
d_noattr$nameClickedObj = as.character(d_noattr$nameClickedObj)
d_noattr$nameClickedObj = tolower(d_noattr$nameClickedObj)
d_noattr$nameClickedObj = as.factor(as.character(d_noattr$nameClickedObj))

tmp = d_noattr %>%
  select(speakerMessages,condition,nameClickedObj,basiclevelClickedObj,superdomainClickedObj,typeMentioned,basiclevelMentioned,superClassMentioned)

table(tmp[,c("typeMentioned","basiclevelMentioned","superClassMentioned")])
tmp[tmp$basiclevelMentioned & tmp$typeMentioned,] # there are eight cases that are marked as both basic level and type mentioned. i'm going to interpret these as type mentions.
tmp[tmp$basiclevelMentioned & tmp$typeMentioned,]$basiclevelMentioned = F

# first get completely collapsed dataset (ignoring items and domains)
agr = tmp %>%
  select(condition,typeMentioned,basiclevelMentioned,superClassMentioned) %>%
  gather(Utterance, Mentioned,-condition) %>%
  group_by(Utterance,condition) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
head(agr)
agr$YMax = agr$Probability + agr$ci.high
agr$YMin = agr$Probability - agr$ci.low
agr$UtteranceType = factor(x=ifelse(agr$Utterance == "typeMentioned","sub",ifelse(agr$Utterance == "basiclevelMentioned","basic","super")),levels=c("sub","basic","super"))

agr_noattr_coll_coll = agr
nrow(agr_noattr_coll_coll) # 108 datapoints when collapsing across individual targets
agr_noattr_coll_coll$condition = gsub("distr","item",as.character(agr_noattr_coll_coll$condition))


# then get dataset collapsed across items but not domains

agr = tmp %>%
  select(condition,basiclevelClickedObj,typeMentioned,basiclevelMentioned,superClassMentioned) %>%
  gather(Utterance, Mentioned,-condition,-basiclevelClickedObj) %>%
  group_by(Utterance,condition,basiclevelClickedObj) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
head(agr)
agr$YMax = agr$Probability + agr$ci.high
agr$YMin = agr$Probability - agr$ci.low
agr$UtteranceType = factor(x=ifelse(agr$Utterance == "typeMentioned","sub",ifelse(agr$Utterance == "basiclevelMentioned","basic","super")),levels=c("sub","basic","super"))

agr_noattr_coll = agr
nrow(agr_noattr_coll) # 108 datapoints when collapsing across individual targets
agr_noattr_coll$condition = gsub("distr","item",as.character(agr_noattr_coll$condition))

# get dataset for comparison to model predictions
agr = tmp %>%
  select(nameClickedObj,condition,basiclevelClickedObj,typeMentioned,basiclevelMentioned,superClassMentioned) %>%
  gather(Utterance, Mentioned,-condition,-basiclevelClickedObj,-nameClickedObj) %>%
  group_by(Utterance,condition,basiclevelClickedObj,nameClickedObj) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
head(agr)
agr$YMax = agr$Probability + agr$ci.high
agr$YMin = agr$Probability - agr$ci.low
agr$UtteranceType = factor(x=ifelse(agr$Utterance == "typeMentioned","sub",ifelse(agr$Utterance == "basiclevelMentioned","basic","super")),levels=c("sub","basic","super"))

agr_noattr = agr
nrow(agr_noattr) # 429 data points
agr_noattr$condition = gsub("distr","item",as.character(agr_noattr$condition))

# with attribute mentions
d_allattr = read.csv("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/4_numdistractors_basiclevel_newitems/results/allAttr.csv")
nrow(d_allattr)
d_allattr$nameClickedObj = as.character(d_allattr$nameClickedObj)
d_allattr$nameClickedObj = tolower(d_allattr$nameClickedObj)
d_allattr$nameClickedObj = as.factor(as.character(d_allattr$nameClickedObj))

tmp = d_allattr %>%
  select(speakerMessages,condition,nameClickedObj,basiclevelClickedObj,superdomainClickedObj,typeMentioned,basiclevelMentioned,superClassMentioned,typeAttributeMentioned,basiclevelAttributeMentioned,superclassattributeMentioned)

table(tmp[,c("typeMentioned","basiclevelMentioned","superClassMentioned","typeAttributeMentioned","basiclevelAttributeMentioned","superclassattributeMentioned")])
unique(tmp[,c("typeMentioned","basiclevelMentioned","superClassMentioned","typeAttributeMentioned","basiclevelAttributeMentioned","superclassattributeMentioned")])
# some cases are marked as having type and attribute mentions at different levels of the hierarchy. i'll interpret all mentions as type mentions of the highest compatible category
tmp$superMentioned = tmp$superClassMentioned | tmp$superclassattributeMentioned
tmp$basicMentioned = ifelse(!(tmp$superClassMentioned | tmp$superclassattributeMentioned) & (tmp$basiclevelMentioned | tmp$basiclevelAttributeMentioned),T,F)
tmp$subMentioned = !(tmp$superMentioned | tmp$basicMentioned)
table(tmp[,c("subMentioned","basicMentioned","superMentioned")])

agr = tmp %>%
  select(condition,basiclevelClickedObj,subMentioned,basicMentioned,superMentioned) %>%
  gather(Utterance, Mentioned,-condition,-basiclevelClickedObj) %>%
  group_by(Utterance,condition,basiclevelClickedObj) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
head(agr)
agr$YMax = agr$Probability + agr$ci.high
agr$YMin = agr$Probability - agr$ci.low
agr$UtteranceType = factor(x=ifelse(agr$Utterance == "subMentioned","sub",ifelse(agr$Utterance == "basicMentioned","basic","super")),levels=c("sub","basic","super"))

agr_allattr_coll = agr
nrow(agr_allattr_coll) # 108 datapoints when collapsing across individual targets
agr_allattr_coll$condition = gsub("distr","item",as.character(agr_allattr_coll$condition))

# get dataset for comparison to model predictions
agr = tmp %>%
  select(nameClickedObj,condition,basiclevelClickedObj,subMentioned,basicMentioned,superMentioned) %>%
  gather(Utterance, Mentioned,-condition,-basiclevelClickedObj,-nameClickedObj) %>%
  group_by(Utterance,condition,basiclevelClickedObj,nameClickedObj) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
head(agr)
agr$YMax = agr$Probability + agr$ci.high
agr$YMin = agr$Probability - agr$ci.low
agr$UtteranceType = factor(x=ifelse(agr$Utterance == "subMentioned","sub",ifelse(agr$Utterance == "basicMentioned","basic","super")),levels=c("sub","basic","super"))

agr_allattr = agr
nrow(agr_allattr) # 432 datapoints
agr_allattr$condition = gsub("distr","item",as.character(agr_allattr$condition))

### ANALYZE RESIDUALS
row.names(agr_allattr) = paste(agr_allattr$condition,agr_allattr$basiclevelClickedObj,agr_allattr$nameClickedObj,agr_allattr$UtteranceType)
row.names(agr_allattr_coll) = paste(agr_allattr_coll$condition,agr_allattr_coll$basiclevelClickedObj,agr_allattr_coll$UtteranceType)
row.names(agr_noattr) = paste(agr_noattr$condition,agr_noattr$basiclevelClickedObj,agr_noattr$nameClickedObj,agr_noattr$UtteranceType)
row.names(agr_noattr_coll) = paste(agr_noattr_coll$condition,agr_noattr_coll$basiclevelClickedObj,agr_noattr_coll$UtteranceType)

#d = read.csv("normalizedFreqLength.csv")
#d = read.csv("allModelPreds.csv")
d = read.csv("predictionsWithEmpiricalLength.csv")

#d1 = read.csv("predictionsWithEmpiricalLength_ict.csv")
#d2 = read.csv("predictionsWithEmpiricalLength_ic.csv")
#d = merge(d1,d2,all=T)
nrow(d)
head(d)
summary(d)
d$Utterance = factor(x=ifelse(d$label == "basicLevel","basic",ifelse(d$label == "superDomain","super","sub")),levels=c("sub","basic","super"))
unique(d$alpha)  
unique(d$lengthWeight)  
unique(d$freqWeight) 
unique(d$interactionWeight) 

d$EmpiricalProbNoAttr = agr_noattr[paste(d$condition,d$domain,d$target,d$Utterance),]$Probability
#d$EmpiricalProbAllAttr = agr_allattr[paste(d$condition,d$domain,d$target,d$Utterance),]$Probability

summary(d)
# look at only cases with at least 4 data points per cell:
# items = as.data.frame(table(d_noattr$nameClickedObj,d_noattr$condition))
# items = droplevels(items[items$Freq > 3,])
# colnames(items) = c("target","condition","Freq")
# items$condition = gsub("distr","item",as.character(items$condition))
# row.names(items) = paste(items$target,items$condition)
# summary(items)
# head(items) # only 117 combinations left out of 144
# items[items$target == "hummingbird",]
# 
# tmp = d
# d$combo = paste(d$target,d$condition)
# d = droplevels(d[d$combo %in% row.names(items),])

# by-target correlations
cors_noattr = d %>%
  group_by(alpha,lengthWeight,freqWeight,interactionWeight,modelVersion) %>%
  filter(!is.na(EmpiricalProbNoAttr)) %>%
  summarise(Cor = cor(modelProb,EmpiricalProbNoAttr)) %>%
  group_by(modelVersion) %>%
  summarise(bestcorr=max(Cor)[1],bestalpha=alpha[Cor==max(Cor)][1],bestlengthWeight=lengthWeight[Cor==max(Cor)][1],bestfreqWeight=freqWeight[Cor==max(Cor)][1],bestinteractionWeight=interactionWeight[Cor==max(Cor)][1])
cors_noattr = as.data.frame(cors_noattr)
cors_noattr # maximized correlation for alpha = 6.5 and lengthWeight = 0.6 and freqWeight = 0 and interactionWeight 1.6  -- correlation .76

# scatterplot of model vs empirical for each model type with best params
agr = d[(d$modelVersion =="inform+cost+typicality" & d$alpha==6.5 & d$freqWeight==0 & d$lengthWeight==.6 & d$interactionWeight==1.6 | d$modelVersion =="inform+cost" & d$alpha==3 & d$freqWeight==0 & d$lengthWeight==1.4 & d$interactionWeight==.8 | d$modelVersion =="inform" & d$alpha==2 & d$freqWeight==0 & d$lengthWeight==0 & d$interactionWeight==0),] 
agr$Condition = agr$condition
ggplot(agr, aes(x=modelProb,y=EmpiricalProbNoAttr,color=Condition,shape=Utterance)) +
  geom_point(size=3) +
  xlab("Model predicted utterance probability") +
  ylab("Empirical proportion of utterance choice") +
  #geom_abline(xintercept=0,slope=1,color="gray80") +
  facet_wrap(~modelVersion)
ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/cogsci/graphs/scatterplot.pdf",width=15,height=4.7)


# make beautiful qualitative pattern plot
best_d_no = d[(d$modelVersion =="inform+cost+typicality" & d$alpha==6.5 & d$freqWeight==0 & d$lengthWeight==.6 & d$interactionWeight==1.6 | d$modelVersion =="inform+cost" & d$alpha==3 & d$freqWeight==0 & d$lengthWeight==1.4 & d$interactionWeight==.8 | d$modelVersion =="inform" & d$alpha==2 & d$freqWeight==0 & d$lengthWeight==0 & d$interactionWeight==0),] %>%
  group_by(condition,Utterance,modelVersion) %>%
  summarise(Probability=mean(modelProb),ci.low=ci.low(modelProb),ci.high=ci.high(modelProb))
best_d_no = as.data.frame(best_d_no)
best_d_no$YMin = best_d_no$Probability - best_d_no$ci.low
best_d_no$YMax = best_d_no$Probability + best_d_no$ci.high
dodge = position_dodge(.9)

agr = d_noattr %>%
  select(typeMentioned,basiclevelMentioned,superClassMentioned, condition) %>%
  gather(Utt,Mentioned,-condition) %>%
  group_by(Utt,condition) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
summary(agr)
dodge = position_dodge(.9)
agr$Utt = as.factor(ifelse(agr$Utt == "typeMentioned","sub",ifelse(agr$Utt == "basiclevelMentioned","basic","super")))
agr$Utterance = factor(x=as.character(agr$Utt),levels=c("sub","basic","super"))
agr$condition = gsub("distr","item",agr$condition)
agr$modelVersion = "empirical"
agr$Utt = NULL

best_d_no = rbind(best_d_no,agr)
colors = scale_colour_brewer()#[1:3]
best_d_no$Model = as.factor(ifelse(best_d_no$modelVersion == "inform","info",ifelse(best_d_no$modelVersion == "inform+cost","info+cost",ifelse(best_d_no$modelVersion == "inform+cost+typicality","info+cost+typ","empirical"))))

p = ggplot(best_d_no, aes(x=condition,y=Probability,fill=Model)) +
  geom_bar(stat="identity",position=dodge,color="black") +
  geom_bar(stat="identity",position=dodge) +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),position=dodge,width=.25)+
#  geom_text(data=cors_noattr_dom,aes(label=Label)) +
  scale_fill_brewer(guide=F) +
  ylab("Utterance probability") +
  xlab("Condition") +
  facet_grid(Model~Utterance) +
#  ggtitle("Parameter order: r, alpha, lengthW, freqW, interW") +
  theme(axis.text.x=element_text(angle=45,vjust=1,hjust=1)) 
p
ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/cogsci/graphs/collapsed-pattern.pdf",width=6.5,height=7)

# collapse across targets and domains compute correlation with best params fit to by-target data
best_d_no_coll = d[(d$modelVersion =="inform+cost+typicality" & d$alpha==6.5 & d$freqWeight==0 & d$lengthWeight==.6 & d$interactionWeight==1.6 | d$modelVersion =="inform+cost" & d$alpha==3 & d$freqWeight==0 & d$lengthWeight==1.4 & d$interactionWeight==.8 | d$modelVersion =="inform" & d$alpha==2 & d$freqWeight==0 & d$lengthWeight==0 & d$interactionWeight==0),] %>%
  group_by(modelVersion,Utterance,condition) %>%
  summarise(modelProb=mean(modelProb))
row.names(agr) = paste(agr$condition,agr$Utterance)
best_d_no_coll$EmpiricalProbNoAttr = agr[paste(best_d_no_coll$condition,best_d_no_coll$Utterance),]$Probability
best_d_no_coll %>%
  group_by(modelVersion) %>%
  summarise(Cor = cor(modelProb,EmpiricalProbNoAttr))
# collapsing over targets and domains, cors are: .79, .92, .98  

# collapse across targets and compute correlation with best params fit to by-target data

agr = d_noattr %>%
  select(typeMentioned,basiclevelMentioned,superClassMentioned, condition,basiclevelClickedObj) %>%
  gather(Utt,Mentioned,-condition,-basiclevelClickedObj) %>%
  group_by(Utt,condition,basiclevelClickedObj) %>%
  summarise(Probability=mean(Mentioned))
agr = as.data.frame(agr)
agr$Utt = as.factor(ifelse(agr$Utt == "typeMentioned","sub",ifelse(agr$Utt == "basiclevelMentioned","basic","super")))
agr$Utterance = factor(x=as.character(agr$Utt),levels=c("sub","basic","super"))
agr$condition = gsub("distr","item",agr$condition)
row.names(agr) = paste(agr$condition,agr$Utterance,agr$basiclevelClickedObj)

best_d_no_coll = d[(d$modelVersion =="inform+cost+typicality" & d$alpha==6.5 & d$freqWeight==0 & d$lengthWeight==.6 & d$interactionWeight==1.6 | d$modelVersion =="inform+cost" & d$alpha==3 & d$freqWeight==0 & d$lengthWeight==1.4 & d$interactionWeight==.8 | d$modelVersion =="inform" & d$alpha==2 & d$freqWeight==0 & d$lengthWeight==0 & d$interactionWeight==0),] %>%
  group_by(modelVersion,Utterance,condition,domain) %>%
  summarise(modelProb=mean(modelProb))
best_d_no_coll$EmpiricalProbNoAttr = agr[paste(best_d_no_coll$condition,best_d_no_coll$Utterance,best_d_no_coll$domain),]$Probability
best_d_no_coll %>%
  group_by(modelVersion) %>%
  summarise(Cor = cor(modelProb,EmpiricalProbNoAttr))
# collapsing over targets and domains, cors are: .7, .82, .86  

# collapse across targets and compute best params (you don't actually use this anywhere in the paper)
cors_noattr_coll = d %>%
  group_by(alpha,lengthWeight,freqWeight,interactionWeight,modelVersion,domain,Utterance) %>%
  filter(!is.na(EmpiricalProbNoAttr)) %>%
  summarise(modelProb = mean(modelProb),EmpiricalProbNoAttr=mean(EmpiricalProbNoAttr)) %>%
  group_by(alpha,lengthWeight,freqWeight,interactionWeight,modelVersion) %>%  
  summarise(Cor = cor(modelProb,EmpiricalProbNoAttr)) %>%
  group_by(modelVersion) %>%
  summarise(bestcorr=max(Cor)[1],bestalpha=alpha[Cor==max(Cor)][1],bestlengthWeight=lengthWeight[Cor==max(Cor)][1],bestfreqWeight=freqWeight[Cor==max(Cor)][1],bestinteractionWeight=interactionWeight[Cor==max(Cor)][1])
cors_noattr_coll = as.data.frame(cors_noattr_coll)
cors_noattr_coll 


# by-target correlations for the case where frequency and interaction weight are 0: informativeness overall lower, correlations also slightly lower
cors_noattr = d[d$freqWeight == 0 & d$interactionWeight == 0,] %>%
  group_by(alpha,lengthWeight,modelVersion) %>%
  filter(!is.na(EmpiricalProbNoAttr)) %>%
  summarise(Cor = cor(modelProb,EmpiricalProbNoAttr)) %>%
  filter(!is.na(Cor))
cors_noattr = as.data.frame(cors_noattr)
cors_noattr_dom = cors_noattr %>%
  group_by(modelVersion) %>%
  summarise(bestcorr=max(Cor)[1],bestalpha=alpha[Cor==max(Cor)][1],bestlengthWeight=lengthWeight[Cor==max(Cor)][1])
cors_noattr_dom = as.data.frame(cors_noattr_dom)
cors_noattr_dom 

# to figure out best parameters by domain:
cors_noattr_bydomain = d %>%
  group_by(alpha,lengthWeight,freqWeight,domain,interactionWeight,modelVersion) %>%
  filter(!is.na(EmpiricalProbNoAttr)) %>%
  summarise(Cor = cor(modelProb,EmpiricalProbNoAttr))
head(cors_noattr_bydomain)
cors_noattr_bydomain = as.data.frame(cors_noattr_bydomain)
bydomain = cors_noattr_bydomain %>%
  group_by(domain,modelVersion) %>%
  summarise(bestcorr=max(Cor)[1],bestalpha=alpha[Cor==max(Cor)][1],bestlengthWeight=lengthWeight[Cor==max(Cor)][1],bestfreqWeight=freqWeight[Cor==max(Cor)][1],bestinteractionWeight=interactionWeight[Cor==max(Cor)][1])
bydomain = as.data.frame(bydomain)
bydomain

ggplot(bydomain, aes(x=domain,y=))



# same plot, but collapsing across targets within domain (change values depending on best fitting params)
coll = d[(d$modelVersion =="inform+cost+typicality" & d$alpha==6 & d$freqWeight==0 & d$lengthWeight==.6 & d$interactionWeight==1.6 | d$modelVersion =="inform+cost" & d$alpha==3 & d$freqWeight==0 & d$lengthWeight==1.4 & d$interactionWeight==.8 | d$modelVersion =="inform" & d$alpha==2.5 & d$freqWeight==0 & d$lengthWeight==0 & d$interactionWeight==0),] %>%
  group_by(domain,condition,Utterance,modelVersion) %>%
  summarise(modelProb=mean(modelProb),ci.low=ci.low(modelProb),ci.high=ci.high(modelProb))
coll = as.data.frame(coll)
coll$XMin = coll$modelProb - coll$ci.low
coll$XMax = coll$modelProb + coll$ci.high
summary(coll)


# this is calling the wrong dataset
coll$EmpiricalProbNoAttr = agr_noattr_coll[paste(coll$condition,coll$domain,coll$Utterance),]$Probability
coll$YMinNoAttr = agr_noattr_coll[paste(coll$condition,coll$domain,coll$Utterance),]$YMin
coll$YMaxNoAttr = agr_noattr_coll[paste(coll$condition,coll$domain,coll$Utterance),]$YMax

ggplot(coll,aes(x=modelProb,y=EmpiricalProbNoAttr,shape=condition,color=Utterance)) +
  geom_point() +
  geom_errorbar(aes(ymin=YMinNoAttr,ymax=YMaxNoAttr)) +
  xlim(c(0,1)) +
  ylim(c(0,1)) +
  ylab("Empirical proportion") +
  xlab("Model predicted probability") +
  geom_abline(xintercept=0,yintercept=0,slope=1,color="gray60") +
  facet_wrap(~domain)
ggsave("graphs/antisuper/model_empirical_noattr_bydomain_collapsed_iflweight.pdf",width=8.4,height=6)



######## QUALITATIVE
# look for examples for paper
typs = read.table("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/5_norming_object_typicality_phrasing1/results/data/itemtypicalities.txt",header=T,quote="",sep="\t")
head(typs)
ttyps = droplevels(subset(typs, itemtype == "target"))
row.names(ttyps) = paste(ttyps$labeltype, ttyps$item)
d_noattr$TypeTyp = ttyps[paste("sub",as.character(d_noattr$nameClickedObj)),]$meanresponse
d_noattr$BasicTyp = ttyps[paste("basic",as.character(d_noattr$nameClickedObj)),]$meanresponse
d_noattr$SuperTyp = ttyps[paste("super",as.character(d_noattr$nameClickedObj)),]$meanresponse
d_noattr$ratioTypeToBasicTypicality = d_noattr$TypeTyp/d_noattr$BasicTyp
d_noattr$ratioTypeToSuperTypicality = d_noattr$TypeTyp/d_noattr$SuperTyp
d_noattr$condition = gsub("distr","item",as.character(d_noattr$condition))
d_noattr$target = d_noattr$nameClickedObj
d_noattr$modelVersion = "empirical"

best = d[(d$modelVersion =="inform+cost+typicality" & d$alpha==8.5 & d$freqWeight==.5 & d$lengthWeight==2.5 & d$interactionWeight==.5 | d$modelVersion =="inform+cost" & d$alpha==4.5 & d$freqWeight==.5 & d$lengthWeight==2.5 & d$interactionWeight==.5 | d$modelVersion =="inform" & d$alpha==2.5 & d$freqWeight==0 & d$lengthWeight==0 & d$interactionWeight==0),]
head(best)
best[best$modelVersion=="inform+cost+typicality" & best$modelProb > .8 & best$Utterance == "basic" & best$condition == "item33",]

# great case: convertible
best[best$Utterance == "basic" & best$condition == "item33" & best$target == "convertible",]
d_noattr[ d_noattr$condition == "distr33" & d_noattr$nameClickedObj == "convertible",] # 6/7 basic mentions. typicality: type .94, basic .92, super .93. length: sub: 11, basic: 3, super: 7
highinfo[highinfo$target == "convertible",]
ggplot(highinfo[highinfo$target == "convertible",], aes(x=condition,y=modelProb)) +
  geom_bar(stat="identity") +
  facet_grid(modelVersion~Utterance) +
  theme(axis.text.x=element_text(angle=45,vjust=1,hjust=1)) 

# potential demonstration case: germansheperd
best[best$Utterance == "basic" & best$condition == "item33" & best$target == "germanshepherd",] # .33, .65, .93
d_noattr[ d_noattr$condition == "distr33" & d_noattr$nameClickedObj == "germanshepherd",] # 3/4 basic, 1/4 super. typicality: type .95, basic .93, super .96. length: sub: 14, basic: 3, super: 6
ggplot(highinfo[highinfo$target == "germanshepherd",], aes(x=condition,y=modelProb)) +
  geom_bar(stat="identity") +
  facet_grid(modelVersion~Utterance) +
  theme(axis.text.x=element_text(angle=45,vjust=1,hjust=1)) 

# potential demonstration case: grizzlybear
best[best$Utterance == "basic" & best$condition == "item33" & best$target == "grizzlybear",] # .33, .56, .87
d_noattr[ d_noattr$condition == "distr33" & d_noattr$nameClickedObj == "grizzlybear",] # 7/7 basic. typicality: type .95, basic .97, super .86. length: sub: 14, basic: 3, super: 6
ggplot(highinfo[highinfo$target == "grizzlybear",], aes(x=condition,y=modelProb)) +
  geom_bar(stat="identity") +
  facet_grid(modelVersion~Utterance) +
  theme(axis.text.x=element_text(angle=45,vjust=1,hjust=1)) 

# potential demonstration case: hummingbird
best[best$Utterance == "basic" & best$condition == "item33" & best$target == "hummingbird",] # .33, .57, .87
d_noattr[ d_noattr$condition == "distr33" & d_noattr$nameClickedObj == "hummingbird",] # 2/4 basic, 2/4 sub. typicality: type .93, basic .84, super .75. length: sub: 11, basic: 4, super: 6
toplot = merge(d_noattr[d_noattr$target == "hummingbird",c("condition","target","modelVersion")],highinfo[highinfo$target == "hummingbird",],all=T)
ggplot(highinfo[highinfo$target == "hummingbird",], aes(x=condition,y=modelProb)) +
  geom_bar(stat="identity") +
  facet_grid(modelVersion~Utterance) +
  theme(axis.text.x=element_text(angle=45,vjust=1,hjust=1)) 


highinfo = d[d$alpha==8.5 & (d$modelVersion == "inform" & d$freqWeight==0 & d$lengthWeight==0 & d$interactionWeight==0 | d$modelVersion %in% c("inform+cost+typicality","inform+cost") & d$freqWeight==.5 & d$lengthWeight==2.5 & d$interactionWeight==.5),]




## QUALITATIVE CASES: WHY DOES ADDING TYPICALITY DECREASE SUB LEVEL USE IN ITEM12?
best[best$modelVersion=="inform+cost+typicality" & best$modelProb > .6 & best$modelProb < .7 & best$Utterance == "sub" & best$condition == "item12",]

# diningtable
best[best$Utterance == "sub" & best$condition == "item12" & best$target == "diningtable",] # .81, .95, .61
d_noattr[ d_noattr$condition == "item12" & d_noattr$target == "diningtable",] # 2/4 basic, 2/4 sub. typicality: type .93, basic .84, super .75. length: sub: 11, basic: 4, super: 6


### EAGLE PREDICTIONS
eagle = d[d$target == "eagle" & (d$modelVersion =="inform+cost+typicality" & d$alpha==6.5 & d$freqWeight==0 & d$lengthWeight==.6 & d$interactionWeight==1.6 | d$modelVersion =="inform+cost" & d$alpha==3 & d$freqWeight==0 & d$lengthWeight==1.4 & d$interactionWeight==.8 | d$modelVersion =="inform" & d$alpha==2 & d$freqWeight==0 & d$lengthWeight==0 & d$interactionWeight==0),]
head(eagle)
ggplot(eagle, aes(x=condition,y=modelProb)) +
  geom_bar(stat="identity") +
  facet_grid(modelVersion~Utterance)
ggsave("graphs/eagle.pdf",width=7)
ttyps[ttyps$item == "eagle",]

### GET THE LEAST WELL PREDICTED ITEMS
best =  d[(d$modelVersion =="inform+cost+typicality" & d$alpha==6.5 & d$freqWeight==0 & d$lengthWeight==.6 & d$interactionWeight==1.6),]
nrow(best) # should be 432
summary(best)
worst = best %>%
  group_by(target) %>%
  filter(!is.na(EmpiricalProbNoAttr)) %>%
  summarise(Cor=cor(modelProb,EmpiricalProbNoAttr))
worst = as.data.frame(worst)
worst = worst[order(worst[,c("Cor")]),]
head(worst)
tail(worst)

#jellybeans PREDICTIONS
jellybeans = d[d$target == "jellybeans" & (d$modelVersion =="inform+cost+typicality" & d$alpha==6.5 & d$freqWeight==0 & d$lengthWeight==.6 & d$interactionWeight==1.6 | d$modelVersion =="inform+cost" & d$alpha==3 & d$freqWeight==0 & d$lengthWeight==1.4 & d$interactionWeight==.8 | d$modelVersion =="inform" & d$alpha==2 & d$freqWeight==0 & d$lengthWeight==0 & d$interactionWeight==0),]
head(jellybeans)
ggplot(jellybeans, aes(x=condition,y=modelProb)) +
  geom_bar(stat="identity") +
  facet_grid(modelVersion~Utterance)
ggsave("graphs/jellybeans.pdf",width=7)

#HUMMINGBIRD PREDICTIONS
hummingbird = d[d$target == "hummingbird" & (d$modelVersion =="inform+cost+typicality" & d$alpha==6.5 & d$freqWeight==0 & d$lengthWeight==.6 & d$interactionWeight==1.6 | d$modelVersion =="inform+cost" & d$alpha==3 & d$freqWeight==0 & d$lengthWeight==1.4 & d$interactionWeight==.8 | d$modelVersion =="inform" & d$alpha==2 & d$freqWeight==0 & d$lengthWeight==0 & d$interactionWeight==0),]
head(hummingbird)
ggplot(hummingbird, aes(x=condition,y=modelProb)) +
  geom_bar(stat="identity") +
  facet_grid(modelVersion~Utterance)
ggsave("graphs/hummingbird.pdf",width=7)


#BEDSIDETABLE PREDICTIONS
bedsidetable = d[d$target == "bedsidetable" & (d$modelVersion =="inform+cost+typicality" & d$alpha==6.5 & d$freqWeight==0 & d$lengthWeight==.6 & d$interactionWeight==1.6 | d$modelVersion =="inform+cost" & d$alpha==3 & d$freqWeight==0 & d$lengthWeight==1.4 & d$interactionWeight==.8 | d$modelVersion =="inform" & d$alpha==2 & d$freqWeight==0 & d$lengthWeight==0 & d$interactionWeight==0),]
head(bedsidetable)
ggplot(bedsidetable, aes(x=condition,y=modelProb)) +
  geom_bar(stat="identity") +
  facet_grid(modelVersion~Utterance)
ggsave("graphs/bedsidetable.pdf",width=7)

