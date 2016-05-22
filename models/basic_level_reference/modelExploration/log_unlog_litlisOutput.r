theme_set(theme_bw(18))

setwd("/home/caroline/cocolab/overinformativeness/models/basic_level_reference/modelExploration")

source("rscripts/helpers.R")

#load("data/r.RData")
unlogged = read.table(file="modelOutput_unloggedTyps.csv",sep=",", header=T, quote="")
head(unlogged)
logged = read.table(file="modelOutput_loggedTyps.csv",sep=",", header=T, quote="")
head(logged)
nrow(logged)

agr = unlogged %>%
  select(p_l_sub_t,p_l_sub_d1,p_l_sub_d2, t_sub_d1, t_sub_t) %>%
  gather(Utterance,Mentioned,-t_sub_t, -t_sub_d1) %>%
  group_by(Utterance,t_sub_t, t_sub_d1) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

ggplot(agr, aes(x=Utterance,y=Probability)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(t_sub_d1~t_sub_t) +
  #facet_wrap(~condition) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("litLisProb_by_targetTyp_by_t_sub_d1.pdf",width=10,height=10)

# t_sub_t = targetTypicality for sub term
# t_sub_d1 = distr1Typicality (=distr2Typicality) for sub term
# p_l_sub_t = literal listener probability to pick target based on sub term
# p_l_sub_d1 = literal listener probability to pick distractor1 based on sub term
# p_l_sub_d2 = literal listener probability to pick distractor2 based on sub term
