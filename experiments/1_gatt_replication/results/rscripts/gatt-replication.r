theme_set(theme_bw(18))
setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/1_gatt_replication/results")
source("rscripts/helpers.r")

#load("data/r.RData")
d = read.table(file="data/results.csv",sep="\t", header=T, quote="")
d = read.table(file="data/results_modified.csv",sep=",", header=T, quote="")
head(d)
nrow(d)
d$speakerMessages
summary(d)

table(d$condition,d$typeMentioned)
table(d$condition,d$colorMentioned)
table(d$condition,d$sizeMentioned)

targets = droplevels(subset(d, condition != "filler"))
nrow(targets)
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


size = as.data.frame(prop.table(table(targets$condition,targets$sizeMentioned),mar=c(1)))
colnames(size) = c("condition","mentioned","freq_size")

color = as.data.frame(prop.table(table(targets$condition,targets$colorMentioned),mar=c(1)))
colnames(color) = c("condition","mentioned","freq_color")
row.names(color) = paste(color$condition,color$mentioned)

type = as.data.frame(prop.table(table(targets$condition,targets$typeMentioned),mar=c(1)))
colnames(type) = c("condition","mentioned","freq_type")
row.names(type) = paste(type$condition,type$mentioned)

size$freq_color = color[paste(size$condition,size$mentioned),]$freq_color
size$freq_type = type[paste(size$condition,size$mentioned),]$freq_type

#size = droplevels(subset(size, mentioned == "TRUE"))
agr = size %>%
  gather(Feature, Mentioned, -condition, -mentioned)
agr$Feature = gsub("freq_","",as.character(agr$Feature))
agr
ggplot(agr, aes(x=Feature,y=Mentioned)) +
  geom_bar(stat="identity") +
  ylab("Proportion of feature mention") +
  facet_wrap(~condition)
ggsave("graphs/mentioned_features_by_condition.pdf",width=8,height=3.5)

targets$UtteranceType = as.factor(ifelse(targets$sizeMentioned & targets$colorMentioned, "size and color", ifelse(targets$sizeMentioned, "size", ifelse(targets$colorMentioned, "color","OTHER"))))

ggplot(targets, aes(x=UtteranceType)) +
  geom_histogram() +
  facet_wrap(~condition)
ggsave("graphs/mentioned_features_by_condition_other.pdf",width=10,height=3.5)

fillers = droplevels(subset(d, condition == "filler"))
fillers$AnyTypeMentioned = fillers$typeMentioned | fillers$otherFeatureMentioned
ggplot(fillers, aes(x=AnyTypeMentioned)) +
  geom_histogram()

