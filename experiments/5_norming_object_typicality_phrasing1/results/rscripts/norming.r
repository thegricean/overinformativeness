theme_set(theme_bw(18))
setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/5_norming_object_typicality_phrasing1/results")
source("rscripts/helpers.r")

d = read.table(file="data/norming.csv",sep=",", header=T, quote="")
head(d)
nrow(d)
summary(d)
totalnrow = nrow(d)
d$Trial = d$slide_number_in_experiment - 1
d$Half = as.factor(ifelse(d$Trial < 23, "first","second"))
d$itemtype = as.character(d$itemtype)
d[d$itemtype == "dist_super",]$itemtype = "dist_diffsuper"
d$itemtype = as.factor(as.character(d$itemtype))

# look at turker comments
unique(d$comments)

ggplot(d, aes(rt)) +
  geom_histogram() +
  scale_x_continuous(limits=c(0,10000))

ggplot(d, aes(log(rt))) +
  geom_histogram() 

ggplot(d, aes(Answer.time_in_minutes)) +
  geom_histogram()

ggplot(d, aes(gender)) +
  geom_histogram()

ggplot(d, aes(asses)) +
  geom_histogram()

ggplot(d, aes(age)) +
  geom_histogram()

ggplot(d, aes(education)) +
  geom_histogram()

ggplot(d, aes(language)) +
  geom_histogram()

ggplot(d, aes(enjoyment)) +
  geom_histogram()

d$Combo = paste(d$item,d$label)
sort(table(d$Combo)) # how many of each? is it roughly evenly distributed?

agr = d %>% 
  group_by(itemtype,labeltype) %>%
  summarise(meanresponse = mean(response), ci.low=ci.low(response),ci.high=ci.high(response))
agr = as.data.frame(agr)
agr$Utterance = factor(x=as.character(agr$labeltype),levels=c("sub","basic","super"))

ggplot(agr, aes(x=Utterance,y=meanresponse)) +
  geom_point() +
  geom_errorbar(aes(ymin=meanresponse-ci.low,ymax=meanresponse+ci.high),width=.25) +
  facet_wrap(~itemtype)
ggsave("graphs/collapsed.pdf")


agr = d %>% 
  group_by(itemtype,labeltype,item) %>%
  summarise(meanresponse = mean(response), ci.low=ci.low(response),ci.high=ci.high(response))
agr = as.data.frame(agr)
agr$YMin = agr$meanresponse-agr$ci.low
agr$YMax = agr$meanresponse+agr$ci.high
agr$Utterance = factor(x=as.character(agr$labeltype),levels=c("sub","basic","super"))

ggplot(agr,aes(x=Utterance,y=meanresponse,color=itemtype)) +
  geom_point() +
  geom_errorbar(aes(ymin=meanresponse-ci.low,ymax=meanresponse+ci.high),width=.25) +
  facet_wrap(~item)
ggsave("graphs/allitems.pdf",width=15,height=15)

agr = d %>% 
  group_by(itemtype,labeltype,item,label) %>%
  summarise(meanresponse = mean(response), ci.low=ci.low(response),ci.high=ci.high(response))
agr = as.data.frame(agr)
agr$YMin = agr$meanresponse-agr$ci.low
agr$YMax = agr$meanresponse+agr$ci.high
agr$Utterance = factor(x=as.character(agr$labeltype),levels=c("sub","basic","super"))

ggplot(agr,aes(x=Utterance,y=meanresponse,color=itemtype)) +
  geom_point() +
  geom_errorbar(aes(ymin=meanresponse-ci.low,ymax=meanresponse+ci.high),width=.25) +
  geom_text(aes(label=label),size=2,color='black') +
  facet_wrap(~item)
ggsave("graphs/allitems_annotated.pdf",width=15,height=15)

tmp = agr
agr = agr[order(agr[,c("Utterance")]),]
agr$Label = factor(x=as.character(agr$label),levels=unique(as.character(agr$label)))
ggplot(agr, aes(x=item,y=meanresponse,color=itemtype)) +
  geom_point() +
  geom_errorbar(aes(ymin=meanresponse-ci.low,ymax=meanresponse+ci.high),width=.25) +
  facet_wrap(~Label,scales="free_x") +
  theme(axis.text.x=element_text(angle=45,vjust=1,hjust=1,size=8))
ggsave("graphs/typicality_bylabel.pdf",width=30,height=23)

write.table(agr[,c("itemtype","labeltype","item","label","meanresponse","YMin","YMax")],file="data/itemtypicalities.txt",sep="\t",row.names=F,col.names=T,quote=F)
