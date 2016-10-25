theme_set(theme_bw(18))

setwd("~/cogsci/projects/stanford/projects/overinformativeness/models/6_qualitative_nom_L0/")
source("rscripts/helpers.R")

d = read.table(file="listenerOutput.csv",sep=",", header=F, quote="")
colnames(d) = c("t_sub","d_sub","t_basic","d_basic","t_super","d_super","Utterance","Referent","Probability")

agr = d %>%
  filter(Referent == "target" & Utterance == "sub" & t_basic == 1 & d_basic == 1) %>%
  select(t_sub,d_sub,t_basic,d_basic,Utterance,Probability) #%>%
  # gather(Utterance,Mentioned,-t_t, -t_d1) %>%
  # group_by(Utterance,t_t, t_d1) %>%
  # summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
head(agr)

ggplot(agr, aes(x=t_sub,y=d_sub,color=Probability)) +
  geom_point(size=8,shape=15) +
  scale_colour_gradientn(colors=rev(rainbow(4,start=0,end=4/6)),name="Probability of\ntarget choice") +
  xlab("Target typicality") +
  ylab("Distractor typicality")
ggsave("L0probs.png",width=5.6,height=3.5)#,dpi=1400)


# t_t = targetTypicality 
# t_d1 = distr1Typicality (=distr2Typicality)
# p_l_t = literal listener probability to pick target 
# p_l_d1 = literal listener probability to pick distractor1 
# p_l_d2 = literal listener probability to pick distractor2 

