theme_set(theme_bw(18))
setwd("/home/caroline/cocolab/overinformativeness/models/basic_level_reference/")
#setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/basic_level_reference/")
source("rscripts/helpers.R")

# first make plots of data with vs without attribute rather than type mentions
# without attribute mentions
d_noattr = read.csv("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/4_numdistractors_basiclevel_newitems/results/noAttr.csv")
nrow(d_noattr) # only 781 obs, vs 868 with attribute mentions (exclusion of 1-% data)
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

d = read.csv("normalizedFreqLength_Multiplicative.csv",quote="")
nrow(d)
head(d)
summary(d)
d$Utterance = factor(x=ifelse(d$label == "basicLevel","basic",ifelse(d$label == "superDomain","super","sub")),levels=c("sub","basic","super"))
table(d$alpha)  
table(d$superProb)  
table(d$freqWeight)  
d$EmpiricalProbNoAttr = agr_noattr[paste(d$condition,d$domain,d$target,d$Utterance),]$Probability
d$EmpiricalProbAllAttr = agr_allattr[paste(d$condition,d$domain,d$target,d$Utterance),]$Probability

# by-target correlations
cors_noattr = d %>%
  group_by(alpha,superProb,freqWeight) %>%
  filter(!is.na(EmpiricalProbNoAttr)) %>%
  summarise(Cor = cor(modelProb,EmpiricalProbNoAttr))
cors_noattr = as.data.frame(cors_noattr)
head(cors_noattr)
cors_noattr[cors_noattr$Cor == max(cors_noattr$Cor),] # maximized correlation for alpha = .8 and superProb = .15 and freqWeight = .5 (.73)

ggplot(cors_noattr, aes(x=alpha,y=Cor,color=as.factor(superProb))) +
  geom_point() +
  facet_wrap(~freqWeight) +
  ggtitle("Max r=.73 for alpha=.8, superProb=.15, freqWeight=.5")
ggsave("graphs/antisuper/correlations_noattr_multiplicative.pdf",height=8,width=10.5)

# to figure out best parameters by domain:
cors_noattr_bydomain = d %>%
  group_by(alpha,superProb,freqWeight,domain) %>%
  filter(!is.na(EmpiricalProbNoAttr)) %>%
  summarise(Cor = cor(modelProb,EmpiricalProbNoAttr))
head(cors_noattr_bydomain)
cors_noattr_bydomain = as.data.frame(cors_noattr_bydomain)
cors_noattr_bydomain %>%
  group_by(domain) %>%
  summarise(bestcorr=max(Cor),bestalpha=alpha[Cor==max(Cor)],bestsuperProb=superProb[Cor==max(Cor)],bestfreqWeight=freqWeight[Cor==max(Cor)])

cors_allattr = d %>%
  group_by(alpha,superProb,freqWeight) %>%
  filter(!is.na(EmpiricalProbAllAttr)) %>%
  summarise(Cor = cor(modelProb,EmpiricalProbAllAttr))
head(cors_allattr)
cors_allattr = as.data.frame(cors_allattr)
cors_allattr[cors_allattr$Cor == max(cors_allattr$Cor),] # maximized correlation for alpha = .8 and superProb = .15 and freqWeigth=.5 (.75)

ggplot(cors_allattr, aes(x=alpha,y=Cor,color=as.factor(superProb))) +
  geom_point() +
  facet_wrap(~freqWeight) +
  ggtitle("Max r=.75 for alpha=.8, superProb=.15, freqWeight=.5")
ggsave("graphs/antisuper/correlations_allattr_multiplicative.pdf",height=8,width=10.5)

# to figure out best parameters by domain:
cors_allattr_bydomain = d %>%
  group_by(alpha,superProb,freqWeight,domain) %>%
  filter(!is.na(EmpiricalProbAllAttr)) %>%
  summarise(Cor = cor(modelProb,EmpiricalProbAllAttr))
head(cors_allattr_bydomain)
cors_allattr_bydomain = as.data.frame(cors_allattr_bydomain)
bestbydomain_all = cors_allattr_bydomain %>%
  group_by(domain) %>%
  summarise(bestcorr=max(Cor),bestalpha=alpha[Cor==max(Cor)],bestsuperProb=superProb[Cor==max(Cor)],bestfreqWeight=freqWeight[Cor==max(Cor)])
bestbydomain_all
bestbydomain_all = as.data.frame(bestbydomain_all)

# correlations collapsing across targets
dsub = d %>%
  group_by(alpha,superProb,freqWeight,condition,Utterance,domain) %>%
  summarise(modelProb=mean(modelProb))
dsub = as.data.frame(dsub)
dsub$EmpiricalProbNoAttr = agr_noattr_coll[paste(dsub$condition,dsub$domain,dsub$Utterance),]$Probability
dsub$EmpiricalProbAllAttr = agr_allattr_coll[paste(dsub$condition,dsub$domain,dsub$Utterance),]$Probability

cors_noattr_coll = dsub %>%
  group_by(alpha,superProb,freqWeight) %>%
  filter(!is.na(EmpiricalProbNoAttr)) %>%
  summarise(Cor = cor(modelProb,EmpiricalProbNoAttr))
cors_noattr_coll = as.data.frame(cors_noattr_coll)
head(cors_noattr_coll)
cors_noattr_coll[cors_noattr_coll$Cor == max(cors_noattr_coll$Cor),] # maximized correlation for alpha = .75 and superProb = .16 and freqWeight=0 (.85)

ggplot(cors_noattr_coll, aes(x=alpha,y=Cor,color=as.factor(superProb))) +
  geom_point() +
  facet_wrap(~freqWeight) +
  ggtitle("Max r=.85 for alpha=.75, superProb=.16, freqW=.5 (collapsed)")
ggsave("graphs/antisuper/correlations_noattr_collapsed_multiplicative.pdf",height=7,width=10.5)

cors_allattr_coll = dsub %>%
  group_by(alpha,superProb,freqWeight) %>%
  filter(!is.na(EmpiricalProbAllAttr)) %>%
  summarise(Cor = cor(modelProb,EmpiricalProbAllAttr))
head(cors_allattr_coll)
cors_allattr_coll = as.data.frame(cors_allattr_coll)
cors_allattr_coll[cors_allattr_coll$Cor == max(cors_allattr_coll$Cor),] # maximized correlation for alpha = .85 and superProb = .14 and freqWeight=.5 (.86)

ggplot(cors_allattr_coll, aes(x=alpha,y=Cor,color=as.factor(superProb))) +
  geom_point() +
  ggtitle("Max r=.86 for alpha=.85, superProb=.14, freqW=.5 (collapsed)") +
  facet_wrap(~freqWeight)
ggsave("graphs/antisuper/correlations_allattr_collapsed_multiplicative.pdf",height=8,width=10.5)

# plot model predictions vs empirical scatterplot for best fitting params
ggplot(d[d$alpha==.8 & d$superProb==.15 & d$freqWeight==.5,],aes(x=modelProb,y=EmpiricalProbAllAttr,shape=condition,color=Utterance)) +
  geom_point() +
  xlim(c(0,1)) +
  ylim(c(0,1)) +
  ylab("Empirical proportion") +
  xlab("Model predicted probability") +
  geom_abline(xintercept=0,yintercept=0,slope=1,color="gray60") +
  facet_wrap(~domain)
ggsave("graphs/antisuper/model_empirical_allattr_bydomain_multiplicative.pdf",width=8.4,height=6)

# plot model predictions vs empirical scatterplot for best fitting params
ggplot(d[d$alpha==.8 & d$superProb==.15 & d$freqWeight==.5,],aes(x=modelProb,y=EmpiricalProbNoAttr,shape=condition,color=Utterance)) +
  geom_point() +
  xlim(c(0,1)) +
  ylim(c(0,1)) +
  ylab("Empirical proportion") +
  xlab("Model predicted probability") +
  geom_abline(xintercept=0,yintercept=0,slope=1,color="gray60") +
  facet_wrap(~domain)
ggsave("graphs/antisuper/model_empirical_noattr_bydomain_multiplicative.pdf",width=8.4,height=6)

# same plot, but collapsing across targets within domain (change values depending on best fitting params)
coll = d[d$alpha==.8 & d$superProb==.15 & d$freqWeight==.5,] %>%
#coll = d[d$alpha==1 & d$superProb==.15 & d$freqWeight==.3,] %>%
  group_by(domain,condition,Utterance) %>%
  summarise(modelProb=mean(modelProb),ci.low=ci.low(modelProb),ci.high=ci.high(modelProb))
coll = as.data.frame(coll)
coll$XMin = coll$modelProb - coll$ci.low
coll$XMax = coll$modelProb + coll$ci.high
summary(coll)

coll$EmpiricalProbNoAttr = agr_noattr_coll[paste(coll$condition,coll$domain,coll$Utterance),]$Probability
coll$YMinNoAttr = agr_noattr_coll[paste(coll$condition,coll$domain,coll$Utterance),]$YMin
coll$YMaxNoAttr = agr_noattr_coll[paste(coll$condition,coll$domain,coll$Utterance),]$YMax

coll$EmpiricalProbAllAttr = agr_allattr_coll[paste(coll$condition,coll$domain,coll$Utterance),]$Probability
coll$YMinAllAttr = agr_allattr_coll[paste(coll$condition,coll$domain,coll$Utterance),]$YMin
coll$YMaxAllAttr = agr_allattr_coll[paste(coll$condition,coll$domain,coll$Utterance),]$YMax

ggplot(coll,aes(x=modelProb,y=EmpiricalProbAllAttr,shape=condition,color=Utterance)) +
  geom_point() +
  geom_errorbar(aes(ymin=YMinAllAttr,ymax=YMaxAllAttr)) +
  xlim(c(0,1)) +
  ylim(c(0,1)) +
  ylab("Empirical proportion") +
  xlab("Model predicted probability") +
  geom_abline(xintercept=0,yintercept=0,slope=1,color="gray60") +
  facet_wrap(~domain)
ggsave("graphs/antisuper/model_empirical_allattr_bydomain_collapsed_multiplicative.pdf",width=8.4,height=6)

ggplot(coll,aes(x=modelProb,y=EmpiricalProbNoAttr,shape=condition,color=Utterance)) +
  geom_point() +
  geom_errorbar(aes(ymin=YMinNoAttr,ymax=YMaxNoAttr)) +
  xlim(c(0,1)) +
  ylim(c(0,1)) +
  ylab("Empirical proportion") +
  xlab("Model predicted probability") +
  geom_abline(xintercept=0,yintercept=0,slope=1,color="gray60") +
  facet_wrap(~domain)
ggsave("graphs/antisuper/model_empirical_noattr_bydomain_collapsed_multiplicative.pdf",width=8.4,height=6)

best_d_all = d[d$alpha == .8 & d$superProb == .15 & d$freqWeight==.5,] %>%
  group_by(condition,Utterance) %>%
  summarise(Probability=mean(modelProb),ci.low=ci.low(modelProb),ci.high=ci.high(modelProb))
best_d_all = as.data.frame(best_d_all)
best_d_all$YMin = best_d_all$Probability - best_d_all$ci.low
best_d_all$YMax = best_d_all$Probability + best_d_all$ci.high
dodge = position_dodge(.9)

p = ggplot(best_d_all, aes(x=condition,y=Probability)) +
  geom_bar(stat="identity",position=dodge) +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),position=dodge,width=.25) +
  facet_wrap(~Utterance)
ggsave("graphs/antisuper/probs_best_all_multiplicative.pdf",width=10,height=3.5)

best_d_no = d[d$alpha == .8 & d$superProb == .15 & d$freqWeight == .5,] %>%
  group_by(condition,Utterance) %>%
  summarise(Probability=mean(modelProb),ci.low=ci.low(modelProb),ci.high=ci.high(modelProb))
best_d_no = as.data.frame(best_d_no)
best_d_no$YMin = best_d_no$Probability - best_d_no$ci.low
best_d_no$YMax = best_d_no$Probability + best_d_no$ci.high
dodge = position_dodge(.9)

p = ggplot(best_d_no, aes(x=condition,y=Probability)) +
  geom_bar(stat="identity",position=dodge) +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),position=dodge,width=.25)+
  facet_wrap(~Utterance)
ggsave("graphs/antisuper/probs_best_no_multiplicative.pdf",width=10,height=3.5)


# agr = d[d$alpha %in% c(.01,.05,.1,.31,.91) & d$superProb %in% c(.01,.02,.1,.2,.32),] %>%
#   group_by(condition,alpha,superProb,Utterance) %>%
#   summarise(Probability=mean(modelProb),ci.low=ci.low(modelProb),ci.high=ci.high(modelProb))
# agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
# dodge = position_dodge(.9)
# 
# p = ggplot(agr, aes(x=Utterance,y=Probability,fill=condition)) +
#   geom_bar(stat="identity",position=dodge) +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),position=dodge,width=.25) +
#   facet_grid(alpha~superProb)
# ggsave("graphs/antisuper/probs.pdf",width=10,height=10)

