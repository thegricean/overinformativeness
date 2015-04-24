library(ggplot2)
library(plyr)
theme_set(theme_bw(18))
setwd("~/cogsci/projects/stanford/projects/overinformativeness/corpus_results/")
source("rscripts/helpers.r")

#load("data/r.RData")
rs = read.table("data/swbd.tab", sep="\t", header=T, quote="")
rb = read.table("data/bncs.tab", sep="\t", header=T, quote="")
nrow(rb)
head(rb)

bnc_adjfreqs = as.data.frame(table(rb$Adjective))
bnc_adjfreqs = bnc_adjfreqs[order(bnc_adjfreqs[,c("Freq")],decreasing=T),]
bnc_padjfreqs = as.data.frame(table(rb$PrevAdjective))
bnc_padjfreqs = bnc_padjfreqs[order(bnc_padjfreqs[,c("Freq")],decreasing=T),]
head(bnc_padjfreqs)
bnc_ppadjfreqs = as.data.frame(table(rb$PrevPrevAdjective))
bnc_ppadjfreqs = bnc_ppadjfreqs[order(bnc_ppadjfreqs[,c("Freq")],decreasing=T),]
head(bnc_ppadjfreqs)

swbd_adjfreqs = as.data.frame(table(rs$Adjective))
swbd_adjfreqs = swbd_adjfreqs[order(swbd_adjfreqs[,c("Freq")],decreasing=T),]
swbd_padjfreqs = as.data.frame(table(rs$PrevAdjective))
swbd_padjfreqs = swbd_padjfreqs[order(swbd_padjfreqs[,c("Freq")],decreasing=T),]
head(swbd_padjfreqs)
swbd_ppadjfreqs = as.data.frame(table(rs$PrevPrevAdjective))
swbd_ppadjfreqs = swbd_ppadjfreqs[order(swbd_ppadjfreqs[,c("Freq")],decreasing=T),]
head(swbd_ppadjfreqs)
row.names(swbd_adjfreqs) = swbd_adjfreqs$Var1

bnc_adjfreqs$FreqBNC = bnc_adjfreqs$Freq
bnc_adjfreqs$FreqSWBD = swbd_adjfreqs[as.character(bnc_adjfreqs$Var1),]$Freq
bnc_adjfreqs$logBNCFreq = log(bnc_adjfreqs$FreqBNC)
bnc_adjfreqs$logSWBDFreq = log(bnc_adjfreqs$FreqSWBD)
head(bnc_adjfreqs)

ggplot(bnc_adjfreqs,aes(x=logBNCFreq,y=logSWBDFreq)) +
  geom_point() +
  geom_smooth() +
  geom_abline(xintercept=0,slope=1)

ggplot(bnc_adjfreqs,aes(x=FreqBNC,y=FreqSWBD)) +
  geom_point() +
  geom_smooth() 

cor(bnc_adjfreqs$FreqBNC,bnc_adjfreqs$FreqSWBD,use="complete.obs")
cor(bnc_adjfreqs$logBNCFreq,bnc_adjfreqs$logSWBDFreq,use="complete.obs")

r[grep("^red$",r$Adjective,perl=T),]$NP
r[grep("^tall$",r$Adjective,perl=T),]$NP

r[r$PrevPrevAdj == "yes",]

nrow(r[r$PrevAdj == "yes",])
sort(table(rb[rb$PrevAdj == "yes",]$Adjective))

row.names(bnc_adjfreqs) = bnc_adjfreqs$Var1
row.names(bnc_padjfreqs) = bnc_padjfreqs$Var1
row.names(bnc_ppadjfreqs) = bnc_ppadjfreqs$Var1
tentative_finalset = c("blue", "green", "red", "purple", "yellow", "brown","big","tiny","long", "short", "huge", "small","wooden", "hard", "soft", "smooth", "plastic", "metallic", "old", "young", "fresh", "rotten", "open", "closed", "full", "empty")

d = data.frame(Adjective = factor(x=tentative_finalset))
d$BNCFreqDist1 = bnc_adjfreqs[as.character(d$Adjective),]$Freq
d$BNCFreqDist2 = bnc_padjfreqs[as.character(d$Adjective),]$Freq
d$BNCFreqDist3 = bnc_ppadjfreqs[as.character(d$Adjective),]$Freq
d$logFreqDist1 = log(d$BNCFreqDist1)
d$logFreqDist2 = log(d$BNCFreqDist2)
d$logFreqDist3 = log(d$BNCFreqDist3)

ggplot(d, aes(x=logFreqDist1,y=logFreqDist2)) +
  geom_point() +
  geom_text(aes(label=Adjective,x=logFreqDist1+.2)) 
ggsave(file="graphs/adj_freqs.pdf",height=6)

size = c("little","big","tiny","long", "short", "large", "small", "skinny", "wide", "tall", "huge", "heavy")
age = c("old","new", "elderly", "young", "fresh", "rotten")
quality = c("good","bad", "cheap", "expensive")
color = c("white", "blue", "green", "red", "black", "purple", "yellow", "brown", "golden", "orange", "gray", "pink")
material = c("wooden", "hard", "soft", "solid", "smooth", "shiny", "flat","rough", "plastic")
mood = c("sad", "happy")
volume = c("full", "empty", "deep", "shallow")
temperature = c("hot", "cold")
strength = c("strong","weak")
other = c("open", "closed", "dark", "bright")
