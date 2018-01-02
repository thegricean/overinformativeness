library(dplyr)
library(ggplot2)
library(bootstrap)
library(lme4)
library(tidyr)

theme_set(theme_bw(18))
setwd("/Users/elisakreiss/Documents/Stanford/overinformativeness/experiments/elisa_paper_relevant/norming_comp_colorPatch/results")
setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/23_color_patch_norming/results")

theme_set(theme_bw(18))
source("rscripts/helpers.r")

d = read.table(file="../part1/results/data/norming.csv",sep=",", header=T)#, quote="")
d1 = read.table(file="../part2/results/data/norming.csv",sep=",", header=T)#, quote="")
head(d)
nrow(d)
nrow(d1)

d1$workerid = d1$workerid + 60
d = rbind(d,d1)
summary(d)

totalnrow = nrow(d)
d$Trial = d$slide_number_in_experiment - 1
length(unique(d$workerid))
d$Item = sapply(strsplit(as.character(d$item_color),"_"), "[", 1)
d$Color = sapply(strsplit(as.character(d$item_color),"_"), "[", 2)
# look at turker comments
unique(d[,c("workerid","comments")])

# exclude one worker who did the hit wrong
# d = d[d$workerid != 16,]
nrow(d)
#d = subset(d, workerid != 16)

ggplot(d, aes(rt)) +
  geom_histogram() +
  scale_x_continuous(limits=c(0,10000))

ggplot(d, aes(log(rt))) +
  geom_histogram() 

summary(d$Answer.time_in_minutes)
ggplot(d, aes(Answer.time_in_minutes)) +
  geom_histogram()

ggplot(d, aes(gender)) +
  stat_count()

ggplot(d, aes(asses)) +
  stat_count()

ggplot(d, aes(age)) +
  geom_histogram()
table(d$age)

ggplot(d, aes(education)) +
  stat_count()

ggplot(d, aes(language)) +
  stat_count()

ggplot(d, aes(enjoyment)) +
  stat_count()

ggplot(d, aes(Item)) +
  stat_count()

ggplot(d, aes(Color)) +
  stat_count()

##########
# old (no purple)

# items = as.data.frame(table(d$color_utterance,d$item_color))
# nrow(items)
# colnames(items) = c("Utterance","Object","Freq")
# items = items[order(items[,c("Freq")]),]
# items = items[grep("cup",items$Object,invert=T),]
# items = items[grep("purple",items$Object,invert=T),]
# # items = items[grep("pepper_green",items$Object,invert=T),]
# items = items[grep("cup",items$Utterance,invert=T),]
# nrow(items)
# write.csv(items[1:74,c("Utterance","Object")],file="data/rerun.csv",row.names=F,quote=F)
# 
# nocups = d[grep("cup",d$item_color,invert=T),]
# nocups = nocups[grep("cup",nocups$item_color,invert=T),]
# # nocups = nocups[grep("pepper_green",nocups$item_color,invert=T),]
# nocups = nocups[grep("purple",nocups$item_color,invert=T),]
# nocups = nocups[grep("purple",nocups$color_utterance,invert=T),]
# nocups = droplevels(nocups)
# 
# agr = nocups %>% 
#   group_by(Item,Color,color_utterance) %>%
#   summarise(MeanTypicality = mean(response), ci.low=ci.low(response),ci.high=ci.high(response))
# agr = as.data.frame(agr)
# agr$YMin = agr$MeanTypicality - agr$ci.low
# agr$YMax = agr$MeanTypicality + agr$ci.high
# 
# agr$Combo = paste(agr$Color,agr$Item)
# agr$Color = as.factor(as.character(agr$Color))
# #agr$OrdCombo = factor(agr$Combo, levels=agr[order(agr$MeanTypicality), "Combo"])
# #agr$OrdCombo = factor(x=as.character(agr$Combo), levels=agr[order(agr$MeanTypicality,decreasing=T), "Combo"])
# #agr = agr[order(agr[,c("MeanTypicality")],decreasing=T),]
# 
# ggplot(agr, aes(x=Combo,y=MeanTypicality,color=Color)) +
#   geom_point() +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_wrap(~color_utterance,scales="free_x",nrow=4) +
#   scale_color_manual(values=levels(agr$Color)) +
#   theme(axis.text.x = element_text(angle=45,size=5,vjust=1,hjust=1))
# ggsave("graphs/merged_typicalities.png",height=9, width=15)
# 
# 
# agr$MeanTypicality = round(agr$MeanTypicality, digits = 3)
# 
# #agr$Typicality = agr$MeanTypicality
# write.csv(agr[,c("Item","Color","color_utterance","Combo","MeanTypicality","YMin","YMax")], file="data/meantypicalities.csv",row.names=F,quote=F)
# 
# subset(agr[agr$color_utterance=="black",], select=c("Combo", "MeanTypicality"))

#######
# new with purple

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

agr = dat %>% 
  group_by(Item,Color,color_utterance) %>%
  summarise(MeanTypicality = mean(response), ci.low=ci.low(response),ci.high=ci.high(response))
agr = as.data.frame(agr)
agr$YMin = agr$MeanTypicality - agr$ci.low
agr$YMax = agr$MeanTypicality + agr$ci.high

agr$Combo = paste(agr$Color,agr$Item)
agr$Color = as.factor(as.character(agr$Color))
# agr$OrdCombo = factor(agr$Combo, levels=agr[order(agr$MeanTypicality), "Combo"])
# agr$OrdCombo = factor(x=as.character(agr$Combo), levels=agr[order(agr$MeanTypicality,decreasing=T), "Combo"])
# agr = agr[order(agr[,c("MeanTypicality")],decreasing=T),]

# ggplot(agr, aes(x=Combo,y=MeanTypicality,color=Color)) +
#   geom_point() +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_wrap(~color_utterance,scales="free_x",nrow=4) +
#   scale_color_manual(values=levels(agr$Color)) +
#   theme(axis.text.x = element_text(angle=45,size=11,vjust=1,hjust=1))
# ggsave("graphs/merged_typicalities.png",height=9, width=15)

ggplot(agr, aes(x=Combo,y=MeanTypicality,color=Color)) +
  geom_point(size=2) +
  ylab("Typicality") +
  xlab("Objects") +
  theme(legend.position="none") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~color_utterance,scales="free_x",nrow=4) +
  scale_color_manual(values=levels(agr$Color)) +
  theme(axis.title=element_text(size=25)) +
  theme(axis.title.y = element_text(margin = margin(t = 0, r = 60, b = 0, l = 0))) +
  theme(axis.text.x = element_text(angle=45,size=20,vjust=1,hjust=1)) +
  theme(axis.text.y=element_text(size=10)) +
  theme(axis.ticks=element_line(size=.25), axis.ticks.length=unit(.75,"mm")) +
  theme(strip.text.x=element_text(size=25)) +
  theme(strip.background=element_rect(colour="#939393",fill="lightgrey")) +
  theme(panel.background=element_rect(colour="#939393")) 
ggsave("graphs/merged_typicalities.png",height=15, width=17)
ggsave("../../../../../../Uni/BachelorThesis/graphs/typicalities_colpatch.png",height=15, width=17)

agr$MeanTypicality = round(agr$MeanTypicality, digits = 3)

#agr$Typicality = agr$MeanTypicality
write.csv(agr[,c("Item","Color","color_utterance","Combo","MeanTypicality","YMin","YMax")], file="data/meantypicalities.csv",row.names=F,quote=F)

