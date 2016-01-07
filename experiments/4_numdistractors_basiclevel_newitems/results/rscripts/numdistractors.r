theme_set(theme_bw(18))
setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/4_numdistractors_basiclevel_newitems/results")
source("rscripts/helpers.r")

d = read.table(file="data/results_modified.csv",sep=",", header=T, quote="")

d$Half = as.factor(ifelse(d$roundNum < 37, "first","second"))
d$Quarter = as.factor(ifelse(d$roundNum < 19, "first",ifelse(d$roundNum < 37,"second", ifelse(d$roundNum < 55, "third","fourth"))))
head(d)
nrow(d)
#d$speakerMessages
summary(d)
totalnrow = nrow(d)
totalnrow
d[is.na(d$typeMentioned),]$typeMentioned = FALSE
d$TypeMentioned = d$typeMentioned
d[is.na(d$otherFeatureMentioned),]$otherFeatureMentioned = FALSE
d[is.na(d$superClassMentioned),]$superClassMentioned = FALSE
d[is.na(d$basiclevelMentioned),]$basiclevelMentioned = FALSE
d[is.na(d$superclassattributeMentioned),]$superclassattributeMentioned = FALSE
d[is.na(d$utteranceContracted),]$utteranceContracted = FALSE

# look at turker comments
comments = read.table(file="data/overinf.csv",sep=",", header=T, quote="")
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
length(levels(d$gameid)) # 28

table(d$condition,d$TypeMentioned)
table(d$condition,d$superClassMentioned)
table(d$condition,d$superSuperClassMentioned)
table(d$condition,d$basiclevelMentioned)
d[d$superclassattributeMentioned == TRUE,]

table(d$condition,d$colorMentioned)
table(d$condition,d$sizeMentioned)

### ANALYZE ONLY TRIALS WHERE COLOR/SIZE/NUMDISTRACTORS WAS MANIPULATED
# exclude pair where listener always seemed to click something completely different
d = droplevels(d[d$trialType == "colorSizeTrial",])
totalnrow = nrow(d)
d$SufficientProperty = as.factor(ifelse(d$condition %in% c("sizeOnly4Distr3Same", "sizeOnly2Distr1Same", "sizeOnly4Distr1Same", "sizeOnly3Distr3Same", "sizeOnly3Distr2Same", "sizeOnly3Distr1Same"), "size", "color"))
d$NumDistractors = ifelse(d$condition %in% c("sizeOnly2Distr1Same","colorOnly2Distr1Same"), 2, ifelse(d$condition %in% c("sizeOnly4Distr1Same","sizeOnly4Distr3Same","colorOnly4Distr1Same","colorOnly4Distr3Same"),4,3))
d$NumDiffDistractors = ifelse(d$condition %in% c("sizeOnly3Distr3Same","colorOnly3Distr3Same","sizeOnly2Distr2Same","colorOnly2Distr2Same","sizeOnly4Distr4Same","colorOnly4Distr4Same"), 0, ifelse(d$condition %in% c("sizeOnly3Distr2Same","colorOnly3Distr2Same","sizeOnly2Distr1Same","colorOnly2Distr1Same","sizeOnly4Distr3Same","colorOnly4Distr3Same"), 1, ifelse(d$condition %in% c("sizeOnly4Distr2Same","colorOnly4Distr2Same","sizeOnly3Distr1Same","colorOnly3Distr1Same"),2,ifelse(d$condition %in% c("sizeOnly4Distr1Same","colorOnly4Distr1Same"),3, 4))))
d$NumSameDistractors = ifelse(d$condition %in% c("sizeOnly3Distr1Same","colorOnly3Distr1Same","sizeOnly2Distr1Same","colorOnly2Distr1Same","sizeOnly4Distr1Same","colorOnly4Distr1Same"), 1, ifelse(d$condition %in% c("sizeOnly3Distr2Same","colorOnly3Distr2Same","sizeOnly2Distr2Same","colorOnly2Distr2Same","sizeOnly4Distr2Same","colorOnly4Distr2Same"), 2, ifelse(d$condition %in% c("sizeOnly4Distr3Same","colorOnly4Distr3Same","sizeOnly3Distr3Same","colorOnly3Distr3Same"),3,ifelse(d$condition %in% c("sizeOnly4Distr4Same","colorOnly4Distr4Same"),4,NA))))

d = droplevels(d[d$targetStatusClickedObj == "target",])

print(paste("percentage of excluded trials because distractor was chosen: ", (totalnrow -nrow(d))*100/totalnrow))

d1=d
d1$Experiment = "2"
load("../../3_numdistractors_basiclevel/results/data/d.RData") # load first round of data
d2=d
d2$Experiment = "1"

d = merge(d1,d2,all=T)
summary(d)

targets = d
nrow(targets) # 998 cases
targets$UtteranceType = as.factor(ifelse(targets$sizeMentioned & targets$colorMentioned, "size and color", ifelse(targets$sizeMentioned, "size", ifelse(targets$colorMentioned, "color","OTHER"))))
targets = droplevels(targets[!is.na(targets$UtteranceType),])
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
  geom_point() +
  ylab("Probability of redundancy") +
  #geom_smooth(method="lm") +
  facet_wrap(~RedundantProperty)


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
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax)) +
  facet_grid(RedundantProperty~DType) +
  xlab("Ratio of distractors with different to same non-sufficient feature") +
  ylab("Probability of redundancy")
ggsave("graphs_numdistractors/model-empirical_correctonly.pdf",width=9,height=4)
ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/theory/pics/model-empirical.pdf",width=9,height=6)

# plot by ratio and numdistractors and EXPERIMENT, only for 'correct' properties, to see whether there are differences in the 2-1, 4-1, and 4-3 conditions across experiments
targets$CorrectProperty = ifelse(targets$SufficientProperty == "color" & (targets$Color == 1 | targets$SizeAndColor == 1), 1, ifelse(targets$SufficientProperty == "size" & (targets$Size == 1 | targets$SizeAndColor == 1), 1, 0)) # 20 cases of incorrect property mention
targets$minimal = ifelse(targets$SizeAndColor == 0, 1, 0)
targets$redundant = ifelse(targets$SizeAndColor == 1, 1, 0)
agr = targets[targets$CorrectProperty == 1,] %>%
  select(redundant,SufficientProperty,NumDistractors,RatioOfDiffToSame,Experiment) %>%
  gather(Utterance,Mentioned,-SufficientProperty,-NumDistractors,-RatioOfDiffToSame,-Experiment) %>%
  group_by(Utterance,SufficientProperty,NumDistractors,RatioOfDiffToSame,Experiment) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
agr$Distractors = as.factor(agr$NumDistractors)
agr$RedundantProperty = ifelse(agr$SufficientProperty == 'color',"size redundant","color redundant")
ggplot(agr, aes(x=RatioOfDiffToSame,y=Probability,color=Distractors,shape=Experiment,group=1)) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax)) +
  xlab("Ratio of different to same (other) feature values") +
  ylab("Probability of redundancy") +
  #  geom_smooth(method="lm") +
  facet_wrap(~RedundantProperty)
ggsave("graphs_numdistractors/utterancetype_by_condition_byexperiment_ratio_correctonly.pdf",width=7,height=3.2)



centered=cbind(targets,myCenter(targets[,c("SufficientProperty","RatioOfDiffToSame","NumDistractors")]))
m = glmer(redundant ~ cSufficientProperty * cRatioOfDiffToSame + cNumDistractors + (1+cSufficientProperty|gameid) + (1|clickedType), data=centered,family='binomial')
summary(m)
m = glmer(redundant ~ SufficientProperty * cRatioOfDiffToSame - cRatioOfDiffToSame + (1+cSufficientProperty|gameid), data=centered,family='binomial')
summary(m)

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














