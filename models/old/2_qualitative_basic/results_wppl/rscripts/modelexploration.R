setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/2_qualitative_basic/")

typtype = "unlogged" 
# typtype = "logged"
searchtype = "wide"
# searchtype = "narrow"

######### PLOT LISTENER #########

dlistener = read.table(paste("results_wppl/data/listener_",typtype,"_",searchtype,".csv",sep=""),sep=",")
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
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/2_qualitative_basic/results_wppl/graphs/listenerdist_sizesufficient_",typtype,"_",searchtype,".pdf",sep=""),height=12,width=15)

# relevant for color sufficient condition:
dlcs = dlistener[dlistener$utterance %in% c("red_thumbtack","othersize_thumbtack","othersize_red_thumbtack"),]
dlcs$Object = as.factor(ifelse(dlcs$object == "size,blue,thumbtack","distractor",ifelse(dlcs$object == "othersize,blue,thumbtack","size_competitor","target")))
dlcs$Utterance = as.factor(ifelse(dlcs$utterance == "red_thumbtack","color",ifelse(dlcs$utterance == "othersize_thumbtack","size","size_color")))
ggplot(dlcs, aes(x=Utterance,y=probability,fill=Object)) +
  geom_bar(stat="identity",position="dodge") +
  facet_grid(typicality_color~typicality_size) +
  theme(axis.text.x = element_text(angle=45,hjust=1,vjust=1)) +
  ggtitle("Size fidelity increases left to right; color increases top to bottom")
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/2_qualitative_basic/results_wppl/graphs/listenerdist_colorsufficient_",typtype,"_",searchtype,".pdf",sep=""),height=12,width=15)

######### PLOT SPEAKER #########

dspeaker = read.table(paste("results_wppl/data/speaker_",typtype,"_",searchtype,".csv",sep=""),sep=",")
colnames(dspeaker) = c("alpha","lengthWeight","typicality_color","typicality_size","cost_color","cost_size","sufficientdimension","utterance","probability")
head(dspeaker)
summary(dspeaker)
nrow(dspeaker)

d = dspeaker
d$typicality_size = as.factor(as.character(d$typicality_size))
ggplot(d[d$cost_color == 1 & d$cost_size == 1 & d$sufficientdimension == "size_sufficient" & d$lengthWeight == 1,], aes(x=typicality_color,y=probability,color=typicality_size,group=typicality_size)) +
  geom_point() +
  geom_line() +
  facet_grid(alpha~utterance)
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/2_qualitative_basic/results_wppl/graphs/modelexploration-",typtype,"_",searchtype,".pdf",sep=""),height=10,width=15)

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
dp = dspeaker[dspeaker$lengthWeight == 0 & dspeaker$cost_color == 1 & dspeaker$cost_size == 1 & dspeaker$sufficientdimension == "size_sufficient" & dspeaker$utterance %in% c("blue_thumbtack","size_thumbtack","size_blue_thumbtack"),]
dp$utterance = as.factor(ifelse(dp$utterance == "blue_thumbtack","insufficient",ifelse(dp$utterance == "size_thumbtack","sufficient","redundant")))
dp = dp %>%
  mutate(typicality_sufficient = typicality_size, typicality_insufficient = typicality_color) %>%
  select(alpha,typicality_sufficient,typicality_insufficient, utterance,probability)
nrow(dp)
head(dp)

dp$typicality_insufficient = as.factor(as.character(dp$typicality_insufficient))
dp$Utterance = factor(x=as.character(dp$utterance),levels=c("insufficient","sufficient","redundant"))
ggplot(dp[dp$typicality_sufficient != "0.95" & dp$typicality_insufficient != .95,], aes(x=typicality_sufficient,y=typicality_insufficient,color=probability)) +
  geom_point(size=8,shape=15) +
  scale_colour_gradientn(colors=rev(rainbow(4,start=0,end=4/6)),name="Probability\nof utterance") +
  xlab("Fidelity of sufficient utterance") +
  ylab("Fidelity of insufficient utterance") +
  facet_grid(alpha~Utterance) 
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/2_qualitative_basic/results_wppl/graphs/modelexploration-fullfidelityeffect-",typtype,"-",searchtype,".pdf",sep=""),height=15,width=9.5)
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/theory/pics/modelexploration-fullfidelityeffect-",typtype,"-",searchtype,".pdf",sep=""),height=15,width=9.5)

# dp$typicality_insufficient = as.factor(as.character(dp$typicality_insufficient))
dp$typicality_insufficient = as.numeric(as.character(dp$typicality_insufficient))
dp$Utt = factor(x=ifelse(dp$Utterance == "sufficient","'small'",ifelse(dp$Utterance == "insufficient", "'blue'",ifelse(dp$Utterance == "redundant","'small blue'","NA"))),levels=c("'small'","'blue'","'small blue'"))
ggplot(dp[dp$alpha == 30 & dp$typicality_sufficient != 0.95 & dp$typicality_insufficient != .95,], aes(x=typicality_sufficient,y=typicality_insufficient,color=probability)) +
  geom_point(size=8,shape=15) +
  # ylim(c(.5,1)) +
  # xlim(c(.5,1)) +
  scale_x_continuous(limits=c(.45,1),breaks=seq(.5,1,.1)) +
  scale_y_continuous(limits=c(.45,1),breaks=seq(.5,1,.1)) +
  scale_colour_gradientn(colors=rev(rainbow(4,start=0,end=4/6)),name="Probability\nof utterance") +
  xlab("Semantic value of size") +
  ylab("Semantic value of color") +
  facet_wrap(~Utt) +
  theme(axis.text = element_text(size=7), axis.title = element_text(size=9), legend.title = element_text(size=8))
# ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/2_qualitative_basic/results_wppl/graphs/modelexploration-fidelityeffect-",typtype,"-",searchtype,".pdf",sep=""),height=3.5,width=10)
# ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/theory/pics/modelexploration-fidelityeffect-",typtype,"-",searchtype,".pdf",sep=""),height=3.8,width=11)
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/2_qualitative_basic/results_wppl/graphs/modelexploration-fidelityeffect-paper.pdf",sep=""),height=1.75,width=5)
ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/theory/pics/modelexploration-fidelityeffect-paper.pdf",height=1.75,width=5)
