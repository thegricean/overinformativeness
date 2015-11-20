theme_set(theme_bw(18))
setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/2_number_of_distractors/results/")

source("rscripts/helpers.r")
r = read.table("parsed/results-moreconditions.txt",quote="", sep=",", header=T)

r$sufficientproperty = sapply(strsplit(as.character(r$context),"_"), "[", 1)
r$sufficientproperty = as.factor(as.character(r$sufficientproperty))
r$samesize = as.numeric(as.character(sapply(strsplit(as.character(r$context),"_"), "[", 2)))
r$differentsize = as.numeric(as.character(sapply(strsplit(as.character(r$context),"_"), "[", 3)))
r$samecolor = as.numeric(as.character(sapply(strsplit(as.character(r$context),"_"), "[", 4)))
r$differentcolor = as.numeric(as.character(sapply(strsplit(as.character(r$context),"_"), "[", 4)))
r$numdistractors = r$samesize + r$differentsize

head(r)
nrow(r)
names(r)
summary(r)


# gather values
r = r %>%
  gather(Utterance,Probability,big_red:red)
nrow(r)
summary(r)
r$speaker.opt = as.factor(as.character(r$speaker.opt))
# test to make sure all dists sum up to 1
tmp = as.data.frame(r %>% 
  group_by(color_fidelity,size_fidelity,color_cost,size_cost,speaker.opt,context) %>% 
  summarise(sum=sum(Probability)))
summary(tmp)
save(r,file="parsed/r-moreconditions.RData")

##################
# PLOTS OF UTTERANCE PROBABILITY AS A FUNCTION OF SPEAKER OPTIMALITY (COLOR), INCREASING COST OF SIZE (COLUMNS) AND INCREASING COST OF COLOR (ROWS) FOR FIXED VALUES OF OBJECT, COLOR FIDELITY, AND SIZE FIDELITY

### PLOT JUST THE RANGES THAT ARE RELEVANT
# COLOR COST .1
# SIZE COST .1
# SPEAKER OPTIMALITY 15
# COLOR FIDELITY .8
# SIZE FIDELITY .999

ggplot(r[r$object == "o1" & r$color_fidelity == .999 & r$size_fidelity == .8  & r$color_cost == .1 & r$size_cost == .1 & as.numeric(as.character(r$speaker.opt)  == 15),],aes(x=as.factor(samecolor),y=Probability,color=as.factor(numdistractors),group=as.factor(numdistractors))) +
  geom_point() +
  geom_line() +
  facet_grid(sufficientproperty~Utterance) +
  #scale_x_continuous(name="Number of distractors with same color") +
  scale_y_continuous(limits=c(0,1))
ggsave("graphs/_moreconditions/cf.999_sf.8_ccss.1_spopt15.pdf",width=12,height=3.5)
ggsave("graphs/_moreconditions/cf.999_sf.8_ccss.1_spopt15.jpg",width=15,height=4)

ggplot(r[r$object == "o1" & r$color_fidelity == .999 & r$size_fidelity == .8  & r$color_cost == .1 & r$size_cost == .1 & as.numeric(as.character(r$speaker.opt)  == 10),],aes(x=as.factor(samecolor),y=Probability,color=as.factor(numdistractors),group=as.factor(numdistractors))) +
  geom_point() +
  geom_line() +
  facet_grid(sufficientproperty~Utterance) +
  #scale_x_continuous(name="Number of distractors with same color") +
  scale_y_continuous(limits=c(0,1))
ggsave("graphs/_moreconditions/cf.999_sf.8_ccss.1_spopt10.pdf",width=12,height=3.5)
ggsave("graphs/_moreconditions/cf.999_sf.8_ccss.1_spopt10.jpg",width=15,height=4)


ggplot(r[r$object == "o1" & r$color_fidelity == .999 & r$size_fidelity == .8  & r$color_cost == .1 & r$size_cost == .1 & as.numeric(as.character(r$speaker.opt)  == 5),],aes(x=as.factor(samecolor),y=Probability,color=as.factor(numdistractors),group=as.factor(numdistractors))) +
  geom_point() +
  geom_line() +
  facet_grid(sufficientproperty~Utterance) +
  #scale_x_continuous(name="Number of distractors with same color") +
  scale_y_continuous(limits=c(0,1))
ggsave("graphs/_moreconditions/cf.999_sf.8_ccss.1_spopt5.pdf",width=12,height=3.5)
ggsave("graphs/_moreconditions/cf.999_sf.8_ccss.1_spopt5.jpg",width=15,height=4)


ggplot(r[r$object == "o1" & r$color_fidelity == .999 & r$size_fidelity == .8  & r$color_cost == .1 & r$size_cost == .1 & as.numeric(as.character(r$speaker.opt)  == 4),],aes(x=as.factor(samecolor),y=Probability,color=as.factor(numdistractors),group=as.factor(numdistractors))) +
  geom_point() +
  geom_line() +
  facet_grid(sufficientproperty~Utterance) +
  #scale_x_continuous(name="Number of distractors with same color") +
  scale_y_continuous(limits=c(0,1))
ggsave("graphs/_moreconditions/cf.999_sf.8_ccss.1_spopt4.pdf",width=12,height=3.5)
ggsave("graphs/_moreconditions/cf.999_sf.8_ccss.1_spopt4.jpg",width=15,height=4)

ggplot(r[r$object == "o1" & r$color_fidelity == .999 & r$size_fidelity == .8  & r$color_cost == .1 & r$size_cost == .1 & as.numeric(as.character(r$speaker.opt)  == 3),],aes(x=as.factor(samecolor),y=Probability,color=as.factor(numdistractors),group=as.factor(numdistractors))) +
  geom_point() +
  geom_line() +
  facet_grid(sufficientproperty~Utterance) +
  #scale_x_continuous(name="Number of distractors with same color") +
  scale_y_continuous(limits=c(0,1))
ggsave("graphs/_moreconditions/cf.999_sf.8_ccss.1_spopt3.pdf",width=12,height=3.5)
ggsave("graphs/_moreconditions/cf.999_sf.8_ccss.1_spopt3.jpg",width=15,height=4)

ggplot(r[r$object == "o1" & r$color_fidelity == .999 & r$size_fidelity == .8  & r$color_cost == .1 & r$size_cost == .1 & as.numeric(as.character(r$speaker.opt)  == 2),],aes(x=as.factor(samecolor),y=Probability,color=as.factor(numdistractors),group=as.factor(numdistractors))) +
  geom_point() +
  geom_line() +
  facet_grid(sufficientproperty~Utterance) +
  #scale_x_continuous(name="Number of distractors with same color") +
  scale_y_continuous(limits=c(0,1))
ggsave("graphs/_moreconditions/cf.999_sf.8_ccss.1_spopt2.pdf",width=12,height=3.5)
ggsave("graphs/_moreconditions/cf.999_sf.8_ccss.1_spopt2.jpg",width=15,height=4)


