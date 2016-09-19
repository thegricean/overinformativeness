theme_set(theme_bw(18))

setwd("~/cogsci/projects/stanford/projects/overinformativeness/models/7_qualitative_nom_S1_typ/")
source("rscripts/helpers.R")

# alpha = 7, t_super = .8
d = read.table(file="speakerOutput-alpha7.csv",sep=",", header=F, quote="")
colnames(d) = c("t_sub","d_sub","t_basic","d_basic","t_super","d_super","Utterance","Probability")

agr = d %>%
  filter(t_sub %in% c(0,.5,1) & t_basic %in% c(0,.5,1) & d_sub %in% c(0,.5,1) & d_basic %in% c(0,.5,1)) %>%
  select(t_sub,d_sub,t_basic,d_basic,Utterance,Probability) 
agr = as.data.frame(agr)
# agr$YMin = agr$Probability - agr$ci.low
# agr$YMax = agr$Probability + agr$ci.high
head(agr)
agr$Utt = factor(x=as.character(agr$Utterance),levels=c("sub","basic","super"))

ggplot(agr[agr$d_basic == 0,], aes(x=t_sub,y=Probability,color=d_sub,group=d_sub)) +
  geom_point() +
  geom_line(size=2) +
  xlab("Target sub typicality") +
  scale_colour_continuous(name="Distractor\nsub typicality") +
  facet_grid(t_basic~Utt) +
  ggtitle("Rows: t basic typicality (d basic typicality = 0)")
ggsave("S1probs_dtyp0.png",width=8,height=6)

ggplot(agr[agr$d_basic == 0.5,], aes(x=t_sub,y=Probability,color=d_sub,group=d_sub)) +
  geom_point() +
  geom_line(size=2) +
  xlab("Target sub typicality") +
  scale_colour_continuous(name="Distractor\nsub typicality") +
  facet_grid(t_basic~Utt) +
  ggtitle("Rows: t basic typicality (d basic typicality = .5)")
ggsave("S1probs_dtyp.5.png",width=8,height=6)

ggplot(agr[agr$d_basic == 1,], aes(x=t_sub,y=Probability,color=d_sub,group=d_sub)) +
  geom_point() +
  geom_line(size=2) +
  xlab("Target sub typicality") +
  scale_colour_continuous(name="Distractor\nsub typicality") +
  facet_grid(t_basic~Utt) +
  ggtitle("Rows: t basic typicality (d basic typicality = 1)")
ggsave("S1probs_dtyp1.png",width=8,height=6)

agr = d
agr$Utt = factor(x=as.character(agr$Utterance),levels=c("sub","basic","super"))
agr$TTypicalityGain = agr$t_sub - agr$t_basic
agr$DTypicalityGain = agr$d_sub - agr$d_basic

# ggplot(agr, aes(x=TTypicalityGain,y=DTypicalityGain,color=Probability)) +
#   geom_point(size=4,shape=15) +
#   scale_colour_gradient(low="red") +
#   geom_vline(xintercept=0,color="gray80") +
#   geom_hline(yintercept=0,color="gray80") +
#   xlab("Target typicality gain") +
#   ylab("Distractor typicality gain") +
#   facet_wrap(~Utt)
# ggsave("S1probs_typgainmap.png",width=10,height=3.5)
# ggsave("S1probs_typgainmap_alpha7.png",width=10,height=3.5)

# simulate conditions
agr$SimCondition = as.factor(ifelse(agr$d_sub == 0 & agr$d_basic == .8 & agr$d_super == .8,"sub necessary",ifelse(agr$d_sub == 0 & agr$d_basic == .1 & agr$d_super == .8, "basic sufficient", ifelse(agr$d_sub == 0 & agr$d_basic == 0 & agr$d_super == 0,"super sufficient","other"))))
table(agr$SimCondition)
agr = droplevels(agr[agr$SimCondition != "other",])
agr$Condition = factor(x=as.character(agr$SimCondition),levels=c("sub necessary","basic sufficient","super sufficient"))

ggplot(agr, aes(x=t_sub,y=TTypicalityGain,color=Probability)) +
  geom_point(size=7,shape=15) +
  scale_colour_gradient(low="red") +
  # geom_vline(xintercept=0,color="gray80") +
  # geom_hline(yintercept=0,color="gray80") +
  xlab("Target sub typicality") +
  ylab("Target typicality gain") +
  facet_grid(Condition~Utt)
ggsave("S1probs_typgainmap_alpha7.png",width=10,height=7.8)
