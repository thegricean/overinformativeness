setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/3_qualitative_scene_variation/")

typtype = "unlogged" 
# typtype = "logged"
searchtype = "wide"
# searchtype = "narrow"

######### PLOT SPEAKER #########

dspeaker = read.table(paste("results_wppl/data/scene_variation_koolen/speaker_",typtype,"_",searchtype,".csv",sep=""),sep=",")
colnames(dspeaker) = c("alpha","lengthWeight","typicality_color","typicality_size","typicality_type","cost_color","cost_size","condition","utterance","probability")
head(dspeaker)
summary(dspeaker)
nrow(dspeaker)
dspeaker$sufficientdimension = as.factor(ifelse(d$condition %in% c("lowvariation_exp1","highvariation_exp1"),"type_sufficient","size_sufficient"))

d = dspeaker
d$typicality_color = as.factor(as.character(d$typicality_color))
ggplot(d[d$condition == "lowvariation_exp1" & d$probability > .02 & d$typicality_type == .95,], aes(x=typicality_size,y=probability,color=typicality_color,group=typicality_color)) +
  scale_colour_brewer(palette = "RdYlBu",name="Color\nfidelity") +
  geom_point() +
  geom_line() +
    xlab("Size fidelity") +
  facet_grid(alpha~utterance)
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/3_qualitative_scene_variation/results_wppl/graphs/scene_variation_koolen/modelexploration-lowvarexp1-",typtype,"_",searchtype,".pdf",sep=""),height=10,width=9)

ggplot(d[d$condition == "highvariation_exp1" & d$probability > .02,], aes(x=typicality_size,y=probability,color=typicality_color,group=typicality_color)) +
  scale_colour_brewer(palette = "RdYlBu",name="Color\nfidelity") +
  geom_point() +
  geom_line() +
  xlab("Size fidelity") +
  facet_grid(alpha~utterance)
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/3_qualitative_scene_variation/results_wppl/graphs/scene_variation_koolen/modelexploration-highvarexp1-",typtype,"_",searchtype,".pdf",sep=""),height=10,width=9)

ggplot(d[d$condition == "lowvariation_exp2" & d$probability > .02,], aes(x=typicality_size,y=probability,color=typicality_color,group=typicality_color)) +
  scale_colour_brewer(palette = "RdYlBu",name="Color\nfidelity") +
  geom_point() +
  geom_line() +
  xlab("Size fidelity") +
  facet_grid(alpha~utterance)
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/3_qualitative_scene_variation/results_wppl/graphs/scene_variation_koolen/modelexploration-lowvarexp2-",typtype,"_",searchtype,".pdf",sep=""),height=10,width=9)

ggplot(d[d$condition == "highvariation_exp2" & d$probability > .02,], aes(x=typicality_size,y=probability,color=typicality_color,group=typicality_color)) +
  scale_colour_brewer(palette = "RdYlBu",name="Color\nfidelity") +
  geom_point() +
  geom_line() +
  xlab("Size fidelity") +
  facet_grid(alpha~utterance)
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/3_qualitative_scene_variation/results_wppl/graphs/scene_variation_koolen/modelexploration-highvarexp2-",typtype,"_",searchtype,".pdf",sep=""),height=10,width=9)


# assign utterance type based on condition (low/high, exp1/2)
d$UtteranceType = "other"
d[d$condition == "lowvariation_exp1" & d$utterance == "fan",]$UtteranceType = "minimal"
d[d$condition == "lowvariation_exp1" & d$utterance == "green_fan",]$UtteranceType = "redundant"
d[d$condition == "lowvariation_exp1" & d$utterance == "big_green_fan",]$UtteranceType = "redundant"
d[d$condition == "highvariation_exp1" & d$utterance == "couch",]$UtteranceType = "minimal"
d[d$condition == "highvariation_exp1" & d$utterance == "blue_couch",]$UtteranceType = "redundant"
d[d$condition == "highvariation_exp1" & d$utterance == "small_blue_couch",]$UtteranceType = "redundant"
d[d$condition == "lowvariation_exp2" & d$utterance == "big_chair",]$UtteranceType = "minimal"
d[d$condition == "lowvariation_exp2" & d$utterance == "big_red_chair",]$UtteranceType = "redundant"
d[d$condition == "highvariation_exp2" & d$utterance == "small_chair",]$UtteranceType = "minimal"
d[d$condition == "highvariation_exp2" & d$utterance == "small_brown_chair",]$UtteranceType = "redundant"

# sum probs by condition
agr = d %>% 
  group_by(typicality_size,typicality_color,typicality_type,UtteranceType,condition,alpha) %>%
  summarise(probability = sum(probability))

agr$typicality_color = as.factor(as.character(agr$typicality_color))
ggplot(agr[agr$alpha==5 & agr$typicality_type == .9,], aes(x=typicality_size,y=probability,color=typicality_color,group=typicality_color)) +
  scale_colour_brewer(palette = "RdYlBu",name="Color\nfidelity") +
  geom_point() +
  geom_line() +
  xlab("Size fidelity") +
  facet_grid(condition~UtteranceType)
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/3_qualitative_scene_variation/results_wppl/graphs/scene_variation_koolen/modelexploration-allconds-alpha5-",typtype,"_",searchtype,".pdf",sep=""),height=8,width=9)

# plot only probability of redundancy
# paper plot, for appendix
ggplot(agr[agr$UtteranceType == "redundant" & agr$typicality_type == .9,], aes(x=typicality_size,y=probability,color=condition,group=condition)) +
  # scale_colour_brewer(palette = "RdYlBu",name="Color\nfidelity") +
  geom_point() +
  geom_line() +
  xlab("Size fidelity") +
  facet_grid(typicality_color~alpha)
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/3_qualitative_scene_variation/results_wppl/graphs/scene_variation_koolen/koolen-full-exploration.pdf",sep=""),height=19,width=19)
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/theory/pics/koolen-full-exploration.pdf",sep=""),height=19,width=19)

# paper plot, basic koolen effect
agr$Variation = as.factor(ifelse(agr$condition %in% c("lowvariation_exp1","lowvariation_exp2"),"low","high"))
agr$Experiment = as.factor(ifelse(agr$condition %in% c("lowvariation_exp1","highvariation_exp1"),"Exp 1","Exp 2"))
ggplot(agr[agr$UtteranceType == "redundant" & agr$typicality_type == .9 & agr$typicality_color == .999 & agr$typicality_size == .8 & agr$alpha == 30,], aes(x=Experiment,y=probability,fill=Variation)) +
  geom_bar(stat="identity",position="dodge") +
  ylab("Probability of redundant color")
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/3_qualitative_scene_variation/results_wppl/graphs/scene_variation_koolen/koolen-effect.pdf",sep=""),height=3,width=4)
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/theory/pics/koolen-effect.pdf",sep=""),height=3,width=4)
