theme_set(theme_bw(18))
setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/4_color_predictability/results/")

source("rscripts/helpers.r")
r = read.table("parsed/results.txt",sep=",", header=T,quote="")
head(r)
nrow(r)
names(r)
summary(r)
r$blue = NULL
r$red = NULL
r$yellow = NULL
r$minimal = r$tomato +r$apple + r$pepper
r$redundant = r$red_tomato + r$yellow_apple + r$blue_pepper
r$tomato = NULL
r$red_tomato = NULL
r$apple = NULL
r$yellow_apple = NULL
r$pepper = NULL
r$blue_pepper = NULL
d=r

# gather values
r = r %>%
  gather(Utterance,Probability,minimal:redundant,-context,-speaker.opt,-cost.param,-prior.exp)
nrow(r)
summary(r)
r$speaker.opt = as.factor(as.character(r$speaker.opt))
r$prior.exp = as.factor(as.character(r$prior.exp))
# test to make sure all dists sum up to 1
tmp = as.data.frame(r %>% 
  group_by(cost.param,speaker.opt,prior.exp,context) %>% 
  summarise(sum=sum(Probability)))
summary(tmp)
save(r,file="parsed/r.RData")

##################
# PLOTS OF REDUNDANT UTTERANCE PROBABILITY AS A FUNCTION OF SPEAKER OPTIMALITY, CONTEXT, AND COST-PARAM
r$Context = factor(x=as.character(r$context),levels=c("atypical","intermediate","typical"))
ggplot(r[r$Utterance == "redundant",], aes(x=Context,y=Probability,color=speaker.opt,group=speaker.opt)) +
  geom_point() +
  geom_line() +
  facet_grid(prior.exp~cost.param)
ggsave("graphs/bigmodel-predictions.pdf")
