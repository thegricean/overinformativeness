library(dplyr)
library(ggplot2)
library(bootstrap)
library(lme4)
library(tidyr)

theme_set(theme_bw(18))
setwd("/Users/elisakreiss/Documents/Stanford/overinformativeness/experiments/elisa_paper_relevant/typicality_calculation")
source("rscripts/helpers.r")

objTyp = read.table(file="../norming_comp_object/results/data/meantypicalities.csv",sep=",", header=T, quote="")
colTyp = read.table(file="../norming_comp_colorPatch/results/data/meantypicalities.csv",sep=",", header=T, quote="")
fullTyp = read.table(file="../norming_full/results/data/meantypicalities.csv",sep=",", header=T, quote="")

fullTyp$Col_utt = sapply(strsplit(as.character(fullTyp$Utterance),"_"), "[", 1)
fullTyp$Obj_utt = sapply(strsplit(as.character(fullTyp$Utterance),"_"), "[", 2)

fullTyp$ID = seq.int(nrow(fullTyp))

fullTyp$ColTyp = lapply(fullTyp$ID, function(x) colTyp[colTyp$Combo == fullTyp$Combo[x] & colTyp$color_utterance == fullTyp$Col_utt[x],]$MeanTypicality)
fullTyp$ObjTyp = lapply(fullTyp$ID, function(x) objTyp[objTyp$Combo == fullTyp$Combo[x] & objTyp$utterance == fullTyp$Obj_utt[x],]$MeanTypicality)

fullTyp$ColTyp <- as.numeric(fullTyp$ColTyp)
fullTyp$ObjTyp <- as.numeric(fullTyp$ObjTyp)

fullTyp$Sum = (fullTyp$ColTyp)+fullTyp$ObjTyp
fullTyp$SigmSum = 1/(1+exp(-1*fullTyp$Sum))
minVal = min(fullTyp$Sum)
maxVal = max(fullTyp$Sum)
fullTyp$NormSum = (fullTyp$Sum - minVal)/(maxVal - minVal)
minVal = min(fullTyp$SigmSum)
maxVal = max(fullTyp$SigmSum)
fullTyp$NormSigmSum = (fullTyp$SigmSum - minVal)/(maxVal - minVal)

# normed data point doesn't make any sense
fullTyp = droplevels(fullTyp[!(fullTyp$Utterance == "red_tomato" & fullTyp$Combo == "green pear"),])

ggplot(fullTyp, aes(x=RoundMTypicality, y=NormSigmSum, group=1)) +
  geom_point() +
  # geom_smooth() +
  xlim(0, 1) + 
  ylim(0, 1)
# geom_line() +
# theme(axis.text.x = element_text(angle=45,size=5,vjust=1,hjust=1))
ggsave("graphs/normSigmSum.png",height=10, width=13)

ggplot(fullTyp, aes(x=RoundMTypicality, y=NormSum, group=1)) +
  geom_point() +
  # geom_smooth() +
  xlim(0, 1) + 
  ylim(0, 1)
# geom_line() +
# theme(axis.text.x = element_text(angle=45,size=5,vjust=1,hjust=1))
ggsave("graphs/normSum.png",height=10, width=13)

ggplot(fullTyp, aes(x=RoundMTypicality, y=NormSigmSum, group=1)) +
  geom_point() +
  geom_text(aes(label=Combo),angle=0,hjust=0, vjust=0) +
  geom_text(aes(label=Utterance),angle=0,hjust=0, vjust=0.5, color="red") +
  # geom_smooth() +
  xlim(0, 1) + 
  ylim(0, 1)
  # geom_line() +
  # theme(axis.text.x = element_text(angle=45,size=5,vjust=1,hjust=1))
ggsave("graphs/normSigmSum_label.png",height=20, width=20)

ggplot(fullTyp, aes(x=RoundMTypicality, y=NormSum, group=1)) +
  geom_point() +
  geom_text(aes(label=Combo),angle=0,hjust=0, vjust=0) +
  geom_text(aes(label=Utterance),angle=0,hjust=0, vjust=0.5, color="red") +
  # geom_smooth() +
  xlim(0, 1) + 
  ylim(0, 1)
# geom_line() +
# theme(axis.text.x = element_text(angle=45,size=5,vjust=1,hjust=1))
ggsave("graphs/normSum_label.png",height=20, width=20)




