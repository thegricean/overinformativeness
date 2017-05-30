library(dplyr)
library(ggplot2)
library(bootstrap)
library(lme4)
library(tidyr)

theme_set(theme_bw(18))
setwd("/Users/elisakreiss/Documents/Stanford/overinformativeness/experiments/elisa_paper_relevant/norming_full/results")
setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/elisa_paper_relevant/norming_full/results")

theme_set(theme_bw(18))
source("rscripts/helpers.r")

d = read.csv(file="data/meantypicalities.csv")
# d$Comb = gsub(" ","_",d$Combo)
# d$RedItem = ifelse(d$Utterance == d$Comb, d$Comb, "other") ## CONTINUE HERE
# head(d)
# summary(d)

# first time
# d0 = read.table(file="../mturk0/norming.csv",sep=",",header=T)
# d1 = read.table(file="../mturk1/norming.csv",sep=",",header=T)
# d1$workerid = d1$workerid + 20
# d2 = read.table(file="../mturk2/norming.csv",sep=",",header=T)
# d2$workerid = d2$workerid + 20 + 10
# d3 = read.table(file="../mturk3/norming.csv",sep=",",header=T)
# d3$workerid = d3$workerid + 20 + 10 + 9
# d4 = read.table(file="../mturk4/norming.csv",sep=",",header=T)
# d4$workerid = d4$workerid + 20 + 10 + 9 + 9
# d5 = read.table(file="../mturk5/norming.csv",sep=",",header=T)
# d5$workerid = d5$workerid + 20 + 10 + 9 + 9 + 9
# d6 = read.table(file="../mturk6/norming.csv",sep=",",header=T)
# d6$workerid = d6$workerid + 20 + 10 + 9 + 9 + 9 + 9
# d7 = read.table(file="../mturk7/norming.csv",sep=",",header=T)
# d7$workerid = d7$workerid + 20 + 10 + 9 + 9 + 9 + 9 + 9
# d8 = read.table(file="../mturk8/norming.csv",sep=",",header=T)
# d8$workerid = d8$workerid + 20 + 10 + 9 + 9 + 9 + 9 + 9 + 9
# d9 = read.table(file="../mturk9/norming.csv",sep=",",header=T)
# d9$workerid = d9$workerid + 20 + 10 + 9 + 9 + 9 + 9 + 9 + 9 + 9
# d10 = read.table(file="../mturk10/norming.csv",sep=",",header=T)
# d10$workerid = d10$workerid + 20 + 10 + 9 + 9 + 9 + 9 + 9 + 9 + 9 + 9
# d11 = read.table(file="../mturk11/norming.csv",sep=",",header=T)
# d11$workerid = d11$workerid + 20 + 10 + 9 + 9 + 9 + 9 + 9 + 9 + 9 + 9 + 9
# d12 = read.table(file="../mturk12/norming.csv",sep=",",header=T)
# d12$workerid = d12$workerid + 20 + 10 + 9 + 9 + 9 + 9 + 9 + 9 + 9 + 9 + 9 + 9
# d = rbind(d0,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12)
# write.table(d, file="data/norming.csv",sep="\t",row.names=F,col.names=T,quote=F)

d = read.table(file="data/norming.csv",sep="\t", header=T)#, quote="")
head(d)
nrow(d)

totalnrow = nrow(d)
d$Trial = d$slide_number_in_experiment - 1
length(unique(d$workerid))
d$Item = sapply(strsplit(as.character(d$object),"_"), "[", 1)
d$Color = sapply(strsplit(as.character(d$object),"_"), "[", 2)
d$utterance = gsub("^ ","",as.character(d$utterance))
# look at turker comments
unique(d[,c("workerid","comments")])
d$UttColor = sapply(strsplit(as.character(d$utterance)," "), "[", 1)
d$UttType = sapply(strsplit(as.character(d$utterance)," "), "[", 2)
d$Utterance = paste(d$UttColor,d$UttType,sep="_")
d$InvUtterance = paste(d$UttType,d$UttColor,sep="_")
d$Third = ifelse(d$Trial < 110/3, 1, ifelse(d$Trial < 2*(110/3),2,3))

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

# sanity check
d[d$object == d$InvUtterance & d$response < .6,c("workerid","Third","object","utterance","response")]
table(d[d$object == d$InvUtterance & d$response < .6,]$Third)

# exclude non-native speakers
unique(d$language)
d = droplevels(d[!d$language == "Chinese",])
d = droplevels(d[!d$language == "Urdu/English",])
d = droplevels(d[!d$language == "Italian",])
length(unique(d$workerid))

# exclude people who didn't systematically give higher ratings for "true" cases (excluded four cases where mean(match) - mean(no_match) < .35)
d$Match = ifelse(d$object == d$InvUtterance, "match","no_match")
means = d %>%
  group_by(workerid,Match) %>%
  summarise(mean=mean(response))
tmp = means %>%
  group_by(workerid) %>%
  summarise(diff=mean[1]-mean[2])
tmp = as.data.frame(tmp)
tmp = tmp[order(tmp[,c("diff")]),]
head(tmp,10)
problematic = tmp[tmp$diff < .35,]$workerid
problematic

d = droplevels(d[!d$workerid %in% problematic,]) 
length(unique(d$workerid)) # 120 participants left

items = as.data.frame(table(d$Utterance,d$object))
nrow(items)
colnames(items) = c("Utterance","Object","Freq")
items = items[order(items[,c("Freq")]),]
ggplot(items, aes(x=Freq)) +
  geom_histogram()
table(items$Freq)
# it_low = items[items$Freq < 5,]
# it_five = items[items$Freq == 5,]
# nrow(it_low)
# nrow(it_five)
# write.csv(it_low[,c("Utterance","Object")],file="data/rerun_less5.csv",row.names=F,quote=F)
# write.csv(it_five[,c("Utterance","Object")],file="data/rerun_5.csv",row.names=F,quote=F)

# z-score ratings
zscored = d %>%
  group_by(workerid) %>%
  summarise(Range=max(response) - min(response))
zscored = as.data.frame(zscored)
row.names(zscored) = as.character(zscored$workerid)
ggplot(zscored,aes(x=Range)) +
  geom_histogram()

d$Range = zscored[as.character(d$workerid),]$Range
d$zresponse = d$response / d$Range

agr = d %>% 
  group_by(Item,Color,Utterance) %>%
  summarise(MeanTypicality = mean(response), ci.low=ci.low(response),ci.high=ci.high(response),MeanZTypicality = mean(zresponse), ci.low.z=ci.low(zresponse),ci.high.z=ci.high(zresponse))
agr = as.data.frame(agr)
agr$YMin = agr$MeanTypicality - agr$ci.low
agr$YMax = agr$MeanTypicality + agr$ci.high
agr$YMinZ = agr$MeanZTypicality - agr$ci.low.z
agr$YMaxZ = agr$MeanZTypicality + agr$ci.high.z

agr$Combo = paste(agr$Color,agr$Item,sep="_")
agr$Color = as.factor(as.character(agr$Color))

# determine final sample to run based on large CIs
# agr$Diff = agr$YMax-agr$YMin
# agr$Object = paste(agr$Item,agr$Color,sep="_")
# it_low$Combined = paste(it_low$Utterance,it_low$Object)
# agr$Combined = paste(agr$Utterance,agr$Object)
# not_in_it_low = agr %>%
#   filter(! Combined %in% as.character(it_low$Combined))
# nrow(not_in_it_low)
# head(not_in_it_low[order(not_in_it_low[,c("Diff")],decreasing=T),c("Utterance","Object","Diff")],40)

# rerun = rbind(it_low[,c("Utterance","Object")],head(not_in_it_low[order(not_in_it_low[,c("Diff")],decreasing=T),c("Utterance","Object")],18))
# nrow(rerun)
# write.csv(head(not_in_it_low[order(not_in_it_low[,c("Diff")],decreasing=T),c("Utterance","Object")],40),file="data/rerun_bigerrors.csv",row.names=F,quote=F)

ggplot(agr, aes(x=Combo,y=MeanTypicality,color=Color)) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~Utterance,scales="free_x",nrow=4) +
  scale_color_manual(values=levels(agr$Color)) +
  theme(axis.text.x = element_text(angle=45,size=5,vjust=1,hjust=1))
ggsave("graphs/typicalities.png",height=20, width=35)

ggplot(agr, aes(x=Combo,y=MeanZTypicality,color=Color)) +
  geom_point() +
  geom_errorbar(aes(ymin=YMinZ,ymax=YMaxZ),width=.25) +
  facet_wrap(~Utterance,scales="free_x",nrow=4) +
  scale_color_manual(values=levels(agr$Color)) +
  theme(axis.text.x = element_text(angle=45,size=5,vjust=1,hjust=1))
ggsave("graphs/ztypicalities.png",height=20, width=35)

ggplot(agr, aes(x=MeanTypicality,y=MeanZTypicality)) +
  geom_point() +
  geom_errorbar(aes(ymin=YMinZ,ymax=YMaxZ),width=.025,alpha=.5) +
  geom_errorbarh(aes(xmin=YMin,xmax=YMax),height=.025,alpha=.5) +
  geom_abline(intercept=0,slope=1,linetype="dashed", color="gray40")
ggsave("graphs/scale_unscaled_correlation.png",height=4, width=6)

agr$Combo = paste(agr$Color,agr$Item,sep=" ")
agr$RoundMTypicality = round(agr$MeanTypicality, digits=3);

write.csv(agr[,c("Item","Color","Utterance","Combo","RoundMTypicality","YMin","YMax")], file="data/meantypicalities.csv",row.names=F,quote=F)



#write json file with color+type utterances
# output = "{\n"
# for (u in unique(agr$Utterance)) {
#   output1 = paste("    \"",u,"\" : {\n",sep="")
#   output2 = paste("        \"",paste(agr[agr$Utterance == u,]$Combo,agr[agr$Utterance == u,]$RoundMTypicality,sep="\" : "),",\n",sep="",collapse="")
#   output = paste(output,output1,output2,"    },\n",sep="")
# }
# output = paste(output,"}",sep="")
#cat(output)
#write.table(output,file="../../../models/10_bda_comparison/refModule/json/completeTypicalities.json",quote=FALSE,sep="",row.names=FALSE,col.names=FALSE)



#write json file with all typicalities
output = "{\n"
for (u in unique(agr$Utterance)) {
  output1 = paste("    \"",u,"\" : {\n",sep="")
  output2 = paste("        \"",paste(agr[agr$Utterance == u,]$Combo,agr[agr$Utterance == u,]$RoundMTypicality,sep="\" : "),",\n",sep="",collapse="")
  output = paste(output,output1,output2,"    },\n",sep="")
}

col = read.table(file="../../norming_comp_colorPatch/results/data/meantypicalities.csv",sep=",", header=T)
col$Combo = paste(col$Color,col$Item,sep="_")

for (u in unique(col$color_utterance)) {
  output1 = paste("    \"",u,"\" : {\n",sep="")
  output2 = paste("        \"",paste(col[col$color_utterance == u,]$Combo,col[col$color_utterance == u,]$MeanTypicality,sep="\" : "),",\n",sep="",collapse="")
  output = paste(output,output1,output2,"    },\n",sep="")
}


t = read.table(file="../../norming_comp_object/results/data/meantypicalities.csv",sep=",", header=T)
t$Combo = paste(t$Color,t$Item,sep="_")

for (u in unique(t$utterance)) {
  output1 = paste("    \"",u,"\" : {\n",sep="")
  output2 = paste("        \"",paste(t[t$utterance == u,]$Combo,t[t$utterance == u,]$MeanTypicality,sep="\" : "),",\n",sep="",collapse="")
  output = paste(output,output1,output2,"    },\n",sep="")
}

output = paste(output,"}",sep="")
#cat(output)
write.table(output,file="../../../../models/11_visualization/refModule/json/completeTypicalities.json",quote=FALSE,sep="",row.names=FALSE,col.names=FALSE)


ggplot(d, aes(x=response,fill=Match)) +
  geom_histogram() +
  facet_wrap(~workerid)
ggsave("graphs/subject_variability.png",height=20, width=20)
