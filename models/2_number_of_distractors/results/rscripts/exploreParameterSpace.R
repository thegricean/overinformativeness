theme_set(theme_bw(18))
setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/2_number_of_distractors/results/")

source("rscripts/helpers.r")
r = read.table("parsed/results.txt",quote="", sep=",", header=T)

r$distractors = sapply(strsplit(as.character(r$context),"_"), "[", 1)
r$distractortype = sapply(strsplit(as.character(r$context),"_"), "[", 2)
r$sufficientproperty = sapply(strsplit(as.character(r$context),"_"), "[", 3)
r$distractors = as.factor(as.character(r$distractors))
r$distractortype = as.factor(as.character(r$distractortype))
r$sufficientproperty = as.factor(as.character(r$sufficientproperty))

head(r)
nrow(r)
names(r)
summary(r)
d=r

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
r$numdistractors = as.numeric(ifelse(r$distractors == "two",2,ifelse(r$distractors == "three",3,4)))
save(r,file="parsed/r.RData")

##################
# PLOTS OF UTTERANCE PROBABILITY AS A FUNCTION OF SPEAKER OPTIMALITY (COLOR), INCREASING COST OF SIZE (COLUMNS) AND INCREASING COST OF COLOR (ROWS) FOR FIXED VALUES OF OBJECT, COLOR FIDELITY, AND SIZE FIDELITY

### PLOT JUST THE RANGES THAT ARE RELEVANT
# COLOR COST .1
# SIZE COST .1
# SPEAKER OPTIMALITY 15
# COLOR FIDELITY .8
# SIZE FIDELITY .999

ggplot(r[r$object == "o1" & r$color_fidelity == .999 & r$size_fidelity == .8  & r$color_cost == .1 & r$size_cost == .1 & as.numeric(as.character(r$speaker.opt)) == 15,],aes(x=numdistractors,y=Probability,color=distractortype,group=distractortype)) +
  geom_point() +
  geom_line() +
  facet_grid(sufficientproperty~Utterance) +
  scale_x_continuous(breaks=c(2,3,4)) +
  scale_y_continuous(limits=c(0,1))
ggsave("graphs/cf.999_sf.8_ccss.1_spopt15.pdf",width=18,height=6)
ggsave("graphs/cf.999_sf.8_ccss.1_spopt15.jpg",width=15,height=4)

ggplot(r[r$object == "o1" & r$color_fidelity == .999 & r$size_fidelity == .8  & r$color_cost == .1 & r$size_cost == .1 & as.numeric(as.character(r$speaker.opt)) == 10,],aes(x=numdistractors,y=Probability,color=distractortype,group=distractortype)) +
  geom_point() +
  geom_line() +
  facet_grid(sufficientproperty~Utterance) +
  scale_x_continuous(breaks=c(2,3,4)) +
  scale_y_continuous(limits=c(0,1))  
ggsave("graphs/cf.999_sf.8_ccss.1_spopt10.pdf",width=18,height=6)
ggsave("graphs/cf.999_sf.8_ccss.1_spopt10.jpg",width=15,height=4)

ggplot(r[r$object == "o1" & r$color_fidelity == .999 & r$size_fidelity == .8  & r$color_cost == .1 & r$size_cost == .1 & as.numeric(as.character(r$speaker.opt)) == 5,],aes(x=numdistractors,y=Probability,color=distractortype,group=distractortype)) +
  geom_point() +
  geom_line() +
  facet_grid(sufficientproperty~Utterance) +
  scale_x_continuous(breaks=c(2,3,4)) +
  scale_y_continuous(limits=c(0,1))  
ggsave("graphs/cf.999_sf.8_ccss.1_spopt5.pdf",width=18,height=6)
ggsave("graphs/cf.999_sf.8_ccss.1_spopt5.jpg",width=15,height=4)




