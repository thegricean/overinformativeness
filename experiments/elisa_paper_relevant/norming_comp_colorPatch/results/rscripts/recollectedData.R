library(dplyr)
library(ggplot2)
library(bootstrap)
library(lme4)
library(tidyr)

theme_set(theme_bw(18))
setwd("/Users/elisakreiss/Documents/Stanford/overinformativeness/experiments/elisa_paper_relevant/norming_comp_colorPatch/results")

source("rscripts/helpers.r")

d = read.table(file="../part1/results/data/norming.csv",sep=",", header=T)#, quote="")
d$Item = sapply(strsplit(as.character(d$item_color),"_"), "[", 1)
d$Color = sapply(strsplit(as.character(d$item_color),"_"), "[", 2)

df = d[,c("color_utterance","Item","Color","response")]

# exclude cups
df_nocups = df[!df$Item == "cup",]
# exlude color_utterance == pink
df_nopink = df_nocups[!df_nocups$color_utterance == "pink",]
# exclude purple carrot
df_p1p2 = df_nopink[!(df_nopink$Color == "purple" & df_nopink$Item == "carrot"),]
# rename pink carrot/tomato to purple carrot/tomato
df_p1p2$Color = ifelse(df_p1p2$Color == "pink", "purple", df_p1p2$Color)

blub = df_p1p2
blub$Combo  = paste(blub$Color,blub$Item)

table(blub$Combo, blub$color_utterance)

# add part 3 HERE! (because of labeling of purple carrot)
d2_0 = read.table(file="../part3/results/data/norming0.csv",sep=",", header=T)#, quote="")
d2_1 = read.table(file="../part3/results/data/norming1.csv",sep=",", header=T)
d2_2 = read.table(file="../part3/results/data/norming2.csv",sep=",", header=T)
d2_3 = read.table(file="../part3/results/data/norming3.csv",sep=",", header=T)

length(unique(d2_0$workerid))
length(unique(d2_1$workerid))
length(unique(d2_2$workerid))
length(unique(d2_3$workerid))

d2_0$workerid = d2_0$workerid + 75
d2_1$workerid = d2_1$workerid + 84
d2_2$workerid = d2_2$workerid + 93
d2_3$workerid = d2_3$workerid + 102
d2 = rbind(d2_0,d2_1,d2_2,d2_3)

length(unique(d2$workerid))
table(d2$color_utterance, d2$item_color)

d2$Item = sapply(strsplit(as.character(d2$item_color),"_"), "[", 1)
d2$Color = sapply(strsplit(as.character(d2$item_color),"_"), "[", 2)

dpurple = d2[,c("color_utterance","Item","Color","response")]
dat = rbind(df_p1p2,dpurple)
dat$fit = TRUE

# data with nonfitting trials
d_nofit = read.table(file="../part2/results/data/norming.csv",sep=",", header=T)#, quote="")
d_nofit = droplevels(d_nofit[d_nofit$color_utterance != 'pink',])

d_nofit$Item = sapply(strsplit(as.character(d_nofit$item_color),"_"), "[", 1)
d_nofit$Color = sapply(strsplit(as.character(d_nofit$item_color),"_"), "[", 2)
d_nofit$Color = ifelse(d_nofit$Color == "pink", "purple", d_nofit$Color)

d_nf = d_nofit[,c("color_utterance","Item","Color","response")]
d_nf$fit = FALSE

comp = rbind(d_nf,dat)

agr = comp %>% 
  group_by(Item,Color,color_utterance,fit) %>%
  summarise(MeanTypicality = mean(response), ci.low=ci.low(response),ci.high=ci.high(response))
agr = as.data.frame(agr)
agr$YMin = agr$MeanTypicality - agr$ci.low
agr$YMax = agr$MeanTypicality + agr$ci.high

agr$Combo = paste(agr$Color,agr$Item)
agr$Color = as.factor(as.character(agr$Color))
# agr$OrdCombo = factor(agr$Combo, levels=agr[order(agr$MeanTypicality), "Combo"])
# agr$OrdCombo = factor(x=as.character(agr$Combo), levels=agr[order(agr$MeanTypicality,decreasing=T), "Combo"])
# agr = agr[order(agr[,c("MeanTypicality")],decreasing=T),]

ggplot(agr, aes(x=Combo,y=MeanTypicality,color=fit)) +
  geom_point(size=2) +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~color_utterance,scales="free_x",nrow=4) +
  xlab("Objects") +
  ylab("Typicality") +
  theme(axis.title.y = element_text(margin = margin(t = 0, r = 55, b = 0, l = 0))) +
  theme(axis.title=element_text(size=40,colour="#757575")) +
  theme(axis.text.x=element_text(size=28,colour="#757575",angle=45,vjust=1,hjust=1)) +
  theme(axis.text.y=element_text(size=20,colour="#757575")) +
  theme(axis.ticks=element_line(size=.25,colour="#757575"), axis.ticks.length=unit(.75,"mm")) +
  theme(legend.title=element_text(size=35,color="#757575")) +
  theme(legend.text=element_text(size=30,colour="#757575")) +
  theme(strip.text.x=element_text(size=28)) +
  theme(strip.background=element_rect(colour="#939393",fill="lightgrey")) +
  theme(legend.position = "top") +
  labs(color = "Consistent Trials") +
  theme(panel.background=element_rect(colour="#939393")) 
# ggsave("graphs/typicalities_fitvsnonfit.png",height=11, width=15)
ggsave("../../../../../../Uni/BachelorThesis/graphs/typcolpatch_fitvsnonfit.png",height=16.5, width=25)
