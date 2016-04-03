theme_set(theme_bw(18))
setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/9_norming_colordescription_typicality/results")
source("rscripts/helpers.r")

d = read.table(file="data/norming.csv",sep=",", header=T, quote="")
head(d)
nrow(d)
summary(d)
totalnrow = nrow(d)
d$Trial = d$slide_number_in_experiment - 1
d$Half = as.factor(ifelse(d$Trial < 19, "first","second"))
length(unique(d$workerid))

# look at turker comments
unique(d$comments)

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

ggplot(d, aes(education)) +
  stat_count()

ggplot(d, aes(language)) +
  stat_count()

ggplot(d, aes(enjoyment)) +
  stat_count()

d$Combo = paste(d$item,d$color,d$condition)
sort(table(d$Combo)) # how many of each? is it roughly evenly distributed?

agr = d %>% 
  group_by(item,color,condition) %>%
  summarise(meanresponse = mean(response), ci.low=ci.low(response),ci.high=ci.high(response))
agr = as.data.frame(agr)
agr$YMin = agr$meanresponse - agr$ci.low
agr$YMax = agr$meanresponse + agr$ci.high

ggplot(agr, aes(x=color,y=meanresponse,color=condition)) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~item,scales="free_x")
ggsave("graphs/typicalities.pdf",height=10)

mutated = agr %>%
  mutate(Item=item,Color=color,Modification=condition,Typicality=meanresponse,CI.low=YMin,CI.high=YMax)

write.table(mutated[,c("Item","Color","Modification","Typicality","CI.low","CI.high")],file="data/typicalities.txt",sep="\t",row.names=F,col.names=T,quote=F)

# compare the "how typical is this color for an X" wording to the current "how typical is this for an X" wording
typicalities = read.table("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/8_norming_colorSize_typicality/results/data/typicalities.txt",header=T)
head(typicalities)
head(mutated)
#row.names(typicalities) = paste(typicalities$Item,typicalities$Color)
typicalities$Modification = "puretypicality"

m = merge(mutated,typicalities,all=T) %>%
  select(Item,Color,Modification,Typicality,CI.low,CI.high)
summary(m)

ggplot(m, aes(x=Color,y=Typicality,color=Modification)) +
  geom_point() +
  geom_errorbar(aes(ymin=CI.low,ymax=CI.high),width=.25) +
  facet_wrap(~Item,scales="free_x")
ggsave("graphs/typicalities_full.pdf",height=10)

library(scales)
m$rescaledTypicality = rescale(m$Typicality,to=c(.5,1))
m$Utterance = paste(m$Color,m$Item,sep="_")
m[m$Modification != "modified",]$Utterance = as.character(m[m$Modification != "modified",]$Item)
head(m)
m$Object = paste(m$Color,m$Item,sep="_")

# write the three different typicality measures to file so they can be used by model
write.table(m[m$Modification == "modified",c("Item","Color","rescaledTypicality")],file="data/typicalities_modified.txt",sep="\t",row.names=F,col.names=T,quote=F)

write.table(m[m$Modification == "unmodified",c("Item","Color","rescaledTypicality")],file="data/typicalities_unmodified.txt",sep="\t",row.names=F,col.names=T,quote=F)

write.table(m[m$Modification == "puretypicality",c("Item","Color","rescaledTypicality")],file="data/typicalities_pure.txt",sep="\t",row.names=F,col.names=T,quote=F)


# get final values for model, 

write.csv(m[m$Modification != "puretypicality",c("Object","rescaledTypicality","Utterance")],file="data/typicalities.csv",row.names=F,quote=F)
write.csv(m[m$Modification != "puretypicality",c("Object","Typicality","Utterance")],file="data/typicalities_raw.csv",row.names=F,quote=F)


# figure out which cases have the greatest typicality difference between modified and unmodified versions
diffs = m %>%
  filter(Modification != "puretypicality") %>%
  group_by(Item, Color) %>%
  summarise(Diff=Typicality[1]-Typicality[2],TypicalityModified=Typicality[1],TypicalityUnmodified=Typicality[2])
diffs = as.data.frame(diffs)
row.names(diffs) = paste(diffs$Color,diffs$Item)
# cases where modified version much more typical than unmodified version:
head(diffs[order(diffs[,c("Diff")],decreasing=T),])
maxdiffitems = as.character(diffs[order(diffs[,c("Diff")],decreasing=T),]$Item)[1:4]
write.csv(diffs[order(diffs[,c("Diff")],decreasing=T),],file="data/maxdiffitems.csv",row.names=F,quote=F)
m[m$Item %in% maxdiffitems,]
# cases where unmodified version more typical than modified version:
tail(diffs[order(diffs[,c("Diff")],decreasing=T),])

# plot empirical overmodification rates for max typicality diff cases
emp = read.csv("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/7_overinf_basiclevel_biggersample/results/data/data_bda_modifiers.csv",col.names=c("gameid","trial","condition","size","color","othercolor","item","utterance"))
head(emp)

emp$TypicalityDiff = diffs[paste(emp$color,emp$item),]$Diff
emp$sufficientdimension = ifelse(substr(emp$condition,1,5) == "color","color","size")
emp$condition = gsub("(color|size)","",as.character(emp$condition))
emp$numdistractors = substr(emp$condition,1,1)
emp$numsame = substr(emp$condition,2,2)
emp$proportionsame = as.numeric(as.character(emp$numsame))/as.numeric(as.character(emp$numdistractors))
head(emp)
emp$redutterance = "color"
emp[emp$utterance == "size",]$redutterance = "size"
emp[grep("_",as.character(emp$utterance)),]$redutterance = "size_color"
emp$uttcolor = ifelse(emp$redutterance == "color", 1, 0)
emp$uttsize = ifelse(emp$redutterance == "size", 1, 0)
emp$uttsizecolor = ifelse(emp$redutterance == "size_color", 1, 0)
table(emp$uttcolor,emp$uttsize,emp$uttsizecolor)

agr = emp %>%
  filter(item %in% maxdiffitems) %>%
  group_by(item,color,sufficientdimension,TypicalityDiff) %>%
  summarise(probcolor=mean(uttcolor),ccilow=ci.low(uttcolor),ccihigh=ci.high(uttcolor),probsize=mean(uttsize),scilow=ci.low(uttsize),scihigh=ci.high(uttsize),probsc=mean(uttsizecolor),sccilow=ci.low(uttsizecolor),sccihigh=ci.high(uttsizecolor))
agr = as.data.frame(agr)
head(agr)
low = agr %>%
  select(item, color, TypicalityDiff, sufficientdimension, ccilow, scilow, sccilow) %>%
  gather(utterance,cilow,-item,-color,-TypicalityDiff, -sufficientdimension)
high = agr %>%
  select(item, color, TypicalityDiff, sufficientdimension, ccihigh, scihigh, sccihigh) %>%
  gather(utterance,cihigh,-item,-color,-TypicalityDiff, -sufficientdimension)
sp = agr %>%
  select(item, color, TypicalityDiff, sufficientdimension, probcolor, probsize, probsc) %>%
  gather(utterance,probability,-item,-color,-TypicalityDiff, -sufficientdimension)
sp$combo = paste(sp$color,sp$item)
sp$utterance = gsub("prob","",as.character(sp$utterance))
sp$ymin = sp$probability-low$cilow
sp$ymax = sp$probability+high$cihigh
head(sp)

ggplot(sp,aes(x=TypicalityDiff,y=probability,color=item,group=item)) +
  geom_point() +
  #geom_smooth(method="lm") +
  geom_line() +
  #geom_errorbar(aes(ymin=ymin,ymax=ymax)) +
  geom_text(aes(label=combo)) +
  facet_grid(sufficientdimension~utterance)
ggsave("graphs/maxtypicalitydiffcases.pdf",height=6,width=11)


