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
nrow(d)
head(d)
summary(d)
d$Utterance = factor(x=ifelse(d$label == "basicLevel","basic",ifelse(d$label == "superDomain","super","sub")),levels=c("sub","basic","super"))
table(d$alpha)  
table(d$lengthWeight)  
table(d$freqWeight) 
table(d$interactionWeight) 

d$EmpiricalProbNoAttr = agr_noattr[paste(d$condition,d$domain,d$target,d$Utterance),]$Probability # no values for the dressshirt distr12 condition empirically 
d$EmpiricalProbAllAttr = agr_allattr[paste(d$condition,d$domain,d$target,d$Utterance),]$Probability

summary(d)

# by-target correlations
cors_noattr = d %>%
  group_by(alpha,lengthWeight,freqWeight,interactionWeight,modelVersion) %>%
  filter(!is.na(EmpiricalProbNoAttr)) %>%
  summarise(Cor = cor(modelProb,EmpiricalProbNoAttr))
cors_noattr = as.data.frame(cors_noattr)
cors_noattr_dom = cors_noattr %>%
  group_by(modelVersion) %>%
  summarise(bestcorr=max(Cor)[1],bestalpha=alpha[Cor==max(Cor)][1],bestlengthWeight=lengthWeight[Cor==max(Cor)][1],bestfreqWeight=freqWeight[Cor==max(Cor)][1],bestinteractionWeight=interactionWeight[Cor==max(Cor)][1])
cors_noattr_dom = as.data.frame(cors_noattr_dom)
cors_noattr_dom$Label = paste(round(cors_noattr_dom$bestcorr,2),cors_noattr_dom$bestalpha,cors_noattr_dom$bestlengthWeight,cors_noattr_dom$bestfreqWeight,cors_noattr_dom$bestinteractionWeight)
cors_noattr_dom$condition = "item22"
cors_noattr_dom$Probability = .8
cors_noattr_dom

# maxcorr: .6, .7, .75

# ggplot(cors_noattr, aes(x=alpha,y=Cor,color=as.factor(lengthWeight))) +
#   geom_point() +
#   facet_grid(modelVersion~freqWeight) +
#   ggtitle("Max r=.82 for alpha=7.5, lenWeight=0.5, freqWeight=2.5")
# ggsave("graphs/antisuper/correlations_noattr_iflweight.pdf",height=8,width=10.5)

# by-target correlations for the case where frequency and interaction weight are 0
cors_noattr = d[d$freqWeight == 0 & d$interactionWeight == 0,] %>%
  group_by(alpha,lengthWeight,modelVersion) %>%
  filter(!is.na(EmpiricalProbNoAttr)) %>%
  summarise(Cor = cor(modelProb,EmpiricalProbNoAttr))
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
  group_by(modelVersion,domain) %>%
  summarise(bestcorr=max(Cor)[1],bestalpha=alpha[Cor==max(Cor)][1],bestlengthWeight=lengthWeight[Cor==max(Cor)][1],bestfreqWeight=freqWeight[Cor==max(Cor)][1],bestinteractionWeight=interactionWeight[Cor==max(Cor)][1])
bydomain = as.data.frame(bydomain)
toplot = bydomain %>%
  gather(Parameter,Value,-modelVersion,-domain)
head(toplot)
ggplot(toplot, aes(x=domain,y=Value)) +
  geom_bar(stat="identity") +
  facet_grid(Parameter~modelVersion,scales="free") +
  theme(axis.text.x=element_text(angle=45,vjust=1,hjust=1))


# correlations collapsing across targets
dsub = d %>%
  group_by(alpha,lengthWeight,freqWeight,interactionWeight,modelVersion,condition,Utterance,domain) %>%
  summarise(modelProb=mean(modelProb))
dsub = as.data.frame(dsub)
dsub$EmpiricalProbNoAttr = agr_noattr_coll[paste(dsub$condition,dsub$domain,dsub$Utterance),]$Probability
dsub$EmpiricalProbAllAttr = agr_allattr_coll[paste(dsub$condition,dsub$domain,dsub$Utterance),]$Probability

cors_noattr_coll = dsub %>%
  group_by(alpha,lengthWeight,freqWeight,interactionWeight,modelVersion) %>%
  filter(!is.na(EmpiricalProbNoAttr)) %>%
  summarise(Cor = cor(modelProb,EmpiricalProbNoAttr))
cors_noattr_coll = as.data.frame(cors_noattr_coll)
head(cors_noattr_coll)

cors_noattr_dom_coll = cors_noattr_coll %>%
  group_by(modelVersion) %>%
  summarise(bestcorr=max(Cor)[1],bestalpha=alpha[Cor==max(Cor)][1],bestlengthWeight=lengthWeight[Cor==max(Cor)][1],bestfreqWeight=freqWeight[Cor==max(Cor)][1],bestinteractionWeight=interactionWeight[Cor==max(Cor)][1])
cors_noattr_dom_coll = as.data.frame(cors_noattr_dom_coll)
cors_noattr_dom_coll
# max corrs: .7, .82, .86

# ggplot(cors_noattr_coll, aes(x=alpha,y=Cor,color=as.factor(lengthWeight))) +
#   geom_point() +
#   facet_wrap(~freqWeight) +
#   ggtitle("Max r=.84 for alpha=8.5, lenW=2.5, freqW=.5 (collapsed)")
# ggsave("graphs/antisuper/correlations_noattr_collapsed_iflweight.pdf",height=7,width=10.5)

# plot model predictions vs empirical scatterplot for best fitting params
toplot = droplevels(d[(d$modelVersion =="inform+cost+typicality" & d$alpha==8.5 & d$freqWeight==.5 & d$lengthWeight==2.5 & d$interactionWeight==.5 | d$modelVersion =="inform+cost" & d$alpha==4.5 & d$freqWeight==.5 & d$lengthWeight==2.5 & d$interactionWeight==.5 | d$modelVersion =="inform" & d$alpha==2.5 & d$freqWeight==0 & d$lengthWeight==0 & d$interactionWeight==0),])
ggplot(toplot,aes(x=modelProb,y=EmpiricalProbNoAttr,shape=condition,color=Utterance)) +
  geom_point() +
  #geom_smooth(method="lm",aes(group=1)) +
  xlim(c(0,1)) +
  ylim(c(0,1)) +
  ylab("Empirical proportion") +
  xlab("Model predicted probability") +
  geom_abline(xintercept=0,yintercept=0,slope=1,color="gray60") +
  facet_wrap(~modelVersion)
  #facet_wrap(modelVersion~domain)
ggsave("graphs/paperplots/full-scatterplot.pdf",width=12,height=4)

ggplot(toplot,aes(x=modelProb,y=EmpiricalProbNoAttr,shape=condition,color=Utterance)) +
  geom_point() +
  #geom_smooth(method="lm",aes(group=1)) +
  xlim(c(0,1)) +
  ylim(c(0,1)) +
  ylab("Empirical proportion") +
  xlab("Model predicted probability") +
  geom_abline(xintercept=0,yintercept=0,slope=1,color="gray60") +
  facet_grid(domain~modelVersion)
#facet_wrap(modelVersion~domain)
ggsave("graphs/paperplots/full-scatterplot-bydomain.pdf",width=10,height=20)


# same plot, but collapsing across targets within domain (change values depending on best fitting params)
coll = d[(d$modelVersion =="inform+cost+typicality" & d$alpha==8.5 & d$freqWeight==.5 & d$lengthWeight==2.5 & d$interactionWeight==.5 | d$modelVersion =="inform+cost" & d$alpha==4.5 & d$freqWeight==.5 & d$lengthWeight==2.5 & d$interactionWeight==.5 | d$modelVersion =="inform" & d$alpha==2.5 & d$freqWeight==0 & d$lengthWeight==0 & d$interactionWeight==0),] %>%
  group_by(domain,condition,Utterance,modelVersion) %>%
  summarise(modelProb=mean(modelProb),ci.low=ci.low(modelProb),ci.high=ci.high(modelProb))
coll = as.data.frame(coll)
coll$XMin = coll$modelProb - coll$ci.low
coll$XMax = coll$modelProb + coll$ci.high
summary(coll)

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
  facet_grid(domain~modelVersion)
ggsave("graphs/paperplots/collapsed-modelempirical.pdf",width=10,height=20)

best_d_no = d[(d$modelVersion =="inform+cost+typicality" & d$alpha==8.5 & d$freqWeight==.5 & d$lengthWeight==2.5 & d$interactionWeight==.5 | d$modelVersion =="inform+cost" & d$alpha==4.5 & d$freqWeight==.5 & d$lengthWeight==2.5 & d$interactionWeight==.5 | d$modelVersion =="inform" & d$alpha==2.5 & d$freqWeight==0 & d$lengthWeight==0 & d$interactionWeight==0),] %>%
  group_by(condition,Utterance,modelVersion) %>%
  summarise(Probability=mean(modelProb),ci.low=ci.low(modelProb),ci.high=ci.high(modelProb))
best_d_no = as.data.frame(best_d_no)
best_d_no$YMin = best_d_no$Probability - best_d_no$ci.low
best_d_no$YMax = best_d_no$Probability + best_d_no$ci.high
dodge = position_dodge(.9)
best_d_no$modelVersion = as.character(best_d_no$modelVersion)

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

p = ggplot(best_d_no, aes(x=condition,y=Probability,fill=modelVersion)) +
  geom_bar(stat="identity",position=dodge,color="black") +
  geom_bar(stat="identity",position=dodge) +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),position=dodge,width=.25)+
  geom_text(data=cors_noattr_dom,aes(label=Label)) +
  scale_fill_brewer(guide=F) +
  facet_grid(modelVersion~Utterance) +
  ggtitle("Parameter order: r, alpha, lengthW, freqW, interW") +
  theme(axis.text.x=element_text(angle=45,vjust=1,hjust=1)) 
p
ggsave("graphs/paperplots/collapsed-pattern.pdf",width=7.5,height=7)
ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/cogsci/graphs/collapsed-pattern.pdf",width=7.5,height=7)


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
