theme_set(theme_bw(18))

setwd("/Users/cocolab/overinformativeness/experiments/3_numdistractors_basiclevel/results")
source("rscripts/helpers.r")

#load("data/r.RData")
d1 = read.table(file="data/results_modified_round1.csv",sep=",", header=T, quote="")
d2 = read.table(file="data/results_modified_round2.csv",sep=",", header=T, quote="")
d2$TypeMentioned = d2$typeMentioned
d = merge(d1,d2,all=T)
d$Half = as.factor(ifelse(d$roundNum < 37, "first","second"))
d$Quarter = as.factor(ifelse(d$roundNum < 19, "first",ifelse(d$roundNum < 37,"second", ifelse(d$roundNum < 55, "third","fourth"))))
head(d)
nrow(d)
#d$speakerMessages
summary(d)
totalnrow = nrow(d)
totalnrow
d[is.na(d$TypeMentioned),]$TypeMentioned = FALSE
d[is.na(d$otherFeatureMentioned),]$otherFeatureMentioned = FALSE
d[is.na(d$superClassMentioned),]$superClassMentioned = FALSE
d[is.na(d$superSuperClassMentioned),]$superSuperClassMentioned = FALSE
d[is.na(d$superclassattributeMentioned),]$superclassattributeMentioned = FALSE
d[is.na(d$utteranceContracted),]$utteranceContracted = FALSE

# look at turker comments
c1 = read.table(file="data/overinf_round1.csv",sep=",", header=T, quote="")
c2 = read.table(file="data/overinf_round2.csv",sep=",", header=T, quote="")
comments = rbind(c1,c2)
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
ggsave("graphs_basiclevel/frequency_mentioned_features_by_condition.pdf",width=8,height=10)

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
ggsave("graphs_basiclevel/proportion_mentioned_features_by_condition.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~Utterance) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/proportion_mentioned_features_by_feature.pdf",width=10,height=10)

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
ggsave("graphs_basiclevel/frequency_mentioned_features_by_condition_by_domain.pdf",width=8,height=10)

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
ggsave("graphs_basiclevel/proportion_mentioned_features_by_condition_by_domain.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(domainClickedObj~Utterance) +
  #facet_wrap(~Utterance) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/proportion_mentioned_features_by_feature_by_domain.pdf",width=10,height=10)

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
ggsave("graphs_basiclevel/all_frequency_mentioned_features_by_condition.pdf",width=8,height=10)

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
ggsave("graphs_basiclevel/all_proportion_mentioned_features_by_condition.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~Utterance) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/all_proportion_mentioned_features_by_feature.pdf",width=10,height=10)

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
ggsave("graphs_basiclevel/all_frequency_mentioned_features_by_condition_by_domain.pdf",width=8,height=10)

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
ggsave("graphs_basiclevel/all_proportion_mentioned_features_by_condition_by_domain.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(domainClickedObj~Utterance) +
  #facet_wrap(~Utterance) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/all_proportion_mentioned_features_by_feature_by_domain.pdf",width=10,height=10)

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
# ggsave("graphs_basiclevel/dogs_frequency_mentioned_features_by_condition.pdf",width=8,height=10)

# Analysis of word length effect: (only for correct trials!)

#Add new variable which encodes relative word length (shorter or longer) of type class to superclass
bdCorrect$TypeLength = nchar(as.character(bdCorrect$nameClickedObj))
head(bdCorrect$TypeLength)
bdCorrect$SuperClassLength = nchar(as.character(bdCorrect$domainClickedObj))
bdCorrect$TypeShorter = ifelse(bdCorrect$TypeLength < bdCorrect$SuperClassLength, "type_shorter","type_longer")

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
ggsave("graphs_basiclevel/proportion_mentioned_features_by_condition_by_domain_by_length.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability,fill=TypeShorter)) +
#ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(domainClickedObj~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/proportion_mentioned_features_by_feature_by_domain_by_length.pdf",width=10,height=10)

# same analysis with length bins: 

#Add new variable which encodes absolute word length bins of clickedObj

head(bdCorrect$TypeLength)

# getAbsLengthLabel <- function(row) {
#   if(row$TypeLength < 4) {
#     return "type_length_<4";
#   }
# }
# 
# if (bdCorrect$TypeLength < 4) {
#   bdCorrect$absLength = "type_length_<4"
# # } else if (bdCorrect$TypeLength < 7 & bdCorrect$TypeLength > 3) {
# #   bdCorrect$absLength = "type_length_4-6"
# # } else if (bdCorrect$TypeLength < 10 & bdCorrect$TypeLength > 6) {
# #   bdCorrect$absLength = "type_length_7-9"
# } else {   #if (bdCorrect$Typelength > 9)
#   bdCorrect$absLength = "type_length_>10"
# }



# 4 bins

bdCorrect$typeNumOfChar = ifelse(bdCorrect$TypeLength < 4, "01-03",
                             ifelse((bdCorrect$TypeLength < 7 & bdCorrect$TypeLength > 3), "04-06", 
                                    ifelse((bdCorrect$TypeLength < 10 & bdCorrect$TypeLength > 6), "07-09", "10+" )))

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
ggsave("graphs_basiclevel/proportion_mentioned_features_by_condition_by_domain_by_length_4bins.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability,fill=typeNumOfChar)) +
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(domainClickedObj~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/proportion_mentioned_features_by_feature_by_domain_by_length_4bins.pdf",width=10,height=10)


# 6 bins:


bdCorrect$typeNumOfChar6bins = ifelse(bdCorrect$TypeLength < 4, "01-03",
                                 ifelse((bdCorrect$TypeLength < 6 & bdCorrect$TypeLength > 3), "04-05", 
                                        ifelse((bdCorrect$TypeLength < 8 & bdCorrect$TypeLength > 5), "06-07", 
                                               ifelse((bdCorrect$TypeLength < 10 & bdCorrect$TypeLength > 7), "08-09",  
                                                      ifelse((bdCorrect$TypeLength < 12 & bdCorrect$TypeLength > 9), "10-11", "12+" )))))

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
ggsave("graphs_basiclevel/proportion_mentioned_features_by_condition_by_domain_by_length_6bins.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability,fill=typeNumOfChar6bins)) +
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(domainClickedObj~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/proportion_mentioned_features_by_feature_by_domain_by_length_6bins.pdf",width=10,height=10)


  
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



