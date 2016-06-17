setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/1_basic_overinformativeness/")

typtype = "unlogged" 
typtype = "logged"
searchtype = "wide"
searchtype = "narrow"

######### PLOT LISTENER #########

dlistener = read.table(paste("results_model/data/listener_",typtype,"_",searchtype,".csv",sep=""),sep=",")
colnames(dlistener) = c("alpha","lengthWeight","typicality_color","typicality_size","cost_color","cost_size","utterance","object","probability")
head(dlistener)
summary(dlistener)

dlistener = unique(dlistener[,c("typicality_color","typicality_size","utterance","object","probability")])
nrow(dlistener)

# relevant for size sufficient condition:
dlss = dlistener[dlistener$utterance %in% c("blue_thumbtack","size_thumbtack","size_blue_thumbtack"),]
dlss$Object = as.factor(ifelse(dlss$object == "size,blue,thumbtack","target",ifelse(dlss$object == "othersize,blue,thumbtack","color_competitor","distractor")))
dlss$Utterance = as.factor(ifelse(dlss$utterance == "blue_thumbtack","color",ifelse(dlss$utterance == "size_thumbtack","size","size_color")))
ggplot(dlss, aes(x=Utterance,y=probability,fill=Object)) +
  geom_bar(stat="identity",position="dodge") +
  facet_grid(typicality_color~typicality_size) +
  theme(axis.text.x = element_text(angle=45,hjust=1,vjust=1)) +
  ggtitle("Size fidelity increases left to right; color increases top to bottom")
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/1_basic_overinformativeness/results_model/graphs/listenerdist_sizesufficient_",typtype,"_",searchtype,".pdf",sep=""),height=12,width=15)

# relevant for color sufficient condition:
dlcs = dlistener[dlistener$utterance %in% c("red_thumbtack","othersize_thumbtack","othersize_red_thumbtack"),]
dlcs$Object = as.factor(ifelse(dlcs$object == "size,blue,thumbtack","distractor",ifelse(dlcs$object == "othersize,blue,thumbtack","size_competitor","target")))
dlcs$Utterance = as.factor(ifelse(dlcs$utterance == "red_thumbtack","color",ifelse(dlcs$utterance == "othersize_thumbtack","size","size_color")))
ggplot(dlcs, aes(x=Utterance,y=probability,fill=Object)) +
  geom_bar(stat="identity",position="dodge") +
  facet_grid(typicality_color~typicality_size) +
  theme(axis.text.x = element_text(angle=45,hjust=1,vjust=1)) +
  ggtitle("Size fidelity increases left to right; color increases top to bottom")
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/1_basic_overinformativeness/results_model/graphs/listenerdist_colorsufficient_",typtype,"_",searchtype,".pdf",sep=""),height=12,width=15)

######### PLOT SPEAKER #########

dspeaker = read.table(paste("results_model/data/speaker_",typtype,"_",searchtype,".csv",sep=""),sep=",")
colnames(dspeaker) = c("alpha","lengthWeight","typicality_color","typicality_size","cost_color","cost_size","sufficientdimension","utterance","probability")
head(dspeaker)
summary(dspeaker)
nrow(dspeaker)

d = dspeaker
d$typicality_size = as.factor(as.character(d$typicality_size))
ggplot(d[d$cost_color == .5 & d$cost_size == .5 & d$sufficientdimension == "size_sufficient" & d$lengthWeight == 1,], aes(x=typicality_color,y=probability,color=typicality_size,group=typicality_size)) +
  geom_point() +
  geom_line() +
  facet_grid(alpha~utterance)
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/1_basic_overinformativeness/results_model/graphs/modelexploration-",typtype,"_",searchtype,".pdf",sep=""),height=10,width=15)

spreadspeaker = dspeaker %>%
  spread(utterance,probability)

# cases that match size sufficient condition from gatt et al 2011
ss = spreadspeaker[spreadspeaker$sufficientdimension == "size_sufficient" & spreadspeaker$size_blue_thumbtack > .78 & spreadspeaker$size_blue_thumbtack < .81 & spreadspeaker$size_thumbtack > .16 & spreadspeaker$size_thumbtack < .22 & spreadspeaker$blue_thumbtack < .04,]
nrow(ss)
row.names(ss) = paste(ss$alpha,ss$lengthWeight,ss$typicality_color,ss$typicality_size,ss$cost_color,ss$cost_size)

cs = spreadspeaker[spreadspeaker$sufficientdimension == "color_sufficient" & spreadspeaker$othersize_red_thumbtack > .07 & spreadspeaker$othersize_red_thumbtack < .11 & spreadspeaker$othersize_thumbtack < .01 & spreadspeaker$red_thumbtack < .925 & spreadspeaker$red_thumbtack > .89,]
nrow(cs)
row.names(cs) = paste(cs$alpha,cs$lengthWeight,cs$typicality_color,cs$typicality_size,cs$cost_color,cs$cost_size)

intersect(row.names(ss),row.names(cs))
# logged, wide search: the top 5 cases are
# [1] "15 2 0.999 0.9 0 0"   "15 2 0.999 0.9 0 0.5" "15 2 0.999 0.9 0 1"  
# [4] "15 2 0.999 0.9 0 1.5" "15 2 0.999 0.9 0 2"  
# logged, narrow search: the top 10 cases are
#  [1] "14 2.5 0.999 0.9 0 0"     "14 2.5 0.999 0.9 0 0.1"   "14 2.5 0.999 0.9 0 0.5"  
# [4] "14 2.5 0.999 0.9 0 1"     "14 2.5 0.999 0.9 0 2"     "17 2.5 0.999 0.9 0.1 0"  
# [7] "17 2.5 0.999 0.9 0.1 0.1" "17 2.5 0.999 0.9 0.1 0.5" "17 2.5 0.999 0.9 0.1 1"  
# [10] "17 2.5 0.999 0.9 0.1 2"

# unlogged, narrow search:
# [1] "28 0 0.999 0.8 0 0"     "28 0 0.999 0.8 0 0.1"   "28 0 0.999 0.8 0 0.2"  
# [4] "28 0 0.999 0.8 0.1 0"   "28 0 0.999 0.8 0.1 0.1" "28 0 0.999 0.8 0.1 0.2"
# [7] "28 0 0.999 0.8 0.2 0"   "28 0 0.999 0.8 0.2 0.1" "28 0 0.999 0.8 0.2 0.2"

# plot for paper
dp = dspeaker[dspeaker$lengthWeight == 0 & dspeaker$cost_color == 0 & dspeaker$cost_size == 0 & dspeaker$sufficientdimension == "size_sufficient" & dspeaker$utterance %in% c("blue_thumbtack","size_thumbtack","size_blue_thumbtack"),]
dp$utterance = as.factor(ifelse(dp$utterance == "blue_thumbtack","insufficient",ifelse(dp$utterance == "size_thumbtack","sufficient","redundant")))
dp = dp %>%
  mutate(typicality_sufficient = typicality_size, typicality_insufficient = typicality_color) %>%
  select(alpha,typicality_sufficient,typicality_insufficient, utterance,probability)
nrow(dp)
head(dp)

dp$typicality_insufficient = as.factor(as.character(dp$typicality_insufficient))
dp$Utterance = factor(x=as.character(dp$utterance),levels=c("insufficient","sufficient","redundant"))
ggplot(dp, aes(x=typicality_sufficient,y=probability,color=typicality_insufficient,group=typicality_insufficient)) +
  geom_point(size=1) +
  geom_line(size=1.5) +
  geom_hline(yintercept=.5,color="gray20", linetype="dashed") +
  ylab("Probability of utterance") +
  xlab("Fidelity of sufficient utterance") +
  # scale_colour_brewer(palette = "PiYG",name="Fidelity of\nsufficient\nutterance") +
  scale_colour_brewer(palette = "RdYlBu",name="Fidelity of\nsufficient\nutterance") +
  facet_grid(alpha~Utterance) 
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/1_basic_overinformativeness/results_model/graphs/modelexploration-fullfidelityeffect-",typtype,"-",searchtype,".pdf",sep=""),height=11,width=9)
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/theory/pics/modelexploration-fullfidelityeffect-",typtype,"-",searchtype,".pdf",sep=""),height=11,width=9)

dp$typicality_insufficient = as.factor(as.character(dp$typicality_insufficient))
ggplot(dp[dp$alpha == 30,], aes(x=typicality_sufficient,y=probability,color=typicality_insufficient,group=typicality_insufficient)) +
  geom_point(size=1) +
  geom_line(size=1.5) +
  geom_hline(yintercept=.5,color="gray20", linetype="dashed") +
  ylab("Probability of utterance") +
  xlab("Fidelity of sufficient utterance") +
  # scale_colour_brewer(palette = "PiYG",name="Fidelity of\nsufficient\nutterance") +
  scale_colour_brewer(palette = "RdYlBu",name="Fidelity of\ninsufficient\nutterance") +
  facet_wrap(~Utterance) 
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/theory/pics/modelexploration-fidelityeffect-",typtype,"-",searchtype,".pdf",sep=""),height=3.5,width=10)
