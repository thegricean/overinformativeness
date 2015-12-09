theme_set(theme_bw(18))

setwd("/Users/cocolab/overinformativeness/experiments/4_numdistractors_basiclevel_newitems/results")
source("rscripts/helpers.r")

#load("data/r.RData")
#<<<<<<< HEAD
d = read.table(file="data/results_modified.csv",sep=",", header=T, quote="")
# =======
# d1 = read.table(file="data/results_modified_round1.csv",sep=",", header=T, quote="")
# d2 = read.table(file="data/results_modified_round2.csv",sep=",", header=T, quote="")
# d2$typeMentioned = d2$typeMentioned
# d = merge(d1,d2,all=T)
# >>>>>>> c766de1c18e2962fbdfce98c8e13a67b7b608a81
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
#<<<<<<< HEAD
comments = read.table(file="data/overinf_round1.csv",sep=",", header=T, quote="")
# =======
# c1 = read.table(file="data/overinf_round1.csv",sep=",", header=T, quote="")
# c2 = read.table(file="data/overinf_round2.csv",sep=",", header=T, quote="")
# comments = rbind(c1,c2)
# >>>>>>> c766de1c18e2962fbdfce98c8e13a67b7b608a81
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

# bd$liberalSupersuperclass = bd$basiclevelMentioned &

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
  select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, condition) %>%
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

# We want to include the domain:

#Get rid of domain == NA

bdCorrect = droplevels(bdCorrect[!is.na(bdCorrect$basiclevelClickedObj),])
summary(bdCorrect)

agr = bdCorrect %>%
  select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, basiclevelClickedObj, condition) %>%
  gather(Feature,Mentioned,-condition, -basiclevelClickedObj)
agr$Feature = gsub("Mentioned","",as.character(agr$Feature))
agr = droplevels(subset(agr,Mentioned == "TRUE"))
head(agr)
summary(agr)

# plot histogram of mentioned features by condition
ggplot(agr, aes(x=Feature)) +
  geom_histogram() +
  facet_grid(basiclevelClickedObj~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
  #facet_wrap(~condition)
ggsave("graphs_basiclevel/frequency_mentioned_features_by_condition_by_domain.pdf",width=8,height=10)

# plot histogram with probabilities

agr = bdCorrect %>%
  select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, basiclevelClickedObj, condition) %>%
  gather(Utterance,Mentioned,-condition, -basiclevelClickedObj) %>%
  group_by(Utterance,condition, basiclevelClickedObj) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

ggplot(agr, aes(x=Utterance,y=Probability)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(basiclevelClickedObj~condition) +
  #facet_wrap(~condition) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/proportion_mentioned_features_by_condition_by_domain.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(basiclevelClickedObj~Utterance) +
  #facet_wrap(~Utterance) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/proportion_mentioned_features_by_feature_by_domain.pdf",width=10,height=10)

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

######################################################################################

# Analysis of word length effect: (only for correct trials!)

#Add new variable which encodes relative word length (shorter or longer) of type class to superclass
bdCorrect$typeLength = nchar(as.character(bdCorrect$nameClickedObj))
head(bdCorrect$typeLength)
bdCorrect$SuperClassLength = nchar(as.character(bdCorrect$basiclevelClickedObj))
bdCorrect$TypeShorter = ifelse(bdCorrect$typeLength < bdCorrect$SuperClassLength, "type_shorter","type_longer")

# plot histogram with probabilities

agr = bdCorrect %>%
  select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, basiclevelClickedObj, condition, TypeShorter) %>%
  gather(Utterance,Mentioned,-condition, -basiclevelClickedObj, -TypeShorter) %>%
  group_by(Utterance,condition, basiclevelClickedObj, TypeShorter) %>%
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
  facet_grid(basiclevelClickedObj~condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/length_proportion_mentioned_features_by_condition_by_domain_by_length.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability,fill=TypeShorter)) +
#ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(basiclevelClickedObj~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/length_proportion_mentioned_features_by_feature_by_domain_by_length.pdf",width=10,height=10)

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


# 2 bins

#What's the medium word length?
summary(bdCorrect$typeLength)
# mean = 8.229, median = 9

bdCorrect$typeNumOfChar2bins = ifelse(bdCorrect$typeLength < 10, "01-09", "10+" )

head(bdCorrect$typeNumOfChar2bins)
head(bdCorrect)

# plot histogram with probabilities

agr = bdCorrect %>%
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
ggsave("graphs_basiclevel/length2bins_proportion_mentioned_features_by_condition_by_domain_by_length_2bins.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability,fill=typeNumOfChar2bins)) +
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(basiclevelClickedObj~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/length2bins_proportion_mentioned_features_by_feature_by_domain_by_length_2bins.pdf",width=10,height=10)



# 4 bins

bdCorrect$typeNumOfChar4bins = ifelse(bdCorrect$typeLength < 4, "01-03",
                                      ifelse((bdCorrect$typeLength < 7 & bdCorrect$typeLength > 3), "04-06", 
                                             ifelse((bdCorrect$typeLength < 10 & bdCorrect$typeLength > 6), "07-09", "10+" )))

head(bdCorrect$typeNumOfChar4bins)
head(bdCorrect)

# plot histogram with probabilities

agr = bdCorrect %>%
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
ggsave("graphs_basiclevel/length4bins_proportion_mentioned_features_by_condition_by_domain_by_length_4bins.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability,fill=typeNumOfChar4bins)) +
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(basiclevelClickedObj~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/length4bins_proportion_mentioned_features_by_feature_by_domain_by_length_4bins.pdf",width=10,height=10)


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
ggsave("graphs_basiclevel/length6bins_proportion_mentioned_features_by_condition_by_domain_by_length_6bins.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability,fill=typeNumOfChar6bins)) +
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(basiclevelClickedObj~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/length6bins_proportion_mentioned_features_by_feature_by_domain_by_length_6bins.pdf",width=10,height=10)

# 8 bins:


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
ggsave("graphs_basiclevel/length8bins_proportion_mentioned_features_by_condition_by_domain_by_length_8bins.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability,fill=typeNumOfChar8bins)) +
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(basiclevelClickedObj~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/length8bins_proportion_mentioned_features_by_feature_by_domain_by_length_8bins.pdf",width=10,height=10)



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




# Convert to numeric:
bdCorrect$relFreqType = as.numeric(bdCorrect$relFreqType)
bdCorrect$relFreqBasiclevel = as.numeric(bdCorrect$relFreqBasiclevel)
bdCorrect$relFreqSuperdomain = as.numeric(bdCorrect$relFreqSuperdomain)


head(bdCorrect$relFreqType)
head(bdCorrect$relFreqBasiclevel)
head(bdCorrect$relFreqSuperdomain)


summary(bdCorrect$relFreqType)
summary(bdCorrect$relFreqBasiclevel)
summary(bdCorrect$relFreqSuperdomain)



# same analyses with frequency bins: 

# 2 bins

# infrequent = smaller frequency that median frequency of 5.286e-06

medianFreqType = 4.970e-07

bdCorrect$freqMedian2bins = ifelse(bdCorrect$typeFreqToBasiclevelFreqRatio < medianFreqType | bdCorrect$typeFreqToBasiclevelFreqRatio == medianFreqType, "less_frequent", "more_frequent")
head(bdCorrect$freqMedian2bins)

# plot histogram with probabilities
# Median frequency analysis

agr = bdCorrect %>%
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
ggsave("graphs_basiclevel/proportion_mentioned_features_by_condition_by_domain_by_frequency_2bins_median.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability,fill=freqMedian2bins)) +
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(basiclevelClickedObj~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/proportion_mentioned_features_by_feature_by_domain_by_frequency_2bins_median.pdf",width=10,height=10)


# 4 bins:

firstQuFreqType = 1.63e-07
thirdQuFreqType = 1.05e-06

head(bdCorrect$typeFreqToBasiclevelFreqRatio)
summary(bdCorrect$typeFreqToBasiclevelFreqRatio)

bdCorrect$freqMedian4bins = ifelse(as.numeric(bdCorrect$typeFreqToBasiclevelFreqRatio) < firstQuFreqType, "least_frequent", 
                                         ifelse(as.numeric(bdCorrect$typeFreqToBasiclevelFreqRatio) < medianFreqType, "less_frequent",
                                                ifelse(as.numeric(bdCorrect$typeFreqToBasiclevelFreqRatio) < thirdQuFreqType,"more_frequent", "most_frequent")))

head(bdCorrect$freqMedian4bins)
summary(bdCorrect$freqMedian4bins)

# plot histogram with probabilities
# Median frequency analysis

agr = bdCorrect %>%
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
ggsave("graphs_basiclevel/proportion_mentioned_features_by_condition_by_domain_by_frequency_4bins_median.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability,fill=freqMedian4bins)) +
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(basiclevelClickedObj~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/proportion_mentioned_features_by_feature_by_domain_by_frequency_4bins_median.pdf",width=10,height=10)


# Analysis of the relative frequency of the sublevel and corresponding basiclevel term:

bdCorrect$typeFreqToBasiclevelFreqRatio = bdCorrect$relFreqType / bdCorrect$relFreqBasiclevel

head(bdCorrect$typeFreqToBasiclevelFreqRatio)
summary(bdCorrect$typeFreqToBasiclevelFreqRatio)

# 2 bins

medianFreqRatio = 0.0062600

bdCorrect$freqMedianRatio2bins = ifelse(bdCorrect$typeFreqToBasiclevelFreqRatio < medianFreqRatio, "smaller_ratio_Type/BL", "bigger_ratio_Type/BL")
head(bdCorrect$freqMedianRatio2bins)

# plot histogram with probabilities
# Median frequency analysis

agr = bdCorrect %>%
  select(typeMentioned,basiclevelMentioned,superClassMentioned, superclassattributeMentioned, basiclevelClickedObj, condition, freqMedianRatio2bins) %>%
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
ggsave("graphs_basiclevel/proportion_mentioned_features_by_condition_by_domain_by_frequencyRatio_2bins_median.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability,fill=freqMedianRatio2bins)) +
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(basiclevelClickedObj~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/proportion_mentioned_features_by_feature_by_domain_by_frequencyRatio_2bins_median.pdf",width=10,height=10)


# 4 bins:

firstQuFreqRatio = 0.0023190
thirdQuFreqRatio = 0.0265000

head(bdCorrect$relFreqType)
summary(bdCorrect$relFreqType)

bdCorrect$freqMedianRatio4bins = ifelse(as.numeric(bdCorrect$typeFreqToBasiclevelFreqRatio) < firstQuFreqRatio, "smallest_ratio_Type/BL", 
                                        ifelse(as.numeric(bdCorrect$typeFreqToBasiclevelFreqRatio) < medianFreqRatio, "smaller_ratio_Type/BL",
                                               ifelse(as.numeric(bdCorrect$typeFreqToBasiclevelFreqRatio) < thirdQuFreqRatio,"bigger_ratio_Type/BL", "biggest_ratio_Type/BL")))

head(bdCorrect$freqMedianRatio4bins)
summary(bdCorrect$freqMedianRatio4bins)

# plot histogram with probabilities
# Median frequency analysis

agr = bdCorrect %>%
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
ggsave("graphs_basiclevel/proportion_mentioned_features_by_condition_by_domain_by_frequencyRatio_4bins_median.pdf",width=10,height=10)

ggplot(agr, aes(x=condition,y=Probability,fill=freqMedianRatio4bins)) +
  #ggplot(agr, aes(x=condition,y=Probability)) +
  #dodge = position_dodge(.9) +
  geom_bar(stat="identity",position=dodge) +
  #geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(basiclevelClickedObj~Utterance) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("graphs_basiclevel/proportion_mentioned_features_by_feature_by_domain_by_frequencyRatio_4bins_median.pdf",width=10,height=10)

