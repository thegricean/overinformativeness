theme_set(theme_bw(18))

setwd("/home/caroline/cocolab/overinformativeness/experiments/4_numdistractors_basiclevel_newitems/results")
<<<<<<< HEAD
source("rscripts/helpers.R")

###Annotation check file###

x = read.table(file="data/results.csv",sep=",", header=T, quote="")
head(x)
summary(x)
totalnrow = nrow(x)

y = droplevels(subset(x, condition == "distr12" | condition == "distr22" | condition == "distr23" | condition == "distr33"))

head(y)
nrow(y)
totalnrow = nrow(y)

#look only at incorrect trials:

incorr = droplevels(subset(y, targetStatusClickedObj == "distrClass1" || targetStatusClickedObj == "distrClass2" || targetStatusClickedObj == "distrClass3"))
head(incorr)
nrow(incorr)

#drop incorrect trials:

results_annotation_check = droplevels(y[!is.na(y$targetStatusClickedObj) & y$targetStatusClickedObj != "distrClass1" & y$targetStatusClickedObj != "distrClass2" & y$targetStatusClickedObj != "distrClass3",])
head(results_annotation_check)
nrow(results_annotation_check)
print(paste("percentage of excluded trials because distractor was chosen: ", (totalnrow -nrow(results_annotation_check))*100/totalnrow))


write.csv(results_annotation_check, file = "results_annotation_check.csv")

##########################################################################################

z = read.table(file="data/results_modified.csv",sep=",", header=T, quote="")
head(z)
summary(z)

q = droplevels(subset(z, condition == "distr12" | condition == "distr22" | condition == "distr23" | condition == "distr33"))

head(q)
nrow(q)
totalnrow = nrow(q)

#drop incorrect trials:

results_annotation_check_results_modified = droplevels(q[!is.na(q$targetStatusClickedObj) & q$targetStatusClickedObj != "distrClass1" & q$targetStatusClickedObj != "distrClass2",])
head(results_annotation_check_results_modified)
nrow(results_annotation_check_results_modified)
print(paste("percentage of excluded trials because distractor was chosen: ", (totalnrow -nrow(results_annotation_check_results_modified))*100/totalnrow))


write.csv(results_annotation_check_results_modified, file = "results_annotation_check_results_modified.csv")


###No. of trials where both bl and type was said:

both = droplevels(results_annotation_check_results_modified[!is.na(results_annotation_check_results_modified$basiclevelMentioned) & !is.na(results_annotation_check_results_modified$typeMentioned) & results_annotation_check_results_modified$basiclevelMentioned != F & results_annotation_check_results_modified$typeMentioned != F,])

both = droplevels(subset(results_annotation_check_results_modified, (typeMentioned == T && basiclevelMentioned == T )))
head(both)
nrow(both)
print(paste("percentage of trials where both sub and basic level term was said: ", (totalnrow -nrow(results_annotation_check_results_modified))*100/totalnrow))


# one, the, contractions

y = read.table(file="data/results_annotation_check_results_modified.csv",sep=",", header=T, quote="")

one = droplevels(subset(y, (oneMentioned == T)))
head(one)
nrow(one)

the = droplevels(subset(y, (theMentioned == T)))
head(the)
nrow(the)

contr = droplevels(subset(y, (utteranceContracted == T)))
head(contr)
nrow(contr)

sentence = droplevels(subset(y, (fullSentence == T)))
head(sentence)
nrow(sentence)

########################################################################################

# only look at typeMentions

z = read.table(file="data/results_annotation_check.csv",sep=",", header=T, quote="")
head(z)
summary(z)
nrow(z)

## both type and bl mentioned



q = droplevels(subset(z, typeMentioned_after_manual_correction == T))

head(q)
nrow(q)
totalnrow = nrow(q)

write.csv(q, file = "results_annotation_Type_true.csv")

# only look at supermentions

supers = droplevels(subset(results_annotation_check_results_modified, superClassMentioned == T))

head(supers)
nrow(supers)

write.csv(supers, file = "supers.csv")

# only look at BLmentions

bl = droplevels(subset(results_annotation_check_results_modified, basiclevelMentioned == T))

head(bl)
nrow(bl)

write.csv(bl, file = "basiclevels.csv")

x = read.table(file="data/length_calculations/basiclevels.csv",sep=",", header=T, quote="")
head(x)
nrow(x)

blattribute = droplevels(subset(x, attributeUsed == T))
head(blattribute)
nrow(blattribute)



blnoatt = droplevels(subset(x, (colorMentioned == F || is.na(colorMentioned)) && (otherFeatureMentioned == F || is.na(colorMentioned)) ))
head(blattribute)
nrow(blattribute)

rose = droplevels(subset(bl, nameClickedObj == "rose"))
head(rose)
nrow(rose)

candy = droplevels(subset(bl, refExp == "candy"))
head(candy)
nrow(candy)

dog = droplevels(subset(bl, basiclevelClickedObj == "dog"))
head(dog)
nrow(dog)

fish = droplevels(subset(bl, basiclevelClickedObj == "fish"))
head(fish)
nrow(fish)

flower = droplevels(subset(bl, basiclevelClickedObj == "flower"))
head(flower)
nrow(flower)

bear = droplevels(subset(bl, basiclevelClickedObj == "bear"))
head(bear)
nrow(bear)

bird = droplevels(subset(bl, basiclevelClickedObj == "bird"))
head(bird)
nrow(bird)

car = droplevels(subset(bl, basiclevelClickedObj == "car"))
head(car)
nrow(car)

table = droplevels(subset(bl, basiclevelClickedObj == "table"))
head(table)
nrow(table)

shirt = droplevels(subset(bl, basiclevelClickedObj == "shirt"))
head(shirt)
nrow(shirt)


grizzly = droplevels(subset(bl, nameClickedObj == "grizzlyBear"))
head(grizzly)
nrow(grizzly)
write.csv(grizzly, file = "grizzly.csv")




# ###DOG
# 
# a = read.table(file="data/results_annotation_Type_true.csv",sep=",", header=T, quote="")
# head(a)
# summary(a)
# nrow(a)
# 
# gershep = droplevels(subset(a, nameClickedObj == "germanShepherd"))
# write.csv(gershep, file = "gershep.csv")

###########################################################################################

# get extra column where you say whether ANY level was mentioned (false for attribute/other mentions)

results_annotation_check$basicLevelMentioned = ifelse(refexp == "dog", T,
                                                      ifelse(refexp == "fish", T,
                                                             ifelse(refexp == "bird", T,
                                                                    ifelse(refexp == "bear", T,
                                                                           ifelse(refexp == "candy", T,
                                                                                  ifelse(refexp == "shirt", T,
                                                                                         ifelse(refexp == "car", T,
                                                                                                ifelse(refexp == "table", T,
                                                                                                       ifelse(refexp == "flower", T, F)))))))))

#########################################################

#load("data/r.RData")
d = read.table(file="data/results_modified.csv",sep=",", header=T, quote="")
head(d)
nrow(d)
summary(d)
d[is.na(d$typeMentioned),]$typeMentioned = FALSE
d[is.na(d$otherFeatureMentioned),]$otherFeatureMentioned = FALSE
d[is.na(d$basiclevelMentioned),]$basiclevelMentioned = FALSE
d[is.na(d$superClassMentioned),]$superClassMentioned = FALSE
d[is.na(d$superclassattributeMentioned),]$superclassattributeMentioned = FALSE
d[is.na(d$utteranceContracted),]$utteranceContracted = FALSE

# how many unique pairs?
length(levels(d$gameid)) # 28

# Only look at basiclevel conditions: distr12, distr22, distr23, distr33:

#basiclevel data:
bd = droplevels(subset(d, condition == "distr12" | condition == "distr22" | condition == "distr23" | condition == "distr33"))
head(bd)
nrow(bd)
summary(bd)
totalnrow = nrow(bd)

table(bd$condition,bd$typeMentioned)
table(bd$condition,bd$basiclevelMentioned)
table(bd$condition,bd$otherFeatureMentioned)
table(bd$condition,bd$superClassMentioned)
table(bd$condition,bd$superclassattributeMentioned)

#less interesting: sizeMentioned and colorMentioned
table(bd$condition,bd$colorMentioned)
table(bd$condition,bd$sizeMentioned)
# d[d$superclassattributeMentioned == TRUE,] look at which superclassatributes people used

# drop incorrect trials:
allAtt = droplevels(bd[!is.na(bd$targetStatusClickedObj) & bd$targetStatusClickedObj != "distrClass1" & bd$targetStatusClickedObj != "distrClass2",])
head(bdCorrect)
nrow(bdCorrect)
print(paste("percentage of excluded trials because distractor was chosen: ", (totalnrow -nrow(bdCorrect))*100/totalnrow))

############################################################################################################

#UPDATE DATASET TO INCLUDE BASICLEVELATTRIBUTES AND TYPEATTRIBUTES AND USE CORRECTED SUPERATTRIBUTES DATA:

# load data of ONLY CORRECT trials without black stimulus:

d = read.table(file="data/results_modified_Exp4_bdCorrect_withoutBlackstimulus.csv",sep=",", header=T, quote="")
head(d)
summary(d)
dRows = nrow(d)

d[is.na(d$typeMentioned),]$typeMentioned = FALSE
d[is.na(d$typeAttributeMentioned),]$typeAttributeMentioned = FALSE
d[is.na(d$otherFeatureMentioned),]$otherFeatureMentioned = FALSE
d[is.na(d$basiclevelMentioned),]$basiclevelMentioned = FALSE
d[is.na(d$basiclevelAttributeMentioned),]$basiclevelAttributeMentioned = FALSE
d[is.na(d$superClassMentioned),]$superClassMentioned = FALSE
d[is.na(d$superclassattributeMentioned),]$superclassattributeMentioned = FALSE
d[is.na(d$utteranceContracted),]$utteranceContracted = FALSE

head(d)

# Graphs 1: Include all attributes: (but no trials where neither sub/basic/super nor attributes of sub/basic/super were mentioned)

allAtt = droplevels(d[d$noAttrOrLevelMentioned != "x",])

head(allAtt)

nrow(allAtt)
print(paste("percentage of excluded trials because neither level nor attribute of level was chosen: ", (dRows -nrow(allAtt))*100/dRows))

write.csv(allAtt, file = "allAttr.csv")

# Now, if either the level OR the attribute of this level was mentioned, it will be combined into one variable

allAtt$subMentioned = ifelse(allAtt$typeMentioned | allAtt$typeAttributeMentioned, T, F)
allAtt$basicMentioned = ifelse(allAtt$basiclevelMentioned | allAtt$basiclevelAttributeMentioned, T, F)
allAtt$superMentioned = ifelse(allAtt$superClassMentioned | allAtt$superclassattributeMentioned, T, F)


# Graphs with all-attribute data: 

agr = allAtt %>%
  select(subMentioned,basicMentioned, superMentioned, condition) %>%
  gather(Feature,Mentioned,-condition)
agr$Feature = gsub("Mentioned","",as.character(agr$Feature))
agr = droplevels(subset(agr,Mentioned == "TRUE"))
head(agr)

# plot histogram of mentioned features by condition
ggplot(agr, aes(x=Feature)) +
  #geom_histogram() +
  stat_count() +
  facet_wrap(~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/0_frequencyMentionedFeatured/frequency_mentioned_features_by_condition.pdf",width=8,height=10)

# plot histogram with probabilities

agr = allAtt %>%
  select(subMentioned,basicMentioned, superMentioned, condition) %>%
  gather(Utterance,Mentioned,-condition) %>%
  group_by(Utterance,condition) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
agr$UtteranceType = factor(x=ifelse(agr$Utterance == "subMentioned","sub",ifelse(agr$Utterance == "basicMentioned","basic","super")),levels=c("sub","basic","super"))

ggplot(agr, aes(x=UtteranceType,y=Probability)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~condition) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/1_proportionMentionedFeatures/proportion_mentioned_features_by_condition.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~UtteranceType) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/1_proportionMentionedFeatures/proportion_mentioned_features_by_feature.pdf",width=10,height=10)

# agr = allAtt %>%
#   select(subMentioned,basicMentioned, superMentioned, condition) %>%
#   gather(Utterance,Mentioned,-condition) %>%
#   group_by(Utterance,condition) %>%
#   summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
# agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
# agr$UtteranceType = factor(x=ifelse(agr$Utterance == "subMentioned","sub",ifelse(agr$Utterance == "basicMentioned","basic","super")),levels=c("sub","basic","super"))
# 
# ggplot(agr, aes(x=condition,y=Probability)) +
#   geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_wrap(~UtteranceType) + 
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/1_proportionMentionedFeatures/proportion_mentioned_features_by_feature_combinedSuperCategory.pdf",width=9,height=4)
# 

# We want to include the domain:

#Get rid of domain == NA

allAtt = droplevels(allAtt[!is.na(allAtt$basiclevelClickedObj),])
summary(allAtt)

agr = allAtt %>%
  select(subMentioned,basicMentioned, superMentioned, basiclevelClickedObj, condition) %>%
  gather(Feature,Mentioned,-condition, -basiclevelClickedObj)
agr$Feature = gsub("Mentioned","",as.character(agr$Feature))
agr = droplevels(subset(agr,Mentioned == "TRUE"))
head(agr)
summary(agr)

# plot histogram of mentioned features by condition
ggplot(agr, aes(x=Feature)) +
  #geom_histogram() +
  stat_count() +
  facet_grid(basiclevelClickedObj~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
  #facet_wrap(~condition)
ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/0_frequencyMentionedFeatured/frequency_mentioned_features_by_condition_by_domain.pdf",width=8,height=10)

# plot histogram with probabilities

agr = allAtt %>%
  select(subMentioned,basicMentioned, superMentioned, basiclevelClickedObj, condition) %>%
  gather(Utterance,Mentioned,-condition, -basiclevelClickedObj) %>%
  group_by(Utterance,condition, basiclevelClickedObj) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
agr$UtteranceType = factor(x=ifelse(agr$Utterance == "subMentioned","sub",ifelse(agr$Utterance == "basicMentioned","basic","super")),levels=c("sub","basic","super"))

ggplot(agr, aes(x=UtteranceType,y=Probability)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(basiclevelClickedObj~condition) +
  #facet_wrap(~condition) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/1_proportionMentionedFeatures/proportion_mentioned_features_by_condition_by_domain.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(basiclevelClickedObj~UtteranceType) +
  #facet_wrap(~Utterance) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/1_proportionMentionedFeatures/proportion_mentioned_features_by_feature_by_domain.pdf",width=10,height=10)

### Not doing length or frequency analysis for attributes, since length and frequency is only extracted for exact names of labels

# ######################################################################################
# 
# # Analysis of word length effect: (only for correct trials!)
# 
# #Add new variable which encodes relative word length (shorter or longer) of type class to superclass
# allAtt$typeLength = nchar(as.character(allAtt$nameClickedObj))
# head(allAtt$typeLength)
# allAtt$basiclevelLength = nchar(as.character(allAtt$basiclevelClickedObj))
# head(allAtt$basiclevelLength)
# 
# allAtt$TypeShorter = ifelse(allAtt$typeLength < allAtt$basiclevelLength, "type_shorter_than_BL","type_longer_than_BL")
# 
# # plot histogram with probabilities RELATIVE LENGTH TYPE/BL
# 
# agr = allAtt %>%
#   select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, basiclevelClickedObj, condition, TypeShorter) %>%
#   gather(Utterance,Mentioned,-condition, -basiclevelClickedObj, -TypeShorter) %>%
#   group_by(Utterance,condition, basiclevelClickedObj, TypeShorter) %>%
#   summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
# agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
# 
# dodge = position_dodge(.9)
# 
# ggplot(agr, aes(x=Utterance,y=Probability,fill=TypeShorter)) +
# #ggplot(agr, aes(x=Utterance,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   # geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(basiclevelClickedObj~condition) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/2_lengthAnalysis/proportion_mentioned_features_by_condition_by_domain_by_length.pdf",width=10,height=10)
# 
# ggplot(agr, aes(x=condition,y=Probability,fill=TypeShorter)) +
# #ggplot(agr, aes(x=condition,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   #geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(basiclevelClickedObj~Utterance) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/2_lengthAnalysis/proportion_mentioned_features_by_feature_by_domain_by_length.pdf",width=10,height=10)
# 
# # same analysis with length bins: 
# 
# head(allAtt$typeLength)
# 
# # 2 bins
# 
# #What's the medium word length?
# summary(allAtt$typeLength)
# # mean = 8.229, median = 9
# 
# allAtt$typeNumOfChar2bins = ifelse(allAtt$typeLength < 9, "01-08", "9+" )
# 
# head(allAtt$typeNumOfChar2bins)
# head(allAtt)
# 
# # plot histogram with probabilities
# 
# agr = allAtt %>%
#   select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, basiclevelClickedObj, condition, typeNumOfChar2bins) %>%
#   gather(Utterance,Mentioned,-condition, -basiclevelClickedObj, -typeNumOfChar2bins) %>%
#   group_by(Utterance,condition, basiclevelClickedObj, typeNumOfChar2bins) %>%
#   summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
# agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
# 
# dodge = position_dodge(.9)
# 
# ggplot(agr, aes(x=Utterance,y=Probability,fill=typeNumOfChar2bins)) +
#   #ggplot(agr, aes(x=Utterance,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   # geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(basiclevelClickedObj~condition) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/2_lengthAnalysis/2bins_proportion_mentioned_features_by_condition_by_domain_by_length_2bins.pdf",width=10,height=10)
# 
# ggplot(agr, aes(x=condition,y=Probability,fill=typeNumOfChar2bins)) +
#   #ggplot(agr, aes(x=condition,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   #geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(basiclevelClickedObj~Utterance) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/2_lengthAnalysis/2bins_proportion_mentioned_features_by_feature_by_domain_by_length_2bins.pdf",width=10,height=10)
# 
# # 2 bins without domain: 
# 
# agr = allAtt %>%
#   select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, condition, typeNumOfChar2bins) %>%
#   gather(Utterance,Mentioned,-condition, -typeNumOfChar2bins) %>%
#   group_by(Utterance,condition, typeNumOfChar2bins) %>%
#   summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
# agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
# 
# dodge = position_dodge(.9)
# 
# ggplot(agr, aes(x=Utterance,y=Probability,fill=typeNumOfChar2bins)) +
#   #ggplot(agr, aes(x=Utterance,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   # geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(~condition) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/2_lengthAnalysis/2bins_proportion_mentioned_features_by_condition_by_length_2bins.pdf",width=10,height=10)
# 
# allAtt$superMentioned = ifelse(allAtt$superClassMentioned | allAtt$superclassattributeMentioned, T, F)
# agr = allAtt %>%
#   select(typeMentioned,basiclevelMentioned,superMentioned, condition, typeNumOfChar2bins) %>%
#   gather(Utterance,Mentioned,-condition, -typeNumOfChar2bins) %>%
#   group_by(Utterance,condition, typeNumOfChar2bins) %>%
#   summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
# agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
# agr$UtteranceType = factor(x=ifelse(agr$Utterance == "typeMentioned","sub",ifelse(agr$Utterance == "basiclevelMentioned","basic","super")),levels=c("sub","basic","super"))
# 
# dodge = position_dodge(.9)
# 
# ggplot(agr, aes(x=condition,y=Probability,fill=typeNumOfChar2bins)) +
#   #ggplot(agr, aes(x=condition,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   #geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(~UtteranceType) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/2_lengthAnalysis/2bins_proportion_mentioned_features_by_feature_by_length_2bins.pdf",width=10,height=4)
# 
# 
# # 4 bins
# 
# allAtt$typeNumOfChar4bins = ifelse(allAtt$typeLength < 4, "01-03",
#                                       ifelse((allAtt$typeLength < 7 & allAtt$typeLength > 3), "04-06", 
#                                              ifelse((allAtt$typeLength < 10 & allAtt$typeLength > 6), "07-09", "10+" )))
# 
# head(allAtt$typeNumOfChar4bins)
# head(allAtt)
# 
# # plot histogram with probabilities
# 
# agr = allAtt %>%
#   select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, basiclevelClickedObj, condition, typeNumOfChar4bins) %>%
#   gather(Utterance,Mentioned,-condition, -basiclevelClickedObj, -typeNumOfChar4bins) %>%
#   group_by(Utterance,condition, basiclevelClickedObj, typeNumOfChar4bins) %>%
#   summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
# agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
# 
# dodge = position_dodge(.9)
# 
# ggplot(agr, aes(x=Utterance,y=Probability,fill=typeNumOfChar4bins)) +
#   #ggplot(agr, aes(x=Utterance,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   # geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(basiclevelClickedObj~condition) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/2_lengthAnalysis/4bins_proportion_mentioned_features_by_condition_by_domain_by_length_4bins.pdf",width=10,height=10)
# 
# ggplot(agr, aes(x=condition,y=Probability,fill=typeNumOfChar4bins)) +
#   #ggplot(agr, aes(x=condition,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   #geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(basiclevelClickedObj~Utterance) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/2_lengthAnalysis/4bins_proportion_mentioned_features_by_feature_by_domain_by_length_4bins.pdf",width=10,height=10)
# 
# # 4 bins without domain
# 
# agr = allAtt %>%
#   select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, condition, typeNumOfChar4bins) %>%
#   gather(Utterance,Mentioned,-condition, -typeNumOfChar4bins) %>%
#   group_by(Utterance,condition, typeNumOfChar4bins) %>%
#   summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
# agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
# 
# dodge = position_dodge(.9)
# 
# ggplot(agr, aes(x=Utterance,y=Probability,fill=typeNumOfChar4bins)) +
#   #ggplot(agr, aes(x=Utterance,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   # geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(~condition) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/2_lengthAnalysis/4bins_proportion_mentioned_features_by_condition_by_length_4bins.pdf",width=10,height=10)
# 
# ggplot(agr, aes(x=condition,y=Probability,fill=typeNumOfChar4bins)) +
#   #ggplot(agr, aes(x=condition,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   #geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(~Utterance) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/2_lengthAnalysis/4bins_proportion_mentioned_features_by_feature_by_length_4bins.pdf",width=10,height=10)
# 

# 
# # 6 bins:
# 
# 
# allAtt$typeNumOfChar6bins = ifelse(allAtt$typeLength < 4, "01-03",
#                                  ifelse((allAtt$typeLength < 6 & allAtt$typeLength > 3), "04-05", 
#                                         ifelse((allAtt$typeLength < 8 & allAtt$typeLength > 5), "06-07", 
#                                                ifelse((allAtt$typeLength < 10 & allAtt$typeLength > 7), "08-09",  
#                                                       ifelse((allAtt$typeLength < 12 & allAtt$typeLength > 9), "10-11", "12+" )))))
# 
# head(allAtt$typeNumOfChar6bins)
# head(allAtt)
# 
# # plot histogram with probabilities
# 
# agr = allAtt %>%
#   select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, basiclevelClickedObj, condition, typeNumOfChar6bins) %>%
#   gather(Utterance,Mentioned,-condition, -basiclevelClickedObj, -typeNumOfChar6bins) %>%
#   group_by(Utterance,condition, basiclevelClickedObj, typeNumOfChar6bins) %>%
#   summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
# agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
# 
# dodge = position_dodge(.9)
# 
# ggplot(agr, aes(x=Utterance,y=Probability,fill=typeNumOfChar6bins)) +
#   #ggplot(agr, aes(x=Utterance,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   # geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(basiclevelClickedObj~condition) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/2_lengthAnalysis/6bins_proportion_mentioned_features_by_condition_by_domain_by_length_6bins.pdf",width=10,height=10)
# 
# ggplot(agr, aes(x=condition,y=Probability,fill=typeNumOfChar6bins)) +
#   #ggplot(agr, aes(x=condition,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   #geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(basiclevelClickedObj~Utterance) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/2_lengthAnalysis/6bins_proportion_mentioned_features_by_feature_by_domain_by_length_6bins.pdf",width=10,height=10)
# 
# 
# # 6 bins without domain
# 
# agr = allAtt %>%
#   select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, condition, typeNumOfChar6bins) %>%
#   gather(Utterance,Mentioned,-condition, -typeNumOfChar6bins) %>%
#   group_by(Utterance,condition, typeNumOfChar6bins) %>%
#   summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
# agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
# 
# dodge = position_dodge(.9)
# 
# ggplot(agr, aes(x=Utterance,y=Probability,fill=typeNumOfChar6bins)) +
#   #ggplot(agr, aes(x=Utterance,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   # geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(~condition) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/2_lengthAnalysis/6bins_proportion_mentioned_features_by_condition_by_length_6bins.pdf",width=10,height=10)
# 
# ggplot(agr, aes(x=condition,y=Probability,fill=typeNumOfChar6bins)) +
#   #ggplot(agr, aes(x=condition,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   #geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(~Utterance) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/2_lengthAnalysis/6bins_proportion_mentioned_features_by_feature_by_length_6bins.pdf",width=10,height=10)
# 
# 
# # 8 bins:
# 
# 
# allAtt$typeNumOfChar8bins = ifelse(allAtt$typeLength < 4, "01-03",
#                                       ifelse((allAtt$typeLength < 6 & allAtt$typeLength > 3), "04-05", 
#                                              ifelse((allAtt$typeLength < 8 & allAtt$typeLength > 5), "06-07", 
#                                                     ifelse((allAtt$typeLength < 10 & allAtt$typeLength > 7), "08-09", 
#                                                            ifelse((allAtt$typeLength < 12 & allAtt$typeLength > 9), "10-11", 
#                                                                   ifelse((allAtt$typeLength < 14 & allAtt$typeLength > 11), "12-13", 
#                                                                          ifelse((allAtt$typeLength < 16 & allAtt$typeLength > 13), "14-15", "16+" )))))))
# 
# head(allAtt$typeNumOfChar8bins)
# head(allAtt)
# 
# # plot histogram with probabilities
# 
# agr = allAtt %>%
#   select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, basiclevelClickedObj, condition, typeNumOfChar8bins) %>%
#   gather(Utterance,Mentioned,-condition, -basiclevelClickedObj, -typeNumOfChar8bins) %>%
#   group_by(Utterance,condition, basiclevelClickedObj, typeNumOfChar8bins) %>%
#   summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
# agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
# 
# dodge = position_dodge(.9)
# 
# ggplot(agr, aes(x=Utterance,y=Probability,fill=typeNumOfChar8bins)) +
#   #ggplot(agr, aes(x=Utterance,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   # geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(basiclevelClickedObj~condition) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/2_lengthAnalysis/8bins_proportion_mentioned_features_by_condition_by_domain_by_length_8bins.pdf",width=10,height=10)
# 
# ggplot(agr, aes(x=condition,y=Probability,fill=typeNumOfChar8bins)) +
#   #ggplot(agr, aes(x=condition,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   #geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(basiclevelClickedObj~Utterance) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/2_lengthAnalysis/8bins_proportion_mentioned_features_by_feature_by_domain_by_length_8bins.pdf",width=10,height=10)
# 
# # 8 bins without domain:
# 
# agr = allAtt %>%
#   select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, condition, typeNumOfChar8bins) %>%
#   gather(Utterance,Mentioned,-condition, -typeNumOfChar8bins) %>%
#   group_by(Utterance,condition, typeNumOfChar8bins) %>%
#   summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
# agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
# 
# dodge = position_dodge(.9)
# 
# ggplot(agr, aes(x=Utterance,y=Probability,fill=typeNumOfChar8bins)) +
#   #ggplot(agr, aes(x=Utterance,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   # geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(~condition) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/2_lengthAnalysis/8bins_proportion_mentioned_features_by_condition_by_length_8bins.pdf",width=10,height=10)
# 
# ggplot(agr, aes(x=condition,y=Probability,fill=typeNumOfChar8bins)) +
#   #ggplot(agr, aes(x=condition,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   #geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(~Utterance) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/2_lengthAnalysis/8bins_proportion_mentioned_features_by_feature_by_length_8bins.pdf",width=10,height=10)
# 
# 
# 
# 
# # exclude contracted utterances and see if it makes a difference 
# 
# # 2 bins
# 
# bdCorrectNoContractions = droplevels(allAtt[allAtt$utteranceContracted != TRUE,])
# head(bdCorrectNoContractions)
# nrow(bdCorrectNoContractions)
# 
# #What's the medium word length?
# summary(allAtt$typeLength)
# # mean = 8.229, median = 9
# 
# bdCorrectNoContractions$typeNumOfChar2bins = ifelse(bdCorrectNoContractions$typeLength < 9, "01-08", "9+" )
# 
# head(bdCorrectNoContractions$typeNumOfChar2bins)
# head(bdCorrectNoContractions)
# 
# # plot histogram with probabilities
# 
# agr = bdCorrectNoContractions %>%
#   select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, basiclevelClickedObj, condition, typeNumOfChar2bins) %>%
#   gather(Utterance,Mentioned,-condition, -basiclevelClickedObj, -typeNumOfChar2bins) %>%
#   group_by(Utterance,condition, basiclevelClickedObj, typeNumOfChar2bins) %>%
#   summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
# agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
# 
# dodge = position_dodge(.9)
# 
# ggplot(agr, aes(x=Utterance,y=Probability,fill=typeNumOfChar2bins)) +
#   #ggplot(agr, aes(x=Utterance,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   # geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(basiclevelClickedObj~condition) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/2_lengthAnalysis/nonContr_2bins_proportion_mentioned_features_by_condition_by_domain_by_length_2bins.pdf",width=10,height=10)
# 
# ggplot(agr, aes(x=condition,y=Probability,fill=typeNumOfChar2bins)) +
#   #ggplot(agr, aes(x=condition,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   #geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(basiclevelClickedObj~Utterance) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/2_lengthAnalysis/nonContr_2bins_proportion_mentioned_features_by_feature_by_domain_by_length_2bins_NoContractions.pdf",width=10,height=10)
# 
# 
# 
# 
# 
# # Ratio length analyses:
# 
# # new variable for ratio:
# 
# allAtt$typeBasiclevelLengthRatio = allAtt$typeLength / allAtt$basiclevelLength
# head(allAtt$typeBasiclevelLengthRatio)
# summary(allAtt$typeBasiclevelLengthRatio)
# 
# lengthRatioMedian = 2
# lengthRatioMean = 1.9890
# 
# # 2 bins analysis MEDIAN
# 
# allAtt$lengthRatio2bins = ifelse(allAtt$typeBasiclevelLengthRatio < lengthRatioMedian, "smaller_typeBLRatio", "bigger_typeBLRatio" )
# 
# head(allAtt$lengthRatio2bins)
# 
# # plot histogram with probabilities
# 
# agr = allAtt %>%
#   select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, basiclevelClickedObj, condition, lengthRatio2bins) %>%
#   gather(Utterance,Mentioned,-condition, -basiclevelClickedObj, -lengthRatio2bins) %>%
#   group_by(Utterance,condition, basiclevelClickedObj, lengthRatio2bins) %>%
#   summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
# agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
# 
# dodge = position_dodge(.9)
# 
# ggplot(agr, aes(x=Utterance,y=Probability,fill=lengthRatio2bins)) +
#   #ggplot(agr, aes(x=Utterance,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   # geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(basiclevelClickedObj~condition) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/2_lengthAnalysis/ratio_2bins_proportion_mentioned_features_by_condition_by_domain_by_length_2bins.pdf",width=10,height=10)
# 
# ggplot(agr, aes(x=condition,y=Probability,fill=lengthRatio2bins)) +
#   #ggplot(agr, aes(x=condition,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   #geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(basiclevelClickedObj~Utterance) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/2_lengthAnalysis/ratio_2bins_proportion_mentioned_features_by_feature_by_domain_by_length_2bins.pdf",width=10,height=10)
# 
# 
# # ratio2bins without domain:
# 
# agr = allAtt %>%
#   select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, condition, lengthRatio2bins) %>%
#   gather(Utterance,Mentioned,-condition, -lengthRatio2bins) %>%
#   group_by(Utterance,condition, lengthRatio2bins) %>%
#   summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
# agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
# 
# dodge = position_dodge(.9)
# 
# ggplot(agr, aes(x=Utterance,y=Probability,fill=lengthRatio2bins)) +
#   #ggplot(agr, aes(x=Utterance,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   # geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(~condition) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/2_lengthAnalysis/ratio_2bins_proportion_mentioned_features_by_condition_by_length_2bins.pdf",width=10,height=10)
# 
# ggplot(agr, aes(x=condition,y=Probability,fill=lengthRatio2bins)) +
#   #ggplot(agr, aes(x=condition,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   #geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(~Utterance) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/2_lengthAnalysis/ratio_2bins_proportion_mentioned_features_by_feature_by_length_2bins.pdf",width=10,height=10)
# 
# # Combine superclassMentioned and superclassAttributeMentioned
# allAtt$superMentioned = ifelse(allAtt$superClassMentioned | allAtt$superclassattributeMentioned, T, F)
# agr = allAtt %>%
#   select(typeMentioned,basiclevelMentioned,superMentioned, condition, lengthRatio2bins) %>%
#   gather(Utterance,Mentioned,-condition, -lengthRatio2bins) %>%
#   group_by(Utterance,condition, lengthRatio2bins) %>%
#   summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
# agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
# agr$UtteranceType = factor(x=ifelse(agr$Utterance == "typeMentioned","sub",ifelse(agr$Utterance == "basiclevelMentioned","basic","super")),levels=c("sub","basic","super"))
# 
# dodge = position_dodge(.9)
# 
# ggplot(agr, aes(x=condition,y=Probability,fill=lengthRatio2bins)) +
#   geom_bar(stat="identity",position=dodge) +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #facet_wrap(~UtteranceType) + 
#   facet_grid(~UtteranceType) + 
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/2_lengthAnalysis/ratio_2bins_proportion_mentioned_features_by_feature_by_length_combinedSuperCategory.pdf",width=9,height=4)
# 
# 
# # 4 bins analysis
# 
# summary(allAtt$typeBasiclevelLengthRatio)
# 
# lengthRatio1stQu = 1.5
# lengthRatio3rdQu = 2.25
# 
# allAtt$lengthRatio4bins = ifelse(allAtt$typeBasiclevelLengthRatio < lengthRatio1stQu, "01_smallest_typeBLRatio", 
#                                     ifelse(allAtt$typeBasiclevelLengthRatio < lengthRatioMedian, "02_smaller_typeBLRatio", 
#                                            ifelse(allAtt$typeBasiclevelLengthRatio < lengthRatio3rdQu, "03_bigger_typeBLRatio", "04_biggest_typeBLRatio" )))
# 
# head(allAtt$lengthRatio4bins)
# 
# # plot histogram with probabilities
# 
# agr = allAtt %>%
#   select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, basiclevelClickedObj, condition, lengthRatio4bins) %>%
#   gather(Utterance,Mentioned,-condition, -basiclevelClickedObj, -lengthRatio4bins) %>%
#   group_by(Utterance,condition, basiclevelClickedObj, lengthRatio4bins) %>%
#   summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
# agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
# 
# dodge = position_dodge(.9)
# 
# ggplot(agr, aes(x=Utterance,y=Probability,fill=lengthRatio4bins)) +
#   #ggplot(agr, aes(x=Utterance,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   # geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(basiclevelClickedObj~condition) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/2_lengthAnalysis/ratio_4bins_proportion_mentioned_features_by_condition_by_domain_by_length_4bins.pdf",width=10,height=10)
# 
# ggplot(agr, aes(x=condition,y=Probability,fill=lengthRatio4bins)) +
#   #ggplot(agr, aes(x=condition,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   #geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(basiclevelClickedObj~Utterance) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/2_lengthAnalysis/ratio_4bins_proportion_mentioned_features_by_feature_by_domain_by_length_4bins.pdf",width=10,height=10)
# 
# 
# # ratio4bins without domain:
# 
# agr = allAtt %>%
#   select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, condition, lengthRatio4bins) %>%
#   gather(Utterance,Mentioned,-condition, -lengthRatio4bins) %>%
#   group_by(Utterance,condition, lengthRatio4bins) %>%
#   summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
# agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
# 
# dodge = position_dodge(.9)
# 
# ggplot(agr, aes(x=Utterance,y=Probability,fill=lengthRatio4bins)) +
#   #ggplot(agr, aes(x=Utterance,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   # geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(~condition) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/2_lengthAnalysis/ratio_4bins_proportion_mentioned_features_by_condition_by_length_4bins.pdf",width=10,height=10)
# 
# ggplot(agr, aes(x=condition,y=Probability,fill=lengthRatio4bins)) +
#   #ggplot(agr, aes(x=condition,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   #geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(~Utterance) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/2_lengthAnalysis/ratio_4bins_proportion_mentioned_features_by_feature_by_length_4bins.pdf",width=10,height=10)
# 
# # Combine superclassMentioned and superclassAttributeMentioned
# allAtt$superMentioned = ifelse(allAtt$superClassMentioned | allAtt$superclassattributeMentioned, T, F)
# agr = allAtt %>%
#   select(typeMentioned,basiclevelMentioned,superMentioned, condition, lengthRatio4bins) %>%
#   gather(Utterance,Mentioned,-condition, -lengthRatio4bins) %>%
#   group_by(Utterance,condition, lengthRatio4bins) %>%
#   summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
# agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
# agr$UtteranceType = factor(x=ifelse(agr$Utterance == "typeMentioned","sub",ifelse(agr$Utterance == "basiclevelMentioned","basic","super")),levels=c("sub","basic","super"))
# 
# dodge = position_dodge(.9)
# 
# ggplot(agr, aes(x=condition,y=Probability,fill=lengthRatio4bins)) +
#   geom_bar(stat="identity",position=dodge) +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #facet_wrap(~UtteranceType) + 
#   facet_grid(~UtteranceType) + 
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/2_lengthAnalysis/ratio_4bins_proportion_mentioned_features_by_feature_by_length_combinedSuperCategory.pdf",width=9,height=4)
# 
# 
# 
# # MEAN length ratio ANALYSIS:
# 
# # 2 bins analysis
# 
# allAtt$length_ratio_sub_to_basic = ifelse(allAtt$typeBasiclevelLengthRatio < lengthRatioMean, "smaller_typeBLRatio", "bigger_typeBLRatio" )
# 
# head(allAtt$length_ratio_sub_to_basic)
# 
# # plot histogram with probabilities
# 
# agr = allAtt %>%
#   select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, basiclevelClickedObj, condition, length_ratio_sub_to_basic) %>%
#   gather(Utterance,Mentioned,-condition, -basiclevelClickedObj, -length_ratio_sub_to_basic) %>%
#   group_by(Utterance,condition, basiclevelClickedObj, length_ratio_sub_to_basic) %>%
#   summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
# agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
# 
# dodge = position_dodge(.9)
# 
# ggplot(agr, aes(x=Utterance,y=Probability,fill=length_ratio_sub_to_basic)) +
#   #ggplot(agr, aes(x=Utterance,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   # geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(basiclevelClickedObj~condition) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/2_lengthAnalysis/ratio_2bins_proportion_mentioned_features_by_condition_by_domain_by_length_2bins_Mean.pdf",width=10,height=10)
# 
# ggplot(agr, aes(x=condition,y=Probability,fill=length_ratio_sub_to_basic)) +
#   #ggplot(agr, aes(x=condition,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   #geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(basiclevelClickedObj~Utterance) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/2_lengthAnalysis/ratio_2bins_proportion_mentioned_features_by_feature_by_domain_by_length_2bins_Mean.pdf",width=10,height=10)
# 
# 
# # ratio2bins without domain:
# 
# agr = allAtt %>%
#   select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, condition, length_ratio_sub_to_basic) %>%
#   gather(Utterance,Mentioned,-condition, -length_ratio_sub_to_basic) %>%
#   group_by(Utterance,condition, length_ratio_sub_to_basic) %>%
#   summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
# agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
# 
# dodge = position_dodge(.9)
# 
# ggplot(agr, aes(x=Utterance,y=Probability,fill=length_ratio_sub_to_basic)) +
#   #ggplot(agr, aes(x=Utterance,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   # geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(~condition) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/2_lengthAnalysis/ratio_2bins_proportion_mentioned_features_by_condition_by_length_2bins_Mean.pdf",width=10,height=10)
# 
# ggplot(agr, aes(x=condition,y=Probability,fill=length_ratio_sub_to_basic)) +
#   #ggplot(agr, aes(x=condition,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   #geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(~Utterance) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/2_lengthAnalysis/ratio_2bins_proportion_mentioned_features_by_feature_by_length_2bins_Mean.pdf",width=10,height=10)
# 
# # Combine superclassMentioned and superclassAttributeMentioned
# allAtt$superMentioned = ifelse(allAtt$superClassMentioned | allAtt$superclassattributeMentioned, T, F)
# agr = allAtt %>%
#   select(typeMentioned,basiclevelMentioned,superMentioned, condition, length_ratio_sub_to_basic) %>%
#   gather(Utterance,Mentioned,-condition, -length_ratio_sub_to_basic) %>%
#   group_by(Utterance,condition, length_ratio_sub_to_basic) %>%
#   summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
# agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
# agr$UtteranceType = factor(x=ifelse(agr$Utterance == "typeMentioned","sub",ifelse(agr$Utterance == "basiclevelMentioned","basic","super")),levels=c("sub","basic","super"))
# 
# dodge = position_dodge(.9)
# 
# ggplot(agr, aes(x=condition,y=Probability,fill=length_ratio_sub_to_basic)) +
#   geom_bar(stat="identity",position=dodge) +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #facet_wrap(~UtteranceType) + 
#   facet_grid(~UtteranceType) + 
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/2_lengthAnalysis/ratio_2bins_proportion_mentioned_features_by_feature_by_length_Mean_combinedSuperCategory.pdf",width=9,height=4)
# 
# 
# 
# 
# 
# 
# ####################################################################################
# 
# # Frequency analysis (only for correct trials!)
# 
# #load("data/r.RData")    (frequenciesAll)
# frequencies = read.table(file="data/frequencyChart.csv",sep=",", header=T, quote="")
# 
# head(frequencies)
# summary(frequencies)
# 
# # frequenciesType = droplevels(subset(frequencies, noun != "animal" & noun != "bear" & noun != "bird" & noun != "candy" & noun != "car" & noun != "clothing" & noun != "dog" & noun != "fish" & noun != "flower" & noun != "furniture" & noun != "plant" & noun != "shirt" & noun != "snack" & noun != "table" & noun != "vehicle"))
# # 
# # head(frequenciesType)
# # summary(frequenciesType)
# 
# #Add new variable to allAtt from frequencyChart
# allAtt$relFreqType = ifelse(allAtt$nameClickedObj == "bedsideTable", (subset(frequencies, noun == "bedsideTable"))$relFreq, 
#                            ifelse(allAtt$nameClickedObj == "blackBear", (subset(frequencies, noun == "blackBear"))$relFreq, 
#                                   ifelse(allAtt$nameClickedObj == "catfish", (subset(frequencies, noun == "catfish"))$relFreq, 
#                                          ifelse(allAtt$nameClickedObj == "clownFish", (subset(frequencies, noun == "clownFish"))$relFreq, 
#                                                 ifelse(allAtt$nameClickedObj == "coffeeTable", (subset(frequencies, noun == "coffeeTable"))$relFreq, 
#                                                        ifelse(allAtt$nameClickedObj == "convertible", (subset(frequencies, noun == "convertible"))$relFreq, 
#                                                               ifelse(allAtt$nameClickedObj == "daisy", (subset(frequencies, noun == "daisy"))$relFreq, 
#                                                                      ifelse(allAtt$nameClickedObj == "dalmatian", (subset(frequencies, noun == "dalmatian"))$relFreq, 
#                                                                             ifelse(allAtt$nameClickedObj == "diningTable", (subset(frequencies, noun == "diningTable"))$relFreq, 
#                                                                                    ifelse(allAtt$nameClickedObj == "dressShirt", (subset(frequencies, noun == "dressShirt"))$relFreq, 
#                                                                                           ifelse(allAtt$nameClickedObj == "eagle", (subset(frequencies, noun == "eagle"))$relFreq, 
#                                                                                                  ifelse(allAtt$nameClickedObj == "germanShepherd", (subset(frequencies, noun == "germanShepherd"))$relFreq, 
#                                                                                                         ifelse(allAtt$nameClickedObj == "goldFish", (subset(frequencies, noun == "goldFish"))$relFreq, 
#                                                                                                                ifelse(allAtt$nameClickedObj == "grizzlyBear", (subset(frequencies, noun == "grizzlyBear"))$relFreq, 
#                                                                                                                       ifelse(allAtt$nameClickedObj == "gummyBears", (subset(frequencies, noun == "gummyBears"))$relFreq, 
#                                                                                                                              ifelse(allAtt$nameClickedObj == "hawaiiShirt", (subset(frequencies, noun == "hawaiiShirt"))$relFreq, 
#                                                                                                                                     ifelse(allAtt$nameClickedObj == "hummingBird", (subset(frequencies, noun == "hummingBird"))$relFreq, 
#                                                                                                                                            ifelse(allAtt$nameClickedObj == "husky", (subset(frequencies, noun == "husky"))$relFreq, 
#                                                                                                                                                   ifelse(allAtt$nameClickedObj == "jellyBeans", (subset(frequencies, noun == "jellyBeans"))$relFreq, 
#                                                                                                                                                          ifelse(allAtt$nameClickedObj == "mnMs", (subset(frequencies, noun == "mnMs"))$relFreq, 
#                                                                                                                                                                 ifelse(allAtt$nameClickedObj == "minivan", (subset(frequencies, noun == "minivan"))$relFreq, 
#                                                                                                                                                                        ifelse(allAtt$nameClickedObj == "pandaBear", (subset(frequencies, noun == "pandaBear"))$relFreq, 
#                                                                                                                                                                               ifelse(allAtt$nameClickedObj == "parrot", (subset(frequencies, noun == "parrot"))$relFreq, 
#                                                                                                                                                                                      ifelse(allAtt$nameClickedObj == "picnicTable", (subset(frequencies, noun == "picnicTable"))$relFreq, 
#                                                                                                                                                                                             ifelse(allAtt$nameClickedObj == "pigeon", (subset(frequencies, noun == "pigeon"))$relFreq, 
#                                                                                                                                                                                                    ifelse(allAtt$nameClickedObj == "polarBear", (subset(frequencies, noun == "polarBear"))$relFreq, 
#                                                                                                                                                                                                           ifelse(allAtt$nameClickedObj == "poloShirt", (subset(frequencies, noun == "poloShirt"))$relFreq, 
#                                                                                                                                                                                                                  ifelse(allAtt$nameClickedObj == "pug", (subset(frequencies, noun == "pug"))$relFreq, 
#                                                                                                                                                                                                                         ifelse(allAtt$nameClickedObj == "rose", (subset(frequencies, noun == "rose"))$relFreq, 
#                                                                                                                                                                                                                                ifelse(allAtt$nameClickedObj == "skittles", (subset(frequencies, noun == "skittles"))$relFreq, 
#                                                                                                                                                                                                                                       ifelse(allAtt$nameClickedObj == "sportsCar", (subset(frequencies, noun == "sportsCar"))$relFreq, 
#                                                                                                                                                                                                                                              ifelse(allAtt$nameClickedObj == "sunflower", (subset(frequencies, noun == "sunflower"))$relFreq, 
#                                                                                                                                                                                                                                                     ifelse(allAtt$nameClickedObj == "suv", (subset(frequencies, noun == "suv"))$relFreq, 
#                                                                                                                                                                                                                                                            ifelse(allAtt$nameClickedObj == "swordFish", (subset(frequencies, noun == "swordFish"))$relFreq, 
#                                                                                                                                                                                                                                                                   ifelse(allAtt$nameClickedObj == "tShirt", (subset(frequencies, noun == "tShirt"))$relFreq, 
#                                                                                                                                                                                                                                                                          ifelse(allAtt$nameClickedObj == "tulip", (subset(frequencies, noun == "tulip"))$relFreq, "NA"))))))))))))))))))))))))))))))))))))
# # length of basiclevels:
# 
# allAtt$relFreqBasiclevel = ifelse(allAtt$basiclevelClickedObj == "bear", (subset(frequencies, noun == "bear"))$relFreq, 
#                                      ifelse(allAtt$basiclevelClickedObj == "bird", (subset(frequencies, noun == "bird"))$relFreq, 
#                                             ifelse(allAtt$basiclevelClickedObj == "candy", (subset(frequencies, noun == "candy"))$relFreq, 
#                                                    ifelse(allAtt$basiclevelClickedObj == "car", (subset(frequencies, noun == "car"))$relFreq, 
#                                                           ifelse(allAtt$basiclevelClickedObj == "dog", (subset(frequencies, noun == "dog"))$relFreq, 
#                                                                  ifelse(allAtt$basiclevelClickedObj == "fish", (subset(frequencies, noun == "fish"))$relFreq, 
#                                                                         ifelse(allAtt$basiclevelClickedObj == "flower", (subset(frequencies, noun == "flower"))$relFreq, 
#                                                                                ifelse(allAtt$basiclevelClickedObj == "shirt", (subset(frequencies, noun == "shirt"))$relFreq,
#                                                                                       ifelse(allAtt$basiclevelClickedObj == "table", (subset(frequencies, noun == "table"))$relFreq, "NA")))))))))
#                                                                                
# # length of superclasses:
# 
# allAtt$relFreqSuperdomain = ifelse(allAtt$superdomainClickedObj == "animal", (subset(frequencies, noun == "animal"))$relFreq, 
#                                      ifelse(allAtt$superdomainClickedObj == "clothing", (subset(frequencies, noun == "clothing"))$relFreq, 
#                                             ifelse(allAtt$superdomainClickedObj == "furniture", (subset(frequencies, noun == "furniture"))$relFreq, 
#                                                    ifelse(allAtt$superdomainClickedObj == "plant", (subset(frequencies, noun == "plant"))$relFreq, 
#                                                           ifelse(allAtt$superdomainClickedObj == "snack", (subset(frequencies, noun == "snack"))$relFreq, 
#                                                                  ifelse(allAtt$superdomainClickedObj == "vehicle", (subset(frequencies, noun == "vehicle"))$relFreq, "NA"))))))
# 
# 
# 
# 
# # Convert to numeric:
# allAtt$relFreqType = as.numeric(allAtt$relFreqType)
# allAtt$relFreqBasiclevel = as.numeric(allAtt$relFreqBasiclevel)
# allAtt$relFreqSuperdomain = as.numeric(allAtt$relFreqSuperdomain)
# 
# 
# head(allAtt$relFreqType)
# head(allAtt$relFreqBasiclevel)
# head(allAtt$relFreqSuperdomain)
# 
# 
# summary(allAtt$relFreqType)
# summary(allAtt$relFreqBasiclevel)
# summary(allAtt$relFreqSuperdomain)
# 
# 
# 
# # same analyses with frequency bins: 
# 
# # 2 bins
# 
# summary(allAtt$relFreqType)
# medianFreqType = 4.970e-07
# 
# allAtt$freqMedian2bins = ifelse(allAtt$relFreqType < medianFreqType, "less_frequent", "more_frequent")
# head(allAtt$freqMedian2bins)
# 
# # plot histogram with probabilities (median)
# 
# agr = allAtt %>%
#   select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, basiclevelClickedObj, condition, freqMedian2bins) %>%
#   gather(Utterance,Mentioned,-condition, -basiclevelClickedObj, -freqMedian2bins) %>%
#   group_by(Utterance,condition, basiclevelClickedObj, freqMedian2bins) %>%
#   summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
# agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
# 
# dodge = position_dodge(.9)
# 
# ggplot(agr, aes(x=Utterance,y=Probability,fill=freqMedian2bins)) +
#   #ggplot(agr, aes(x=Utterance,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   # geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(basiclevelClickedObj~condition) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/3_frequencyAnalysis/2bins_proportion_mentioned_features_by_condition_by_domain_by_frequency_2bins_median.pdf",width=10,height=10)
# 
# ggplot(agr, aes(x=condition,y=Probability,fill=freqMedian2bins)) +
#   #ggplot(agr, aes(x=condition,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   #geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(basiclevelClickedObj~Utterance) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/3_frequencyAnalysis/2bins_proportion_mentioned_features_by_feature_by_domain_by_frequency_2bins_median.pdf",width=10,height=10)
# 
# # without domain
# 
# agr = allAtt %>%
#   select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, condition, freqMedian2bins) %>%
#   gather(Utterance,Mentioned,-condition, -freqMedian2bins) %>%
#   group_by(Utterance,condition, freqMedian2bins) %>%
#   summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
# agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
# 
# dodge = position_dodge(.9)
# 
# ggplot(agr, aes(x=Utterance,y=Probability,fill=freqMedian2bins)) +
#   #ggplot(agr, aes(x=Utterance,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   # geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(~condition) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/3_frequencyAnalysis/2bins_proportion_mentioned_features_by_condition_by_frequency_2bins_median.pdf",width=10,height=10)
# 
# # CONTINUE HERE
# allAtt$superMentioned = ifelse(allAtt$superClassMentioned | allAtt$superclassattributeMentioned, T, F)
# agr = allAtt %>%
#   select(typeMentioned,basiclevelMentioned,superMentioned, condition, freqMedian2bins) %>%
#   gather(Utterance,Mentioned,-condition, -freqMedian2bins) %>%
#   group_by(Utterance,condition, freqMedian2bins) %>%
#   summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
# agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
# 
# dodge = position_dodge(.9)
# agr$UtteranceType = factor(x=ifelse(agr$Utterance == "typeMentioned","sub",ifelse(agr$Utterance == "basiclevelMentioned","basic","super")),levels=c("sub","basic","super"))
# 
# dodge = position_dodge(.9)
# 
# ggplot(agr, aes(x=condition,y=Probability,fill=freqMedian2bins)) +
#   #ggplot(agr, aes(x=condition,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   #geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(~UtteranceType) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/3_frequencyAnalysis/2bins_proportion_mentioned_features_by_feature_by_frequency_2bins_median.pdf",width=10,height=4)
# 
# 
# # 4 bins:
# 
# summary(allAtt$relFreqType)
# firstQuFreqType = 1.63e-07
# thirdQuFreqType = 1.05e-06
# 
# head(allAtt$relFreqType)
# summary(allAtt$relFreqType)
# 
# allAtt$freqMedian4bins = ifelse(allAtt$relFreqType < firstQuFreqType, "least_frequent", 
#                                          ifelse(allAtt$relFreqType < medianFreqType, "less_frequent",
#                                                 ifelse(allAtt$relFreqType < thirdQuFreqType,"more_frequent", "most_frequent")))
# 
# head(allAtt$freqMedian4bins)
# summary(allAtt$freqMedian4bins)
# 
# # plot histogram with probabilities (median)
# 
# agr = allAtt %>%
#   select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, basiclevelClickedObj, condition, freqMedian4bins) %>%
#   gather(Utterance,Mentioned,-condition, -basiclevelClickedObj, -freqMedian4bins) %>%
#   group_by(Utterance,condition, basiclevelClickedObj, freqMedian4bins) %>%
#   summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
# agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
# 
# dodge = position_dodge(.9)
# 
# ggplot(agr, aes(x=Utterance,y=Probability,fill=freqMedian4bins)) +
#   #ggplot(agr, aes(x=Utterance,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   # geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(basiclevelClickedObj~condition) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/3_frequencyAnalysis/4bins_proportion_mentioned_features_by_condition_by_domain_by_frequency_4bins_median.pdf",width=10,height=10)
# 
# ggplot(agr, aes(x=condition,y=Probability,fill=freqMedian4bins)) +
#   #ggplot(agr, aes(x=condition,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   #geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(basiclevelClickedObj~Utterance) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/3_frequencyAnalysis/4bins_proportion_mentioned_features_by_feature_by_domain_by_frequency_4bins_median.pdf",width=10,height=10)
# 
# # without domain
# 
# agr = allAtt %>%
#   select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, condition, freqMedian4bins) %>%
#   gather(Utterance,Mentioned,-condition, -freqMedian4bins) %>%
#   group_by(Utterance,condition, freqMedian4bins) %>%
#   summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
# agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
# 
# dodge = position_dodge(.9)
# 
# ggplot(agr, aes(x=Utterance,y=Probability,fill=freqMedian4bins)) +
#   #ggplot(agr, aes(x=Utterance,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   # geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(~condition) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/3_frequencyAnalysis/4bins_proportion_mentioned_features_by_condition_by_frequency_4bins_median.pdf",width=10,height=10)
# 
# ggplot(agr, aes(x=condition,y=Probability,fill=freqMedian4bins)) +
#   #ggplot(agr, aes(x=condition,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   #geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(~Utterance) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/3_frequencyAnalysis/4bins_proportion_mentioned_features_by_feature_by_frequency_4bins_median.pdf",width=10,height=10)
# 
# 
# 
# # Analysis of the relative frequency of the sublevel and corresponding basiclevel term: RATIO FREQUENCY ANALYSIS
# 
# allAtt$typeFreqToBasiclevelFreqRatio = allAtt$relFreqType / allAtt$relFreqBasiclevel
# 
# head(allAtt$typeFreqToBasiclevelFreqRatio)
# summary(allAtt$typeFreqToBasiclevelFreqRatio)
# 
# # 2 bins
# 
# medianFreqRatio = 0.0062600
# meanFreqRatio = 0.0327200
# 
# allAtt$freqMedianRatio2bins = ifelse(allAtt$typeFreqToBasiclevelFreqRatio < medianFreqRatio, "smaller_ratio_Type/BL", "bigger_ratio_Type/BL")
# head(allAtt$freqMedianRatio2bins)
# 
# allAtt$frequency_ratio_sub_to_basic = ifelse(allAtt$typeFreqToBasiclevelFreqRatio < meanFreqRatio, "smaller_ratio_Type/BL", "bigger_ratio_Type/BL")
# head(allAtt$frequency_ratio_sub_to_basic)
# 
# # plot histogram with probabilities (median)
# 
# agr = allAtt %>%
#   select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, basiclevelClickedObj, condition, freqMedianRatio2bins) %>%
#   gather(Utterance,Mentioned,-condition, -basiclevelClickedObj, -freqMedianRatio2bins) %>%
#   group_by(Utterance,condition, basiclevelClickedObj, freqMedianRatio2bins) %>%
#   summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
# agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
# 
# dodge = position_dodge(.9)
# 
# ggplot(agr, aes(x=Utterance,y=Probability,fill=freqMedianRatio2bins)) +
#   #ggplot(agr, aes(x=Utterance,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   # geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(basiclevelClickedObj~condition) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/3_frequencyAnalysis/ratio_2bins_proportion_mentioned_features_by_condition_by_domain_by_frequencyRatio_2bins_median.pdf",width=10,height=10)
# 
# ggplot(agr, aes(x=condition,y=Probability,fill=freqMedianRatio2bins)) +
#   #ggplot(agr, aes(x=condition,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   #geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(basiclevelClickedObj~Utterance) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/3_frequencyAnalysis/ratio_2bins_proportion_mentioned_features_by_feature_by_domain_by_frequencyRatio_2bins_median.pdf",width=10,height=10)
# 
# # without domain
# 
# agr = allAtt %>%
#   select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, condition, freqMedianRatio2bins) %>%
#   gather(Utterance,Mentioned,-condition, -freqMedianRatio2bins) %>%
#   group_by(Utterance,condition, freqMedianRatio2bins) %>%
#   summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
# agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
# 
# dodge = position_dodge(.9)
# 
# ggplot(agr, aes(x=Utterance,y=Probability,fill=freqMedianRatio2bins)) +
#   #ggplot(agr, aes(x=Utterance,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   # geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(~condition) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/3_frequencyAnalysis/ratio_2bins_proportion_mentioned_features_by_condition_by_frequencyRatio_2bins_median.pdf",width=10,height=10)
# 
# ggplot(agr, aes(x=condition,y=Probability,fill=freqMedianRatio2bins)) +
#   #ggplot(agr, aes(x=condition,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   #geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(~Utterance) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/3_frequencyAnalysis/ratio_2bins_proportion_mentioned_features_by_feature_by_frequencyRatio_2bins_median.pdf",width=10,height=10)
# 
# 
# # plot histogram with probabilities (mean)
# 
# agr = allAtt %>%
#   select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, basiclevelClickedObj, condition, frequency_ratio_sub_to_basic) %>%
#   gather(Utterance,Mentioned,-condition, -basiclevelClickedObj, -frequency_ratio_sub_to_basic) %>%
#   group_by(Utterance,condition, basiclevelClickedObj, frequency_ratio_sub_to_basic) %>%
#   summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
# agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
# 
# dodge = position_dodge(.9)
# 
# ggplot(agr, aes(x=Utterance,y=Probability,fill=frequency_ratio_sub_to_basic)) +
#   #ggplot(agr, aes(x=Utterance,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   # geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(basiclevelClickedObj~condition) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/3_frequencyAnalysis/ratio_2bins_proportion_mentioned_features_by_condition_by_domain_by_frequencyRatio_2bins_mean.pdf",width=10,height=10)
# 
# ggplot(agr, aes(x=condition,y=Probability,fill=frequency_ratio_sub_to_basic)) +
#   #ggplot(agr, aes(x=condition,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   #geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(basiclevelClickedObj~Utterance) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/3_frequencyAnalysis/ratio_2bins_proportion_mentioned_features_by_feature_by_domain_by_frequencyRatio_2bins_mean.pdf",width=10,height=10)
# 
# # without domain
# 
# agr = allAtt %>%
#   select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, condition, frequency_ratio_sub_to_basic) %>%
#   gather(Utterance,Mentioned,-condition, -frequency_ratio_sub_to_basic) %>%
#   group_by(Utterance,condition, frequency_ratio_sub_to_basic) %>%
#   summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
# agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
# 
# dodge = position_dodge(.9)
# 
# ggplot(agr, aes(x=Utterance,y=Probability,fill=frequency_ratio_sub_to_basic)) +
#   #ggplot(agr, aes(x=Utterance,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   # geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(~condition) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/3_frequencyAnalysis/ratio_2bins_proportion_mentioned_features_by_condition_by_frequencyRatio_2bins_mean.pdf",width=10,height=10)
# 
# ggplot(agr, aes(x=condition,y=Probability,fill=frequency_ratio_sub_to_basic)) +
#   #ggplot(agr, aes(x=condition,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   #geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(~Utterance) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/3_frequencyAnalysis/ratio_2bins_proportion_mentioned_features_by_feature_by_frequencyRatio_2bins_mean.pdf",width=10,height=10)
# 
# 
# # Combine superclassMentioned and superclassAttributeMentioned
# allAtt$superMentioned = ifelse(allAtt$superClassMentioned | allAtt$superclassattributeMentioned, T, F)
# agr = allAtt %>%
#   select(typeMentioned,basiclevelMentioned,superMentioned, condition, frequency_ratio_sub_to_basic) %>%
#   gather(Utterance,Mentioned,-condition, -frequency_ratio_sub_to_basic) %>%
#   group_by(Utterance,condition, frequency_ratio_sub_to_basic) %>%
#   summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
# agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
# agr$UtteranceType = factor(x=ifelse(agr$Utterance == "typeMentioned","sub",ifelse(agr$Utterance == "basiclevelMentioned","basic","super")),levels=c("sub","basic","super"))
# 
# dodge = position_dodge(.9)
# 
# ggplot(agr, aes(x=condition,y=Probability,fill=frequency_ratio_sub_to_basic)) +
#   geom_bar(stat="identity",position=dodge) +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #facet_wrap(~UtteranceType) + 
#   facet_grid(~UtteranceType) + 
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/3_frequencyAnalysis/ratio_2bins_proportion_mentioned_features_by_feature_by_frequencyRatio_2bins_mean_combinedSuperCategory.pdf",width=9,height=4)
# 
# 
# 
# # 4 bins:
# 
# firstQuFreqRatio = 0.0023190
# thirdQuFreqRatio = 0.0265000
# 
# head(allAtt$relFreqType)
# summary(allAtt$relFreqType)
# 
# allAtt$freqMedianRatio4bins = ifelse(as.numeric(allAtt$typeFreqToBasiclevelFreqRatio) < firstQuFreqRatio, "01 smallest_ratio_Type/BL", 
#                                         ifelse(as.numeric(allAtt$typeFreqToBasiclevelFreqRatio) < medianFreqRatio, "02 smaller_ratio_Type/BL",
#                                                ifelse(as.numeric(allAtt$typeFreqToBasiclevelFreqRatio) < thirdQuFreqRatio,"03 bigger_ratio_Type/BL", "04 biggest_ratio_Type/BL")))
# 
# head(allAtt$freqMedianRatio4bins)
# summary(allAtt$freqMedianRatio4bins)
# 
# # plot histogram with probabilities (median)
# 
# agr = allAtt %>%
#   select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, basiclevelClickedObj, condition, freqMedianRatio4bins) %>%
#   gather(Utterance,Mentioned,-condition, -basiclevelClickedObj, -freqMedianRatio4bins) %>%
#   group_by(Utterance,condition, basiclevelClickedObj, freqMedianRatio4bins) %>%
#   summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
# agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
# 
# dodge = position_dodge(.9)
# 
# ggplot(agr, aes(x=Utterance,y=Probability,fill=freqMedianRatio4bins)) +
#   #ggplot(agr, aes(x=Utterance,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   # geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(basiclevelClickedObj~condition) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/3_frequencyAnalysis/ratio_4bins_proportion_mentioned_features_by_condition_by_domain_by_frequencyRatio_4bins_median.pdf",width=10,height=10)
# 
# ggplot(agr, aes(x=condition,y=Probability,fill=freqMedianRatio4bins)) +
#   #ggplot(agr, aes(x=condition,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   #geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(basiclevelClickedObj~Utterance) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/3_frequencyAnalysis/ratio_4bins_proportion_mentioned_features_by_feature_by_domain_by_frequencyRatio_4bins_median.pdf",width=10,height=10)
# 
# # without domain
# 
# agr = allAtt %>%
#   select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, condition, freqMedianRatio4bins) %>%
#   gather(Utterance,Mentioned,-condition, -freqMedianRatio4bins) %>%
#   group_by(Utterance,condition, freqMedianRatio4bins) %>%
#   summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
# agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
# 
# dodge = position_dodge(.9)
# 
# ggplot(agr, aes(x=Utterance,y=Probability,fill=freqMedianRatio4bins)) +
#   #ggplot(agr, aes(x=Utterance,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   # geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(~condition) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/3_frequencyAnalysis/ratio_4bins_proportion_mentioned_features_by_condition_by_frequencyRatio_4bins_median.pdf",width=10,height=10)
# 
# ggplot(agr, aes(x=condition,y=Probability,fill=freqMedianRatio4bins)) +
#   #ggplot(agr, aes(x=condition,y=Probability)) +
#   #dodge = position_dodge(.9) +
#   geom_bar(stat="identity",position=dodge) +
#   #geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(~Utterance) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/3_frequencyAnalysis/ratio_4bins_proportion_mentioned_features_by_feature_by_frequencyRatio_4bins_median.pdf",width=10,height=10)
# 
# 
# ######## ANALYSIS OF LENGTH AND FREQUENCY -- JUDITH'S CODE
# 
# # length
# allAtt$TypeLength = nchar(as.character(allAtt$nameClickedObj))
# allAtt$BasicLevelLength = nchar(as.character(allAtt$basiclevelClickedObj))
# allAtt$SuperLength = nchar(as.character(allAtt$superdomainClickedObj))
# allAtt$logTypeLength = log(allAtt$TypeLength)
# allAtt$logBasicLevelLength = log(allAtt$BasicLevelLength)
# allAtt$logSuperLength = log(allAtt$SuperLength)
# 
# un = unique(allAtt[,c("nameClickedObj","basiclevelClickedObj","superdomainClickedObj","TypeLength","BasicLevelLength","SuperLength","logTypeLength","logBasicLevelLength","logSuperLength")])
# nrow(un)
# head(un)
# 
# # absolute lengths
# gathered = un %>%
#   select(TypeLength,BasicLevelLength,SuperLength) %>%
#   gather(Label,Length)
# gathered$Label = gsub("Length","",gathered$Label)
# head(gathered)
# ggplot(gathered, aes(x=Length,fill=Label)) +
#   #geom_histogram(position="dodge")
#   geom_density(alpha=.5)
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/length_histogram.pdf")
# 
# gathered = un %>%
#   select(TypeLength,BasicLevelLength,SuperLength,nameClickedObj) %>%
#   gather(Label,Length,-nameClickedObj)
# gathered$Label = gsub("Length","",gathered$Label)
# gathered$LabelType = factor(x=gathered$Label,levels=c("Type","BasicLevel","Super"))
# head(gathered)
# ggplot(gathered, aes(x=LabelType,y=Length,fill=LabelType)) +
#   geom_bar(stat="identity") +
#   facet_wrap(~nameClickedObj) +
#   theme(axis.text.x=element_text(angle=45,hjust=1,vjust=1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/by-item-lengths.pdf",height=12,width=15)
# 
# # log lengths
# gathered = un %>%
#   select(logTypeLength,logBasicLevelLength,logSuperLength) %>%
#   gather(Label,logLength)
# gathered$Label = gsub("Length","",gathered$Label)
# gathered$Label = gsub("log","",gathered$Label)
# head(gathered)
# ggplot(gathered, aes(x=logLength,fill=Label)) +
#   #geom_histogram(position="dodge")
#   geom_density(alpha=.5)
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/loglength_density.pdf")
# 
# gathered = un %>%
#   select(logTypeLength,logBasicLevelLength,logSuperLength,nameClickedObj) %>%
#   gather(Label,logLength,-nameClickedObj)
# gathered$Label = gsub("Length","",gathered$Label)
# gathered$Label = gsub("log","",gathered$Label)
# gathered$LabelType = factor(x=gathered$Label,levels=c("Type","BasicLevel","Super"))
# head(gathered)
# ggplot(gathered, aes(x=LabelType,y=logLength,fill=LabelType)) +
#   geom_bar(stat="identity") +
#   facet_wrap(~nameClickedObj) +
#   theme(axis.text.x=element_text(angle=45,hjust=1,vjust=1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/by-item-loglengths.pdf",height=12,width=15)
# 
# 
# # frequency
# allAtt$TypeFreq = allAtt$relFreqType
# allAtt$BasicLevelFreq = allAtt$relFreqBasiclevel
# allAtt$SuperFreq = allAtt$relFreqSuperdomain
# 
# allAtt$logTypeFreq = log(allAtt$relFreqType)
# allAtt$logBasicLevelFreq = log(allAtt$relFreqBasiclevel)
# allAtt$logSuperFreq = log(allAtt$relFreqSuperdomain)
# 
# un = unique(allAtt[,c("nameClickedObj","basiclevelClickedObj","superdomainClickedObj","TypeFreq","BasicLevelFreq","SuperFreq","logTypeFreq","logBasicLevelFreq","logSuperFreq")])
# nrow(un)
# head(un)
# 
# gathered = un %>%
#   select(TypeFreq,BasicLevelFreq,SuperFreq) %>%
#   gather(Label,Freq)
# gathered$Label = gsub("Freq","",gathered$Label)
# head(gathered)
# ggplot(gathered, aes(x=Freq,fill=Label)) +
#   #geom_histogram(position="dodge")
#   geom_density(alpha=.5) +
#   scale_x_continuous(limits=c(0,0.00008))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/freq_density.pdf")
# 
# gathered = un %>%
#   select(TypeFreq,BasicLevelFreq,SuperFreq,nameClickedObj) %>%
#   gather(Label,Freq,-nameClickedObj)
# gathered$Label = gsub("Freq","",gathered$Label)
# gathered$LabelType = factor(x=gathered$Label,levels=c("Type","BasicLevel","Super"))
# head(gathered)
# ggplot(gathered, aes(x=LabelType,y=Freq,fill=LabelType)) +
#   geom_bar(stat="identity") +
#   facet_wrap(~nameClickedObj) +
#   theme(axis.text.x=element_text(angle=45,hjust=1,vjust=1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/by-item-freqs.pdf",height=12,width=15)
# 
# # log rel. freq instead of absolute rel. freq
# gathered = un %>%
#   select(logTypeFreq,logBasicLevelFreq,logSuperFreq) %>%
#   gather(Label,logFreq)
# #gathered$Label = gsub("logFreq","",gathered$Label)
# head(gathered)
# ggplot(gathered, aes(x=logFreq,fill=Label)) +
#   #geom_histogram(position="dodge")
#   geom_density(alpha=.5) 
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/logfreq_density.pdf")
# 
# gathered = un %>%
#   select(logTypeFreq,logBasicLevelFreq,logSuperFreq,nameClickedObj) %>%
#   gather(Label,logFreq,-nameClickedObj)
# #gathered$Label = gsub("logFreq","",gathered$Label)
# #gathered$LabelType = factor(x=gathered$Label,levels=c("Type","BasicLevel","Super"))
# head(gathered)
# ggplot(gathered, aes(x=Label,y=logFreq,fill=Label)) +
#   geom_bar(stat="identity") +
#   facet_wrap(~nameClickedObj) +
#   theme(axis.text.x=element_text(angle=45,hjust=1,vjust=1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/by-item-logfreqs.pdf",height=12,width=15)
# 
# 
# #### MIXED EFFECTS MODEL ANALYSIS FOR TYPE MENTION
# 
# centered = cbind(allAtt, myCenter(allAtt[,c("TypeLength","BasicLevelLength","SuperLength","logTypeLength","logBasicLevelLength","logSuperLength","TypeFreq","BasicLevelFreq","SuperFreq","logTypeFreq","logBasicLevelFreq","logSuperFreq")]))
# 
# #contrasts(allAtt$condition) = cbind(c(1,0,0,0),c(0,0,1,0),c(0,0,0,1))
# contrasts(centered$condition) = cbind("12.vs.rest"=c(3/4,-1/4,-1/4,-1/4),"22.vs.3"=c(0,2/3,-1/3,-1/3),"23.vs.33"=c(0,0,1/2,-1/2))
# 
# m = glmer(typeMentioned ~ condition * clogTypeLength * clogTypeFreq + (1 + clogTypeFreq|gameid) + (1|basiclevelClickedObj), family="binomial",data=centered)
# summary(m)
# 
# # collapse across non-12 conditions
# allAtt$redCondition = as.factor(ifelse(allAtt$condition == "distr12","type_forced","type_not_forced"))
# table(allAtt$redCondition)
# centered = cbind(allAtt, myCenter(allAtt[,c("TypeLength","BasicLevelLength","SuperLength","logTypeLength","logBasicLevelLength","logSuperLength","TypeFreq","BasicLevelFreq","SuperFreq","logTypeFreq","logBasicLevelFreq","logSuperFreq","redCondition")]))
# 
# m = glmer(typeMentioned ~ credCondition * clogTypeLength * clogTypeFreq + (1+credCondition|gameid) + (1|basiclevelClickedObj), family="binomial",data=centered)
# summary(m)
# 
# # analyze only non-12 conditions
# non12 = droplevels(subset(allAtt, condition != "distr12"))
# centered = cbind(non12, myCenter(non12[,c("TypeLength","BasicLevelLength","SuperLength","logTypeLength","logBasicLevelLength","logSuperLength","TypeFreq","BasicLevelFreq","SuperFreq","logTypeFreq","logBasicLevelFreq","logSuperFreq")]))
# 
# m = glmer(typeMentioned ~ clogTypeLength * clogTypeFreq + (1 + clogTypeLength|gameid) + (1 + clogTypeLength|basiclevelClickedObj), family="binomial",data=centered)
# summary(m)
# 
# m = glmer(typeMentioned ~ clogTypeLength * clogTypeFreq + (1 |gameid) + (1 + clogTypeFreq|basiclevelClickedObj), family="binomial",data=centered)
# summary(m)
# 
# # for all random effects structures that allow the model to converge, the interaction between frequency and length is significant at (at most) <.01
# #allAtt$cutlogTypeLength = cut(allAtt$logTypeLength,breaks=quantile(allAtt$logTypeLength,probs=c(0,.5,1)))
# allAtt$binnedlogTypeLength = cut_number(allAtt$logTypeLength,2,labels=c("short","long"))
# allAtt$binnedlogTypeFreq = cut_number(allAtt$logTypeFreq,2,labels=c("low-frequency","high-frequency"))
# summary(allAtt)
# 
# agr = allAtt %>%
#   select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, redCondition, binnedlogTypeLength, binnedlogTypeFreq) %>%
#   gather(Utterance,Mentioned,-redCondition, -binnedlogTypeLength, -binnedlogTypeFreq) %>%
#   group_by(Utterance,redCondition, binnedlogTypeLength, binnedlogTypeFreq) %>%
#   summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
# agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
# summary(agr)
# dodge = position_dodge(.9)
# 
# ggplot(agr, aes(x=redCondition,y=Probability,fill=binnedlogTypeLength)) +
#   geom_bar(stat="identity",position=dodge) +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   facet_grid(binnedlogTypeFreq~Utterance) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/4_length-frequency-interaction/freq-length-interaction.pdf",height=10,width=15)
# 
# agr = allAtt %>%
#   select(typeMentioned, redCondition, binnedlogTypeLength, binnedlogTypeFreq) %>%
#   group_by(redCondition, binnedlogTypeLength, binnedlogTypeFreq) %>%
#   summarise(Probability=mean(typeMentioned),ci.low=ci.low(typeMentioned),ci.high=ci.high(typeMentioned))
# agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
# summary(agr)
# dodge = position_dodge(.9)
# 
# ggplot(agr, aes(x=binnedlogTypeFreq,y=Probability,fill=binnedlogTypeLength)) +
#   geom_bar(stat="identity",position=dodge) +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   facet_wrap(~redCondition) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/4_length-frequency-interaction/freq-length-interaction-bycond.pdf",height=5,width=9)
# 
# #allAtt$binnedlogTypeLength = cut_number(allAtt$logTypeLength,3,labels=c("short","mid","long"))
# #allAtt$binnedlogTypeFreq = cut_number(allAtt$logTypeFreq,3,labels=c("low-frequency","mid-frequency","high-frequency"))
# summary(allAtt[,c("binnedlogTypeLength","binnedlogTypeFreq")])
# table(allAtt$binnedlogTypeLength,allAtt$binnedlogTypeFreq)
# 
# agr = allAtt %>%
#   select(typeMentioned, binnedlogTypeLength, binnedlogTypeFreq) %>%
#   group_by(binnedlogTypeLength, binnedlogTypeFreq) %>%
#   summarise(Probability=mean(typeMentioned),ci.low=ci.low(typeMentioned),ci.high=ci.high(typeMentioned))
# agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
# summary(agr)
# dodge = position_dodge(.9)
# 
# ggplot(agr, aes(x=binnedlogTypeFreq,y=Probability,fill=binnedlogTypeLength)) +
#   geom_bar(stat="identity",position=dodge) +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   scale_y_continuous(name="Probability of type mention") +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/allAtt/4_length-frequency-interaction/freq-length-interaction-noconds.pdf",height=5,width=9)


#############################################################################################################
####################################### Graphs 2: NoAtts####################################################
############################################################################################################

# Graphs 2: Include no attributes: (only mentions of sub/basic/super LEVEL, or attributes)

allAttr = read.table(file="data/allAttr.csv",sep=",", header=T, quote="")
head(allAttr)
summary(allAttr)

noAtt = droplevels(allAttr[allAttr$noLevelMentioned != "x",])

head(noAtt)
nrow(noAtt)
print(paste("percentage of excluded trials because no level was mentioned: ", (dRows -nrow(noAtt))*100/dRows))

write.csv(noAtt, file = "noAttr.csv")

# Graphs with no-attribute data: 

agr = noAtt %>%
  select(typeMentioned,basiclevelMentioned,superClassMentioned, condition) %>%
=======

#setwd("C:\\Users\\Caroline\\Desktop\\overinformativeness\\experiments\\4_numdistractors_basiclevel_newitems\\results")
#setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/4_numdistractors_basiclevel_newitems/results")
source("rscripts/helpers.R")

#load("data/r.RData")
d = read.table(file="data/results_modified.csv",sep=",", header=T, quote="")
d$Half = as.factor(ifelse(d$roundNum < 37, "first","second"))
d$Quarter = as.factor(ifelse(d$roundNum < 19, "first",ifelse(d$roundNum < 37,"second", ifelse(d$roundNum < 55, "third","fourth"))))
head(d)
nrow(d)
#d$speakerMessages
summary(d)
d[is.na(d$typeMentioned),]$typeMentioned = FALSE
d[is.na(d$otherFeatureMentioned),]$otherFeatureMentioned = FALSE
d[is.na(d$basiclevelMentioned),]$basiclevelMentioned = FALSE
d[is.na(d$superClassMentioned),]$superClassMentioned = FALSE
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

# first figure out how often target was chosen and exclude trials where it wasn't
table(d$condition,d$targetStatusClickedObj)
prop.table(table(d$condition,d$targetStatusClickedObj),mar=c(1)) # it appears that in the size-only condition, there's twice as many distractor choices (13% vs 7%)
#chisq.test(table(d$condition,d$targetStatusClickedObj))

# how many unique pairs?
length(levels(d$gameid)) # 28

# Only look at basiclevel conditions: distr12, distr22, distr23, distr33:

#basiclevel data:
bd = droplevels(subset(d, condition == "distr12" | condition == "distr22" | condition == "distr23" | condition == "distr33"))
head(bd)
nrow(bd)
summary(bd)
totalnrow = nrow(bd)

table(bd$condition,bd$typeMentioned)
table(bd$condition,bd$basiclevelMentioned)
table(bd$condition,bd$superClassMentioned)
table(bd$condition,bd$superclassattributeMentioned)

#less interesting: sizeMentioned and colorMentioned
table(bd$condition,bd$colorMentioned)
table(bd$condition,bd$sizeMentioned)
# d[d$superclassattributeMentioned == TRUE,] look at which superclassatributes people used

# drop incorrect trials:
bdCorrect = droplevels(bd[!is.na(bd$targetStatusClickedObj) & bd$targetStatusClickedObj != "distrClass1" & bd$targetStatusClickedObj != "distrClass2",])
head(bdCorrect)
print(paste("percentage of excluded trials because distractor was chosen: ", (totalnrow -nrow(bdCorrect))*100/totalnrow))

#targets = droplevels(subset(d, condition != "filler"))
#nrow(targets) # 319 cases
agr = bdCorrect %>%
  select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, condition) %>%
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
  gather(Feature,Mentioned,-condition)
agr$Feature = gsub("Mentioned","",as.character(agr$Feature))
agr = droplevels(subset(agr,Mentioned == "TRUE"))
head(agr)

# plot histogram of mentioned features by condition
ggplot(agr, aes(x=Feature)) +
  #geom_histogram() +
  stat_count() +
  facet_wrap(~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/0_frequencyMentionedFeatured/frequency_mentioned_features_by_condition.pdf",width=8,height=10)

# plot histogram with probabilities

agr = noAtt %>%
  select(typeMentioned,basiclevelMentioned,superClassMentioned, condition) %>%
=======
ggsave("graphs_basiclevel/0_frequencyMentionedFeatured/frequency_mentioned_features_by_condition.pdf",width=8,height=10)

# targets$UtteranceType = as.factor(ifelse(targets$sizeMentioned & targets$colorMentioned, "size and color", ifelse(targets$sizeMentioned, "size", ifelse(targets$colorMentioned, "color","OTHER"))))
# targets = droplevels(targets[!is.na(targets$UtteranceType),])
# targets[targets$UtteranceType == "OTHER",c("gameid","refExp")]
# table(targets[targets$UtteranceType == "OTHER",]$gameid)
# targets$Color = ifelse(targets$UtteranceType == "color",1,0)
# targets$Size = ifelse(targets$UtteranceType == "size",1,0)
# targets$SizeAndColor = ifelse(targets$UtteranceType == "size and color",1,0)
# targets$Other = ifelse(targets$UtteranceType == "OTHER",1,0)

# plot histogram with probabilities

agr = bdCorrect %>%
  select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, condition) %>%
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
  gather(Utterance,Mentioned,-condition) %>%
  group_by(Utterance,condition) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
<<<<<<< HEAD
agr$UtteranceType = factor(x=ifelse(agr$Utterance == "typeMentioned","sub",ifelse(agr$Utterance == "basiclevelMentioned","basic","super")),levels=c("sub","basic","super"))

ggplot(agr, aes(x=UtteranceType,y=Probability)) +
=======

ggplot(agr, aes(x=Utterance,y=Probability)) +
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~condition) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/1_proportionMentionedFeatures/proportion_mentioned_features_by_condition.pdf",width=10,height=10)
=======
ggsave("graphs_basiclevel/1_proportionMentionedFeatures/proportion_mentioned_features_by_condition.pdf",width=10,height=10)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e

ggplot(agr, aes(x=condition,y=Probability)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
<<<<<<< HEAD
  facet_wrap(~UtteranceType) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/1_proportionMentionedFeatures/proportion_mentioned_features_by_feature.pdf",width=10,height=10)

# agr = noAtt %>%
#   select(typeMentioned,basiclevelMentioned,superClassMentioned, condition) %>%
#   gather(Utterance,Mentioned,-condition) %>%
#   group_by(Utterance,condition) %>%
#   summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
# agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
# agr$UtteranceType = factor(x=ifelse(agr$Utterance == "typeMentioned","sub",ifelse(agr$Utterance == "basiclevelMentioned","basic","super")),levels=c("sub","basic","super"))
# 
# ggplot(agr, aes(x=condition,y=Probability)) +
#   geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_wrap(~UtteranceType) + 
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/1_proportionMentionedFeatures/proportion_mentioned_features_by_feature_combinedSuperCategory.pdf",width=9,height=4)
=======
  facet_wrap(~Utterance) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/1_proportionMentionedFeatures/proportion_mentioned_features_by_feature.pdf",width=10,height=10)

bdCorrect$superMentioned = ifelse(bdCorrect$superClassMentioned | bdCorrect$superclassattributeMentioned, T, F)
agr = bdCorrect %>%
  select(typeMentioned,basiclevelMentioned,superMentioned, condition) %>%
  gather(Utterance,Mentioned,-condition) %>%
  group_by(Utterance,condition) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
agr$UtteranceType = factor(x=ifelse(agr$Utterance == "typeMentioned","sub",ifelse(agr$Utterance == "basiclevelMentioned","basic","super")),levels=c("sub","basic","super"))

ggplot(agr, aes(x=condition,y=Probability)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~UtteranceType) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/1_proportionMentionedFeatures/proportion_mentioned_features_by_feature_combinedSuperCategory.pdf",width=9,height=4)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e


# We want to include the domain:

#Get rid of domain == NA

<<<<<<< HEAD
noAtt = droplevels(noAtt[!is.na(noAtt$basiclevelClickedObj),])
summary(noAtt)

agr = noAtt %>%
  select(typeMentioned,basiclevelMentioned,superClassMentioned, basiclevelClickedObj, condition) %>%
=======
bdCorrect = droplevels(bdCorrect[!is.na(bdCorrect$basiclevelClickedObj),])
summary(bdCorrect)

agr = bdCorrect %>%
  select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, basiclevelClickedObj, condition) %>%
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
  gather(Feature,Mentioned,-condition, -basiclevelClickedObj)
agr$Feature = gsub("Mentioned","",as.character(agr$Feature))
agr = droplevels(subset(agr,Mentioned == "TRUE"))
head(agr)
summary(agr)

# plot histogram of mentioned features by condition
ggplot(agr, aes(x=Feature)) +
  #geom_histogram() +
  stat_count() +
  facet_grid(basiclevelClickedObj~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
#facet_wrap(~condition)
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/0_frequencyMentionedFeatured/frequency_mentioned_features_by_condition_by_domain.pdf",width=8,height=10)

# plot histogram with probabilities

agr = noAtt %>%
  select(typeMentioned,basiclevelMentioned,superClassMentioned, basiclevelClickedObj, condition) %>%
=======
  #facet_wrap(~condition)
ggsave("graphs_basiclevel/0_frequencyMentionedFeatured/frequency_mentioned_features_by_condition_by_domain.pdf",width=8,height=10)

# plot histogram with probabilities

agr = bdCorrect %>%
  select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, basiclevelClickedObj, condition) %>%
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
  gather(Utterance,Mentioned,-condition, -basiclevelClickedObj) %>%
  group_by(Utterance,condition, basiclevelClickedObj) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
<<<<<<< HEAD
agr$UtteranceType = factor(x=ifelse(agr$Utterance == "typeMentioned","sub",ifelse(agr$Utterance == "basiclevelMentioned","basic","super")),levels=c("sub","basic","super"))


ggplot(agr, aes(x=UtteranceType,y=Probability)) +
=======

ggplot(agr, aes(x=Utterance,y=Probability)) +
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(basiclevelClickedObj~condition) +
  #facet_wrap(~condition) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/1_proportionMentionedFeatures/proportion_mentioned_features_by_condition_by_domain.pdf",width=10,height=10)
=======
ggsave("graphs_basiclevel/1_proportionMentionedFeatures/proportion_mentioned_features_by_condition_by_domain.pdf",width=10,height=10)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e

ggplot(agr, aes(x=condition,y=Probability)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
<<<<<<< HEAD
  facet_grid(basiclevelClickedObj~UtteranceType) +
  #facet_wrap(~Utterance) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/1_proportionMentionedFeatures/proportion_mentioned_features_by_feature_by_domain.pdf",width=10,height=10)

=======
  facet_grid(basiclevelClickedObj~Utterance) +
  #facet_wrap(~Utterance) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/1_proportionMentionedFeatures/proportion_mentioned_features_by_feature_by_domain.pdf",width=10,height=10)

# # Analysis including incorrect trials:
# 
# agr = bd %>%
#   select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, condition) %>%
#   gather(Feature,Mentioned,-condition)
# agr$Feature = gsub("Mentioned","",as.character(agr$Feature))
# agr = droplevels(subset(agr,Mentioned == "TRUE"))
# head(agr)
# 
# # plot histogram of mentioned features by condition
# ggplot(agr, aes(x=Feature)) +
#   geom_histogram() +
#   facet_wrap(~condition) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/round1/all_frequency_mentioned_features_by_condition.pdf",width=8,height=10)
# 
# # plot histogram with probabilities
# 
# agr = bd %>%
#   select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, condition) %>%
#   gather(Utterance,Mentioned,-condition) %>%
#   group_by(Utterance,condition) %>%
#   summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
# agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
# 
# ggplot(agr, aes(x=Utterance,y=Probability)) +
#   geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_wrap(~condition) + 
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/round1/all_proportion_mentioned_features_by_condition.pdf",width=10,height=10)
# 
# ggplot(agr, aes(x=condition,y=Probability)) +
#   geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_wrap(~Utterance) + 
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/round1/all_proportion_mentioned_features_by_feature.pdf",width=10,height=10)
# 
# # We want to include the domain:
# #!!!! I don't know if this makes sense, in incorrect trials the domain of the clicked obj is not the domain of the target
# 
# # Since we're including incorrect trials, the domain value may be NA.
# # Exclude domain=NAs
# nrow(bd)
# bdNew = droplevels(bd[!is.na(bd$basiclevelClickedObj),])
# head(bdNew)
# summary(bdNew)
# nrow(bdNew)
# 
# agr = bdNew %>%
#   select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, basiclevelClickedObj, condition) %>%
#   gather(Feature,Mentioned,-condition, -basiclevelClickedObj)
# agr$Feature = gsub("Mentioned","",as.character(agr$Feature))
# agr = droplevels(subset(agr,Mentioned == "TRUE"))
# head(agr)
# summary(agr)
# 
# # plot histogram of mentioned features by condition
# ggplot(agr, aes(x=Feature)) +
#   geom_histogram() +
#   facet_grid(basiclevelClickedObj~condition) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# #facet_wrap(~condition)
# ggsave("graphs_basiclevel/round1/all_frequency_mentioned_features_by_condition_by_domain.pdf",width=8,height=10)
# 
# # plot histogram with probabilities
# 
# agr = bdNew %>%
#   select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, basiclevelClickedObj, condition) %>%
#   gather(Utterance,Mentioned,-condition, -basiclevelClickedObj) %>%
#   group_by(Utterance,condition, basiclevelClickedObj) %>%
#   summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
# agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
# 
# ggplot(agr, aes(x=Utterance,y=Probability)) +
#   geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(basiclevelClickedObj~condition) +
#   #facet_wrap(~condition) + 
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/round1/all_proportion_mentioned_features_by_condition_by_domain.pdf",width=10,height=10)
# 
# ggplot(agr, aes(x=condition,y=Probability)) +
#   geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_grid(basiclevelClickedObj~Utterance) +
#   #facet_wrap(~Utterance) + 
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/round1/all_proportion_mentioned_features_by_feature_by_domain.pdf",width=10,height=10)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e

######################################################################################

# Analysis of word length effect: (only for correct trials!)

#Add new variable which encodes relative word length (shorter or longer) of type class to superclass
<<<<<<< HEAD
noAtt$typeLength = nchar(as.character(noAtt$nameClickedObj))
head(noAtt$typeLength)
noAtt$basiclevelLength = nchar(as.character(noAtt$basiclevelClickedObj))
head(noAtt$basiclevelLength)

noAtt$TypeShorter = ifelse(noAtt$typeLength < noAtt$basiclevelLength, "type_shorter_than_BL","type_longer_than_BL")

# plot histogram with probabilities RELATIVE LENGTH TYPE/BL

agr = noAtt %>%
=======
bdCorrect$typeLength = nchar(as.character(bdCorrect$nameClickedObj))
head(bdCorrect$typeLength)
bdCorrect$basiclevelLength = nchar(as.character(bdCorrect$basiclevelClickedObj))
head(bdCorrect$basiclevelLength)

bdCorrect$TypeShorter = ifelse(bdCorrect$typeLength < bdCorrect$basiclevelLength, "type_shorter_than_BL","type_longer_than_BL")

# plot histogram with probabilities RELATIVE LENGTH TYPE/BL

agr = bdCorrect %>%
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
  select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, basiclevelClickedObj, condition, TypeShorter) %>%
  gather(Utterance,Mentioned,-condition, -basiclevelClickedObj, -TypeShorter) %>%
  group_by(Utterance,condition, basiclevelClickedObj, TypeShorter) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

dodge = position_dodge(.9)

ggplot(agr, aes(x=Utterance,y=Probability,fill=TypeShorter)) +
<<<<<<< HEAD
  #ggplot(agr, aes(x=Utterance,y=Probability)) +
=======
#ggplot(agr, aes(x=Utterance,y=Probability)) +
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  # geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(basiclevelClickedObj~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/2_lengthAnalysis/proportion_mentioned_features_by_condition_by_domain_by_length.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability,fill=TypeShorter)) +
  #ggplot(agr, aes(x=condition,y=Probability)) +
=======
ggsave("graphs_basiclevel/2_lengthAnalysis/proportion_mentioned_features_by_condition_by_domain_by_length.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability,fill=TypeShorter)) +
#ggplot(agr, aes(x=condition,y=Probability)) +
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(basiclevelClickedObj~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/2_lengthAnalysis/proportion_mentioned_features_by_feature_by_domain_by_length.pdf",width=10,height=10)

# same analysis with length bins: 

head(noAtt$typeLength)
=======
ggsave("graphs_basiclevel/2_lengthAnalysis/proportion_mentioned_features_by_feature_by_domain_by_length.pdf",width=10,height=10)

# same analysis with length bins: 

head(bdCorrect$typeLength)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e

# 2 bins

#What's the medium word length?
<<<<<<< HEAD
summary(noAtt$typeLength)
# mean = 8.229, median = 9

noAtt$typeNumOfChar2bins = ifelse(noAtt$typeLength < 9, "01-08", "9+" )

head(noAtt$typeNumOfChar2bins)
head(noAtt)

# plot histogram with probabilities

agr = noAtt %>%
=======
summary(bdCorrect$typeLength)
# mean = 8.229, median = 9

bdCorrect$typeNumOfChar2bins = ifelse(bdCorrect$typeLength < 9, "01-08", "9+" )

head(bdCorrect$typeNumOfChar2bins)
head(bdCorrect)

# plot histogram with probabilities

agr = bdCorrect %>%
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
  select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, basiclevelClickedObj, condition, typeNumOfChar2bins) %>%
  gather(Utterance,Mentioned,-condition, -basiclevelClickedObj, -typeNumOfChar2bins) %>%
  group_by(Utterance,condition, basiclevelClickedObj, typeNumOfChar2bins) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

dodge = position_dodge(.9)

ggplot(agr, aes(x=Utterance,y=Probability,fill=typeNumOfChar2bins)) +
  #ggplot(agr, aes(x=Utterance,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  # geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(basiclevelClickedObj~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/2_lengthAnalysis/2bins_proportion_mentioned_features_by_condition_by_domain_by_length_2bins.pdf",width=10,height=10)
=======
ggsave("graphs_basiclevel/2_lengthAnalysis/2bins_proportion_mentioned_features_by_condition_by_domain_by_length_2bins.pdf",width=10,height=10)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e

ggplot(agr, aes(x=condition,y=Probability,fill=typeNumOfChar2bins)) +
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(basiclevelClickedObj~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/2_lengthAnalysis/2bins_proportion_mentioned_features_by_feature_by_domain_by_length_2bins.pdf",width=10,height=10)

# 2 bins without domain: 

agr = noAtt %>%
=======
ggsave("graphs_basiclevel/2_lengthAnalysis/2bins_proportion_mentioned_features_by_feature_by_domain_by_length_2bins.pdf",width=10,height=10)

# 2 bins without domain: 

agr = bdCorrect %>%
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
  select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, condition, typeNumOfChar2bins) %>%
  gather(Utterance,Mentioned,-condition, -typeNumOfChar2bins) %>%
  group_by(Utterance,condition, typeNumOfChar2bins) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

dodge = position_dodge(.9)

ggplot(agr, aes(x=Utterance,y=Probability,fill=typeNumOfChar2bins)) +
  #ggplot(agr, aes(x=Utterance,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  # geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/2_lengthAnalysis/2bins_proportion_mentioned_features_by_condition_by_length_2bins.pdf",width=10,height=10)

noAtt$superMentioned = ifelse(noAtt$superClassMentioned | noAtt$superclassattributeMentioned, T, F)
agr = noAtt %>%
=======
ggsave("graphs_basiclevel/2_lengthAnalysis/2bins_proportion_mentioned_features_by_condition_by_length_2bins.pdf",width=10,height=10)

bdCorrect$superMentioned = ifelse(bdCorrect$superClassMentioned | bdCorrect$superclassattributeMentioned, T, F)
agr = bdCorrect %>%
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
  select(typeMentioned,basiclevelMentioned,superMentioned, condition, typeNumOfChar2bins) %>%
  gather(Utterance,Mentioned,-condition, -typeNumOfChar2bins) %>%
  group_by(Utterance,condition, typeNumOfChar2bins) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
agr$UtteranceType = factor(x=ifelse(agr$Utterance == "typeMentioned","sub",ifelse(agr$Utterance == "basiclevelMentioned","basic","super")),levels=c("sub","basic","super"))

dodge = position_dodge(.9)

ggplot(agr, aes(x=condition,y=Probability,fill=typeNumOfChar2bins)) +
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(~UtteranceType) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/2_lengthAnalysis/2bins_proportion_mentioned_features_by_feature_by_length_2bins.pdf",width=10,height=4)
=======
ggsave("graphs_basiclevel/2_lengthAnalysis/2bins_proportion_mentioned_features_by_feature_by_length_2bins.pdf",width=10,height=4)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e


# 4 bins

<<<<<<< HEAD
noAtt$typeNumOfChar4bins = ifelse(noAtt$typeLength < 4, "01-03",
                                   ifelse((noAtt$typeLength < 7 & noAtt$typeLength > 3), "04-06", 
                                          ifelse((noAtt$typeLength < 10 & noAtt$typeLength > 6), "07-09", "10+" )))

head(noAtt$typeNumOfChar4bins)
head(noAtt)

# plot histogram with probabilities

agr = noAtt %>%
=======
bdCorrect$typeNumOfChar4bins = ifelse(bdCorrect$typeLength < 4, "01-03",
                                      ifelse((bdCorrect$typeLength < 7 & bdCorrect$typeLength > 3), "04-06", 
                                             ifelse((bdCorrect$typeLength < 10 & bdCorrect$typeLength > 6), "07-09", "10+" )))

head(bdCorrect$typeNumOfChar4bins)
head(bdCorrect)

# plot histogram with probabilities

agr = bdCorrect %>%
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
  select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, basiclevelClickedObj, condition, typeNumOfChar4bins) %>%
  gather(Utterance,Mentioned,-condition, -basiclevelClickedObj, -typeNumOfChar4bins) %>%
  group_by(Utterance,condition, basiclevelClickedObj, typeNumOfChar4bins) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

dodge = position_dodge(.9)

ggplot(agr, aes(x=Utterance,y=Probability,fill=typeNumOfChar4bins)) +
  #ggplot(agr, aes(x=Utterance,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  # geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(basiclevelClickedObj~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/2_lengthAnalysis/4bins_proportion_mentioned_features_by_condition_by_domain_by_length_4bins.pdf",width=10,height=10)
=======
ggsave("graphs_basiclevel/2_lengthAnalysis/4bins_proportion_mentioned_features_by_condition_by_domain_by_length_4bins.pdf",width=10,height=10)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e

ggplot(agr, aes(x=condition,y=Probability,fill=typeNumOfChar4bins)) +
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(basiclevelClickedObj~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/2_lengthAnalysis/4bins_proportion_mentioned_features_by_feature_by_domain_by_length_4bins.pdf",width=10,height=10)

# 4 bins without domain

agr = noAtt %>%
=======
ggsave("graphs_basiclevel/2_lengthAnalysis/4bins_proportion_mentioned_features_by_feature_by_domain_by_length_4bins.pdf",width=10,height=10)

# 4 bins without domain

agr = bdCorrect %>%
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
  select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, condition, typeNumOfChar4bins) %>%
  gather(Utterance,Mentioned,-condition, -typeNumOfChar4bins) %>%
  group_by(Utterance,condition, typeNumOfChar4bins) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

dodge = position_dodge(.9)

ggplot(agr, aes(x=Utterance,y=Probability,fill=typeNumOfChar4bins)) +
  #ggplot(agr, aes(x=Utterance,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  # geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/2_lengthAnalysis/4bins_proportion_mentioned_features_by_condition_by_length_4bins.pdf",width=10,height=10)
=======
ggsave("graphs_basiclevel/2_lengthAnalysis/4bins_proportion_mentioned_features_by_condition_by_length_4bins.pdf",width=10,height=10)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e

ggplot(agr, aes(x=condition,y=Probability,fill=typeNumOfChar4bins)) +
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/2_lengthAnalysis/4bins_proportion_mentioned_features_by_feature_by_length_4bins.pdf",width=10,height=10)
=======
ggsave("graphs_basiclevel/2_lengthAnalysis/4bins_proportion_mentioned_features_by_feature_by_length_4bins.pdf",width=10,height=10)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e



# 6 bins:


<<<<<<< HEAD
noAtt$typeNumOfChar6bins = ifelse(noAtt$typeLength < 4, "01-03",
                                   ifelse((noAtt$typeLength < 6 & noAtt$typeLength > 3), "04-05", 
                                          ifelse((noAtt$typeLength < 8 & noAtt$typeLength > 5), "06-07", 
                                                 ifelse((noAtt$typeLength < 10 & noAtt$typeLength > 7), "08-09",  
                                                        ifelse((noAtt$typeLength < 12 & noAtt$typeLength > 9), "10-11", "12+" )))))

head(noAtt$typeNumOfChar6bins)
head(noAtt)

# plot histogram with probabilities

agr = noAtt %>%
=======
bdCorrect$typeNumOfChar6bins = ifelse(bdCorrect$typeLength < 4, "01-03",
                                 ifelse((bdCorrect$typeLength < 6 & bdCorrect$typeLength > 3), "04-05", 
                                        ifelse((bdCorrect$typeLength < 8 & bdCorrect$typeLength > 5), "06-07", 
                                               ifelse((bdCorrect$typeLength < 10 & bdCorrect$typeLength > 7), "08-09",  
                                                      ifelse((bdCorrect$typeLength < 12 & bdCorrect$typeLength > 9), "10-11", "12+" )))))

head(bdCorrect$typeNumOfChar6bins)
head(bdCorrect)

# plot histogram with probabilities

agr = bdCorrect %>%
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
  select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, basiclevelClickedObj, condition, typeNumOfChar6bins) %>%
  gather(Utterance,Mentioned,-condition, -basiclevelClickedObj, -typeNumOfChar6bins) %>%
  group_by(Utterance,condition, basiclevelClickedObj, typeNumOfChar6bins) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

dodge = position_dodge(.9)

ggplot(agr, aes(x=Utterance,y=Probability,fill=typeNumOfChar6bins)) +
  #ggplot(agr, aes(x=Utterance,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  # geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(basiclevelClickedObj~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/2_lengthAnalysis/6bins_proportion_mentioned_features_by_condition_by_domain_by_length_6bins.pdf",width=10,height=10)
=======
ggsave("graphs_basiclevel/2_lengthAnalysis/6bins_proportion_mentioned_features_by_condition_by_domain_by_length_6bins.pdf",width=10,height=10)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e

ggplot(agr, aes(x=condition,y=Probability,fill=typeNumOfChar6bins)) +
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(basiclevelClickedObj~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/2_lengthAnalysis/6bins_proportion_mentioned_features_by_feature_by_domain_by_length_6bins.pdf",width=10,height=10)
=======
ggsave("graphs_basiclevel/2_lengthAnalysis/6bins_proportion_mentioned_features_by_feature_by_domain_by_length_6bins.pdf",width=10,height=10)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e


# 6 bins without domain

<<<<<<< HEAD
agr = noAtt %>%
=======
agr = bdCorrect %>%
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
  select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, condition, typeNumOfChar6bins) %>%
  gather(Utterance,Mentioned,-condition, -typeNumOfChar6bins) %>%
  group_by(Utterance,condition, typeNumOfChar6bins) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

dodge = position_dodge(.9)

ggplot(agr, aes(x=Utterance,y=Probability,fill=typeNumOfChar6bins)) +
  #ggplot(agr, aes(x=Utterance,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  # geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/2_lengthAnalysis/6bins_proportion_mentioned_features_by_condition_by_length_6bins.pdf",width=10,height=10)
=======
ggsave("graphs_basiclevel/2_lengthAnalysis/6bins_proportion_mentioned_features_by_condition_by_length_6bins.pdf",width=10,height=10)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e

ggplot(agr, aes(x=condition,y=Probability,fill=typeNumOfChar6bins)) +
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/2_lengthAnalysis/6bins_proportion_mentioned_features_by_feature_by_length_6bins.pdf",width=10,height=10)
=======
ggsave("graphs_basiclevel/2_lengthAnalysis/6bins_proportion_mentioned_features_by_feature_by_length_6bins.pdf",width=10,height=10)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e


# 8 bins:


<<<<<<< HEAD
noAtt$typeNumOfChar8bins = ifelse(noAtt$typeLength < 4, "01-03",
                                   ifelse((noAtt$typeLength < 6 & noAtt$typeLength > 3), "04-05", 
                                          ifelse((noAtt$typeLength < 8 & noAtt$typeLength > 5), "06-07", 
                                                 ifelse((noAtt$typeLength < 10 & noAtt$typeLength > 7), "08-09", 
                                                        ifelse((noAtt$typeLength < 12 & noAtt$typeLength > 9), "10-11", 
                                                               ifelse((noAtt$typeLength < 14 & noAtt$typeLength > 11), "12-13", 
                                                                      ifelse((noAtt$typeLength < 16 & noAtt$typeLength > 13), "14-15", "16+" )))))))

head(noAtt$typeNumOfChar8bins)
head(noAtt)

# plot histogram with probabilities

agr = noAtt %>%
=======
bdCorrect$typeNumOfChar8bins = ifelse(bdCorrect$typeLength < 4, "01-03",
                                      ifelse((bdCorrect$typeLength < 6 & bdCorrect$typeLength > 3), "04-05", 
                                             ifelse((bdCorrect$typeLength < 8 & bdCorrect$typeLength > 5), "06-07", 
                                                    ifelse((bdCorrect$typeLength < 10 & bdCorrect$typeLength > 7), "08-09", 
                                                           ifelse((bdCorrect$typeLength < 12 & bdCorrect$typeLength > 9), "10-11", 
                                                                  ifelse((bdCorrect$typeLength < 14 & bdCorrect$typeLength > 11), "12-13", 
                                                                         ifelse((bdCorrect$typeLength < 16 & bdCorrect$typeLength > 13), "14-15", "16+" )))))))

head(bdCorrect$typeNumOfChar8bins)
head(bdCorrect)

# plot histogram with probabilities

agr = bdCorrect %>%
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
  select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, basiclevelClickedObj, condition, typeNumOfChar8bins) %>%
  gather(Utterance,Mentioned,-condition, -basiclevelClickedObj, -typeNumOfChar8bins) %>%
  group_by(Utterance,condition, basiclevelClickedObj, typeNumOfChar8bins) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

dodge = position_dodge(.9)

ggplot(agr, aes(x=Utterance,y=Probability,fill=typeNumOfChar8bins)) +
  #ggplot(agr, aes(x=Utterance,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  # geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(basiclevelClickedObj~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/2_lengthAnalysis/8bins_proportion_mentioned_features_by_condition_by_domain_by_length_8bins.pdf",width=10,height=10)
=======
ggsave("graphs_basiclevel/2_lengthAnalysis/8bins_proportion_mentioned_features_by_condition_by_domain_by_length_8bins.pdf",width=10,height=10)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e

ggplot(agr, aes(x=condition,y=Probability,fill=typeNumOfChar8bins)) +
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(basiclevelClickedObj~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/2_lengthAnalysis/8bins_proportion_mentioned_features_by_feature_by_domain_by_length_8bins.pdf",width=10,height=10)

# 8 bins without domain:

agr = noAtt %>%
=======
ggsave("graphs_basiclevel/2_lengthAnalysis/8bins_proportion_mentioned_features_by_feature_by_domain_by_length_8bins.pdf",width=10,height=10)

# 8 bins without domain:

agr = bdCorrect %>%
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
  select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, condition, typeNumOfChar8bins) %>%
  gather(Utterance,Mentioned,-condition, -typeNumOfChar8bins) %>%
  group_by(Utterance,condition, typeNumOfChar8bins) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

dodge = position_dodge(.9)

ggplot(agr, aes(x=Utterance,y=Probability,fill=typeNumOfChar8bins)) +
  #ggplot(agr, aes(x=Utterance,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  # geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/2_lengthAnalysis/8bins_proportion_mentioned_features_by_condition_by_length_8bins.pdf",width=10,height=10)
=======
ggsave("graphs_basiclevel/2_lengthAnalysis/8bins_proportion_mentioned_features_by_condition_by_length_8bins.pdf",width=10,height=10)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e

ggplot(agr, aes(x=condition,y=Probability,fill=typeNumOfChar8bins)) +
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/2_lengthAnalysis/8bins_proportion_mentioned_features_by_feature_by_length_8bins.pdf",width=10,height=10)
=======
ggsave("graphs_basiclevel/2_lengthAnalysis/8bins_proportion_mentioned_features_by_feature_by_length_8bins.pdf",width=10,height=10)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e




# exclude contracted utterances and see if it makes a difference 

# 2 bins

<<<<<<< HEAD
bdCorrectNoContractions = droplevels(noAtt[noAtt$utteranceContracted != TRUE,])
=======
bdCorrectNoContractions = droplevels(bdCorrect[bdCorrect$utteranceContracted != TRUE,])
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
head(bdCorrectNoContractions)
nrow(bdCorrectNoContractions)

#What's the medium word length?
<<<<<<< HEAD
summary(noAtt$typeLength)
=======
summary(bdCorrect$typeLength)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
# mean = 8.229, median = 9

bdCorrectNoContractions$typeNumOfChar2bins = ifelse(bdCorrectNoContractions$typeLength < 9, "01-08", "9+" )

head(bdCorrectNoContractions$typeNumOfChar2bins)
head(bdCorrectNoContractions)

# plot histogram with probabilities

agr = bdCorrectNoContractions %>%
  select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, basiclevelClickedObj, condition, typeNumOfChar2bins) %>%
  gather(Utterance,Mentioned,-condition, -basiclevelClickedObj, -typeNumOfChar2bins) %>%
  group_by(Utterance,condition, basiclevelClickedObj, typeNumOfChar2bins) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

dodge = position_dodge(.9)

ggplot(agr, aes(x=Utterance,y=Probability,fill=typeNumOfChar2bins)) +
  #ggplot(agr, aes(x=Utterance,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  # geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(basiclevelClickedObj~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/2_lengthAnalysis/nonContr_2bins_proportion_mentioned_features_by_condition_by_domain_by_length_2bins.pdf",width=10,height=10)
=======
ggsave("graphs_basiclevel/2_lengthAnalysis/nonContr_2bins_proportion_mentioned_features_by_condition_by_domain_by_length_2bins.pdf",width=10,height=10)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e

ggplot(agr, aes(x=condition,y=Probability,fill=typeNumOfChar2bins)) +
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(basiclevelClickedObj~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/2_lengthAnalysis/nonContr_2bins_proportion_mentioned_features_by_feature_by_domain_by_length_2bins_NoContractions.pdf",width=10,height=10)
=======
ggsave("graphs_basiclevel/2_lengthAnalysis/nonContr_2bins_proportion_mentioned_features_by_feature_by_domain_by_length_2bins_NoContractions.pdf",width=10,height=10)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e





# Ratio length analyses:

# new variable for ratio:

<<<<<<< HEAD
noAtt$typeBasiclevelLengthRatio = noAtt$typeLength / noAtt$basiclevelLength
head(noAtt$typeBasiclevelLengthRatio)
summary(noAtt$typeBasiclevelLengthRatio)
=======
bdCorrect$typeBasiclevelLengthRatio = bdCorrect$typeLength / bdCorrect$basiclevelLength
head(bdCorrect$typeBasiclevelLengthRatio)
summary(bdCorrect$typeBasiclevelLengthRatio)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e

lengthRatioMedian = 2
lengthRatioMean = 1.9890

# 2 bins analysis MEDIAN

<<<<<<< HEAD
noAtt$lengthRatio2bins = ifelse(noAtt$typeBasiclevelLengthRatio < lengthRatioMedian, "smaller_typeBLRatio", "bigger_typeBLRatio" )

head(noAtt$lengthRatio2bins)

# plot histogram with probabilities

agr = noAtt %>%
=======
bdCorrect$lengthRatio2bins = ifelse(bdCorrect$typeBasiclevelLengthRatio < lengthRatioMedian, "smaller_typeBLRatio", "bigger_typeBLRatio" )

head(bdCorrect$lengthRatio2bins)

# plot histogram with probabilities

agr = bdCorrect %>%
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
  select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, basiclevelClickedObj, condition, lengthRatio2bins) %>%
  gather(Utterance,Mentioned,-condition, -basiclevelClickedObj, -lengthRatio2bins) %>%
  group_by(Utterance,condition, basiclevelClickedObj, lengthRatio2bins) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

dodge = position_dodge(.9)

ggplot(agr, aes(x=Utterance,y=Probability,fill=lengthRatio2bins)) +
  #ggplot(agr, aes(x=Utterance,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  # geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(basiclevelClickedObj~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/2_lengthAnalysis/ratio_2bins_proportion_mentioned_features_by_condition_by_domain_by_length_2bins.pdf",width=10,height=10)
=======
ggsave("graphs_basiclevel/2_lengthAnalysis/ratio_2bins_proportion_mentioned_features_by_condition_by_domain_by_length_2bins.pdf",width=10,height=10)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e

ggplot(agr, aes(x=condition,y=Probability,fill=lengthRatio2bins)) +
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(basiclevelClickedObj~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/2_lengthAnalysis/ratio_2bins_proportion_mentioned_features_by_feature_by_domain_by_length_2bins.pdf",width=10,height=10)
=======
ggsave("graphs_basiclevel/2_lengthAnalysis/ratio_2bins_proportion_mentioned_features_by_feature_by_domain_by_length_2bins.pdf",width=10,height=10)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e


# ratio2bins without domain:

<<<<<<< HEAD
agr = noAtt %>%
=======
agr = bdCorrect %>%
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
  select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, condition, lengthRatio2bins) %>%
  gather(Utterance,Mentioned,-condition, -lengthRatio2bins) %>%
  group_by(Utterance,condition, lengthRatio2bins) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

dodge = position_dodge(.9)

ggplot(agr, aes(x=Utterance,y=Probability,fill=lengthRatio2bins)) +
  #ggplot(agr, aes(x=Utterance,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  # geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/2_lengthAnalysis/ratio_2bins_proportion_mentioned_features_by_condition_by_length_2bins.pdf",width=10,height=10)
=======
ggsave("graphs_basiclevel/2_lengthAnalysis/ratio_2bins_proportion_mentioned_features_by_condition_by_length_2bins.pdf",width=10,height=10)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e

ggplot(agr, aes(x=condition,y=Probability,fill=lengthRatio2bins)) +
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/2_lengthAnalysis/ratio_2bins_proportion_mentioned_features_by_feature_by_length_2bins.pdf",width=10,height=10)

# Combine superclassMentioned and superclassAttributeMentioned
#noAtt$superMentioned = ifelse(noAtt$superClassMentioned | noAtt$superclassattributeMentioned, T, F)
agr = noAtt %>%
  select(typeMentioned,basiclevelMentioned,superClassMentioned, condition, lengthRatio2bins) %>%
=======
ggsave("graphs_basiclevel/2_lengthAnalysis/ratio_2bins_proportion_mentioned_features_by_feature_by_length_2bins.pdf",width=10,height=10)

# Combine superclassMentioned and superclassAttributeMentioned
bdCorrect$superMentioned = ifelse(bdCorrect$superClassMentioned | bdCorrect$superclassattributeMentioned, T, F)
agr = bdCorrect %>%
  select(typeMentioned,basiclevelMentioned,superMentioned, condition, lengthRatio2bins) %>%
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
  gather(Utterance,Mentioned,-condition, -lengthRatio2bins) %>%
  group_by(Utterance,condition, lengthRatio2bins) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
agr$UtteranceType = factor(x=ifelse(agr$Utterance == "typeMentioned","sub",ifelse(agr$Utterance == "basiclevelMentioned","basic","super")),levels=c("sub","basic","super"))

dodge = position_dodge(.9)

ggplot(agr, aes(x=condition,y=Probability,fill=lengthRatio2bins)) +
  geom_bar(stat="identity",position=dodge) +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #facet_wrap(~UtteranceType) + 
  facet_grid(~UtteranceType) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/2_lengthAnalysis/ratio_2bins_proportion_mentioned_features_by_feature_by_length_combinedSuperCategory.pdf",width=9,height=4)
=======
ggsave("graphs_basiclevel/2_lengthAnalysis/ratio_2bins_proportion_mentioned_features_by_feature_by_length_combinedSuperCategory.pdf",width=9,height=4)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e


# 4 bins analysis

<<<<<<< HEAD
summary(noAtt$typeBasiclevelLengthRatio)
=======
summary(bdCorrect$typeBasiclevelLengthRatio)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e

lengthRatio1stQu = 1.5
lengthRatio3rdQu = 2.25

<<<<<<< HEAD
noAtt$lengthRatio4bins = ifelse(noAtt$typeBasiclevelLengthRatio < lengthRatio1stQu, "01_smallest_typeBLRatio", 
                                 ifelse(noAtt$typeBasiclevelLengthRatio < lengthRatioMedian, "02_smaller_typeBLRatio", 
                                        ifelse(noAtt$typeBasiclevelLengthRatio < lengthRatio3rdQu, "03_bigger_typeBLRatio", "04_biggest_typeBLRatio" )))

head(noAtt$lengthRatio4bins)

# plot histogram with probabilities

agr = noAtt %>%
=======
bdCorrect$lengthRatio4bins = ifelse(bdCorrect$typeBasiclevelLengthRatio < lengthRatio1stQu, "01_smallest_typeBLRatio", 
                                    ifelse(bdCorrect$typeBasiclevelLengthRatio < lengthRatioMedian, "02_smaller_typeBLRatio", 
                                           ifelse(bdCorrect$typeBasiclevelLengthRatio < lengthRatio3rdQu, "03_bigger_typeBLRatio", "04_biggest_typeBLRatio" )))

head(bdCorrect$lengthRatio4bins)

# plot histogram with probabilities

agr = bdCorrect %>%
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
  select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, basiclevelClickedObj, condition, lengthRatio4bins) %>%
  gather(Utterance,Mentioned,-condition, -basiclevelClickedObj, -lengthRatio4bins) %>%
  group_by(Utterance,condition, basiclevelClickedObj, lengthRatio4bins) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

dodge = position_dodge(.9)

ggplot(agr, aes(x=Utterance,y=Probability,fill=lengthRatio4bins)) +
  #ggplot(agr, aes(x=Utterance,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  # geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(basiclevelClickedObj~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/2_lengthAnalysis/ratio_4bins_proportion_mentioned_features_by_condition_by_domain_by_length_4bins.pdf",width=10,height=10)
=======
ggsave("graphs_basiclevel/2_lengthAnalysis/ratio_4bins_proportion_mentioned_features_by_condition_by_domain_by_length_4bins.pdf",width=10,height=10)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e

ggplot(agr, aes(x=condition,y=Probability,fill=lengthRatio4bins)) +
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(basiclevelClickedObj~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/2_lengthAnalysis/ratio_4bins_proportion_mentioned_features_by_feature_by_domain_by_length_4bins.pdf",width=10,height=10)
=======
ggsave("graphs_basiclevel/2_lengthAnalysis/ratio_4bins_proportion_mentioned_features_by_feature_by_domain_by_length_4bins.pdf",width=10,height=10)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e


# ratio4bins without domain:

<<<<<<< HEAD
agr = noAtt %>%
=======
agr = bdCorrect %>%
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
  select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, condition, lengthRatio4bins) %>%
  gather(Utterance,Mentioned,-condition, -lengthRatio4bins) %>%
  group_by(Utterance,condition, lengthRatio4bins) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

dodge = position_dodge(.9)

ggplot(agr, aes(x=Utterance,y=Probability,fill=lengthRatio4bins)) +
  #ggplot(agr, aes(x=Utterance,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  # geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/2_lengthAnalysis/ratio_4bins_proportion_mentioned_features_by_condition_by_length_4bins.pdf",width=10,height=10)
=======
ggsave("graphs_basiclevel/2_lengthAnalysis/ratio_4bins_proportion_mentioned_features_by_condition_by_length_4bins.pdf",width=10,height=10)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e

ggplot(agr, aes(x=condition,y=Probability,fill=lengthRatio4bins)) +
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/2_lengthAnalysis/ratio_4bins_proportion_mentioned_features_by_feature_by_length_4bins.pdf",width=10,height=10)

# Combine superclassMentioned and superclassAttributeMentioned
noAtt$superMentioned = ifelse(noAtt$superClassMentioned | noAtt$superclassattributeMentioned, T, F)
agr = noAtt %>%
=======
ggsave("graphs_basiclevel/2_lengthAnalysis/ratio_4bins_proportion_mentioned_features_by_feature_by_length_4bins.pdf",width=10,height=10)

# Combine superclassMentioned and superclassAttributeMentioned
bdCorrect$superMentioned = ifelse(bdCorrect$superClassMentioned | bdCorrect$superclassattributeMentioned, T, F)
agr = bdCorrect %>%
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
  select(typeMentioned,basiclevelMentioned,superMentioned, condition, lengthRatio4bins) %>%
  gather(Utterance,Mentioned,-condition, -lengthRatio4bins) %>%
  group_by(Utterance,condition, lengthRatio4bins) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
agr$UtteranceType = factor(x=ifelse(agr$Utterance == "typeMentioned","sub",ifelse(agr$Utterance == "basiclevelMentioned","basic","super")),levels=c("sub","basic","super"))

dodge = position_dodge(.9)

ggplot(agr, aes(x=condition,y=Probability,fill=lengthRatio4bins)) +
  geom_bar(stat="identity",position=dodge) +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #facet_wrap(~UtteranceType) + 
  facet_grid(~UtteranceType) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/2_lengthAnalysis/ratio_4bins_proportion_mentioned_features_by_feature_by_length_combinedSuperCategory.pdf",width=9,height=4)
=======
ggsave("graphs_basiclevel/2_lengthAnalysis/ratio_4bins_proportion_mentioned_features_by_feature_by_length_combinedSuperCategory.pdf",width=9,height=4)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e



# MEAN length ratio ANALYSIS:

# 2 bins analysis

<<<<<<< HEAD
noAtt$length_ratio_sub_to_basic = ifelse(noAtt$typeBasiclevelLengthRatio < lengthRatioMean, "smaller than mean length ratio", "bigger than mean length ratio" )

head(noAtt$length_ratio_sub_to_basic)

# plot histogram with probabilities

agr = noAtt %>%
  select(typeMentioned,basiclevelMentioned,superClassMentioned, basiclevelClickedObj, condition, length_ratio_sub_to_basic) %>%
  gather(Utterance,Mentioned,-condition, -basiclevelClickedObj, -length_ratio_sub_to_basic) %>%
  group_by(Utterance,condition, basiclevelClickedObj, length_ratio_sub_to_basic) %>%
=======
bdCorrect$lengthRatio2binsMean = ifelse(bdCorrect$typeBasiclevelLengthRatio < lengthRatioMean, "smaller_typeBLRatio", "bigger_typeBLRatio" )

head(bdCorrect$lengthRatio2binsMean)

# plot histogram with probabilities

agr = bdCorrect %>%
  select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, basiclevelClickedObj, condition, lengthRatio2binsMean) %>%
  gather(Utterance,Mentioned,-condition, -basiclevelClickedObj, -lengthRatio2binsMean) %>%
  group_by(Utterance,condition, basiclevelClickedObj, lengthRatio2binsMean) %>%
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
<<<<<<< HEAD
agr$UtteranceType = factor(x=ifelse(agr$Utterance == "typeMentioned","sub",ifelse(agr$Utterance == "basiclevelMentioned","basic","super")),levels=c("sub","basic","super"))


dodge = position_dodge(.9)

ggplot(agr, aes(x=UtteranceType,y=Probability,fill=length_ratio_sub_to_basic)) +
=======

dodge = position_dodge(.9)

ggplot(agr, aes(x=Utterance,y=Probability,fill=lengthRatio2binsMean)) +
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
  #ggplot(agr, aes(x=Utterance,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  # geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(basiclevelClickedObj~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/2_lengthAnalysis/ratio_2bins_proportion_mentioned_features_by_condition_by_domain_by_length_2bins_Mean.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability,fill=length_ratio_sub_to_basic)) +
=======
ggsave("graphs_basiclevel/2_lengthAnalysis/ratio_2bins_proportion_mentioned_features_by_condition_by_domain_by_length_2bins_Mean.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability,fill=lengthRatio2binsMean)) +
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
<<<<<<< HEAD
  facet_grid(basiclevelClickedObj~UtteranceType) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/2_lengthAnalysis/ratio_2bins_proportion_mentioned_features_by_feature_by_domain_by_length_2bins_Mean.pdf",width=10,height=10)
=======
  facet_grid(basiclevelClickedObj~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/2_lengthAnalysis/ratio_2bins_proportion_mentioned_features_by_feature_by_domain_by_length_2bins_Mean.pdf",width=10,height=10)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e


# ratio2bins without domain:

<<<<<<< HEAD
agr = noAtt %>%
  select(typeMentioned,basiclevelMentioned,superClassMentioned, condition, length_ratio_sub_to_basic) %>%
  gather(Utterance,Mentioned,-condition, -length_ratio_sub_to_basic) %>%
  group_by(Utterance,condition, length_ratio_sub_to_basic) %>%
=======
agr = bdCorrect %>%
  select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, condition, lengthRatio2binsMean) %>%
  gather(Utterance,Mentioned,-condition, -lengthRatio2binsMean) %>%
  group_by(Utterance,condition, lengthRatio2binsMean) %>%
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
<<<<<<< HEAD
agr$UtteranceType = factor(x=ifelse(agr$Utterance == "typeMentioned","sub",ifelse(agr$Utterance == "basiclevelMentioned","basic","super")),levels=c("sub","basic","super"))


dodge = position_dodge(.9)

ggplot(agr, aes(x=UtteranceType,y=Probability,fill=length_ratio_sub_to_basic)) +
=======

dodge = position_dodge(.9)

ggplot(agr, aes(x=Utterance,y=Probability,fill=lengthRatio2binsMean)) +
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
  #ggplot(agr, aes(x=Utterance,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  # geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/2_lengthAnalysis/ratio_2bins_proportion_mentioned_features_by_condition_by_length_2bins_Mean.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability,fill=length_ratio_sub_to_basic)) +
=======
ggsave("graphs_basiclevel/2_lengthAnalysis/ratio_2bins_proportion_mentioned_features_by_condition_by_length_2bins_Mean.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability,fill=lengthRatio2binsMean)) +
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
<<<<<<< HEAD
  facet_grid(~UtteranceType) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/2_lengthAnalysis/ratio_2bins_proportion_mentioned_features_by_feature_by_length_2bins_Mean.pdf",width=10,height=10)

# # Combine superclassMentioned and superclassAttributeMentioned
# noAtt$superMentioned = ifelse(noAtt$superClassMentioned | noAtt$superclassattributeMentioned, T, F)
# agr = noAtt %>%
#   select(typeMentioned,basiclevelMentioned,superMentioned, condition, length_ratio_sub_to_basic) %>%
#   gather(Utterance,Mentioned,-condition, -length_ratio_sub_to_basic) %>%
#   group_by(Utterance,condition, length_ratio_sub_to_basic) %>%
#   summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
# agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
# agr$UtteranceType = factor(x=ifelse(agr$Utterance == "typeMentioned","sub",ifelse(agr$Utterance == "basiclevelMentioned","basic","super")),levels=c("sub","basic","super"))
# 
# dodge = position_dodge(.9)
# 
# ggplot(agr, aes(x=condition,y=Probability,fill=length_ratio_sub_to_basic)) +
#   geom_bar(stat="identity",position=dodge) +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #facet_wrap(~UtteranceType) + 
#   facet_grid(~UtteranceType) + 
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/2_lengthAnalysis/ratio_2bins_proportion_mentioned_features_by_feature_by_length_Mean_combinedSuperCategory.pdf",width=9,height=4)
=======
  facet_grid(~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/2_lengthAnalysis/ratio_2bins_proportion_mentioned_features_by_feature_by_length_2bins_Mean.pdf",width=10,height=10)

# Combine superclassMentioned and superclassAttributeMentioned
bdCorrect$superMentioned = ifelse(bdCorrect$superClassMentioned | bdCorrect$superclassattributeMentioned, T, F)
agr = bdCorrect %>%
  select(typeMentioned,basiclevelMentioned,superMentioned, condition, lengthRatio2binsMean) %>%
  gather(Utterance,Mentioned,-condition, -lengthRatio2binsMean) %>%
  group_by(Utterance,condition, lengthRatio2binsMean) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
agr$UtteranceType = factor(x=ifelse(agr$Utterance == "typeMentioned","sub",ifelse(agr$Utterance == "basiclevelMentioned","basic","super")),levels=c("sub","basic","super"))

dodge = position_dodge(.9)

ggplot(agr, aes(x=condition,y=Probability,fill=lengthRatio2binsMean)) +
  geom_bar(stat="identity",position=dodge) +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #facet_wrap(~UtteranceType) + 
  facet_grid(~UtteranceType) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/2_lengthAnalysis/ratio_2bins_proportion_mentioned_features_by_feature_by_length_Mean_combinedSuperCategory.pdf",width=9,height=4)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e






####################################################################################

# Frequency analysis (only for correct trials!)

#load("data/r.RData")    (frequenciesAll)
frequencies = read.table(file="data/frequencyChart.csv",sep=",", header=T, quote="")

head(frequencies)
summary(frequencies)

# frequenciesType = droplevels(subset(frequencies, noun != "animal" & noun != "bear" & noun != "bird" & noun != "candy" & noun != "car" & noun != "clothing" & noun != "dog" & noun != "fish" & noun != "flower" & noun != "furniture" & noun != "plant" & noun != "shirt" & noun != "snack" & noun != "table" & noun != "vehicle"))
# 
# head(frequenciesType)
# summary(frequenciesType)

<<<<<<< HEAD
#Add new variable to noAtt from frequencyChart
noAtt$relFreqType = ifelse(noAtt$nameClickedObj == "bedsideTable", (subset(frequencies, noun == "bedsideTable"))$relFreq, 
                            ifelse(noAtt$nameClickedObj == "blackBear", (subset(frequencies, noun == "blackBear"))$relFreq, 
                                   ifelse(noAtt$nameClickedObj == "catfish", (subset(frequencies, noun == "catfish"))$relFreq, 
                                          ifelse(noAtt$nameClickedObj == "clownFish", (subset(frequencies, noun == "clownFish"))$relFreq, 
                                                 ifelse(noAtt$nameClickedObj == "coffeeTable", (subset(frequencies, noun == "coffeeTable"))$relFreq, 
                                                        ifelse(noAtt$nameClickedObj == "convertible", (subset(frequencies, noun == "convertible"))$relFreq, 
                                                               ifelse(noAtt$nameClickedObj == "daisy", (subset(frequencies, noun == "daisy"))$relFreq, 
                                                                      ifelse(noAtt$nameClickedObj == "dalmatian", (subset(frequencies, noun == "dalmatian"))$relFreq, 
                                                                             ifelse(noAtt$nameClickedObj == "diningTable", (subset(frequencies, noun == "diningTable"))$relFreq, 
                                                                                    ifelse(noAtt$nameClickedObj == "dressShirt", (subset(frequencies, noun == "dressShirt"))$relFreq, 
                                                                                           ifelse(noAtt$nameClickedObj == "eagle", (subset(frequencies, noun == "eagle"))$relFreq, 
                                                                                                  ifelse(noAtt$nameClickedObj == "germanShepherd", (subset(frequencies, noun == "germanShepherd"))$relFreq, 
                                                                                                         ifelse(noAtt$nameClickedObj == "goldFish", (subset(frequencies, noun == "goldFish"))$relFreq, 
                                                                                                                ifelse(noAtt$nameClickedObj == "grizzlyBear", (subset(frequencies, noun == "grizzlyBear"))$relFreq, 
                                                                                                                       ifelse(noAtt$nameClickedObj == "gummyBears", (subset(frequencies, noun == "gummyBears"))$relFreq, 
                                                                                                                              ifelse(noAtt$nameClickedObj == "hawaiiShirt", (subset(frequencies, noun == "hawaiiShirt"))$relFreq, 
                                                                                                                                     ifelse(noAtt$nameClickedObj == "hummingBird", (subset(frequencies, noun == "hummingBird"))$relFreq, 
                                                                                                                                            ifelse(noAtt$nameClickedObj == "husky", (subset(frequencies, noun == "husky"))$relFreq, 
                                                                                                                                                   ifelse(noAtt$nameClickedObj == "jellyBeans", (subset(frequencies, noun == "jellyBeans"))$relFreq, 
                                                                                                                                                          ifelse(noAtt$nameClickedObj == "mnMs", (subset(frequencies, noun == "mnMs"))$relFreq, 
                                                                                                                                                                 ifelse(noAtt$nameClickedObj == "minivan", (subset(frequencies, noun == "minivan"))$relFreq, 
                                                                                                                                                                        ifelse(noAtt$nameClickedObj == "pandaBear", (subset(frequencies, noun == "pandaBear"))$relFreq, 
                                                                                                                                                                               ifelse(noAtt$nameClickedObj == "parrot", (subset(frequencies, noun == "parrot"))$relFreq, 
                                                                                                                                                                                      ifelse(noAtt$nameClickedObj == "picnicTable", (subset(frequencies, noun == "picnicTable"))$relFreq, 
                                                                                                                                                                                             ifelse(noAtt$nameClickedObj == "pigeon", (subset(frequencies, noun == "pigeon"))$relFreq, 
                                                                                                                                                                                                    ifelse(noAtt$nameClickedObj == "polarBear", (subset(frequencies, noun == "polarBear"))$relFreq, 
                                                                                                                                                                                                           ifelse(noAtt$nameClickedObj == "poloShirt", (subset(frequencies, noun == "poloShirt"))$relFreq, 
                                                                                                                                                                                                                  ifelse(noAtt$nameClickedObj == "pug", (subset(frequencies, noun == "pug"))$relFreq, 
                                                                                                                                                                                                                         ifelse(noAtt$nameClickedObj == "rose", (subset(frequencies, noun == "rose"))$relFreq, 
                                                                                                                                                                                                                                ifelse(noAtt$nameClickedObj == "skittles", (subset(frequencies, noun == "skittles"))$relFreq, 
                                                                                                                                                                                                                                       ifelse(noAtt$nameClickedObj == "sportsCar", (subset(frequencies, noun == "sportsCar"))$relFreq, 
                                                                                                                                                                                                                                              ifelse(noAtt$nameClickedObj == "sunflower", (subset(frequencies, noun == "sunflower"))$relFreq, 
                                                                                                                                                                                                                                                     ifelse(noAtt$nameClickedObj == "suv", (subset(frequencies, noun == "suv"))$relFreq, 
                                                                                                                                                                                                                                                            ifelse(noAtt$nameClickedObj == "swordFish", (subset(frequencies, noun == "swordFish"))$relFreq, 
                                                                                                                                                                                                                                                                   ifelse(noAtt$nameClickedObj == "tShirt", (subset(frequencies, noun == "tShirt"))$relFreq, 
                                                                                                                                                                                                                                                                          ifelse(noAtt$nameClickedObj == "tulip", (subset(frequencies, noun == "tulip"))$relFreq, "NA"))))))))))))))))))))))))))))))))))))
# length of basiclevels:

noAtt$relFreqBasiclevel = ifelse(noAtt$basiclevelClickedObj == "bear", (subset(frequencies, noun == "bear"))$relFreq, 
                                  ifelse(noAtt$basiclevelClickedObj == "bird", (subset(frequencies, noun == "bird"))$relFreq, 
                                         ifelse(noAtt$basiclevelClickedObj == "candy", (subset(frequencies, noun == "candy"))$relFreq, 
                                                ifelse(noAtt$basiclevelClickedObj == "car", (subset(frequencies, noun == "car"))$relFreq, 
                                                       ifelse(noAtt$basiclevelClickedObj == "dog", (subset(frequencies, noun == "dog"))$relFreq, 
                                                              ifelse(noAtt$basiclevelClickedObj == "fish", (subset(frequencies, noun == "fish"))$relFreq, 
                                                                     ifelse(noAtt$basiclevelClickedObj == "flower", (subset(frequencies, noun == "flower"))$relFreq, 
                                                                            ifelse(noAtt$basiclevelClickedObj == "shirt", (subset(frequencies, noun == "shirt"))$relFreq,
                                                                                   ifelse(noAtt$basiclevelClickedObj == "table", (subset(frequencies, noun == "table"))$relFreq, "NA")))))))))

# length of superclasses:

noAtt$relFreqSuperdomain = ifelse(noAtt$superdomainClickedObj == "animal", (subset(frequencies, noun == "animal"))$relFreq, 
                                   ifelse(noAtt$superdomainClickedObj == "clothing", (subset(frequencies, noun == "clothing"))$relFreq, 
                                          ifelse(noAtt$superdomainClickedObj == "furniture", (subset(frequencies, noun == "furniture"))$relFreq, 
                                                 ifelse(noAtt$superdomainClickedObj == "plant", (subset(frequencies, noun == "plant"))$relFreq, 
                                                        ifelse(noAtt$superdomainClickedObj == "snack", (subset(frequencies, noun == "snack"))$relFreq, 
                                                               ifelse(noAtt$superdomainClickedObj == "vehicle", (subset(frequencies, noun == "vehicle"))$relFreq, "NA"))))))
=======
#Add new variable to bdCorrect from frequencyChart
bdCorrect$relFreqType = ifelse(bdCorrect$nameClickedObj == "bedsideTable", (subset(frequencies, noun == "bedsideTable"))$relFreq, 
                           ifelse(bdCorrect$nameClickedObj == "blackBear", (subset(frequencies, noun == "blackBear"))$relFreq, 
                                  ifelse(bdCorrect$nameClickedObj == "catfish", (subset(frequencies, noun == "catfish"))$relFreq, 
                                         ifelse(bdCorrect$nameClickedObj == "clownFish", (subset(frequencies, noun == "clownFish"))$relFreq, 
                                                ifelse(bdCorrect$nameClickedObj == "coffeeTable", (subset(frequencies, noun == "coffeeTable"))$relFreq, 
                                                       ifelse(bdCorrect$nameClickedObj == "convertible", (subset(frequencies, noun == "convertible"))$relFreq, 
                                                              ifelse(bdCorrect$nameClickedObj == "daisy", (subset(frequencies, noun == "daisy"))$relFreq, 
                                                                     ifelse(bdCorrect$nameClickedObj == "dalmatian", (subset(frequencies, noun == "dalmatian"))$relFreq, 
                                                                            ifelse(bdCorrect$nameClickedObj == "diningTable", (subset(frequencies, noun == "diningTable"))$relFreq, 
                                                                                   ifelse(bdCorrect$nameClickedObj == "dressShirt", (subset(frequencies, noun == "dressShirt"))$relFreq, 
                                                                                          ifelse(bdCorrect$nameClickedObj == "eagle", (subset(frequencies, noun == "eagle"))$relFreq, 
                                                                                                 ifelse(bdCorrect$nameClickedObj == "germanShepherd", (subset(frequencies, noun == "germanShepherd"))$relFreq, 
                                                                                                        ifelse(bdCorrect$nameClickedObj == "goldFish", (subset(frequencies, noun == "goldFish"))$relFreq, 
                                                                                                               ifelse(bdCorrect$nameClickedObj == "grizzlyBear", (subset(frequencies, noun == "grizzlyBear"))$relFreq, 
                                                                                                                      ifelse(bdCorrect$nameClickedObj == "gummyBears", (subset(frequencies, noun == "gummyBears"))$relFreq, 
                                                                                                                             ifelse(bdCorrect$nameClickedObj == "hawaiiShirt", (subset(frequencies, noun == "hawaiiShirt"))$relFreq, 
                                                                                                                                    ifelse(bdCorrect$nameClickedObj == "hummingBird", (subset(frequencies, noun == "hummingBird"))$relFreq, 
                                                                                                                                           ifelse(bdCorrect$nameClickedObj == "husky", (subset(frequencies, noun == "husky"))$relFreq, 
                                                                                                                                                  ifelse(bdCorrect$nameClickedObj == "jellyBeans", (subset(frequencies, noun == "jellyBeans"))$relFreq, 
                                                                                                                                                         ifelse(bdCorrect$nameClickedObj == "mnMs", (subset(frequencies, noun == "mnMs"))$relFreq, 
                                                                                                                                                                ifelse(bdCorrect$nameClickedObj == "minivan", (subset(frequencies, noun == "minivan"))$relFreq, 
                                                                                                                                                                       ifelse(bdCorrect$nameClickedObj == "pandaBear", (subset(frequencies, noun == "pandaBear"))$relFreq, 
                                                                                                                                                                              ifelse(bdCorrect$nameClickedObj == "parrot", (subset(frequencies, noun == "parrot"))$relFreq, 
                                                                                                                                                                                     ifelse(bdCorrect$nameClickedObj == "picnicTable", (subset(frequencies, noun == "picnicTable"))$relFreq, 
                                                                                                                                                                                            ifelse(bdCorrect$nameClickedObj == "pigeon", (subset(frequencies, noun == "pigeon"))$relFreq, 
                                                                                                                                                                                                   ifelse(bdCorrect$nameClickedObj == "polarBear", (subset(frequencies, noun == "polarBear"))$relFreq, 
                                                                                                                                                                                                          ifelse(bdCorrect$nameClickedObj == "poloShirt", (subset(frequencies, noun == "poloShirt"))$relFreq, 
                                                                                                                                                                                                                 ifelse(bdCorrect$nameClickedObj == "pug", (subset(frequencies, noun == "pug"))$relFreq, 
                                                                                                                                                                                                                        ifelse(bdCorrect$nameClickedObj == "rose", (subset(frequencies, noun == "rose"))$relFreq, 
                                                                                                                                                                                                                               ifelse(bdCorrect$nameClickedObj == "skittles", (subset(frequencies, noun == "skittles"))$relFreq, 
                                                                                                                                                                                                                                      ifelse(bdCorrect$nameClickedObj == "sportsCar", (subset(frequencies, noun == "sportsCar"))$relFreq, 
                                                                                                                                                                                                                                             ifelse(bdCorrect$nameClickedObj == "sunflower", (subset(frequencies, noun == "sunflower"))$relFreq, 
                                                                                                                                                                                                                                                    ifelse(bdCorrect$nameClickedObj == "suv", (subset(frequencies, noun == "suv"))$relFreq, 
                                                                                                                                                                                                                                                           ifelse(bdCorrect$nameClickedObj == "swordFish", (subset(frequencies, noun == "swordFish"))$relFreq, 
                                                                                                                                                                                                                                                                  ifelse(bdCorrect$nameClickedObj == "tShirt", (subset(frequencies, noun == "tShirt"))$relFreq, 
                                                                                                                                                                                                                                                                         ifelse(bdCorrect$nameClickedObj == "tulip", (subset(frequencies, noun == "tulip"))$relFreq, "NA"))))))))))))))))))))))))))))))))))))
# length of basiclevels:

bdCorrect$relFreqBasiclevel = ifelse(bdCorrect$basiclevelClickedObj == "bear", (subset(frequencies, noun == "bear"))$relFreq, 
                                     ifelse(bdCorrect$basiclevelClickedObj == "bird", (subset(frequencies, noun == "bird"))$relFreq, 
                                            ifelse(bdCorrect$basiclevelClickedObj == "candy", (subset(frequencies, noun == "candy"))$relFreq, 
                                                   ifelse(bdCorrect$basiclevelClickedObj == "car", (subset(frequencies, noun == "car"))$relFreq, 
                                                          ifelse(bdCorrect$basiclevelClickedObj == "dog", (subset(frequencies, noun == "dog"))$relFreq, 
                                                                 ifelse(bdCorrect$basiclevelClickedObj == "fish", (subset(frequencies, noun == "fish"))$relFreq, 
                                                                        ifelse(bdCorrect$basiclevelClickedObj == "flower", (subset(frequencies, noun == "flower"))$relFreq, 
                                                                               ifelse(bdCorrect$basiclevelClickedObj == "shirt", (subset(frequencies, noun == "shirt"))$relFreq,
                                                                                      ifelse(bdCorrect$basiclevelClickedObj == "table", (subset(frequencies, noun == "table"))$relFreq, "NA")))))))))
                                                                               
# length of superclasses:

bdCorrect$relFreqSuperdomain = ifelse(bdCorrect$superdomainClickedObj == "animal", (subset(frequencies, noun == "animal"))$relFreq, 
                                     ifelse(bdCorrect$superdomainClickedObj == "clothing", (subset(frequencies, noun == "clothing"))$relFreq, 
                                            ifelse(bdCorrect$superdomainClickedObj == "furniture", (subset(frequencies, noun == "furniture"))$relFreq, 
                                                   ifelse(bdCorrect$superdomainClickedObj == "plant", (subset(frequencies, noun == "plant"))$relFreq, 
                                                          ifelse(bdCorrect$superdomainClickedObj == "snack", (subset(frequencies, noun == "snack"))$relFreq, 
                                                                 ifelse(bdCorrect$superdomainClickedObj == "vehicle", (subset(frequencies, noun == "vehicle"))$relFreq, "NA"))))))
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e




# Convert to numeric:
<<<<<<< HEAD
noAtt$relFreqType = as.numeric(noAtt$relFreqType)
noAtt$relFreqBasiclevel = as.numeric(noAtt$relFreqBasiclevel)
noAtt$relFreqSuperdomain = as.numeric(noAtt$relFreqSuperdomain)


head(noAtt$relFreqType)
head(noAtt$relFreqBasiclevel)
head(noAtt$relFreqSuperdomain)


summary(noAtt$relFreqType)
summary(noAtt$relFreqBasiclevel)
summary(noAtt$relFreqSuperdomain)
=======
bdCorrect$relFreqType = as.numeric(bdCorrect$relFreqType)
bdCorrect$relFreqBasiclevel = as.numeric(bdCorrect$relFreqBasiclevel)
bdCorrect$relFreqSuperdomain = as.numeric(bdCorrect$relFreqSuperdomain)


head(bdCorrect$relFreqType)
head(bdCorrect$relFreqBasiclevel)
head(bdCorrect$relFreqSuperdomain)


summary(bdCorrect$relFreqType)
summary(bdCorrect$relFreqBasiclevel)
summary(bdCorrect$relFreqSuperdomain)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e



# same analyses with frequency bins: 

# 2 bins

<<<<<<< HEAD
summary(noAtt$relFreqType)
medianFreqType = 4.970e-07

noAtt$freqMedian2bins = ifelse(noAtt$relFreqType < medianFreqType, "less_frequent", "more_frequent")
head(noAtt$freqMedian2bins)

# plot histogram with probabilities (median)

agr = noAtt %>%
=======
summary(bdCorrect$relFreqType)
medianFreqType = 4.970e-07

bdCorrect$freqMedian2bins = ifelse(bdCorrect$relFreqType < medianFreqType, "less_frequent", "more_frequent")
head(bdCorrect$freqMedian2bins)

# plot histogram with probabilities (median)

agr = bdCorrect %>%
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
  select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, basiclevelClickedObj, condition, freqMedian2bins) %>%
  gather(Utterance,Mentioned,-condition, -basiclevelClickedObj, -freqMedian2bins) %>%
  group_by(Utterance,condition, basiclevelClickedObj, freqMedian2bins) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

dodge = position_dodge(.9)

ggplot(agr, aes(x=Utterance,y=Probability,fill=freqMedian2bins)) +
  #ggplot(agr, aes(x=Utterance,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  # geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(basiclevelClickedObj~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/3_frequencyAnalysis/2bins_proportion_mentioned_features_by_condition_by_domain_by_frequency_2bins_median.pdf",width=10,height=10)
=======
ggsave("graphs_basiclevel/3_frequencyAnalysis/2bins_proportion_mentioned_features_by_condition_by_domain_by_frequency_2bins_median.pdf",width=10,height=10)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e

ggplot(agr, aes(x=condition,y=Probability,fill=freqMedian2bins)) +
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(basiclevelClickedObj~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/3_frequencyAnalysis/2bins_proportion_mentioned_features_by_feature_by_domain_by_frequency_2bins_median.pdf",width=10,height=10)

# without domain

agr = noAtt %>%
=======
ggsave("graphs_basiclevel/3_frequencyAnalysis/2bins_proportion_mentioned_features_by_feature_by_domain_by_frequency_2bins_median.pdf",width=10,height=10)

# without domain

agr = bdCorrect %>%
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
  select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, condition, freqMedian2bins) %>%
  gather(Utterance,Mentioned,-condition, -freqMedian2bins) %>%
  group_by(Utterance,condition, freqMedian2bins) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

dodge = position_dodge(.9)

ggplot(agr, aes(x=Utterance,y=Probability,fill=freqMedian2bins)) +
  #ggplot(agr, aes(x=Utterance,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  # geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/3_frequencyAnalysis/2bins_proportion_mentioned_features_by_condition_by_frequency_2bins_median.pdf",width=10,height=10)

# CONTINUE HERE
#noAtt$superMentioned = ifelse(noAtt$superClassMentioned | noAtt$superclassattributeMentioned, T, F)
agr = noAtt %>%
=======
ggsave("graphs_basiclevel/3_frequencyAnalysis/2bins_proportion_mentioned_features_by_condition_by_frequency_2bins_median.pdf",width=10,height=10)


bdCorrect$superMentioned = ifelse(bdCorrect$superClassMentioned | bdCorrect$superclassattributeMentioned, T, F)
agr = bdCorrect %>%
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
  select(typeMentioned,basiclevelMentioned,superMentioned, condition, freqMedian2bins) %>%
  gather(Utterance,Mentioned,-condition, -freqMedian2bins) %>%
  group_by(Utterance,condition, freqMedian2bins) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

dodge = position_dodge(.9)
agr$UtteranceType = factor(x=ifelse(agr$Utterance == "typeMentioned","sub",ifelse(agr$Utterance == "basiclevelMentioned","basic","super")),levels=c("sub","basic","super"))

dodge = position_dodge(.9)

ggplot(agr, aes(x=condition,y=Probability,fill=freqMedian2bins)) +
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(~UtteranceType) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/3_frequencyAnalysis/2bins_proportion_mentioned_features_by_feature_by_frequency_2bins_median.pdf",width=10,height=4)
=======
ggsave("graphs_basiclevel/3_frequencyAnalysis/2bins_proportion_mentioned_features_by_feature_by_frequency_2bins_median.pdf",width=10,height=4)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e


# 4 bins:

<<<<<<< HEAD
summary(noAtt$relFreqType)
firstQuFreqType = 1.63e-07
thirdQuFreqType = 1.05e-06

head(noAtt$relFreqType)
summary(noAtt$relFreqType)

noAtt$freqMedian4bins = ifelse(noAtt$relFreqType < firstQuFreqType, "least_frequent", 
                                ifelse(noAtt$relFreqType < medianFreqType, "less_frequent",
                                       ifelse(noAtt$relFreqType < thirdQuFreqType,"more_frequent", "most_frequent")))

head(noAtt$freqMedian4bins)
summary(noAtt$freqMedian4bins)

# plot histogram with probabilities (median)

agr = noAtt %>%
=======
summary(bdCorrect$relFreqType)
firstQuFreqType = 1.63e-07
thirdQuFreqType = 1.05e-06

head(bdCorrect$relFreqType)
summary(bdCorrect$relFreqType)

bdCorrect$freqMedian4bins = ifelse(bdCorrect$relFreqType < firstQuFreqType, "least_frequent", 
                                         ifelse(bdCorrect$relFreqType < medianFreqType, "less_frequent",
                                                ifelse(bdCorrect$relFreqType < thirdQuFreqType,"more_frequent", "most_frequent")))

head(bdCorrect$freqMedian4bins)
summary(bdCorrect$freqMedian4bins)

# plot histogram with probabilities (median)

agr = bdCorrect %>%
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
  select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, basiclevelClickedObj, condition, freqMedian4bins) %>%
  gather(Utterance,Mentioned,-condition, -basiclevelClickedObj, -freqMedian4bins) %>%
  group_by(Utterance,condition, basiclevelClickedObj, freqMedian4bins) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

dodge = position_dodge(.9)

ggplot(agr, aes(x=Utterance,y=Probability,fill=freqMedian4bins)) +
  #ggplot(agr, aes(x=Utterance,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  # geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(basiclevelClickedObj~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/3_frequencyAnalysis/4bins_proportion_mentioned_features_by_condition_by_domain_by_frequency_4bins_median.pdf",width=10,height=10)
=======
ggsave("graphs_basiclevel/3_frequencyAnalysis/4bins_proportion_mentioned_features_by_condition_by_domain_by_frequency_4bins_median.pdf",width=10,height=10)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e

ggplot(agr, aes(x=condition,y=Probability,fill=freqMedian4bins)) +
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(basiclevelClickedObj~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/3_frequencyAnalysis/4bins_proportion_mentioned_features_by_feature_by_domain_by_frequency_4bins_median.pdf",width=10,height=10)

# without domain

agr = noAtt %>%
=======
ggsave("graphs_basiclevel/3_frequencyAnalysis/4bins_proportion_mentioned_features_by_feature_by_domain_by_frequency_4bins_median.pdf",width=10,height=10)

# without domain

agr = bdCorrect %>%
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
  select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, condition, freqMedian4bins) %>%
  gather(Utterance,Mentioned,-condition, -freqMedian4bins) %>%
  group_by(Utterance,condition, freqMedian4bins) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

dodge = position_dodge(.9)

ggplot(agr, aes(x=Utterance,y=Probability,fill=freqMedian4bins)) +
  #ggplot(agr, aes(x=Utterance,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  # geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/3_frequencyAnalysis/4bins_proportion_mentioned_features_by_condition_by_frequency_4bins_median.pdf",width=10,height=10)
=======
ggsave("graphs_basiclevel/3_frequencyAnalysis/4bins_proportion_mentioned_features_by_condition_by_frequency_4bins_median.pdf",width=10,height=10)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e

ggplot(agr, aes(x=condition,y=Probability,fill=freqMedian4bins)) +
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/3_frequencyAnalysis/4bins_proportion_mentioned_features_by_feature_by_frequency_4bins_median.pdf",width=10,height=10)
=======
ggsave("graphs_basiclevel/3_frequencyAnalysis/4bins_proportion_mentioned_features_by_feature_by_frequency_4bins_median.pdf",width=10,height=10)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e



# Analysis of the relative frequency of the sublevel and corresponding basiclevel term: RATIO FREQUENCY ANALYSIS

<<<<<<< HEAD
noAtt$typeFreqToBasiclevelFreqRatio = noAtt$relFreqType / noAtt$relFreqBasiclevel

head(noAtt$typeFreqToBasiclevelFreqRatio)
summary(noAtt$typeFreqToBasiclevelFreqRatio)
=======
bdCorrect$typeFreqToBasiclevelFreqRatio = bdCorrect$relFreqType / bdCorrect$relFreqBasiclevel

head(bdCorrect$typeFreqToBasiclevelFreqRatio)
summary(bdCorrect$typeFreqToBasiclevelFreqRatio)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e

# 2 bins

medianFreqRatio = 0.0062600
meanFreqRatio = 0.0327200

<<<<<<< HEAD
noAtt$freqMedianRatio2bins = ifelse(noAtt$typeFreqToBasiclevelFreqRatio < medianFreqRatio, "smaller_ratio_Type/BL", "bigger_ratio_Type/BL")
head(noAtt$freqMedianRatio2bins)

noAtt$frequency_ratio_sub_to_basic = ifelse(noAtt$typeFreqToBasiclevelFreqRatio < meanFreqRatio, "smaller than mean frequency ratio", "bigger than mean frequency ratio")
head(noAtt$frequency_ratio_sub_to_basic)

# plot histogram with probabilities (median)

agr = noAtt %>%
  select(typeMentioned,basiclevelMentioned,superClassMentioned, basiclevelClickedObj, condition, freqMedianRatio2bins) %>%
=======
bdCorrect$freqMedianRatio2bins = ifelse(bdCorrect$typeFreqToBasiclevelFreqRatio < medianFreqRatio, "smaller_ratio_Type/BL", "bigger_ratio_Type/BL")
head(bdCorrect$freqMedianRatio2bins)

bdCorrect$freqMeanRatio2bins = ifelse(bdCorrect$typeFreqToBasiclevelFreqRatio < meanFreqRatio, "smaller_ratio_Type/BL", "bigger_ratio_Type/BL")
head(bdCorrect$freqMeanRatio2bins)

# plot histogram with probabilities (median)

agr = bdCorrect %>%
  select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, basiclevelClickedObj, condition, freqMedianRatio2bins) %>%
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
  gather(Utterance,Mentioned,-condition, -basiclevelClickedObj, -freqMedianRatio2bins) %>%
  group_by(Utterance,condition, basiclevelClickedObj, freqMedianRatio2bins) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

dodge = position_dodge(.9)

ggplot(agr, aes(x=Utterance,y=Probability,fill=freqMedianRatio2bins)) +
  #ggplot(agr, aes(x=Utterance,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  # geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(basiclevelClickedObj~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/3_frequencyAnalysis/ratio_2bins_proportion_mentioned_features_by_condition_by_domain_by_frequencyRatio_2bins_median.pdf",width=10,height=10)
=======
ggsave("graphs_basiclevel/3_frequencyAnalysis/ratio_2bins_proportion_mentioned_features_by_condition_by_domain_by_frequencyRatio_2bins_median.pdf",width=10,height=10)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e

ggplot(agr, aes(x=condition,y=Probability,fill=freqMedianRatio2bins)) +
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(basiclevelClickedObj~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/3_frequencyAnalysis/ratio_2bins_proportion_mentioned_features_by_feature_by_domain_by_frequencyRatio_2bins_median.pdf",width=10,height=10)

# without domain

agr = noAtt %>%
=======
ggsave("graphs_basiclevel/3_frequencyAnalysis/ratio_2bins_proportion_mentioned_features_by_feature_by_domain_by_frequencyRatio_2bins_median.pdf",width=10,height=10)

# without domain

agr = bdCorrect %>%
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
  select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, condition, freqMedianRatio2bins) %>%
  gather(Utterance,Mentioned,-condition, -freqMedianRatio2bins) %>%
  group_by(Utterance,condition, freqMedianRatio2bins) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

dodge = position_dodge(.9)

ggplot(agr, aes(x=Utterance,y=Probability,fill=freqMedianRatio2bins)) +
  #ggplot(agr, aes(x=Utterance,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  # geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/3_frequencyAnalysis/ratio_2bins_proportion_mentioned_features_by_condition_by_frequencyRatio_2bins_median.pdf",width=10,height=10)
=======
ggsave("graphs_basiclevel/3_frequencyAnalysis/ratio_2bins_proportion_mentioned_features_by_condition_by_frequencyRatio_2bins_median.pdf",width=10,height=10)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e

ggplot(agr, aes(x=condition,y=Probability,fill=freqMedianRatio2bins)) +
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/3_frequencyAnalysis/ratio_2bins_proportion_mentioned_features_by_feature_by_frequencyRatio_2bins_median.pdf",width=10,height=10)
=======
ggsave("graphs_basiclevel/3_frequencyAnalysis/ratio_2bins_proportion_mentioned_features_by_feature_by_frequencyRatio_2bins_median.pdf",width=10,height=10)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e


# plot histogram with probabilities (mean)

<<<<<<< HEAD
agr = noAtt %>%
  select(typeMentioned,basiclevelMentioned,superClassMentioned, basiclevelClickedObj, condition, frequency_ratio_sub_to_basic) %>%
  gather(Utterance,Mentioned,-condition, -basiclevelClickedObj, -frequency_ratio_sub_to_basic) %>%
  group_by(Utterance,condition, basiclevelClickedObj, frequency_ratio_sub_to_basic) %>%
=======
agr = bdCorrect %>%
  select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, basiclevelClickedObj, condition, freqMeanRatio2bins) %>%
  gather(Utterance,Mentioned,-condition, -basiclevelClickedObj, -freqMeanRatio2bins) %>%
  group_by(Utterance,condition, basiclevelClickedObj, freqMeanRatio2bins) %>%
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
<<<<<<< HEAD
agr$UtteranceType = factor(x=ifelse(agr$Utterance == "typeMentioned","sub",ifelse(agr$Utterance == "basiclevelMentioned","basic","super")),levels=c("sub","basic","super"))


dodge = position_dodge(.9)

ggplot(agr, aes(x=UtteranceType,y=Probability,fill=frequency_ratio_sub_to_basic)) +
=======

dodge = position_dodge(.9)

ggplot(agr, aes(x=Utterance,y=Probability,fill=freqMeanRatio2bins)) +
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
  #ggplot(agr, aes(x=Utterance,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  # geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(basiclevelClickedObj~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/3_frequencyAnalysis/ratio_2bins_proportion_mentioned_features_by_condition_by_domain_by_frequencyRatio_2bins_mean.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability,fill=frequency_ratio_sub_to_basic)) +
=======
ggsave("graphs_basiclevel/3_frequencyAnalysis/ratio_2bins_proportion_mentioned_features_by_condition_by_domain_by_frequencyRatio_2bins_mean.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability,fill=freqMeanRatio2bins)) +
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
<<<<<<< HEAD
  facet_grid(basiclevelClickedObj~UtteranceType) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/3_frequencyAnalysis/ratio_2bins_proportion_mentioned_features_by_feature_by_domain_by_frequencyRatio_2bins_mean.pdf",width=10,height=10)

# without domain

agr = noAtt %>%
  select(typeMentioned,basiclevelMentioned,superClassMentioned, condition, frequency_ratio_sub_to_basic) %>%
  gather(Utterance,Mentioned,-condition, -frequency_ratio_sub_to_basic) %>%
  group_by(Utterance,condition, frequency_ratio_sub_to_basic) %>%
=======
  facet_grid(basiclevelClickedObj~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/3_frequencyAnalysis/ratio_2bins_proportion_mentioned_features_by_feature_by_domain_by_frequencyRatio_2bins_mean.pdf",width=10,height=10)

# without domain

agr = bdCorrect %>%
  select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, condition, freqMeanRatio2bins) %>%
  gather(Utterance,Mentioned,-condition, -freqMeanRatio2bins) %>%
  group_by(Utterance,condition, freqMeanRatio2bins) %>%
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
<<<<<<< HEAD
agr$UtteranceType = factor(x=ifelse(agr$Utterance == "typeMentioned","sub",ifelse(agr$Utterance == "basiclevelMentioned","basic","super")),levels=c("sub","basic","super"))


dodge = position_dodge(.9)

ggplot(agr, aes(x=UtteranceType,y=Probability,fill=frequency_ratio_sub_to_basic)) +
=======

dodge = position_dodge(.9)

ggplot(agr, aes(x=Utterance,y=Probability,fill=freqMeanRatio2bins)) +
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
  #ggplot(agr, aes(x=Utterance,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  # geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/3_frequencyAnalysis/ratio_2bins_proportion_mentioned_features_by_condition_by_frequencyRatio_2bins_mean.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability,fill=frequency_ratio_sub_to_basic)) +
=======
ggsave("graphs_basiclevel/3_frequencyAnalysis/ratio_2bins_proportion_mentioned_features_by_condition_by_frequencyRatio_2bins_mean.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability,fill=freqMeanRatio2bins)) +
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
<<<<<<< HEAD
  facet_grid(~UtteranceType) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/3_frequencyAnalysis/ratio_2bins_proportion_mentioned_features_by_feature_by_frequencyRatio_2bins_mean.pdf",width=10,height=10)


# # Combine superclassMentioned and superclassAttributeMentioned
# noAtt$superMentioned = ifelse(noAtt$superClassMentioned | noAtt$superclassattributeMentioned, T, F)
# agr = noAtt %>%
#   select(typeMentioned,basiclevelMentioned,superMentioned, condition, frequency_ratio_sub_to_basic) %>%
#   gather(Utterance,Mentioned,-condition, -frequency_ratio_sub_to_basic) %>%
#   group_by(Utterance,condition, frequency_ratio_sub_to_basic) %>%
#   summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
# agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
# agr$UtteranceType = factor(x=ifelse(agr$Utterance == "typeMentioned","sub",ifelse(agr$Utterance == "basiclevelMentioned","basic","super")),levels=c("sub","basic","super"))
# 
# dodge = position_dodge(.9)
# 
# ggplot(agr, aes(x=condition,y=Probability,fill=frequency_ratio_sub_to_basic)) +
#   geom_bar(stat="identity",position=dodge) +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
#   #facet_wrap(~UtteranceType) + 
#   facet_grid(~UtteranceType) + 
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/3_frequencyAnalysis/ratio_2bins_proportion_mentioned_features_by_feature_by_frequencyRatio_2bins_mean_combinedSuperCategory.pdf",width=9,height=4)
=======
  facet_grid(~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/3_frequencyAnalysis/ratio_2bins_proportion_mentioned_features_by_feature_by_frequencyRatio_2bins_mean.pdf",width=10,height=10)


# Combine superclassMentioned and superclassAttributeMentioned
bdCorrect$superMentioned = ifelse(bdCorrect$superClassMentioned | bdCorrect$superclassattributeMentioned, T, F)
agr = bdCorrect %>%
  select(typeMentioned,basiclevelMentioned,superMentioned, condition, freqMeanRatio2bins) %>%
  gather(Utterance,Mentioned,-condition, -freqMeanRatio2bins) %>%
  group_by(Utterance,condition, freqMeanRatio2bins) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
agr$UtteranceType = factor(x=ifelse(agr$Utterance == "typeMentioned","sub",ifelse(agr$Utterance == "basiclevelMentioned","basic","super")),levels=c("sub","basic","super"))

dodge = position_dodge(.9)

ggplot(agr, aes(x=condition,y=Probability,fill=freqMeanRatio2bins)) +
  geom_bar(stat="identity",position=dodge) +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #facet_wrap(~UtteranceType) + 
  facet_grid(~UtteranceType) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/3_frequencyAnalysis/ratio_2bins_proportion_mentioned_features_by_feature_by_frequencyRatio_2bins_mean_combinedSuperCategory.pdf",width=9,height=4)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e



# 4 bins:

firstQuFreqRatio = 0.0023190
thirdQuFreqRatio = 0.0265000

<<<<<<< HEAD
head(noAtt$relFreqType)
summary(noAtt$relFreqType)

noAtt$freqMedianRatio4bins = ifelse(as.numeric(noAtt$typeFreqToBasiclevelFreqRatio) < firstQuFreqRatio, "01 smallest_ratio_Type/BL", 
                                     ifelse(as.numeric(noAtt$typeFreqToBasiclevelFreqRatio) < medianFreqRatio, "02 smaller_ratio_Type/BL",
                                            ifelse(as.numeric(noAtt$typeFreqToBasiclevelFreqRatio) < thirdQuFreqRatio,"03 bigger_ratio_Type/BL", "04 biggest_ratio_Type/BL")))

head(noAtt$freqMedianRatio4bins)
summary(noAtt$freqMedianRatio4bins)

# plot histogram with probabilities (median)

agr = noAtt %>%
=======
head(bdCorrect$relFreqType)
summary(bdCorrect$relFreqType)

bdCorrect$freqMedianRatio4bins = ifelse(as.numeric(bdCorrect$typeFreqToBasiclevelFreqRatio) < firstQuFreqRatio, "01 smallest_ratio_Type/BL", 
                                        ifelse(as.numeric(bdCorrect$typeFreqToBasiclevelFreqRatio) < medianFreqRatio, "02 smaller_ratio_Type/BL",
                                               ifelse(as.numeric(bdCorrect$typeFreqToBasiclevelFreqRatio) < thirdQuFreqRatio,"03 bigger_ratio_Type/BL", "04 biggest_ratio_Type/BL")))

head(bdCorrect$freqMedianRatio4bins)
summary(bdCorrect$freqMedianRatio4bins)

# plot histogram with probabilities (median)

agr = bdCorrect %>%
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
  select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, basiclevelClickedObj, condition, freqMedianRatio4bins) %>%
  gather(Utterance,Mentioned,-condition, -basiclevelClickedObj, -freqMedianRatio4bins) %>%
  group_by(Utterance,condition, basiclevelClickedObj, freqMedianRatio4bins) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

dodge = position_dodge(.9)

ggplot(agr, aes(x=Utterance,y=Probability,fill=freqMedianRatio4bins)) +
  #ggplot(agr, aes(x=Utterance,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  # geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(basiclevelClickedObj~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/3_frequencyAnalysis/ratio_4bins_proportion_mentioned_features_by_condition_by_domain_by_frequencyRatio_4bins_median.pdf",width=10,height=10)
=======
ggsave("graphs_basiclevel/3_frequencyAnalysis/ratio_4bins_proportion_mentioned_features_by_condition_by_domain_by_frequencyRatio_4bins_median.pdf",width=10,height=10)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e

ggplot(agr, aes(x=condition,y=Probability,fill=freqMedianRatio4bins)) +
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(basiclevelClickedObj~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/3_frequencyAnalysis/ratio_4bins_proportion_mentioned_features_by_feature_by_domain_by_frequencyRatio_4bins_median.pdf",width=10,height=10)

# without domain

agr = noAtt %>%
=======
ggsave("graphs_basiclevel/3_frequencyAnalysis/ratio_4bins_proportion_mentioned_features_by_feature_by_domain_by_frequencyRatio_4bins_median.pdf",width=10,height=10)

# without domain

agr = bdCorrect %>%
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
  select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, condition, freqMedianRatio4bins) %>%
  gather(Utterance,Mentioned,-condition, -freqMedianRatio4bins) %>%
  group_by(Utterance,condition, freqMedianRatio4bins) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

dodge = position_dodge(.9)

ggplot(agr, aes(x=Utterance,y=Probability,fill=freqMedianRatio4bins)) +
  #ggplot(agr, aes(x=Utterance,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  # geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/3_frequencyAnalysis/ratio_4bins_proportion_mentioned_features_by_condition_by_frequencyRatio_4bins_median.pdf",width=10,height=10)
=======
ggsave("graphs_basiclevel/3_frequencyAnalysis/ratio_4bins_proportion_mentioned_features_by_condition_by_frequencyRatio_4bins_median.pdf",width=10,height=10)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e

ggplot(agr, aes(x=condition,y=Probability,fill=freqMedianRatio4bins)) +
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/3_frequencyAnalysis/ratio_4bins_proportion_mentioned_features_by_feature_by_frequencyRatio_4bins_median.pdf",width=10,height=10)
=======
ggsave("graphs_basiclevel/3_frequencyAnalysis/ratio_4bins_proportion_mentioned_features_by_feature_by_frequencyRatio_4bins_median.pdf",width=10,height=10)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e


######## ANALYSIS OF LENGTH AND FREQUENCY -- JUDITH'S CODE

# length
<<<<<<< HEAD
noAtt$TypeLength = nchar(as.character(noAtt$nameClickedObj))
noAtt$BasicLevelLength = nchar(as.character(noAtt$basiclevelClickedObj))
noAtt$SuperLength = nchar(as.character(noAtt$superdomainClickedObj))
noAtt$logTypeLength = log(noAtt$TypeLength)
noAtt$logBasicLevelLength = log(noAtt$BasicLevelLength)
noAtt$logSuperLength = log(noAtt$SuperLength)

un = unique(noAtt[,c("nameClickedObj","basiclevelClickedObj","superdomainClickedObj","TypeLength","BasicLevelLength","SuperLength","logTypeLength","logBasicLevelLength","logSuperLength")])
=======
bdCorrect$TypeLength = nchar(as.character(bdCorrect$nameClickedObj))
bdCorrect$BasicLevelLength = nchar(as.character(bdCorrect$basiclevelClickedObj))
bdCorrect$SuperLength = nchar(as.character(bdCorrect$superdomainClickedObj))
bdCorrect$logTypeLength = log(bdCorrect$TypeLength)
bdCorrect$logBasicLevelLength = log(bdCorrect$BasicLevelLength)
bdCorrect$logSuperLength = log(bdCorrect$SuperLength)

un = unique(bdCorrect[,c("nameClickedObj","basiclevelClickedObj","superdomainClickedObj","TypeLength","BasicLevelLength","SuperLength","logTypeLength","logBasicLevelLength","logSuperLength")])
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
nrow(un)
head(un)

# absolute lengths
gathered = un %>%
  select(TypeLength,BasicLevelLength,SuperLength) %>%
  gather(Label,Length)
gathered$Label = gsub("Length","",gathered$Label)
head(gathered)
ggplot(gathered, aes(x=Length,fill=Label)) +
  #geom_histogram(position="dodge")
  geom_density(alpha=.5)
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/length_histogram.pdf")
=======
ggsave("graphs_basiclevel/length_histogram.pdf")
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e

gathered = un %>%
  select(TypeLength,BasicLevelLength,SuperLength,nameClickedObj) %>%
  gather(Label,Length,-nameClickedObj)
gathered$Label = gsub("Length","",gathered$Label)
gathered$LabelType = factor(x=gathered$Label,levels=c("Type","BasicLevel","Super"))
head(gathered)
ggplot(gathered, aes(x=LabelType,y=Length,fill=LabelType)) +
  geom_bar(stat="identity") +
  facet_wrap(~nameClickedObj) +
  theme(axis.text.x=element_text(angle=45,hjust=1,vjust=1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/by-item-lengths.pdf",height=12,width=15)
=======
ggsave("graphs_basiclevel/by-item-lengths.pdf",height=12,width=15)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e

# log lengths
gathered = un %>%
  select(logTypeLength,logBasicLevelLength,logSuperLength) %>%
  gather(Label,logLength)
gathered$Label = gsub("Length","",gathered$Label)
gathered$Label = gsub("log","",gathered$Label)
head(gathered)
ggplot(gathered, aes(x=logLength,fill=Label)) +
  #geom_histogram(position="dodge")
  geom_density(alpha=.5)
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/loglength_density.pdf")
=======
ggsave("graphs_basiclevel/loglength_density.pdf")
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e

gathered = un %>%
  select(logTypeLength,logBasicLevelLength,logSuperLength,nameClickedObj) %>%
  gather(Label,logLength,-nameClickedObj)
gathered$Label = gsub("Length","",gathered$Label)
gathered$Label = gsub("log","",gathered$Label)
gathered$LabelType = factor(x=gathered$Label,levels=c("Type","BasicLevel","Super"))
head(gathered)
ggplot(gathered, aes(x=LabelType,y=logLength,fill=LabelType)) +
  geom_bar(stat="identity") +
  facet_wrap(~nameClickedObj) +
  theme(axis.text.x=element_text(angle=45,hjust=1,vjust=1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/by-item-loglengths.pdf",height=12,width=15)


# frequency
noAtt$TypeFreq = noAtt$relFreqType
noAtt$BasicLevelFreq = noAtt$relFreqBasiclevel
noAtt$SuperFreq = noAtt$relFreqSuperdomain

noAtt$logTypeFreq = log(noAtt$relFreqType)
noAtt$logBasicLevelFreq = log(noAtt$relFreqBasiclevel)
noAtt$logSuperFreq = log(noAtt$relFreqSuperdomain)

un = unique(noAtt[,c("nameClickedObj","basiclevelClickedObj","superdomainClickedObj","TypeFreq","BasicLevelFreq","SuperFreq","logTypeFreq","logBasicLevelFreq","logSuperFreq")])
=======
ggsave("graphs_basiclevel/by-item-loglengths.pdf",height=12,width=15)


# frequency
bdCorrect$TypeFreq = bdCorrect$relFreqType
bdCorrect$BasicLevelFreq = bdCorrect$relFreqBasiclevel
bdCorrect$SuperFreq = bdCorrect$relFreqSuperdomain

bdCorrect$logTypeFreq = log(bdCorrect$relFreqType)
bdCorrect$logBasicLevelFreq = log(bdCorrect$relFreqBasiclevel)
bdCorrect$logSuperFreq = log(bdCorrect$relFreqSuperdomain)

un = unique(bdCorrect[,c("nameClickedObj","basiclevelClickedObj","superdomainClickedObj","TypeFreq","BasicLevelFreq","SuperFreq","logTypeFreq","logBasicLevelFreq","logSuperFreq")])
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
nrow(un)
head(un)

gathered = un %>%
  select(TypeFreq,BasicLevelFreq,SuperFreq) %>%
  gather(Label,Freq)
gathered$Label = gsub("Freq","",gathered$Label)
head(gathered)
ggplot(gathered, aes(x=Freq,fill=Label)) +
  #geom_histogram(position="dodge")
  geom_density(alpha=.5) +
  scale_x_continuous(limits=c(0,0.00008))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/freq_density.pdf")
=======
ggsave("graphs_basiclevel/freq_density.pdf")
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e

gathered = un %>%
  select(TypeFreq,BasicLevelFreq,SuperFreq,nameClickedObj) %>%
  gather(Label,Freq,-nameClickedObj)
gathered$Label = gsub("Freq","",gathered$Label)
gathered$LabelType = factor(x=gathered$Label,levels=c("Type","BasicLevel","Super"))
head(gathered)
ggplot(gathered, aes(x=LabelType,y=Freq,fill=LabelType)) +
  geom_bar(stat="identity") +
  facet_wrap(~nameClickedObj) +
  theme(axis.text.x=element_text(angle=45,hjust=1,vjust=1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/by-item-freqs.pdf",height=12,width=15)
=======
ggsave("graphs_basiclevel/by-item-freqs.pdf",height=12,width=15)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e

# log rel. freq instead of absolute rel. freq
gathered = un %>%
  select(logTypeFreq,logBasicLevelFreq,logSuperFreq) %>%
  gather(Label,logFreq)
#gathered$Label = gsub("logFreq","",gathered$Label)
head(gathered)
ggplot(gathered, aes(x=logFreq,fill=Label)) +
  #geom_histogram(position="dodge")
  geom_density(alpha=.5) 
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/logfreq_density.pdf")
=======
ggsave("graphs_basiclevel/logfreq_density.pdf")
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e

gathered = un %>%
  select(logTypeFreq,logBasicLevelFreq,logSuperFreq,nameClickedObj) %>%
  gather(Label,logFreq,-nameClickedObj)
#gathered$Label = gsub("logFreq","",gathered$Label)
#gathered$LabelType = factor(x=gathered$Label,levels=c("Type","BasicLevel","Super"))
head(gathered)
ggplot(gathered, aes(x=Label,y=logFreq,fill=Label)) +
  geom_bar(stat="identity") +
  facet_wrap(~nameClickedObj) +
  theme(axis.text.x=element_text(angle=45,hjust=1,vjust=1))
<<<<<<< HEAD
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/by-item-logfreqs.pdf",height=12,width=15)


#### MIXED EFFECTS MODEL ANALYSIS FOR TYPE MENTION

centered = cbind(noAtt, myCenter(noAtt[,c("TypeLength","BasicLevelLength","SuperLength","logTypeLength","logBasicLevelLength","logSuperLength","TypeFreq","BasicLevelFreq","SuperFreq","logTypeFreq","logBasicLevelFreq","logSuperFreq")]))

#contrasts(noAtt$condition) = cbind(c(1,0,0,0),c(0,0,1,0),c(0,0,0,1))
contrasts(centered$condition) = cbind("12.vs.rest"=c(3/4,-1/4,-1/4,-1/4),"22.vs.3"=c(0,2/3,-1/3,-1/3),"23.vs.33"=c(0,0,1/2,-1/2))

m = glmer(typeMentioned ~ condition * clogTypeLength * clogTypeFreq + (1 + clogTypeFreq|gameid) + (1|basiclevelClickedObj), family="binomial",data=centered)
summary(m)

# collapse across non-12 conditions
noAtt$redCondition = as.factor(ifelse(noAtt$condition == "distr12","type_forced","type_not_forced"))
table(noAtt$redCondition)
centered = cbind(noAtt, myCenter(noAtt[,c("TypeLength","BasicLevelLength","SuperLength","logTypeLength","logBasicLevelLength","logSuperLength","TypeFreq","BasicLevelFreq","SuperFreq","logTypeFreq","logBasicLevelFreq","logSuperFreq","redCondition")]))

m = glmer(typeMentioned ~ credCondition * clogTypeLength * clogTypeFreq + (1+credCondition|gameid) + (1|basiclevelClickedObj), family="binomial",data=centered)
summary(m)

# analyze only non-12 conditions
non12 = droplevels(subset(noAtt, condition != "distr12"))
centered = cbind(non12, myCenter(non12[,c("TypeLength","BasicLevelLength","SuperLength","logTypeLength","logBasicLevelLength","logSuperLength","TypeFreq","BasicLevelFreq","SuperFreq","logTypeFreq","logBasicLevelFreq","logSuperFreq")]))

m = glmer(typeMentioned ~ clogTypeLength * clogTypeFreq + (1 + clogTypeLength|gameid) + (1 + clogTypeLength|basiclevelClickedObj), family="binomial",data=centered)
summary(m)

m = glmer(typeMentioned ~ clogTypeLength * clogTypeFreq + (1 |gameid) + (1 + clogTypeFreq|basiclevelClickedObj), family="binomial",data=centered)
summary(m)

# for all random effects structures that allow the model to converge, the interaction between frequency and length is significant at (at most) <.01
#noAtt$cutlogTypeLength = cut(noAtt$logTypeLength,breaks=quantile(noAtt$logTypeLength,probs=c(0,.5,1)))
noAtt$binnedlogTypeLength = cut_number(noAtt$logTypeLength,2,labels=c("short","long"))
noAtt$binnedlogTypeFreq = cut_number(noAtt$logTypeFreq,2,labels=c("low-frequency","high-frequency"))
summary(noAtt)

agr = noAtt %>%
  select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, redCondition, binnedlogTypeLength, binnedlogTypeFreq) %>%
  gather(Utterance,Mentioned,-redCondition, -binnedlogTypeLength, -binnedlogTypeFreq) %>%
  group_by(Utterance,redCondition, binnedlogTypeLength, binnedlogTypeFreq) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
summary(agr)
dodge = position_dodge(.9)

ggplot(agr, aes(x=redCondition,y=Probability,fill=binnedlogTypeLength)) +
  geom_bar(stat="identity",position=dodge) +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  facet_grid(binnedlogTypeFreq~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/4_length-frequency-interaction/freq-length-interaction.pdf",height=10,width=15)

agr = noAtt %>%
  select(typeMentioned, redCondition, binnedlogTypeLength, binnedlogTypeFreq) %>%
  group_by(redCondition, binnedlogTypeLength, binnedlogTypeFreq) %>%
  summarise(Probability=mean(typeMentioned),ci.low=ci.low(typeMentioned),ci.high=ci.high(typeMentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
summary(agr)
dodge = position_dodge(.9)

ggplot(agr, aes(x=binnedlogTypeFreq,y=Probability,fill=binnedlogTypeLength)) +
  geom_bar(stat="identity",position=dodge) +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  facet_wrap(~redCondition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/4_length-frequency-interaction/freq-length-interaction-bycond.pdf",height=5,width=9)

#noAtt$binnedlogTypeLength = cut_number(noAtt$logTypeLength,3,labels=c("short","mid","long"))
#noAtt$binnedlogTypeFreq = cut_number(noAtt$logTypeFreq,3,labels=c("low-frequency","mid-frequency","high-frequency"))
summary(noAtt[,c("binnedlogTypeLength","binnedlogTypeFreq")])
table(noAtt$binnedlogTypeLength,noAtt$binnedlogTypeFreq)

agr = noAtt %>%
  select(typeMentioned, binnedlogTypeLength, binnedlogTypeFreq) %>%
  group_by(binnedlogTypeLength, binnedlogTypeFreq) %>%
  summarise(Probability=mean(typeMentioned),ci.low=ci.low(typeMentioned),ci.high=ci.high(typeMentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
summary(agr)
dodge = position_dodge(.9)

ggplot(agr, aes(x=binnedlogTypeFreq,y=Probability,fill=binnedlogTypeLength)) +
  geom_bar(stat="identity",position=dodge) +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  scale_y_continuous(name="Probability of type mention") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/new_attribute_analysis/noAtt/4_length-frequency-interaction/freq-length-interaction-noconds.pdf",height=5,width=9)

=======
ggsave("graphs_basiclevel/by-item-logfreqs.pdf",height=12,width=15)


#####  TO GET THE CASES WE NEED TO NORM FOR TYPICALITY:

labelTests = read.table(file="data/singleColumnLabels.csv",sep=";", header=T, quote="")
head(labelTests)
nrow(labelTests)

labelTestsUnique = unique(labelTests)
head(labelTestsUnique)
nrow(labelTestsUnique) # 1323 unique rows!!! 


# write all unique object types and their basiclevels/superclasses
targets = bdCorrect %>% 
  select(nameClickedObj,basiclevelClickedObj,superdomainClickedObj) %>%
  rename(sub=nameClickedObj,basic=basiclevelClickedObj,super=superdomainClickedObj) 
targets$type = "target"

alt1 = bdCorrect %>% 
  select(alt1Name,alt1Basiclevel,alt1superdomain) %>%
  rename(sub=alt1Name,basic=alt1Basiclevel,super=alt1superdomain)
alt1$type = "dist"

alt2 = bdCorrect %>% 
  select(alt2Name,alt2Basiclevel,alt2superdomain) %>%
  rename(sub=alt2Name,basic=alt2Basiclevel,super=alt2superdomain)
alt2$type = "dist"

alt3 = bdCorrect %>% 
  select(alt3Name,alt3Basiclevel,alt3superdomain) %>%
  rename(sub=alt3Name,basic=alt3Basiclevel,super=alt3superdomain)
alt3$type = "dist"

alt4 = bdCorrect %>% 
  select(alt4Name,alt4Basiclevel,alt4superdomain) %>%
  rename(sub=alt4Name,basic=alt4Basiclevel,super=alt4superdomain)
alt4$type = "dist"

combos = rbind(targets,alt1,alt2,alt3,alt4)
nrow(combos)
combos = unique(combos)
combos$sub = tolower(combos$sub)
nrow(combos)
head(combos)
row.names(combos) = combos$sub

basicsuper = unique(combos[,c("basic","super")])
basicsuper = basicsuper[!is.na(basicsuper$basic),]
row.names(basicsuper) = basicsuper$basic
nrow(basicsuper)
basicsuper
super = unique(combos[,c("super")])

pairs = read.table("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/5_norming_object_typicality_phrasing1/item-combos.csv",sep=",",quote="")
colnames(pairs) = c("Object","Label")
pairs$Label = gsub("m&m's","mnms",pairs$Label)
pairs$Label = gsub("t-shirt","tshirt",pairs$Label)
pairs$Label = gsub("flower\"","flower",pairs$Label)
pairs$ObjectBasic = combos[as.character(pairs$Object),]$basic
pairs$ObjectSuper = combos[as.character(pairs$Object),]$super
pairs$LabelBasic = combos[as.character(pairs$Label),]$basic
pairs$LabelBasicAlt = basicsuper[as.character(pairs$Label),]$basic
pairs[is.na(pairs$LabelBasic),]$LabelBasic = pairs[is.na(pairs$LabelBasic),]$LabelBasicAlt
pairs$LabelSuper = combos[as.character(pairs$Label),]$super
pairs[pairs$Label %in% super,]$LabelSuper = pairs[pairs$Label %in% super,]$Label
pairs[pairs$Label %in% as.character(basicsuper$basic),]$LabelSuper = basicsuper[as.character(pairs[pairs$Label %in% as.character(basicsuper$basic),]$Label),]$super
pairs$LabelBasicAlt = NULL
pairs$LabelType = as.factor(ifelse(pairs$Label %in% as.character(combos$sub),"sub",ifelse(pairs$Label %in% as.character(combos$basic),"basic",ifelse(pairs$Label %in% as.character(combos$super),"super","missing"))))

head(pairs)
tail(pairs)
nrow(pairs)
pairs$Target = as.factor(ifelse(pairs$Object %in% as.character(combos[combos$type == "target",]$sub),"target","dist"))
table(pairs$Target) # there are 108 targets (9 domains with 4 targets each, where each target needs to be normed for its sub, baisc, and super label = 9*4*3 = 108 cases)
pairs[pairs$Target == "target" & pairs$ObjectBasic == "bear",]

# there are also 1377 distractors to norm. can we cut down on this?
head(pairs[pairs$Target == "dist",])
tail(pairs[pairs$Target == "dist",])
pairs[pairs$Target == "dist" & pairs$Object=="koalabear",]
pairs[pairs$Target == "dist" & pairs$Object=="elephant",]
pairs$Label = as.factor(pairs$Label)
summary(pairs)

pairs$SameSuper = as.factor(ifelse(pairs$ObjectSuper == pairs$LabelSuper,"same","different"))
pairs$SameBasic = as.factor(ifelse(pairs$ObjectBasic == pairs$LabelBasic,"same","different"))
table(pairs$Target) # 108 targets that definitely need norming
table(pairs[pairs$Target == "dist",]$SameSuper) # Of the distractors, 469 are cases with the same superclass
table(pairs[pairs$Target == "dist",]$SameSuper,pairs[pairs$Target == "dist",]$SameBasic)
table(pairs[pairs$Target == "dist",]$SameSuper,pairs[pairs$Target == "dist",]$LabelType) # Of the distractors with a different superclass, 168 are cases of superclass norms
# So if we want to only get typicality norms for cases where object and label belong to the same superclass (eg pair the elephant only with other animal labels like “pug”/“dog”) or where the label is the superclass label from another class (eg “furniture"), we'll need to norm 108+469+168 = 745 cases

norms = pairs[(pairs$Target == "target" | pairs$Target == "dist" & pairs$SameSuper == "same" | pairs$Target == "dist" & pairs$SameSuper == "different" & pairs$LabelType == "super"),]
nrow(norms)
head(norms)
norms$ItemType = as.factor(ifelse(norms$Target == "target","target",ifelse(norms$SameSuper == "same","dist_samesuper","dist_super")))
prop.table(table(norms$ItemType)) # we want to try to get 63% dist_samesuper, 22% dist_super, and 14% targets per subject
write.table(norms[,c("Object","Label","ItemType","LabelType")],file="data/norms.txt",col.names=T,sep="\t",row.names=F,quote=F)
>>>>>>> e317e02081b3088e9160b391d825bc7c3e169a4e
