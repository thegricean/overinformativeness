setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/1_basic_overinformativeness/")

typtype = "unlogged" 
# typtype = "logged"
searchtype = "wide"
# searchtype = "narrow"
######### PLOT SPEAKER #########

dspeaker = read.table(paste("results_model/data/scene_variation/speaker_",typtype,"_",searchtype,".csv",sep=""),sep=",")
colnames(dspeaker) = c("alpha","lengthWeight","typicality_color","typicality_size","typicality_type","cost_color","cost_size","condition","utterance","probability")
dspeaker$sufficientdimension = sapply(strsplit(as.character(dspeaker$condition),"_"), "[", 1)
dspeaker$numdistractors = as.numeric(as.character(sapply(strsplit(as.character(dspeaker$condition),"_"), "[", 2)))
dspeaker$numsame = as.numeric(as.character(sapply(strsplit(as.character(dspeaker$condition),"_"), "[", 3)))
dspeaker$numdiff = dspeaker$numdistractors - dspeaker$numsame
dspeaker$scenevariation = dspeaker$numdiff/dspeaker$numdistractors
dspeaker$utterancetype = "other"
dspeaker[dspeaker$utterance == "big_blue_thing",]$utterancetype = "redundant"
dspeaker$ratiodifftosame = dspeaker$numdiff/dspeaker$numsame
dspeaker[dspeaker$utterance == "blue_thing" & dspeaker$sufficientdimension == "color",]$utterancetype = "minimal"
dspeaker[dspeaker$utterance == "big_thing" & dspeaker$sufficientdimension == "size",]$utterancetype = "minimal"
head(dspeaker)
summary(dspeaker)
nrow(dspeaker)

d = dspeaker

# paper plot of scene variation effect with same parameters as in koolen plot
d$numdistractors = as.factor(as.character(d$numdistractors))
ggplot(d[d$typicality_color == .999 & d$alpha == 30 & d$typicality_size == .8 & d$utterancetype != "other",], aes(x=scenevariation,y=probability,color=sufficientdimension,group=sufficientdimension,shape=numdistractors)) +
  geom_smooth(method="lm") +
  geom_point(size=2) +
  xlab("Scene variation") +
  facet_wrap(~utterancetype)
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/1_basic_overinformativeness/results_model/graphs/scene_variation/basic-effect.pdf",sep=""),height=3,width=7)
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/theory/pics/scenevariation-effect.pdf",sep=""),height=3,width=7)


d$typicality_color = as.factor(as.character(d$typicality_color))
ggplot(d[d$typicality_color %in% c("0.8","0.9","0.95","0.999") & d$alpha == 30 & d$typicality_size == .8 & d$utterancetype != "other",], aes(x=scenevariation,y=probability,color=sufficientdimension,group=sufficientdimension,shape=as.factor(numdistractors))) +
  # scale_colour_brewer(palette = "RdYlBu",name="Color\nfidelity") +
  geom_point() +
  # geom_line() +
  geom_smooth(method="lm") +
  xlab("Scene variation") +
  facet_grid(typicality_color~utterancetype)
