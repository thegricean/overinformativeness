theme_set(theme_bw(18))
setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/3_scene_variation/results/")

source("rscripts/helpers.r")
r = read.table("parsed/results_one.txt",sep=",", header=T,quote="")

r$scenevariation = sapply(strsplit(as.character(r$context),"_"), "[", 1)
r$experiment = sapply(strsplit(as.character(r$context),"_"), "[", 2)
r$scenevariation = as.factor(as.character(r$scenevariation))
r$experiment = as.factor(as.character(r$experiment))

head(r)
nrow(r)
names(r)
summary(r)
d=r

# gather values
r = r %>%
  gather(Utterance,Probability,small_green_tv:small_gray_one)
nrow(r)
summary(r)
r$speaker.opt = as.factor(as.character(r$speaker.opt))
# test to make sure all dists sum up to 1
tmp = as.data.frame(r %>% 
  group_by(color_fidelity,size_fidelity,type_fidelity,one_fidelity,color_cost,size_cost,type_cost,speaker.opt,context) %>% 
  summarise(sum=sum(Probability)))
summary(tmp)
save(r,file="parsed/r_one.RData")

##################
# PLOTS OF UTTERANCE PROBABILITY AS A FUNCTION OF SPEAKER OPTIMALITY (COLOR), INCREASING COST OF SIZE (COLUMNS) AND INCREASING COST OF COLOR (ROWS) FOR FIXED VALUES OF OBJECT, COLOR FIDELITY, AND SIZE FIDELITY

### PLOT JUST THE RANGES THAT ARE RELEVANT
# COLOR COST .1
# SIZE COST .1
# SPEAKER OPTIMALITY 15
# COLOR FIDELITY .8
# SIZE FIDELITY .999
# TYPE COST .1

toplot = r[r$object == "o1" & r$color_fidelity == .999 & r$size_fidelity == .8  & r$type_fidelity == .9 & r$color_cost == .1 & r$size_cost == .1 & r$type_cost == .1,]
tmp = toplot %>% 
  group_by(Utterance) %>%
  summarise(MaxProb = max(Probability))
tmp = as.data.frame(droplevels(tmp[tmp$MaxProb>.05,]))
nrow(tmp)
nrow(toplot)

toplot = droplevels(subset(toplot, Utterance %in% as.character(tmp$Utterance)))
toplot[toplot$Probability < .0001,]$Probability = NA
toplot = na.omit(toplot)
nrow(toplot)
unique(toplot$Utterance)
toplot$Expression = factor(x=as.character(toplot$Utterance),levels=c("couch","small_couch","blue_couch","blue_one","small_blue_couch","small_blue_one","small_chair","small_brown_chair","small_brown_one","fan","big_fan","green_fan","big_green_fan","big_chair","big_red_chair"))
toplot$Context = factor(x=as.character(toplot$context),levels=c("lowvariation_exp1","lowvariation_exp2","highvariation_exp1","highvariation_exp2"))

ggplot(toplot,aes(x=Expression,y=Probability,color=speaker.opt,group=speaker.opt)) +
  geom_point() +
  geom_line() +
  facet_grid(one_fidelity~Context,scales="free_x") +
  theme(axis.text.x=element_text(angle=45,vjust=1,hjust=1))
ggsave("graphs/cf.999_sf.8_cstcost.1_one.jpg",width=10,height=8)


# plot only exp. 1 for only one set of settings
toplot = r[r$object == "o1" & r$color_fidelity == .999 & r$size_fidelity == .8  & r$color_cost == .1 & r$size_cost == .1 & r$type_cost == .1 & r$speaker.opt %in% c("10","15","18") & r$type_fidelity == .9 & r$one_fidelity == .9 & r$context %in% c("lowvariation_exp1","highvariation_exp1") & r$speaker.opt==15,]
tmp = toplot %>% 
  group_by(Utterance) %>%
  summarise(MaxProb = max(Probability))
tmp = as.data.frame(droplevels(tmp[tmp$MaxProb>.05,]))
nrow(tmp)
nrow(toplot)

toplot = droplevels(subset(toplot, Utterance %in% as.character(tmp$Utterance)))
toplot[toplot$Probability < .0001,]$Probability = NA
toplot = na.omit(toplot)
nrow(toplot)
#toplot$Utterance = factor(x=as.character(toplot$Utterance),levels=c("couch","small_couch","blue_couch","small_blue_couch","small_chair","small_brown_chair","fan","big_fan","green_fan","big_green_fan","big_chair","big_red_chair"))
toplot$Context = toplot$context

ggplot(toplot,aes(x=Utterance,y=Probability)) +
  geom_bar(stat="identity") +
  facet_grid(type_fidelity~Context,scales="free_x") +
  theme(axis.text.x=element_text(angle=45,vjust=1,hjust=1))
ggsave("graphs/one_low_high_exp1_tfidelity.9.pdf",width=5,height=5)
