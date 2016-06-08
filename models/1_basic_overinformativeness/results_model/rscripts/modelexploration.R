setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/1_basic_overinformativeness/")

dlistener = read.table("results_model/data/listener.csv",sep=",")
colnames(dlistener) = c("alpha","lengthWeight","typicality_color","typicality_size","cost_color","cost_size","utterance","object","probability")
head(dlistener)
summary(dlistener)

dspeaker = read.table("results_model/data/speaker.csv",sep=",")
colnames(dspeaker) = c("alpha","lengthWeight","typicality_color","typicality_size","cost_color","cost_size","sufficientdimension","utterance","probability")
head(dspeaker)
summary(dspeaker)
nrow(dspeaker)

d = dspeaker
d$typicality_size = as.factor(as.character(d$typicality_size))
ggplot(d[d$cost_color == .5 & d$cost_size == .5 & d$ sufficientdimension == "size_sufficient" & d$lengthWeight == 1,], aes(x=typicality_color,y=probability,color=typicality_size,group=typicality_size)) +
  geom_point() +
  geom_line() +
  facet_grid(alpha~utterance)
