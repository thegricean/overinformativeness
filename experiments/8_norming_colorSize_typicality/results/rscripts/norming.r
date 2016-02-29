theme_set(theme_bw(18))
setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/8_norming_colorSize_typicality/results")
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

d$Combo = paste(d$item,d$color)
sort(table(d$Combo)) # how many of each? is it roughly evenly distributed?

agr = d %>% 
  group_by(item,color) %>%
  summarise(meanresponse = mean(response), ci.low=ci.low(response),ci.high=ci.high(response))
agr = as.data.frame(agr)
agr$YMin = agr$meanresponse - agr$ci.low
agr$YMax = agr$meanresponse + agr$ci.high

ggplot(agr, aes(x=color,y=meanresponse)) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~item,scales="free_x")
ggsave("graphs/typiclities.pdf",height=10)

mutated = agr %>%
  mutate(Item=item,Color=color,Typicality=meanresponse,CI.low=YMin,CI.high=YMax)

write.table(mutated[,c("Item","Color","Typicality","CI.low","CI.high")],file="data/typicalities.txt",sep="\t",row.names=F,col.names=T,quote=F)


