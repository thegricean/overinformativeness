theme_set(theme_bw(18))

setwd("/home/caroline/cocolab/overinformativeness/models/basic_level_reference/modelExploration")
#setwd("~/cogsci/projects/stanford/projects/overinformativeness/models/basic_level_reference/modelExploration")

source("rscripts/helpers.R")

#load("data/r.RData")
unlogged = read.table(file="litLisOutput_unloggedTyps.csv",sep=",", header=T, quote="")
head(unlogged)
logged = read.table(file="litLisOutput_loggedTyps.csv",sep=",", header=T, quote="")
head(logged)
nrow(logged)

agr = unlogged %>%
  select(p_l_t,p_l_d1,p_l_d2, t_d1, t_t) %>%
  gather(Utterance,Mentioned,-t_t, -t_d1) %>%
  group_by(Utterance,t_t, t_d1) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

ggplot(agr, aes(x=Utterance,y=Probability)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(t_d1~t_t) +
  #facet_wrap(~condition) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("litLisProb_unlogged_by_t_t_by_t_d.pdf",width=10,height=10)

ggplot(agr, aes(x=t_t,y=Probability,color=t_d1,group=t_d1)) +
#   geom_bar(stat="identity") +
  geom_point() +
  geom_line() +
#   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~Utterance) +
  #facet_wrap(~condition) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("litLisProb2_unlogged_by_t_t_by_t_d.pdf",width=10,height=10)


# do same thing for logged typicalities
agr = logged %>%
  select(p_l_t,p_l_d1,p_l_d2, t_d1, t_t) %>%
  gather(Utterance,Mentioned,-t_t, -t_d1) %>%
  group_by(Utterance,t_t, t_d1) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

ggplot(agr, aes(x=Utterance,y=Probability)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(t_d1~t_t) +
  #facet_wrap(~condition) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("litLisProb_logged_by_t_t_by_t_d.pdf",width=10,height=10)

ggplot(agr, aes(x=t_sub_t,y=Probability,color=t_d1,group=t_d1)) +
  #   geom_bar(stat="identity") +
  geom_point() +
  geom_line() +
  #   geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~Utterance) +
  #facet_wrap(~condition) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("litLisProb2_logged_by_targetTyp_by_t_sub_d1.pdf",width=10,height=10)



# t_t = targetTypicality 
# t_d1 = distr1Typicality (=distr2Typicality)
# p_l_t = literal listener probability to pick target 
# p_l_d1 = literal listener probability to pick distractor1 
# p_l_d2 = literal listener probability to pick distractor2 

