theme_set(theme_bw(18))
setwd("/Users/cocolab/overinformativeness/experiments/3_numdistractors_basiclevel/results")
#setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/3_numdistractors_basiclevel/results")
source("rscripts/helpers.r")

#load("data/r.RData")
d = read.table(file="data/results_modified.csv",sep=",", header=T, quote="")
head(d)
nrow(d)
d$speakerMessages
summary(d)
totalnrow = nrow(d)
d$Half = as.factor(ifelse(d$roundNum < 37, "first","second"))
d$Quarter = as.factor(ifelse(d$roundNum < 19, "first",ifelse(d$roundNum < 37,"second", ifelse(d$roundNum < 55, "third","fourth"))))

# look at turker comments
comments = read.table(file="data/overinf.csv",sep=",", header=T, quote="")
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

table(d$condition,d$typeMentioned)
table(d$condition,d$colorMentioned)
table(d$condition,d$sizeMentioned)

d = droplevels(d[d$targetStatusClickedObj != "distractor",])
print(paste("percentage of excluded trials because distractor was chosen: ", (totalnrow -nrow(d))*100/totalnrow))

targets = droplevels(subset(d, condition != "filler"))
nrow(targets) # 319 cases
agr = targets %>%
  select(sizeMentioned,colorMentioned,typeMentioned,condition) %>%
  gather(Feature,Mentioned,-condition)
agr$Feature = gsub("Mentioned","",as.character(agr$Feature))
agr = droplevels(subset(agr,Mentioned == "TRUE"))
head(agr)

# plot histogram of mentioned features by condition
ggplot(agr, aes(x=Feature)) +
  geom_histogram() +
  facet_wrap(~condition)
ggsave("graphs/mentioned_features_by_condition.pdf",width=8,height=3.5)

targets$UtteranceType = as.factor(ifelse(targets$sizeMentioned & targets$colorMentioned, "size and color", ifelse(targets$sizeMentioned, "size", ifelse(targets$colorMentioned, "color","OTHER"))))
targets = droplevels(targets[!is.na(targets$UtteranceType),])
targets[targets$UtteranceType == "OTHER",c("gameid","refExp")]
table(targets[targets$UtteranceType == "OTHER",]$gameid)
targets$Color = ifelse(targets$UtteranceType == "color",1,0)
targets$Size = ifelse(targets$UtteranceType == "size",1,0)
targets$SizeAndColor = ifelse(targets$UtteranceType == "size and color",1,0)
targets$Other = ifelse(targets$UtteranceType == "OTHER",1,0)
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
ggsave("graphs/mentioned_features_by_condition_other.pdf",width=10,height=3.5)

fillers = droplevels(subset(d, condition == "filler"))
#fillers$AnyTypeMentioned = fillers$typeMentioned | fillers$otherFeatureMentioned
ggplot(fillers, aes(x=typeMentioned)) +
  geom_histogram()


# plot individual variation on targets
# 4 people tend to always mention color redundantly in the size-only condition
# 3 pepole tend to only mention size in the size-only condition (plus 2 who seem to prefer size only but are sometimes redundant)
# all the redundant size mentions in the color-only condition come from three subjects
ggplot(targets, aes(x=UtteranceType,fill=condition)) +
  geom_histogram() +
  facet_wrap(~gameid) +
  theme(axis.text.x=element_text(angle=45,hjust=1,vjust=1))
ggsave("graphs/individual_variation.pdf",width=8,height=7)
