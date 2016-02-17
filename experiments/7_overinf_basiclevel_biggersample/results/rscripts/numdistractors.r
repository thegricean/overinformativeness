theme_set(theme_bw(18))
setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/7_overinf_basiclevel_biggersample/results")
source("rscripts/helpers.r")

d = read.table(file="data/colsizeCor_manModified.csv",sep=",", header=T, quote="")

d$Half = as.factor(ifelse(d$roundNum < 37, "first","second"))
d$Quarter = as.factor(ifelse(d$roundNum < 19, "first",ifelse(d$roundNum < 37,"second", ifelse(d$roundNum < 55, "third","fourth"))))
head(d)
nrow(d) # 2138 cases
unique(d$listenerMessages)

summary(d)
totalnrow = nrow(d)
totalnrow
d$TypeMentioned = d$typeMentioned
d[is.na(d$otherFeatureMentioned),]$otherFeatureMentioned = FALSE

# look at turker comments
comments = read.table(file="../mturk/overinf.csv",sep=",", header=T, quote="")

unique(comments$comments)

ggplot(comments, aes(ratePartner)) +
  geom_histogram()

ggplot(comments, aes(thinksHuman)) +
  geom_histogram()

ggplot(comments, aes(nativeEnglish)) +
  geom_histogram()

ggplot(comments, aes(totalLength)) +
  geom_histogram()

# first figure out how often target was chosen -- exclude trials where it wasn't?
table(d$condition,d$targetStatusClickedObj)
# prop.table(table(d$condition,d$targetStatusClickedObj),mar=c(1)) # it appears that in the size-only condition, there's twice as many distractor choices (13% vs 7%)
# chisq.test(table(d$condition,d$targetStatusClickedObj))

# how many unique pairs?
length(levels(d$gameid)) # 64

table(d$condition,d$TypeMentioned)
table(d$condition,d$sizeMentioned)
table(d$condition,d$colorMentioned)

### ANALYZE ONLY TRIALS WHERE COLOR/SIZE/NUMDISTRACTORS WAS MANIPULATED
# exclude pair where listener always seemed to click something completely different
d$SufficientProperty = as.factor(ifelse(d$condition %in% c("size21", "size22", "size31", "size32", "size33", "size41", "size42", "size43", "size44"), "size", "color"))
d$NumDistractors = ifelse(d$condition %in% c("size21","size22","color21","color22"), 2, ifelse(d$condition %in% c("size31","size32","size33","color31","color32","color33"),3,4))
d$NumDiffDistractors = ifelse(d$condition %in% c("size22","color22","size33","color33","size44","color44"), 0, ifelse(d$condition %in% c("size21","color21","size32","color32","size43","color43"), 1, ifelse(d$condition %in% c("size31","color31","size42","color42"),2,ifelse(d$condition %in% c("size41","color41"),3, 4))))
d$NumSameDistractors = ifelse(d$condition %in% c("size21","size31","size41","color21","color31","color41"), 1, ifelse(d$condition %in% c("size22","size32","size42","color22","color32","color42"), 2, ifelse(d$condition %in% c("size33","color33","size43","color43"),3,ifelse(d$condition %in% c("size44","color44"),4,NA))))

#d = droplevels(d[d$targetStatusClickedObj == "target",])

print(paste("percentage of excluded trials because distractor was chosen: ", (totalnrow -nrow(d))*100/totalnrow))

summary(d)

targets = d
nrow(targets) # 2138 cases
targets$UtteranceType = as.factor(ifelse(targets$sizeMentioned & targets$colorMentioned, "size and color", ifelse(targets$sizeMentioned, "size", ifelse(targets$colorMentioned, "color","OTHER"))))

#targets = droplevels(targets[!is.na(targets$UtteranceType),])
targets[targets$UtteranceType == "OTHER",c("gameid","refExp","condition")]
table(targets[targets$UtteranceType == "OTHER",]$gameid) 
targets$Color = ifelse(targets$UtteranceType == "color",1,0)
targets$Size = ifelse(targets$UtteranceType == "size",1,0)
targets$SizeAndColor = ifelse(targets$UtteranceType == "size and color",1,0)
targets$Other = ifelse(targets$UtteranceType == "OTHER",1,0)
targets$Item = sapply(strsplit(as.character(targets$nameClickedObj),"_"), "[", 3)
targets$redUtterance = as.factor(ifelse(targets$UtteranceType == "size and color","redundant",ifelse(targets$UtteranceType == "size" & targets$SufficientProperty == "size", "minimal", ifelse(targets$UtteranceType == "color" & targets$SufficientProperty == "color", "minimal", "other"))))
targets$RatioOfDiffToSame = targets$NumDiffDistractors/targets$NumSameDistractors
targets$DiffMinusSame = targets$NumDiffDistractors-targets$NumSameDistractors

# plot histogram of mentioned features by condition
agr = targets %>%
  select(sizeMentioned,colorMentioned,typeMentioned,condition) %>%
  gather(Feature,Mentioned,-condition)
agr$Feature = gsub("Mentioned","",as.character(agr$Feature))
agr = droplevels(subset(agr,Mentioned == "TRUE"))
head(agr)

ggplot(agr, aes(x=Feature)) +
  geom_histogram() +
  facet_wrap(~condition)
ggsave("graphs_numdistractors/mentioned_features_by_condition.pdf",width=8,height=3.5)

# plot utterance choice proportions with error bars
agr = targets %>%
  select(Color,Size,SizeAndColor,Other,condition) %>%
  gather(Utterance,Mentioned,-condition) %>%
  group_by(Utterance,condition) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

ggplot(agr, aes(x=Utterance,y=Probability)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~condition)
ggsave("graphs_numdistractors/mentioned_features_by_condition_other.pdf",width=10,height=3.5)

# plot by number of distractors etc
agr = targets %>%
  select(Color,Size,SizeAndColor,Other,SufficientProperty,NumDistractors,NumDiffDistractors) %>%
  gather(Utterance,Mentioned,-SufficientProperty,-NumDistractors,-NumDiffDistractors) %>%
  group_by(Utterance,SufficientProperty,NumDistractors,NumDiffDistractors) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

ggplot(agr, aes(x=NumDiffDistractors,y=Probability,color=as.factor(NumDistractors))) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax)) +
  facet_grid(SufficientProperty~Utterance)
ggsave("graphs_numdistractors/utterancetype_by_condition_diff.pdf",width=9,height=3.5)

agr = targets %>%
  select(Color,Size,SizeAndColor,Other,SufficientProperty,NumDistractors,NumSameDistractors) %>%
  gather(Utterance,Mentioned,-SufficientProperty,-NumDistractors,-NumSameDistractors) %>%
  group_by(Utterance,SufficientProperty,NumDistractors,NumSameDistractors) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

ggplot(agr, aes(x=NumSameDistractors,y=Probability,color=as.factor(NumDistractors))) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax)) +
  facet_grid(SufficientProperty~Utterance)
ggsave("graphs_numdistractors/utterancetype_by_condition_same.pdf",width=9,height=4)

# plot by ratio and numdistractors
agr = targets %>%
  select(Color,Size,SizeAndColor,Other,SufficientProperty,NumDistractors,RatioOfDiffToSame) %>%
  gather(Utterance,Mentioned,-SufficientProperty,-NumDistractors,-RatioOfDiffToSame) %>%
  group_by(Utterance,SufficientProperty,NumDistractors,RatioOfDiffToSame) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

ggplot(agr, aes(x=RatioOfDiffToSame,y=Probability,color=as.factor(NumDistractors))) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax)) +
  facet_grid(SufficientProperty~Utterance)
ggsave("graphs_numdistractors/utterancetype_by_condition_ratio.pdf",width=9,height=4)

head(agr)
#agr$CorrectProprty = ifelse((agr$Utterance %in% c("Color","SizeAndColor") & agr$SufficientProperty == "color") | (agr$Utterance %in% c("Size","SizeAndColor") & agr$SufficientProperty == "size"), "correct","incorrect")

# plot by ratio and numdistractors, only for 'correct' properties
targets$CorrectProperty = ifelse(targets$SufficientProperty == "color" & (targets$Color == 1 | targets$SizeAndColor == 1), 1, ifelse(targets$SufficientProperty == "size" & (targets$Size == 1 | targets$SizeAndColor == 1), 1, 0)) # 20 cases of incorrect property mention
targets$minimal = ifelse(targets$SizeAndColor == 0, 1, 0)
targets$redundant = ifelse(targets$SizeAndColor == 1, 1, 0)
agr = targets[targets$CorrectProperty == 1,] %>%
  select(redundant,SufficientProperty,NumDistractors,RatioOfDiffToSame) %>%
  gather(Utterance,Mentioned,-SufficientProperty,-NumDistractors,-RatioOfDiffToSame) %>%
  group_by(Utterance,SufficientProperty,NumDistractors,RatioOfDiffToSame) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
agr$Distractors = as.factor(agr$NumDistractors)
agr$RedundantProperty = ifelse(agr$SufficientProperty == 'color',"size redundant","color redundant")
ggplot(agr, aes(x=RatioOfDiffToSame,y=Probability,color=Distractors,group=1)) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax)) +
  xlab("Ratio of different to same (other) feature values") +
  ylab("Probability of redundancy") +
#  geom_smooth(method="lm") +
  facet_wrap(~RedundantProperty)
ggsave("graphs_numdistractors/utterancetype_by_condition_ratio_correctonly.pdf",width=7,height=3.2)

## add model predictions
load("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/2_number_of_distractors/results/parsed/r-moreconditions.RData")
# you can play with the values in the next statment to get different model predictions
toplot = r[r$object == "o1" & r$color_fidelity == .999 & r$size_fidelity == .8  & r$color_cost == .1 & r$size_cost == .1 & as.numeric(as.character(r$speaker.opt)  == 15),]
toplot$RatioOfDiffToSame = toplot$differentcolor/toplot$samecolor
toplot[toplot$sufficientproperty == "color",]$RatioOfDiffToSame = toplot[toplot$sufficientproperty == "color",]$differentsize/toplot[toplot$sufficientproperty == "color",]$samesize
toplot$Distractors = as.factor(toplot$numdistractors)
toplot$redundant = ifelse(toplot$Utterance %in% c("big_red","small_yellow","big_yellow","small_red"),1,0)
toplot$correctproperty = ifelse(toplot$Utterance == "big_red" | toplot$sufficientproperty == "color" & toplot$Utterance == "red" | toplot$sufficientproperty == "size" & toplot$Utterance == "big", 1, 0)
toplot$SufficientProperty = toplot$sufficientproperty
toplot$DataType = "model"

agr = toplot[toplot$correctproperty == 1 & toplot$redundant == 1,] %>%
  #select(redundant,sufficientproperty,Distractors,RatioOfDiffToSame) %>%
  #gather(Utterance,Mentioned,-sufficientproperty,-Distractors,-RatioOfDiffToSame) %>%
  group_by(SufficientProperty,Distractors,RatioOfDiffToSame) %>%
  summarise(Probability=Probability)
agr = as.data.frame(agr)
agr$RedundantProperty = ifelse(agr$SufficientProperty == "color","size redundant","color redundant")
agr$Data = "model"
magr = agr

ggplot(agr, aes(x=RatioOfDiffToSame,y=Probability,color=Distractors,group=1)) +
  geom_point(size=4,alpha=.5) +
  ylab("Probability of redundancy") +
  xlab("Ratio of distractors with different to same insufficient feature value") +
  ylim(c(0,1)) +
  facet_wrap(~RedundantProperty)
#ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/talks/2016/edinburgh/model-empirical.pdf",width=8,height=3.5)


agr = targets[targets$CorrectProperty == 1,] %>%
  select(redundant,SufficientProperty,NumDistractors,RatioOfDiffToSame) %>%
  gather(Utterance,Mentioned,-SufficientProperty,-NumDistractors,-RatioOfDiffToSame) %>%
  group_by(Utterance,SufficientProperty,NumDistractors,RatioOfDiffToSame) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
agr$Distractors = as.factor(agr$NumDistractors)
agr$RedundantProperty = ifelse(agr$SufficientProperty == "color","size redundant","color redundant")
agr$Data = "empirical"
eagr = agr

agr = merge(magr,agr,all=T)
agr$DType = factor(x=as.character(agr$Data),levels=c("model","empirical"))

ggplot(agr, aes(x=RatioOfDiffToSame,y=Probability,color=Distractors,group=1)) +
  geom_point(size=4,alpha=.5) +
  geom_errorbar(aes(ymin=YMin,ymax=YMax)) +
  facet_grid(DType~RedundantProperty) +
  xlab("Ratio of distractors with different to same insufficient feature") +
  ylab("Probability of redundancy")
ggsave("graphs_numdistractors/model-empirical_correctonly.pdf",width=9,height=4)
ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/theory/pics/model-empirical.pdf",width=9,height=6)
#ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/talks/2016/edinburgh/model-and-empirical.pdf",width=7.5,height=5)


# plot by ratio only
agr = targets %>%
  select(Color,Size,SizeAndColor,Other,SufficientProperty,RatioOfDiffToSame) %>%
  gather(Utterance,Mentioned,-SufficientProperty,-RatioOfDiffToSame) %>%
  group_by(Utterance,SufficientProperty,RatioOfDiffToSame) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

ggplot(agr, aes(x=RatioOfDiffToSame,y=Probability)) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax)) +
  facet_grid(SufficientProperty~Utterance)
ggsave("graphs_numdistractors/utterancetype_by_condition_ratioonly.pdf",width=9,height=4)

######### ANALYSIS ###########


t = droplevels(subset(targets, redUtterance %in% c("minimal","redundant")))
nrow(t)

centered = cbind(t, myCenter(t[,c("SufficientProperty","NumDistractors","NumSameDistractors","roundNum","RatioOfDiffToSame")]))
contrasts(centered$redUtterance)
contrasts(centered$SufficientProperty)

pairscor.fnc(centered[,c("redUtterance","SufficientProperty","NumDistractors","NumSameDistractors","RatioOfDiffToSame")])
m = glmer(redUtterance ~ cSufficientProperty*cRatioOfDiffToSame + (1+cRatioOfDiffToSame|gameid) + (1|Item), data=centered, family="binomial")
summary(m)

m.simple = glmer(redUtterance ~ SufficientProperty*cRatioOfDiffToSame - cRatioOfDiffToSame + (1|gameid) + (1|Item), data=centered, family="binomial")
summary(m.simple)

m.intercepts = glmer(redUtterance ~ cSufficientProperty*cRatioOfDiffToSame + (1|gameid) + (1|Item), data=centered, family="binomial")
summary(m.intercepts)

# do the analysis only on those cases that have a ratio > 0
centered = cbind(t[t$RatioOfDiffToSame > 0,], myCenter(t[t$RatioOfDiffToSame > 0,c("SufficientProperty","NumDistractors","NumSameDistractors","roundNum","RatioOfDiffToSame")]))
contrasts(centered$redUtterance)
contrasts(centered$SufficientProperty)

pairscor.fnc(centered[,c("redUtterance","SufficientProperty","NumDistractors","NumSameDistractors","RatioOfDiffToSame")])
m = glmer(redUtterance ~ cSufficientProperty*cRatioOfDiffToSame + (1+cRatioOfDiffToSame|gameid) + (1|Item), data=centered, family="binomial")
summary(m) # doing the analysis only on the ratio > 0 cases gets rid of the interaction, ie variation has the same effect on color-redundant and size-redunant trials. (that is, the big scene variation slop in hte color-redundant condition was driven mostly by the 0-ratio cases)

m.intercepts = glmer(redUtterance ~ cSufficientProperty*cRatioOfDiffToSame + (1|gameid) + (1|Item), data=centered, family="binomial")
summary(m.intercepts)


























