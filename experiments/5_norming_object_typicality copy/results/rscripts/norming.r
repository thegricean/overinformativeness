theme_set(theme_bw(18))
setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/2_norming_objects/results")
source("rscripts/helpers.r")

#load("data/r.RData")
d = read.table(file="data/norming.csv",sep=",", header=T, quote="")
head(d)
nrow(d)
summary(d)
totalnrow = nrow(d)
d$Trial = d$slide_number_in_experiment - 1
d$Half = as.factor(ifelse(d$Trial < 23, "first","second"))
d$response = tolower(d$response)
d$response = gsub(" ","",d$response)
d$response = gsub("\"","",d$response)

# look at turker comments
unique(d$comments)

ggplot(d, aes(rt)) +
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


t = as.data.frame(table(d$response,d$item,d$objecttype))
colnames(t) = c("Response","Item","Type","Frequency")
t = t[t$Freq > 0,]
nrow(t)
head(t)
t$Combination = as.factor(paste(t$Type,t$Item,sep=" -- "))

ggplot(t, aes(x=Response,y=Frequency)) +
  geom_bar(stat="identity") +
  facet_wrap(~Combination, scales="free") +
  theme(axis.text.x=element_text(angle=45,vjust=1,hjust=1))
ggsave("graphs/labeldist.pdf",width=20,height=40)
