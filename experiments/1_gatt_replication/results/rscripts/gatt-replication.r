theme_set(theme_bw(18))
setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/1_gatt_replication/results")
source("rscripts/helpers.r")

#load("data/r.RData")
d = read.table(file="data/results.csv",sep="\t", header=T, quote="")
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
agr = droplevels(subset(agr,Mentioned == "True"))
head(agr)

# plot histogram of mentioned features by condition
ggplot(agr, aes(x=Feature)) +
  geom_histogram() +
  facet_wrap(~condition)
ggsave("graphs/mentioned_features_by_condition.pdf",width=8,height=3.5)
