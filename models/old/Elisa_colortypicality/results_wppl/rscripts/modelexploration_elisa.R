library(lme4)
library(ggplot2)
library(dplyr)
library(reshape2)
library(magrittr)
# library(tidyr)

setwd("/Users/elisakreiss/Documents/stanford/study/overinformativeness/models/Elisa_colortypicality")

typtype = "unlogged" 
# typtype = "logged"
searchtype = "wide"
# searchtype = "narrow"

######### PLOT LISTENER #########

dlistener = read.table(paste("results_wppl/data/basic/listener_",typtype,"_",searchtype,".csv",sep=""),sep=",")
colnames(dlistener) = c("alpha","lengthWeight","u_banana_o_yellow_banana","u_banana_o_blue_banana","u_cup_o_yellow_cup","u_cup_o_blue_cup","u_yellow_banana_o_yellow_banana","u_blue_banana_o_blue_banana","u_yellow_cup_o_yellow_cup","u_blue_cup_o_blue_cup","u_apple_o_yellow_apple","u_apple_o_blue_apple","u_yellow_apple_o_yellow_apple","u_blue_apple_o_blue_apple","cost_color","cost_type","utterance","object","probability")
head(dlistener)
summary(dlistener)

dlistener = unique(dlistener[,c("u_banana_o_yellow_banana","u_banana_o_blue_banana","u_cup_o_yellow_cup","u_cup_o_blue_cup","u_yellow_banana_o_yellow_banana","u_blue_banana_o_blue_banana","u_yellow_cup_o_yellow_cup","u_blue_cup_o_blue_cup","u_apple_o_yellow_apple","u_apple_o_blue_apple","u_yellow_apple_o_yellow_apple","u_blue_apple_o_blue_apple","cost_color","cost_type","utterance","object","probability")])
nrow(dlistener)

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

dspeaker = read.table(paste("results_wppl/data/basic/speaker_",typtype,"_",searchtype,".csv",sep=""),sep=",")
colnames(dspeaker) = c("alpha","lengthWeight","u_banana_o_yellow_banana","u_banana_o_blue_banana","u_cup_o_yellow_cup","u_cup_o_blue_cup","u_yellow_banana_o_yellow_banana","u_blue_banana_o_blue_banana","u_yellow_cup_o_yellow_cup","u_blue_cup_o_blue_cup","u_apple_o_yellow_apple","u_apple_o_blue_apple","u_yellow_apple_o_yellow_apple","u_blue_apple_o_blue_apple","cost_color","cost_type","object","probability")
head(dspeaker)
summary(dspeaker)
nrow(dspeaker)

d = dspeaker
# d$typicality_size = as.factor(as.character(d$typicality_size))
ggplot(d, aes(x=u_banana_o_yellow_banana,y=probability,color=u_banana_o_blue_banana,group=u_banana_o_blue_banana)) +
  geom_point() +
  geom_line() +
  facet_grid(alpha~utterance)
# ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/2_qualitative_basic/results_wppl/graphs/modelexploration-",typtype,"_",searchtype,".pdf",sep=""),height=10,width=15)

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
ggplot(dp[dp$typicality_sufficient != "0.95" & dp$typicality_insufficient != .95,], aes(x=typicality_sufficient,y=probability,color=typicality_insufficient,group=typicality_insufficient)) +
  geom_point(size=1) +
  geom_line(size=1.5) +
  geom_hline(yintercept=.5,color="gray20", linetype="dashed") +
  ylab("Probability of utterance") +
  xlab("Fidelity of sufficient utterance") +
  # scale_colour_brewer(palette = "PiYG",name="Fidelity of\nsufficient\nutterance") +
  scale_colour_brewer(palette = "RdYlBu",name="Fidelity of\nsufficient\nutterance") +
  facet_grid(alpha~Utterance) 
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/2_qualitative_basic/results_wppl/graphs/modelexploration-fullfidelityeffect-",typtype,"-",searchtype,".pdf",sep=""),height=11,width=9)
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/theory/pics/modelexploration-fullfidelityeffect-",typtype,"-",searchtype,".pdf",sep=""),height=11,width=9)

dp$typicality_insufficient = as.factor(as.character(dp$typicality_insufficient))
ggplot(dp[dp$alpha == 30 & dp$typicality_sufficient != "0.95" & dp$typicality_insufficient != .95,], aes(x=typicality_sufficient,y=probability,color=typicality_insufficient,group=typicality_insufficient)) +
  geom_point(size=1) +
  geom_line(size=1.5) +
  geom_hline(yintercept=.5,color="gray20", linetype="dashed") +
  ylab("Probability of utterance") +
  xlab("Fidelity of sufficient utterance") +
  # scale_colour_brewer(palette = "PiYG",name="Fidelity of\nsufficient\nutterance") +
  scale_colour_brewer(palette = "RdYlBu",name="Fidelity of\ninsufficient\nutterance") +
  facet_wrap(~Utterance) 
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/2_qualitative_basic/results_wppl/graphs/modelexploration-fidelityeffect-",typtype,"-",searchtype,".pdf",sep=""),height=3.5,width=10)
ggsave(paste("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/theory/pics/modelexploration-fidelityeffect-",typtype,"-",searchtype,".pdf",sep=""),height=4,width=11)
