theme_set(theme_bw(18))
setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/1_gatt_replication/results")
source("rscripts/helpers.r")

d = read.table(file="data/results_round3_modified.csv",sep=",", header=T, quote="")
d = read.table(file="data/results_round3.csv",sep="\t", header=T, quote="")
head(d)
nrow(d)
d$speakerMessages
summary(d)
totalnrow = nrow(d)
d$Half = as.factor(ifelse(d$roundNum < 55, "first","second"))
d$Quarter = as.factor(ifelse(d$roundNum < 28, "first",ifelse(d$roundNum < 55,"second", ifelse(d$roundNum < 82, "third","fourth"))))

# look at turker comments
comments = read.table(file="data/overinf_round3.csv",sep=",", header=T, quote="")
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
chisq.test(table(d$condition,d$targetStatusClickedObj))
# exclude data from two pairs where the speaker consistently used locatives:

#d = droplevels(d[! d$gameid %in% c("5721-4","8263-2"),])
#print(paste("percentage of excluded trials because speaker consistently used locative modifiers: ", (totalnrow -nrow(d))*100/totalnrow))

table(d$condition,d$typeMentioned)
table(d$condition,d$colorMentioned)
table(d$condition,d$sizeMentioned)

d = droplevels(d[d$targetStatusClickedObj != "distractor",])
print(paste("percentage of excluded trials because distractor was chosen: ", (totalnrow -nrow(d))*100/totalnrow))

# in total: 21% data exclusion

targets = droplevels(subset(d, condition != "filler"))
nrow(targets) # 633 cases
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
ggsave("graphs_round2/mentioned_features_by_condition.pdf",width=8,height=3.5)

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
ggsave("graphs_round2/mentioned_features_by_condition_other.pdf",width=10,height=3.5)

# plot by half
agr = targets %>%
  select(Color,Size,SizeAndColor,Other,condition,Half) %>%
  gather(Utterance,Mentioned,-condition,-Half) %>%
  group_by(Utterance,condition,Half) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
dodge = position_dodge(.9)

ggplot(agr, aes(x=Utterance,y=Probability,fill=Half)) +
  geom_bar(stat="identity",position=dodge) +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25,position=dodge) +
  facet_wrap(~condition)
ggsave("graphs_round2/mentioned_features_by_condition_other_half.pdf",width=10,height=3.5)

# plot by quarter
agr = targets %>%
  select(Color,Size,SizeAndColor,Other,condition,Quarter) %>%
  gather(Utterance,Mentioned,-condition,-Quarter) %>%
  group_by(Utterance,condition,Quarter) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
dodge = position_dodge(.9)

ggplot(agr, aes(x=Utterance,y=Probability,fill=Quarter)) +
  geom_bar(stat="identity",position=dodge) +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25,position=dodge) +
  facet_wrap(~condition)
ggsave("graphs_round2/mentioned_features_by_condition_other_quarter.pdf",width=10,height=3.5)

# plot individual variation on targets
# 10 people tend to always mention color redundantly in the size-only condition
# 7 pepole tend to only mention size in the size-only condition
# all the redundant size mentions in the color-only condition come from one subject
ggplot(targets, aes(x=UtteranceType,fill=condition)) +
  geom_histogram() +
  facet_wrap(~gameid) +
  theme(axis.text.x=element_text(angle=45,hjust=1,vjust=1))
ggsave("graphs_round2/individual_variation.pdf",width=10,height=8)


### FILLER ANALYSIS

# how often was type mentioned on filler trials?
fillers = droplevels(subset(d, condition == "filler"))
fillers[is.na(fillers$superclassMentioned),]$superclassMentioned = FALSE
fillers[is.na(fillers$otherFeatureMentioned),]$otherFeatureMentioned = FALSE

ggplot(fillers, aes(x=typeMentioned)) +
  geom_histogram()

# people rarely use size on fillers
ggplot(fillers, aes(x=sizeMentioned)) +
  geom_histogram()

ggplot(fillers, aes(x=colorMentioned)) +
  geom_histogram()

ggplot(fillers, aes(x=superclassMentioned)) +
  geom_histogram()

ggplot(fillers, aes(x=otherFeatureMentioned)) +
  geom_histogram()

gathered = fillers %>%
  select(typeMentioned, sizeMentioned, colorMentioned, superclassMentioned, otherFeatureMentioned) %>%
  gather(Feature, Mentioned)
summary(gathered)

ggplot(gathered, aes(x=Mentioned)) +
  geom_histogram() +
  facet_wrap(~Feature)
ggsave("graphs_round2/fillers.pdf",width=8,height=6)

# test for individual variation in fillers
gathered = fillers %>%
  select(typeMentioned, sizeMentioned, colorMentioned, superclassMentioned, otherFeatureMentioned,gameid) %>%
  gather(Feature, Mentioned,-gameid)# %>%
  #group_by(gameid,Feature,Mentioned)
t = as.data.frame(prop.table(table(gathered$gameid,gathered$Feature,gathered$Mentioned),mar=c(1,2)))
colnames(t) = c("gameid","Feature","Mentioned","Proportion")
t[t$gameid == "0313-5",]
t = droplevels(subset(t, Mentioned == TRUE))

t$Feature = gsub("Mentioned","",as.character(t$Feature))
ggplot(t, aes(x=Feature,y=Proportion,fill=Feature)) +
  geom_bar(stat="identity") +
  facet_wrap(~gameid) +
  theme(axis.text.x=element_text(angle=45,hjust=1,vjust=1))
ggsave("graphs_round2/fillers_individuals.pdf",width=11,height=9)

# get only the guys who usually say "type", to look at some examples of where they say "superclass"
super_short = droplevels(subset(fillers,gameid %in% c("4194-7","5357-c","7844-6","8223-f","1022-7","3261-5") & superclassMentioned == TRUE))
nrow(super_short)
super_short[,c("gameid","refExp","nameClickedObj","alt1Name","alt2Name")]

super_long = droplevels(subset(fillers,! (gameid %in% c("4194-7","5357-c","7844-6","8223-f","1022-7","3261-5")) & superclassMentioned == TRUE))
nrow(super_long)
super_long[,c("gameid","refExp","nameClickedObj","alt1Name","alt2Name")]

other_short = droplevels(subset(fillers, ! (gameid %in% c("2036-f","2809-4","3700-f","5518-8","3075-1","8879-f")) & otherFeatureMentioned == TRUE))
nrow(other_short)
other_short[,c("gameid","refExp","nameClickedObj","alt1Name","alt2Name")]

other_long = droplevels(subset(fillers,gameid %in% c("2036-f","2809-4","3700-f","5518-8","3075-1","8879-f") & otherFeatureMentioned == TRUE))
nrow(other_long)
other_long[,c("gameid","refExp","nameClickedObj","alt1Name","alt2Name")]

color = droplevels(subset(fillers, colorMentioned == TRUE))
nrow(color)
color[,c("gameid","refExp","nameClickedObj","alt1Name","alt2Name")]


### ANALYSIS
m = glmer(colorMentioned ~ condition + (1|gameid),family="binomial",data=targets)
summary(m)
