theme_set(theme_bw(18))

setwd("/Users/cocolab/overinformativeness/experiments/3_numdistractors_basiclevel/results")
source("rscripts/helpers.r")

#load("data/r.RData")
d = read.table(file="data/results_modified_round1.csv",sep=",", header=T, quote="")
d$Half = as.factor(ifelse(d$roundNum < 37, "first","second"))
d$Quarter = as.factor(ifelse(d$roundNum < 19, "first",ifelse(d$roundNum < 37,"second", ifelse(d$roundNum < 55, "third","fourth"))))
head(d)
nrow(d)
#d$speakerMessages
summary(d)
d[is.na(d$TypeMentioned),]$TypeMentioned = FALSE
d[is.na(d$otherFeatureMentioned),]$otherFeatureMentioned = FALSE
d[is.na(d$superClassMentioned),]$superClassMentioned = FALSE
d[is.na(d$superSuperClassMentioned),]$superSuperClassMentioned = FALSE
d[is.na(d$superclassattributeMentioned),]$superclassattributeMentioned = FALSE
d[is.na(d$utteranceContracted),]$utteranceContracted = FALSE

# look at turker comments
comments = read.table(file="data/overinf_round1.csv",sep=",", header=T, quote="")
unique(comments$comments)
comments[comments$gameID %in% c("3276-c","0092-1"),]

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
chisq.test(table(d$condition,d$targetStatusClickedObj))

# how many unique pairs?
length(levels(d$gameid))

# Only look at basiclevel conditions: distr12, distr22, distr23, distr33:

#basiclevel data:
bd = droplevels(subset(d, condition == "distr12" | condition == "distr22" | condition == "distr23" | condition == "distr33"))
head(bd)
nrow(bd)
summary(bd)
totalnrow = nrow(bd)

table(bd$condition,bd$TypeMentioned)
table(bd$condition,bd$superClassMentioned)
table(bd$condition,bd$superSuperClassMentioned)
table(bd$condition,bd$superclassattributeMentioned)

# bd$liberalSupersuperclass = bd$superClassMentioned &

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
  select(TypeMentioned,superClassMentioned,superSuperClassMentioned, superclassattributeMentioned, condition) %>%
  gather(Feature,Mentioned,-condition)
agr$Feature = gsub("Mentioned","",as.character(agr$Feature))
agr = droplevels(subset(agr,Mentioned == "TRUE"))
head(agr)

# plot histogram of mentioned features by condition
ggplot(agr, aes(x=Feature)) +
  geom_histogram() +
  facet_wrap(~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/round1/frequency_mentioned_features_by_condition.pdf",width=8,height=10)

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
  select(TypeMentioned,superClassMentioned,superSuperClassMentioned, superclassattributeMentioned, condition) %>%
  gather(Utterance,Mentioned,-condition) %>%
  group_by(Utterance,condition) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

ggplot(agr, aes(x=Utterance,y=Probability)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~condition) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/round1/proportion_mentioned_features_by_condition.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~Utterance) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/round1/proportion_mentioned_features_by_feature.pdf",width=10,height=10)

# This is unnecessary:
#
# bdCorrect$Type = ifelse(bdCorrect$TypeMentioned,1,0)
# bdCorrect$SuperClass = ifelse(bdCorrect$superClassMentioned,1,0)
# bdCorrect$SuperSuperClass = ifelse(bdCorrect$superSuperClassMentioned,1,0)
# bdCorrect$SuperClassAttribute = ifelse(bdCorrect$superclassattributeMentioned,1,0)
# 
# agr = bdCorrect %>%
#   select(Type,SuperClass,SuperSuperClass, SuperClassAttribute, condition) %>%
#   gather(Utterance,Mentioned,-condition) %>%
#   group_by(Utterance,condition) %>%
#   summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
# agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
# 
# ggplot(agr, aes(x=condition,y=Probability)) +
#   geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_wrap(~Utterance) + 
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))

# We want to include the domain:

agr = bdCorrect %>%
  select(TypeMentioned,superClassMentioned,superSuperClassMentioned, superclassattributeMentioned, domainClickedObj, condition) %>%
  gather(Feature,Mentioned,-condition, -domainClickedObj)
agr$Feature = gsub("Mentioned","",as.character(agr$Feature))
agr = droplevels(subset(agr,Mentioned == "TRUE"))
head(agr)
summary(agr)

# plot histogram of mentioned features by condition
ggplot(agr, aes(x=Feature)) +
  geom_histogram() +
  facet_grid(domainClickedObj~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
  #facet_wrap(~condition)
ggsave("graphs_basiclevel/round1/frequency_mentioned_features_by_condition_by_domain.pdf",width=8,height=10)

# plot histogram with probabilities

agr = bdCorrect %>%
  select(TypeMentioned,superClassMentioned,superSuperClassMentioned, superclassattributeMentioned, domainClickedObj, condition) %>%
  gather(Utterance,Mentioned,-condition, -domainClickedObj) %>%
  group_by(Utterance,condition, domainClickedObj) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

ggplot(agr, aes(x=Utterance,y=Probability)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(domainClickedObj~condition) +
  #facet_wrap(~condition) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/round1/proportion_mentioned_features_by_condition_by_domain.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(domainClickedObj~Utterance) +
  #facet_wrap(~Utterance) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/round1/proportion_mentioned_features_by_feature_by_domain.pdf",width=10,height=10)

# Analysis including incorrect trials:

agr = bd %>%
  select(TypeMentioned,superClassMentioned,superSuperClassMentioned, superclassattributeMentioned, condition) %>%
  gather(Feature,Mentioned,-condition)
agr$Feature = gsub("Mentioned","",as.character(agr$Feature))
agr = droplevels(subset(agr,Mentioned == "TRUE"))
head(agr)

# plot histogram of mentioned features by condition
ggplot(agr, aes(x=Feature)) +
  geom_histogram() +
  facet_wrap(~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/round1/all_frequency_mentioned_features_by_condition.pdf",width=8,height=10)

# plot histogram with probabilities

agr = bd %>%
  select(TypeMentioned,superClassMentioned,superSuperClassMentioned, superclassattributeMentioned, condition) %>%
  gather(Utterance,Mentioned,-condition) %>%
  group_by(Utterance,condition) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

ggplot(agr, aes(x=Utterance,y=Probability)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~condition) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/round1/all_proportion_mentioned_features_by_condition.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~Utterance) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/round1/all_proportion_mentioned_features_by_feature.pdf",width=10,height=10)

# We want to include the domain:
#!!!! I don't know if this makes sense, in incorrect trials the domain of the clicked obj is not the domain of the target

# Since we're including incorrect trials, the domain value may be NA.
# Exclude domain=NAs
nrow(bd)
bdNew = droplevels(bd[!is.na(bd$domainClickedObj),])
head(bdNew)
summary(bdNew)
nrow(bdNew)

agr = bdNew %>%
  select(TypeMentioned,superClassMentioned,superSuperClassMentioned, superclassattributeMentioned, domainClickedObj, condition) %>%
  gather(Feature,Mentioned,-condition, -domainClickedObj)
agr$Feature = gsub("Mentioned","",as.character(agr$Feature))
agr = droplevels(subset(agr,Mentioned == "TRUE"))
head(agr)
summary(agr)

# plot histogram of mentioned features by condition
ggplot(agr, aes(x=Feature)) +
  geom_histogram() +
  facet_grid(domainClickedObj~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
#facet_wrap(~condition)
ggsave("graphs_basiclevel/round1/all_frequency_mentioned_features_by_condition_by_domain.pdf",width=8,height=10)

# plot histogram with probabilities

agr = bdNew %>%
  select(TypeMentioned,superClassMentioned,superSuperClassMentioned, superclassattributeMentioned, domainClickedObj, condition) %>%
  gather(Utterance,Mentioned,-condition, -domainClickedObj) %>%
  group_by(Utterance,condition, domainClickedObj) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

ggplot(agr, aes(x=Utterance,y=Probability)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(domainClickedObj~condition) +
  #facet_wrap(~condition) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/round1/all_proportion_mentioned_features_by_condition_by_domain.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(domainClickedObj~Utterance) +
  #facet_wrap(~Utterance) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/round1/all_proportion_mentioned_features_by_feature_by_domain.pdf",width=10,height=10)

# # let's look at the dog domain:
# 
# dogs = droplevels(subset(bd, domainClickedObj == "dog"))
# head(dogs)
# summary(dogs)
# nrow(dogs)
# 
# agr = dogs %>%
#   select(TypeMentioned,superClassMentioned,superSuperClassMentioned, superclassattributeMentioned, condition, nameClickedObj) %>%
#   gather(Feature,Mentioned,-condition, -nameClickedObj)
# agr$Feature = gsub("Mentioned","",as.character(agr$Feature))
# agr = droplevels(subset(agr,Mentioned == "TRUE"))
# head(agr)
# 
# # plot histogram of mentioned features by condition
# ggplot(agr, aes(x=Feature)) +
#   geom_histogram() +
#   facet_wrap(~condition) +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
# ggsave("graphs_basiclevel/round1/dogs_frequency_mentioned_features_by_condition.pdf",width=8,height=10)

# Analysis of word length effect: (only for correct trials!)

#Add new variable which encodes relative word length (shorter or longer) of type class to superclass
bdCorrect$typeLength = nchar(as.character(bdCorrect$nameClickedObj))
head(bdCorrect$typeLength)
bdCorrect$SuperClassLength = nchar(as.character(bdCorrect$domainClickedObj))
bdCorrect$TypeShorter = ifelse(bdCorrect$typeLength < bdCorrect$SuperClassLength, "type_shorter","type_longer")

# plot histogram with probabilities

agr = bdCorrect %>%
  select(TypeMentioned,superClassMentioned,superSuperClassMentioned, superclassattributeMentioned, domainClickedObj, condition, TypeShorter) %>%
  gather(Utterance,Mentioned,-condition, -domainClickedObj, -TypeShorter) %>%
  group_by(Utterance,condition, domainClickedObj, TypeShorter) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

dodge = position_dodge(.9)

ggplot(agr, aes(x=Utterance,y=Probability,fill=TypeShorter)) +
#ggplot(agr, aes(x=Utterance,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  # geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(domainClickedObj~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/round1/proportion_mentioned_features_by_condition_by_domain_by_length.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability,fill=TypeShorter)) +
#ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(domainClickedObj~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/round1/proportion_mentioned_features_by_feature_by_domain_by_length.pdf",width=10,height=10)

# same analysis with length bins: 

#Add new variable which encodes absolute word length bins of clickedObj

head(bdCorrect$typeLength)

# getAbsLengthLabel <- function(row) {
#   if(row$typeLength < 4) {
#     return "type_length_<4";
#   }
# }
# 
# if (bdCorrect$typeLength < 4) {
#   bdCorrect$absLength = "type_length_<4"
# # } else if (bdCorrect$typeLength < 7 & bdCorrect$typeLength > 3) {
# #   bdCorrect$absLength = "type_length_4-6"
# # } else if (bdCorrect$typeLength < 10 & bdCorrect$typeLength > 6) {
# #   bdCorrect$absLength = "type_length_7-9"
# } else {   #if (bdCorrect$Typelength > 9)
#   bdCorrect$absLength = "type_length_>10"
# }



# 4 bins

bdCorrect$typeNumOfChar = ifelse(bdCorrect$typeLength < 4, "01-03",
                             ifelse((bdCorrect$typeLength < 7 & bdCorrect$typeLength > 3), "04-06", 
                                    ifelse((bdCorrect$typeLength < 10 & bdCorrect$typeLength > 6), "07-09", "10+" )))

head(bdCorrect$typeNumOfChar)
head(bdCorrect)

# plot histogram with probabilities

agr = bdCorrect %>%
  select(TypeMentioned,superClassMentioned,superSuperClassMentioned, superclassattributeMentioned, domainClickedObj, condition, typeNumOfChar) %>%
  gather(Utterance,Mentioned,-condition, -domainClickedObj, -typeNumOfChar) %>%
  group_by(Utterance,condition, domainClickedObj, typeNumOfChar) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

dodge = position_dodge(.9)

ggplot(agr, aes(x=Utterance,y=Probability,fill=typeNumOfChar)) +
  #ggplot(agr, aes(x=Utterance,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  # geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(domainClickedObj~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/round1/proportion_mentioned_features_by_condition_by_domain_by_length_4bins.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability,fill=typeNumOfChar)) +
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(domainClickedObj~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/round1/proportion_mentioned_features_by_feature_by_domain_by_length_4bins.pdf",width=10,height=10)


# 6 bins:


bdCorrect$typeNumOfChar6bins = ifelse(bdCorrect$typeLength < 4, "01-03",
                                 ifelse((bdCorrect$typeLength < 6 & bdCorrect$typeLength > 3), "04-05", 
                                        ifelse((bdCorrect$typeLength < 8 & bdCorrect$typeLength > 5), "06-07", 
                                               ifelse((bdCorrect$typeLength < 10 & bdCorrect$typeLength > 7), "08-09",  
                                                      ifelse((bdCorrect$typeLength < 12 & bdCorrect$typeLength > 9), "10-11", "12+" )))))

head(bdCorrect$typeNumOfChar6bins)
head(bdCorrect)

# plot histogram with probabilities

agr = bdCorrect %>%
  select(TypeMentioned,superClassMentioned,superSuperClassMentioned, superclassattributeMentioned, domainClickedObj, condition, typeNumOfChar6bins) %>%
  gather(Utterance,Mentioned,-condition, -domainClickedObj, -typeNumOfChar6bins) %>%
  group_by(Utterance,condition, domainClickedObj, typeNumOfChar6bins) %>%
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
  facet_grid(domainClickedObj~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/round1/proportion_mentioned_features_by_condition_by_domain_by_length_6bins.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability,fill=typeNumOfChar6bins)) +
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(domainClickedObj~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/round1/proportion_mentioned_features_by_feature_by_domain_by_length_6bins.pdf",width=10,height=10)


  
# # facet_grid(domainClickedObj~Utterance)
# 
# 
# fillers = droplevels(subset(d, condition == "filler"))
# #fillers$AnyTypeMentioned = fillers$typeMentioned | fillers$otherFeatureMentioned
# ggplot(fillers, aes(x=typeMentioned)) +
#   geom_histogram()
# 
# 
# # plot individual variation on targets
# # 4 people tend to always mention color redundantly in the size-only condition
# # 3 pepole tend to only mention size in the size-only condition (plus 2 who seem to prefer size only but are sometimes redundant)
# # all the redundant size mentions in the color-only condition come from three subjects
# ggplot(targets, aes(x=UtteranceType,fill=condition)) +
#   geom_histogram() +
#   facet_wrap(~gameid) +
#   theme(axis.text.x=element_text(angle=45,hjust=1,vjust=1))
# ggsave("graphs_round1/individual_variation.pdf",width=8,height=7)




# results of round 2:

theme_set(theme_bw(18))

setwd("/Users/cocolab/overinformativeness/experiments/3_numdistractors_basiclevel/results")
source("rscripts/helpers.r")

#load("data/r.RData")
d = read.table(file="data/results_modified_round2.csv",sep=",", header=T, quote="")
d$Half = as.factor(ifelse(d$roundNum < 37, "first","second"))
d$Quarter = as.factor(ifelse(d$roundNum < 19, "first",ifelse(d$roundNum < 37,"second", ifelse(d$roundNum < 55, "third","fourth"))))
head(d)
nrow(d)
#d$speakerMessages
summary(d)
d[is.na(d$typeMentioned),]$typeMentioned = FALSE
d[is.na(d$otherFeatureMentioned),]$otherFeatureMentioned = FALSE
d[is.na(d$superClassMentioned),]$superClassMentioned = FALSE
d[is.na(d$superSuperClassMentioned),]$superSuperClassMentioned = FALSE
d[is.na(d$superclassattributeMentioned),]$superclassattributeMentioned = FALSE
d[is.na(d$utteranceContracted),]$utteranceContracted = FALSE

# look at turker comments
comments = read.table(file="data/overinf_round2.csv",sep=",", header=T, quote="")
unique(comments$comments)
comments[comments$gameID %in% c("3276-c","0092-1"),]

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
chisq.test(table(d$condition,d$targetStatusClickedObj))

# how many unique pairs?
length(levels(d$gameid))

# Only look at basiclevel conditions: distr12, distr22, distr23, distr33:

#basiclevel data:
bd = droplevels(subset(d, condition == "distr12" | condition == "distr22" | condition == "distr23" | condition == "distr33"))
head(bd)
nrow(bd)
summary(bd)
totalnrow = nrow(bd)

table(bd$condition,bd$typeMentioned)
table(bd$condition,bd$superClassMentioned)
table(bd$condition,bd$superSuperClassMentioned)
table(bd$condition,bd$superclassattributeMentioned)

# bd$liberalSupersuperclass = bd$superClassMentioned &

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
  select(typeMentioned,superClassMentioned,superSuperClassMentioned, superclassattributeMentioned, condition) %>%
  gather(Feature,Mentioned,-condition)
agr$Feature = gsub("Mentioned","",as.character(agr$Feature))
agr = droplevels(subset(agr,Mentioned == "TRUE"))
head(agr)

# plot histogram of mentioned features by condition
ggplot(agr, aes(x=Feature)) +
  geom_histogram() +
  facet_wrap(~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/round2/frequency_mentioned_features_by_condition.pdf",width=8,height=10)

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
  select(typeMentioned,superClassMentioned,superSuperClassMentioned, superclassattributeMentioned, condition) %>%
  gather(Utterance,Mentioned,-condition) %>%
  group_by(Utterance,condition) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

ggplot(agr, aes(x=Utterance,y=Probability)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~condition) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/round2/proportion_mentioned_features_by_condition.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~Utterance) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/round2/proportion_mentioned_features_by_feature.pdf",width=10,height=10)

# This is unnecessary:
#
# bdCorrect$Type = ifelse(bdCorrect$TypeMentioned,1,0)
# bdCorrect$SuperClass = ifelse(bdCorrect$superClassMentioned,1,0)
# bdCorrect$SuperSuperClass = ifelse(bdCorrect$superSuperClassMentioned,1,0)
# bdCorrect$SuperClassAttribute = ifelse(bdCorrect$superclassattributeMentioned,1,0)
# 
# agr = bdCorrect %>%
#   select(Type,SuperClass,SuperSuperClass, SuperClassAttribute, condition) %>%
#   gather(Utterance,Mentioned,-condition) %>%
#   group_by(Utterance,condition) %>%
#   summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
# agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
# 
# ggplot(agr, aes(x=condition,y=Probability)) +
#   geom_bar(stat="identity") +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_wrap(~Utterance) + 
#   theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))

# We want to include the domain:

nrow(bdCorrect)
bdCorrect = droplevels(subset(bdCorrect, domainClickedObj != "NA"))
nrow(bdCorrect)

agr = bdCorrect %>%
  select(typeMentioned,superClassMentioned,superSuperClassMentioned, superclassattributeMentioned, domainClickedObj, condition) %>%
  gather(Feature,Mentioned,-condition, -domainClickedObj)
agr$Feature = gsub("Mentioned","",as.character(agr$Feature))
agr = droplevels(subset(agr,Mentioned == "TRUE"))
head(agr)
summary(agr)

# plot histogram of mentioned features by condition
ggplot(agr, aes(x=Feature)) +
  geom_histogram() +
  facet_grid(domainClickedObj~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
#facet_wrap(~condition)
ggsave("graphs_basiclevel/round2/frequency_mentioned_features_by_condition_by_domain.pdf",width=8,height=10)

# plot histogram with probabilities

agr = bdCorrect %>%
  select(typeMentioned,superClassMentioned,superSuperClassMentioned, superclassattributeMentioned, domainClickedObj, condition) %>%
  gather(Utterance,Mentioned,-condition, -domainClickedObj) %>%
  group_by(Utterance,condition, domainClickedObj) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

ggplot(agr, aes(x=Utterance,y=Probability)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(domainClickedObj~condition) +
  #facet_wrap(~condition) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/round2/proportion_mentioned_features_by_condition_by_domain.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(domainClickedObj~Utterance) +
  #facet_wrap(~Utterance) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/round2/proportion_mentioned_features_by_feature_by_domain.pdf",width=10,height=10)

# Analysis including incorrect trials:

agr = bd %>%
  select(typeMentioned,superClassMentioned,superSuperClassMentioned, superclassattributeMentioned, condition) %>%
  gather(Feature,Mentioned,-condition)
agr$Feature = gsub("Mentioned","",as.character(agr$Feature))
agr = droplevels(subset(agr,Mentioned == "TRUE"))
head(agr)

# plot histogram of mentioned features by condition
ggplot(agr, aes(x=Feature)) +
  geom_histogram() +
  facet_wrap(~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/round2/all_frequency_mentioned_features_by_condition.pdf",width=8,height=10)

# plot histogram with probabilities

agr = bd %>%
  select(typeMentioned,superClassMentioned,superSuperClassMentioned, superclassattributeMentioned, condition) %>%
  gather(Utterance,Mentioned,-condition) %>%
  group_by(Utterance,condition) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

ggplot(agr, aes(x=Utterance,y=Probability)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~condition) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/round2/all_proportion_mentioned_features_by_condition.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~Utterance) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/round2/all_proportion_mentioned_features_by_feature.pdf",width=10,height=10)

# We want to include the domain:
#!!!! I don't know if this makes sense, in incorrect trials the domain of the clicked obj is not the domain of the target

# Since we're including incorrect trials, the domain value may be NA.
# Exclude domain=NAs
nrow(bd)
bdNew = droplevels(bd[!is.na(bd$domainClickedObj),])
head(bdNew)
summary(bdNew)
nrow(bdNew)

agr = bdNew %>%
  select(typeMentioned,superClassMentioned,superSuperClassMentioned, superclassattributeMentioned, domainClickedObj, condition) %>%
  gather(Feature,Mentioned,-condition, -domainClickedObj)
agr$Feature = gsub("Mentioned","",as.character(agr$Feature))
agr = droplevels(subset(agr,Mentioned == "TRUE"))
head(agr)
summary(agr)

# plot histogram of mentioned features by condition
ggplot(agr, aes(x=Feature)) +
  geom_histogram() +
  facet_grid(domainClickedObj~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
#facet_wrap(~condition)
ggsave("graphs_basiclevel/round2/all_frequency_mentioned_features_by_condition_by_domain.pdf",width=8,height=10)

# plot histogram with probabilities

agr = bdNew %>%
  select(typeMentioned,superClassMentioned,superSuperClassMentioned, superclassattributeMentioned, domainClickedObj, condition) %>%
  gather(Utterance,Mentioned,-condition, -domainClickedObj) %>%
  group_by(Utterance,condition, domainClickedObj) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

ggplot(agr, aes(x=Utterance,y=Probability)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(domainClickedObj~condition) +
  #facet_wrap(~condition) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/round2/all_proportion_mentioned_features_by_condition_by_domain.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(domainClickedObj~Utterance) +
  #facet_wrap(~Utterance) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/round2/all_proportion_mentioned_features_by_feature_by_domain.pdf",width=10,height=10)

# Analysis of word length effect: (only for correct trials!)

#Add new variable which encodes relative word length (shorter or longer) of type class to superclass
bdCorrect$typeLength = nchar(as.character(bdCorrect$nameClickedObj))
head(bdCorrect$typeLength)
bdCorrect$SuperClassLength = nchar(as.character(bdCorrect$domainClickedObj))
bdCorrect$TypeShorter = ifelse(bdCorrect$typeLength < bdCorrect$SuperClassLength, "type_shorter","type_longer")

# plot histogram with probabilities

agr = bdCorrect %>%
  select(typeMentioned,superClassMentioned,superSuperClassMentioned, superclassattributeMentioned, domainClickedObj, condition, TypeShorter) %>%
  gather(Utterance,Mentioned,-condition, -domainClickedObj, -TypeShorter) %>%
  group_by(Utterance,condition, domainClickedObj, TypeShorter) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

dodge = position_dodge(.9)

ggplot(agr, aes(x=Utterance,y=Probability,fill=TypeShorter)) +
  #ggplot(agr, aes(x=Utterance,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  # geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(domainClickedObj~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/round2/proportion_mentioned_features_by_condition_by_domain_by_length.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability,fill=TypeShorter)) +
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(domainClickedObj~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/round2/proportion_mentioned_features_by_feature_by_domain_by_length.pdf",width=10,height=10)

# same analysis with length bins: 

#Add new variable which encodes absolute word length bins of clickedObj

head(bdCorrect$typeLength)

# getAbsLengthLabel <- function(row) {
#   if(row$typeLength < 4) {
#     return "type_length_<4";
#   }
# }
# 
# if (bdCorrect$typeLength < 4) {
#   bdCorrect$absLength = "type_length_<4"
# # } else if (bdCorrect$typeLength < 7 & bdCorrect$typeLength > 3) {
# #   bdCorrect$absLength = "type_length_4-6"
# # } else if (bdCorrect$typeLength < 10 & bdCorrect$typeLength > 6) {
# #   bdCorrect$absLength = "type_length_7-9"
# } else {   #if (bdCorrect$Typelength > 9)
#   bdCorrect$absLength = "type_length_>10"
# }



# 4 bins
head(bdCorrect)
bdCorrect$typeNumOfChar = ifelse(bdCorrect$typeLength < 4, "01-03",
                                 ifelse((bdCorrect$typeLength < 7 & bdCorrect$typeLength > 3), "04-06", 
                                        ifelse((bdCorrect$typeLength < 10 & bdCorrect$typeLength > 6), "07-09", "10+" )))

head(bdCorrect$typeNumOfChar)
head(bdCorrect)

# plot histogram with probabilities

agr = bdCorrect %>%
  select(typeMentioned,superClassMentioned,superSuperClassMentioned, superclassattributeMentioned, domainClickedObj, condition, typeNumOfChar) %>%
  gather(Utterance,Mentioned,-condition, -domainClickedObj, -typeNumOfChar) %>%
  group_by(Utterance,condition, domainClickedObj, typeNumOfChar) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

dodge = position_dodge(.9)

ggplot(agr, aes(x=Utterance,y=Probability,fill=typeNumOfChar)) +
  #ggplot(agr, aes(x=Utterance,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  # geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(domainClickedObj~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/round2/proportion_mentioned_features_by_condition_by_domain_by_length_4bins.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability,fill=typeNumOfChar)) +
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(domainClickedObj~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/round2/proportion_mentioned_features_by_feature_by_domain_by_length_4bins.pdf",width=10,height=10)

droplevels(subset(bdCorrect, domainClickedObj == NA))

# 6 bins:


bdCorrect$typeNumOfChar6bins = ifelse(bdCorrect$typeLength < 4, "01-03",
                                      ifelse((bdCorrect$typeLength < 6 & bdCorrect$typeLength > 3), "04-05", 
                                             ifelse((bdCorrect$typeLength < 8 & bdCorrect$typeLength > 5), "06-07", 
                                                    ifelse((bdCorrect$typeLength < 10 & bdCorrect$typeLength > 7), "08-09",  
                                                           ifelse((bdCorrect$typeLength < 12 & bdCorrect$typeLength > 9), "10-11", "12+" )))))

head(bdCorrect$typeNumOfChar6bins)
head(bdCorrect)

# plot histogram with probabilities

agr = bdCorrect %>%
  select(typeMentioned,superClassMentioned,superSuperClassMentioned, superclassattributeMentioned, domainClickedObj, condition, typeNumOfChar6bins) %>%
  gather(Utterance,Mentioned,-condition, -domainClickedObj, -typeNumOfChar6bins) %>%
  group_by(Utterance,condition, domainClickedObj, typeNumOfChar6bins) %>%
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
  facet_grid(domainClickedObj~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/round2/proportion_mentioned_features_by_condition_by_domain_by_length_6bins.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability,fill=typeNumOfChar6bins)) +
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(domainClickedObj~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/round2/proportion_mentioned_features_by_feature_by_domain_by_length_6bins.pdf",width=10,height=10)








# results combined of round 1 and round 2:

theme_set(theme_bw(18))

setwd("/Users/cocolab/overinformativeness/experiments/3_numdistractors_basiclevel/results")
source("rscripts/helpers.r")

#load("data/r.RData")
d = read.table(file="data/results_modified_all.csv",sep=",", header=T, quote="")
d$Half = as.factor(ifelse(d$roundNum < 37, "first","second"))
d$Quarter = as.factor(ifelse(d$roundNum < 19, "first",ifelse(d$roundNum < 37,"second", ifelse(d$roundNum < 55, "third","fourth"))))
head(d)
nrow(d)
#d$speakerMessages
summary(d)
d[is.na(d$TypeMentioned),]$TypeMentioned = FALSE
d[is.na(d$otherFeatureMentioned),]$otherFeatureMentioned = FALSE
d[is.na(d$superClassMentioned),]$superClassMentioned = FALSE
d[is.na(d$superSuperClassMentioned),]$superSuperClassMentioned = FALSE
d[is.na(d$superclassattributeMentioned),]$superclassattributeMentioned = FALSE
d[is.na(d$utteranceContracted),]$utteranceContracted = FALSE

# how many unique pairs?
length(levels(d$gameid))

# Only look at basiclevel conditions: distr12, distr22, distr23, distr33:

#basiclevel data:
bd = droplevels(subset(d, condition == "distr12" | condition == "distr22" | condition == "distr23" | condition == "distr33"))
head(bd)
nrow(bd)
summary(bd)
totalnrow = nrow(bd)

table(bd$condition,bd$TypeMentioned)
table(bd$condition,bd$superClassMentioned)
table(bd$condition,bd$superSuperClassMentioned)
table(bd$condition,bd$superclassattributeMentioned)

# bd$liberalSupersuperclass = bd$superClassMentioned &

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
  select(TypeMentioned,superClassMentioned,superSuperClassMentioned, superclassattributeMentioned, condition) %>%
  gather(Feature,Mentioned,-condition)
agr$Feature = gsub("Mentioned","",as.character(agr$Feature))
agr = droplevels(subset(agr,Mentioned == "TRUE"))
head(agr)

# plot histogram of mentioned features by condition
ggplot(agr, aes(x=Feature)) +
  geom_histogram() +
  facet_wrap(~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/all/frequency_mentioned_features_by_condition.pdf",width=8,height=10)

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
  select(TypeMentioned,superClassMentioned,superSuperClassMentioned, superclassattributeMentioned, condition) %>%
  gather(Utterance,Mentioned,-condition) %>%
  group_by(Utterance,condition) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

ggplot(agr, aes(x=Utterance,y=Probability)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~condition) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/all/proportion_mentioned_features_by_condition.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~Utterance) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/all/proportion_mentioned_features_by_feature.pdf",width=10,height=10)

# We want to include the domain:

nrow(bdCorrect)
bdCorrect = droplevels(subset(bdCorrect, domainClickedObj != "NA"))
nrow(bdCorrect)

agr = bdCorrect %>%
  select(TypeMentioned,superClassMentioned,superSuperClassMentioned, superclassattributeMentioned, domainClickedObj, condition) %>%
  gather(Feature,Mentioned,-condition, -domainClickedObj)
agr$Feature = gsub("Mentioned","",as.character(agr$Feature))
agr = droplevels(subset(agr,Mentioned == "TRUE"))
head(agr)
summary(agr)

# plot histogram of mentioned features by condition
ggplot(agr, aes(x=Feature)) +
  geom_histogram() +
  facet_grid(domainClickedObj~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
#facet_wrap(~condition)
ggsave("graphs_basiclevel/all/frequency_mentioned_features_by_condition_by_domain.pdf",width=8,height=10)

# plot histogram with probabilities

agr = bdCorrect %>%
  select(TypeMentioned,superClassMentioned,superSuperClassMentioned, superclassattributeMentioned, domainClickedObj, condition) %>%
  gather(Utterance,Mentioned,-condition, -domainClickedObj) %>%
  group_by(Utterance,condition, domainClickedObj) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

ggplot(agr, aes(x=Utterance,y=Probability)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(domainClickedObj~condition) +
  #facet_wrap(~condition) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/all/proportion_mentioned_features_by_condition_by_domain.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(domainClickedObj~Utterance) +
  #facet_wrap(~Utterance) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/all/proportion_mentioned_features_by_feature_by_domain.pdf",width=10,height=10)

# Analysis including incorrect trials:

agr = bd %>%
  select(TypeMentioned,superClassMentioned,superSuperClassMentioned, superclassattributeMentioned, condition) %>%
  gather(Feature,Mentioned,-condition)
agr$Feature = gsub("Mentioned","",as.character(agr$Feature))
agr = droplevels(subset(agr,Mentioned == "TRUE"))
head(agr)

# plot histogram of mentioned features by condition
ggplot(agr, aes(x=Feature)) +
  geom_histogram() +
  facet_wrap(~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/all/all_frequency_mentioned_features_by_condition.pdf",width=8,height=10)

# plot histogram with probabilities

agr = bd %>%
  select(TypeMentioned,superClassMentioned,superSuperClassMentioned, superclassattributeMentioned, condition) %>%
  gather(Utterance,Mentioned,-condition) %>%
  group_by(Utterance,condition) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

ggplot(agr, aes(x=Utterance,y=Probability)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~condition) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/all/all_proportion_mentioned_features_by_condition.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~Utterance) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/all/all_proportion_mentioned_features_by_feature.pdf",width=10,height=10)

# We want to include the domain:
#!!!! I don't know if this makes sense, in incorrect trials the domain of the clicked obj is not the domain of the target

# Since we're including incorrect trials, the domain value may be NA.
# Exclude domain=NAs
nrow(bd)
bdNew = droplevels(bd[!is.na(bd$domainClickedObj),])
head(bdNew)
summary(bdNew)
nrow(bdNew)

agr = bdNew %>%
  select(TypeMentioned,superClassMentioned,superSuperClassMentioned, superclassattributeMentioned, domainClickedObj, condition) %>%
  gather(Feature,Mentioned,-condition, -domainClickedObj)
agr$Feature = gsub("Mentioned","",as.character(agr$Feature))
agr = droplevels(subset(agr,Mentioned == "TRUE"))
head(agr)
summary(agr)

# plot histogram of mentioned features by condition
ggplot(agr, aes(x=Feature)) +
  geom_histogram() +
  facet_grid(domainClickedObj~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
#facet_wrap(~condition)
ggsave("graphs_basiclevel/all/all_frequency_mentioned_features_by_condition_by_domain.pdf",width=8,height=10)

# plot histogram with probabilities

agr = bdNew %>%
  select(TypeMentioned,superClassMentioned,superSuperClassMentioned, superclassattributeMentioned, domainClickedObj, condition) %>%
  gather(Utterance,Mentioned,-condition, -domainClickedObj) %>%
  group_by(Utterance,condition, domainClickedObj) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

ggplot(agr, aes(x=Utterance,y=Probability)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(domainClickedObj~condition) +
  #facet_wrap(~condition) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/all/all_proportion_mentioned_features_by_condition_by_domain.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(domainClickedObj~Utterance) +
  #facet_wrap(~Utterance) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/all/all_proportion_mentioned_features_by_feature_by_domain.pdf",width=10,height=10)

# Analysis of word length effect: (only for correct trials!)

#Add new variable which encodes relative word length (shorter or longer) of type class to superclass
bdCorrect$typeLength = nchar(as.character(bdCorrect$nameClickedObj))
head(bdCorrect$typeLength)
bdCorrect$SuperClassLength = nchar(as.character(bdCorrect$domainClickedObj))
bdCorrect$TypeShorter = ifelse(bdCorrect$typeLength < bdCorrect$SuperClassLength, "type_shorter","type_longer")

# plot histogram with probabilities

agr = bdCorrect %>%
  select(TypeMentioned,superClassMentioned,superSuperClassMentioned, superclassattributeMentioned, domainClickedObj, condition, TypeShorter) %>%
  gather(Utterance,Mentioned,-condition, -domainClickedObj, -TypeShorter) %>%
  group_by(Utterance,condition, domainClickedObj, TypeShorter) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

dodge = position_dodge(.9)

ggplot(agr, aes(x=Utterance,y=Probability,fill=TypeShorter)) +
  #ggplot(agr, aes(x=Utterance,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  # geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(domainClickedObj~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/all/proportion_mentioned_features_by_condition_by_domain_by_length.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability,fill=TypeShorter)) +
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(domainClickedObj~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/all/proportion_mentioned_features_by_feature_by_domain_by_length.pdf",width=10,height=10)

# same analysis with length bins: 

#Add new variable which encodes absolute word length bins of clickedObj

head(bdCorrect$typeLength)

# 4 bins

bdCorrect$typeNumOfChar = ifelse(bdCorrect$typeLength < 4, "01-03",
                                 ifelse((bdCorrect$typeLength < 7 & bdCorrect$typeLength > 3), "04-06", 
                                        ifelse((bdCorrect$typeLength < 10 & bdCorrect$typeLength > 6), "07-09", "10+" )))

head(bdCorrect$typeNumOfChar)
head(bdCorrect)

# plot histogram with probabilities

agr = bdCorrect %>%
  select(TypeMentioned,superClassMentioned,superSuperClassMentioned, superclassattributeMentioned, domainClickedObj, condition, typeNumOfChar) %>%
  gather(Utterance,Mentioned,-condition, -domainClickedObj, -typeNumOfChar) %>%
  group_by(Utterance,condition, domainClickedObj, typeNumOfChar) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

dodge = position_dodge(.9)

ggplot(agr, aes(x=Utterance,y=Probability,fill=typeNumOfChar)) +
  #ggplot(agr, aes(x=Utterance,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  # geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(domainClickedObj~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/all/proportion_mentioned_features_by_condition_by_domain_by_length_4bins.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability,fill=typeNumOfChar)) +
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(domainClickedObj~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/all/proportion_mentioned_features_by_feature_by_domain_by_length_4bins.pdf",width=10,height=10)


# 6 bins:


bdCorrect$typeNumOfChar6bins = ifelse(bdCorrect$typeLength < 4, "01-03",
                                      ifelse((bdCorrect$typeLength < 6 & bdCorrect$typeLength > 3), "04-05", 
                                             ifelse((bdCorrect$typeLength < 8 & bdCorrect$typeLength > 5), "06-07", 
                                                    ifelse((bdCorrect$typeLength < 10 & bdCorrect$typeLength > 7), "08-09",  
                                                           ifelse((bdCorrect$typeLength < 12 & bdCorrect$typeLength > 9), "10-11", "12+" )))))

head(bdCorrect$typeNumOfChar6bins)
head(bdCorrect)

# plot histogram with probabilities

agr = bdCorrect %>%
  select(TypeMentioned,superClassMentioned,superSuperClassMentioned, superclassattributeMentioned, domainClickedObj, condition, typeNumOfChar6bins) %>%
  gather(Utterance,Mentioned,-condition, -domainClickedObj, -typeNumOfChar6bins) %>%
  group_by(Utterance,condition, domainClickedObj, typeNumOfChar6bins) %>%
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
  facet_grid(domainClickedObj~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/all/proportion_mentioned_features_by_condition_by_domain_by_length_6bins.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability,fill=typeNumOfChar6bins)) +
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(domainClickedObj~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/all/proportion_mentioned_features_by_feature_by_domain_by_length_6bins.pdf",width=10,height=10)


#############################################################

# Frequency analysis (only for correct trials!)

#load("data/r.RData")    (frequenciesAll)
frequencies = read.table(file="data/frequencyChart.csv",sep=",", header=T, quote="")

head(frequencies)
summary(frequencies)

frequenciesType = droplevels(subset(frequencies, noun != "animal" & noun != "building" & noun != "clothing" & noun != "dog" & noun != "flower" & noun != "food" & noun != "fruit" & noun != "furniture" & noun != "house" & noun != "instrument" & noun != "object" & noun != "plant" & noun != "vegetable" & noun != "vehicle"))

head(frequenciesType)
summary(frequenciesType)

#Add new variable to bdCorrect from frequencyChart
bdCorrect$relFreqType = ifelse(bdCorrect$nameClickedObj == "ambulance", (subset(frequencies, noun == "ambulance"))$relFreq, 
                           ifelse(bdCorrect$nameClickedObj == "banjo", (subset(frequencies, noun == "banjo"))$relFreq, 
                                  ifelse(bdCorrect$nameClickedObj == "bathrobe", (subset(frequencies, noun == "bathrobe"))$relFreq, 
                                         ifelse(bdCorrect$nameClickedObj == "bed", (subset(frequencies, noun == "bed"))$relFreq, 
                                                ifelse(bdCorrect$nameClickedObj == "belt2", (subset(frequencies, noun == "belt"))$relFreq, 
                                                       ifelse(bdCorrect$nameClickedObj == "bike2", (subset(frequencies, noun == "bike"))$relFreq, 
                                                              ifelse(bdCorrect$nameClickedObj == "boat", (subset(frequencies, noun == "boat"))$relFreq, 
                                                                     ifelse(bdCorrect$nameClickedObj == "bookcase", (subset(frequencies, noun == "bookcase"))$relFreq, 
                                                                            ifelse(bdCorrect$nameClickedObj == "bra", (subset(frequencies, noun == "bra"))$relFreq, 
                                                                                   ifelse(bdCorrect$nameClickedObj == "carrot", (subset(frequencies, noun == "carrot"))$relFreq, 
                                                                                          ifelse(bdCorrect$nameClickedObj == "clarinet", (subset(frequencies, noun == "clarinet"))$relFreq, 
                                                                                                 ifelse(bdCorrect$nameClickedObj == "corn", (subset(frequencies, noun == "corn"))$relFreq, 
                                                                                                        ifelse(bdCorrect$nameClickedObj == "cottage", (subset(frequencies, noun == "cottage"))$relFreq, 
                                                                                                               ifelse(bdCorrect$nameClickedObj == "daisy", (subset(frequencies, noun == "daisy"))$relFreq, 
                                                                                                                      ifelse(bdCorrect$nameClickedObj == "dalmatian", (subset(frequencies, noun == "dalmatian"))$relFreq, 
                                                                                                                             ifelse(bdCorrect$nameClickedObj == "eggplant", (subset(frequencies, noun == "eggplant"))$relFreq, 
                                                                                                                                    ifelse(bdCorrect$nameClickedObj == "firetruck", (subset(frequencies, noun == "firetruck"))$relFreq, 
                                                                                                                                           ifelse(bdCorrect$nameClickedObj == "germanShepherd", (subset(frequencies, noun == "German Shepherd"))$relFreq, 
                                                                                                                                                  ifelse(bdCorrect$nameClickedObj == "grapefruit", (subset(frequencies, noun == "grapefruit"))$relFreq, 
                                                                                                                                                         ifelse(bdCorrect$nameClickedObj == "husky", (subset(frequencies, noun == "husky"))$relFreq, 
                                                                                                                                                                ifelse(bdCorrect$nameClickedObj == "igloo", (subset(frequencies, noun == "igloo"))$relFreq, 
                                                                                                                                                                       ifelse(bdCorrect$nameClickedObj == "kiwi", (subset(frequencies, noun == "kiwi"))$relFreq, 
                                                                                                                                                                              ifelse(bdCorrect$nameClickedObj == "lamp", (subset(frequencies, noun == "lamp"))$relFreq, 
                                                                                                                                                                                     ifelse(bdCorrect$nameClickedObj == "lime", (subset(frequencies, noun == "lime"))$relFreq, 
                                                                                                                                                                                            ifelse(bdCorrect$nameClickedObj == "mushroom", (subset(frequencies, noun == "mushroom"))$relFreq, 
                                                                                                                                                                                                   ifelse(bdCorrect$nameClickedObj == "piano", (subset(frequencies, noun == "piano"))$relFreq, 
                                                                                                                                                                                                          ifelse(bdCorrect$nameClickedObj == "pineapple", (subset(frequencies, noun == "pineapple"))$relFreq, 
                                                                                                                                                                                                                 ifelse(bdCorrect$nameClickedObj == "pug", (subset(frequencies, noun == "pug"))$relFreq, 
                                                                                                                                                                                                                        ifelse(bdCorrect$nameClickedObj == "rose", (subset(frequencies, noun == "rose"))$relFreq, 
                                                                                                                                                                                                                               ifelse(bdCorrect$nameClickedObj == "saxophone", (subset(frequencies, noun == "saxophone"))$relFreq, 
                                                                                                                                                                                                                                      ifelse(bdCorrect$nameClickedObj == "sunflower", (subset(frequencies, noun == "sunflower"))$relFreq, 
                                                                                                                                                                                                                                             ifelse(bdCorrect$nameClickedObj == "swimsuit", (subset(frequencies, noun == "swimsuit"))$relFreq, 
                                                                                                                                                                                                                                                    ifelse(bdCorrect$nameClickedObj == "tent", (subset(frequencies, noun == "tent"))$relFreq, 
                                                                                                                                                                                                                                                           ifelse(bdCorrect$nameClickedObj == "trailer", (subset(frequencies, noun == "trailer"))$relFreq, 
                                                                                                                                                                                                                                                                  ifelse(bdCorrect$nameClickedObj == "tulip", (subset(frequencies, noun == "tulip"))$relFreq, 
                                                                                                                                                                                                                                                                         ifelse(bdCorrect$nameClickedObj == "wardrobe", (subset(frequencies, noun == "wardrobe"))$relFreq, "NA"))))))))))))))))))))))))))))))))))))
summary(bdCorrect$relFreqType)
head(bdCorrect$relFreqType)

# Convert to numeric:
bdCorrect$relFreqType = as.numeric(bdCorrect$relFreqType)


# same analyses with frequency bins: 

# 2 bins

# infrequent = smaller frequency that median frequency of 5.286e-06

medianFreqType = 2.059e-06
bdCorrect$infrequentMedian = ifelse(bdCorrect$relFreqType < medianFreqType, "less_frequent", "more_frequent")

meanFreqType = 8.575e-06
bdCorrect$infrequentMean = ifelse(bdCorrect$relFreqType < meanFreqType, "less_frequent", "more_frequent")

head(bdCorrect$infrequentMedian)
summary(bdCorrect$infrequentMedian)

head(bdCorrect$infrequentMean)
summary(bdCorrect$infrequentMean)

# plot histogram with probabilities
# A : Median frequency analysis

agr = bdCorrect %>%
  select(TypeMentioned,superClassMentioned,superSuperClassMentioned, superclassattributeMentioned, domainClickedObj, condition, infrequentMedian) %>%
  gather(Utterance,Mentioned,-condition, -domainClickedObj, -infrequentMedian) %>%
  group_by(Utterance,condition, domainClickedObj, infrequentMedian) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

dodge = position_dodge(.9)

ggplot(agr, aes(x=Utterance,y=Probability,fill=infrequentMedian)) +
  #ggplot(agr, aes(x=Utterance,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  # geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(domainClickedObj~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/frequencyAll/proportion_mentioned_features_by_condition_by_domain_by_frequency_2bins_median.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability,fill=infrequentMedian)) +
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(domainClickedObj~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/frequencyAll/proportion_mentioned_features_by_feature_by_domain_by_frequency_2bins_median.pdf",width=10,height=10)

# B : Mean frequency analysis

agr = bdCorrect %>%
  select(TypeMentioned,superClassMentioned,superSuperClassMentioned, superclassattributeMentioned, domainClickedObj, condition, infrequentMean) %>%
  gather(Utterance,Mentioned,-condition, -domainClickedObj, -infrequentMean) %>%
  group_by(Utterance,condition, domainClickedObj, infrequentMean) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

dodge = position_dodge(.9)

ggplot(agr, aes(x=Utterance,y=Probability,fill=infrequentMean)) +
  #ggplot(agr, aes(x=Utterance,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  # geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(domainClickedObj~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/frequencyAll/proportion_mentioned_features_by_condition_by_domain_by_frequency_2bins_mean.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability,fill=infrequentMean)) +
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(domainClickedObj~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/frequencyAll/proportion_mentioned_features_by_feature_by_domain_by_frequency_2bins_mean.pdf",width=10,height=10)


# 4 bins:

firstQuFreqType = 8.481e-07
medianFreqType = 2.059e-06
thirdQuFreqType = 1.192e-05

head(bdCorrect$relFreqType)
summary(bdCorrect$relFreqType)

bdCorrect$infrequentMedian4bins = ifelse(bdCorrect$relFreqType < firstQuFreqType, "least_frequent", 
                                         ifelse((bdCorrect$relFreqType > firstQuFreqType & bdCorrect$FreqType < medianFreqType), "less_frequent",
                                                ifelse((bdCorrect$relFreqType > medianFreqType & bdCorrect$relFreqType < thirdQuFreqType), "more_frequent", "most_frequent")))

head(bdCorrect$infrequentMedian4bins)
summary(bdCorrect$infrequentMedian4bins)

# plot histogram with probabilities
# A : Median frequency analysis

agr = bdCorrect %>%
  select(TypeMentioned,superClassMentioned,superSuperClassMentioned, superclassattributeMentioned, domainClickedObj, condition, infrequentMedian) %>%
  gather(Utterance,Mentioned,-condition, -domainClickedObj, -infrequentMedian) %>%
  group_by(Utterance,condition, domainClickedObj, infrequentMedian) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

dodge = position_dodge(.9)

ggplot(agr, aes(x=Utterance,y=Probability,fill=infrequentMedian)) +
  #ggplot(agr, aes(x=Utterance,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  # geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(domainClickedObj~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/frequencyAll/proportion_mentioned_features_by_condition_by_domain_by_frequency_2bins_median.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability,fill=infrequentMedian)) +
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(domainClickedObj~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/frequencyAll/proportion_mentioned_features_by_feature_by_domain_by_frequency_2bins_median.pdf",width=10,height=10)


