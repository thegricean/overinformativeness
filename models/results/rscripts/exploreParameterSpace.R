theme_set(theme_bw(18))
setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/results/")

source("rscripts/helpers.r")
r = read.table("parsed/results.txt",quote="", sep=",", header=T)
head(r)
nrow(r)
names(r)
summary(r)
d=r

# gather values
r = r %>%
  gather(Utterance,Probability,big:small_yellow)
nrow(r)
summary(r)
r$speaker.opt = as.factor(as.character(r$speaker.opt))
save(r,file="parsed/r.RData")

##################
# PLOTS OF UTTERANCE PROBABILITY AS A FUNCTION OF SPEAKER OPTIMALITY (COLOR), INCREASING COST OF SIZE (COLUMNS) AND INCREASING COST OF COLOR (ROWS) FOR FIXED VALUES OF OBJECT, COLOR FIDELITY, AND SIZE FIDELITY

ggplot(r[r$object == "o1" & r$color_fidelity == .999 & r$size_fidelity == .999,],aes(x=Utterance,y=Probability,color=speaker.opt,group=speaker.opt)) +
  geom_point() +
  geom_line() +
  facet_grid(color_cost~size_cost) +
  theme(axis.text.x=element_text(angle=45,vjust=1,hjust=1)) +
  ggtitle("columns: increasing size cost. rows: increasing color cost")
ggsave("graphs/o1_cf.999_sf.999.pdf",width=25,height=20)

ggplot(r[r$object == "o1" & r$color_fidelity == .999 & r$size_fidelity == .9,],aes(x=Utterance,y=Probability,color=speaker.opt,group=speaker.opt)) +
  geom_point() +
  geom_line() +
  facet_grid(color_cost~size_cost) +
  theme(axis.text.x=element_text(angle=45,vjust=1,hjust=1)) +
  ggtitle("columns: increasing size cost. rows: increasing color cost")
ggsave("graphs/o1_cf.999_sf.9.pdf",width=25,height=20)

ggplot(r[r$object == "o1" & r$color_fidelity == .999 & r$size_fidelity == .8,],aes(x=Utterance,y=Probability,color=speaker.opt,group=speaker.opt)) +
  geom_point() +
  geom_line() +
  facet_grid(color_cost~size_cost) +
  theme(axis.text.x=element_text(angle=45,vjust=1,hjust=1)) +
  ggtitle("columns: increasing size cost. rows: increasing color cost")
ggsave("graphs/o1_cf.999_sf.8.pdf",width=25,height=20)

ggplot(r[r$object == "o1" & r$color_fidelity == .8 & r$size_fidelity == .6,],aes(x=Utterance,y=Probability,color=speaker.opt,group=speaker.opt)) +
  geom_point() +
  geom_line() +
  facet_grid(color_cost~size_cost) +
  theme(axis.text.x=element_text(angle=45,vjust=1,hjust=1)) +
  ggtitle("columns: increasing size cost. rows: increasing color cost")
ggsave("graphs/o1_cf.8_sf.6.pdf",width=25,height=20)

ggplot(r[r$object == "o1" & r$color_fidelity == .8 & r$size_fidelity == .7,],aes(x=Utterance,y=Probability,color=speaker.opt,group=speaker.opt)) +
  geom_point() +
  geom_line() +
  facet_grid(color_cost~size_cost) +
  theme(axis.text.x=element_text(angle=45,vjust=1,hjust=1)) +
  ggtitle("columns: increasing size cost. rows: increasing color cost")
ggsave("graphs/o1_cf.8_sf.7.pdf",width=25,height=20)

ggplot(r[r$object == "o1" & r$color_fidelity == .8 & r$size_fidelity == .7,],aes(x=Utterance,y=Probability,color=speaker.opt,group=speaker.opt)) +
  geom_point() +
  geom_line() +
  facet_grid(color_cost~size_cost) +
  theme(axis.text.x=element_text(angle=45,vjust=1,hjust=1)) +
  ggtitle("columns: increasing size cost. rows: increasing color cost")
ggsave("graphs/o1_cf.8_sf.7.pdf",width=25,height=20)

### TRYING TO HONE IN ON THE IMPORTANT REGIONS
summary(d$big_red)
d[d$object == "o1" & d$big_red > .75 & d$big < .25 & d$red < .05,c("color_fidelity","size_fidelity","big","red","big_red","speaker.opt","color_cost","size_cost")]

summary(d[d$object == "o3" & d$small_yellow < .15 & d$small < .05 & d$yellow > .85 & d$color_cost == .1 & d$size_cost < .3 & d$color_fidelity > .75 & d$size_fidelity > .6 & d$color_fidelity > d$size_fidelity,c("color_fidelity","size_fidelity","small","yellow","small_yellow","speaker.opt","color_cost","size_cost")])

d[d$object == "o3" & d$color_cost == .1 & d$size_cost == .1 & d$color_fidelity > .75 & d$size_fidelity > .6 & d$color_fidelity > d$size_fidelity & d$speaker.opt > 10 & d$yellow > .85,c("color_fidelity","size_fidelity","small","yellow","small_yellow","speaker.opt")]

d[d$object == "o1" & d$color_cost == .1 & d$size_cost == .1 & d$color_fidelity == .999 & d$size_fidelity > .6 & d$color_fidelity > d$size_fidelity & d$speaker.opt == 18,c("color_fidelity","size_fidelity","big","red","big_red")]

### PLOT JUST THE RANGES THAT ARE RELEVANT
# COLOR COST .1
# SIZE COST .1 AND .2
# SPEAKER OPTIMALITY > 10
# COLOR FIDELITY .85, .9, .999
# SIZE FIDELITY .7, .75, .8

ggplot(r[r$object == "o1" & r$color_fidelity > .6 & r$size_fidelity > .6  & r$color_cost == .1 & r$size_cost == .1 & (as.numeric(as.character(r$speaker.opt)) > 10 | as.numeric(as.character(r$speaker.opt)) == 5),],aes(x=Utterance,y=Probability,color=speaker.opt,group=speaker.opt)) +
  geom_point() +
  geom_line() +
  facet_grid(color_fidelity~size_fidelity) +
  theme(axis.text.x=element_text(angle=45,vjust=1,hjust=1)) +
  ggtitle("columns: increasing size fidelity. rows: increasing color fidelity")
ggsave("graphs/o1_cc.1_sc.1.pdf",width=20,height=15)

ggplot(r[r$object == "o2" & r$color_fidelity > .6 & r$size_fidelity > .6  & r$color_cost == .1 & r$size_cost == .1 & (as.numeric(as.character(r$speaker.opt)) > 10 | as.numeric(as.character(r$speaker.opt)) == 5),],aes(x=Utterance,y=Probability,color=speaker.opt,group=speaker.opt)) +
  geom_point() +
  geom_line() +
  facet_grid(color_fidelity~size_fidelity) +
  theme(axis.text.x=element_text(angle=45,vjust=1,hjust=1)) +
  ggtitle("columns: increasing size fidelity. rows: increasing color fidelity")
ggsave("graphs/o2_cc.1_sc.1.pdf",width=20,height=15)

ggplot(r[r$object == "o3" & r$color_fidelity > .6 & r$size_fidelity > .6  & r$color_cost == .1 & r$size_cost == .1 & (as.numeric(as.character(r$speaker.opt)) > 10 | as.numeric(as.character(r$speaker.opt)) == 5),],aes(x=Utterance,y=Probability,color=speaker.opt,group=speaker.opt)) +
  geom_point() +
  geom_line() +
  facet_grid(color_fidelity~size_fidelity) +
  theme(axis.text.x=element_text(angle=45,vjust=1,hjust=1)) +
  ggtitle("columns: increasing size fidelity. rows: increasing color fidelity")
ggsave("graphs/o3_cc.1_sc.1.pdf",width=20,height=15)

### PLOT MODEL PREDICTIONS WITH (EYE-BALLING) BEST PARAMETERS FOR ALL THREE OBJECTS ALONGSIDE EMPIRICAL DATA FROM GATT ET AL 2011 (BOTH ENGLISH AND DUTCH)

t = droplevels(subset(r, color_fidelity == .999 & size_fidelity == .8 & color_cost == .1 & size_cost == .1 & speaker.opt == 17))
t
t$DataType = "model prediction"

emp = data.frame(object = rep(rep(c("o1","o2","o3"),each=7),2),DataType=rep(c("empirical (Dutch)","empirical (English)"),each=21),Utterance=rep(levels(r$Utterance),6),Probability=c(.21,.003,.79,0,0,0,0,NA,NA,NA,NA,NA,NA,NA,0,0,0,.003,0,.9,.1,.17,.03,.8,0,0,0,0,NA,NA,NA,NA,NA,NA,NA,0,0,0,0,0,.92,.08))
head(emp)

toplot = merge(t,emp,all=T)
toplot$DataType = as.factor(as.character(toplot$DataType))
summary(toplot)

ggplot(toplot, aes(x=Utterance,y=Probability,fill=DataType)) +
  geom_bar(stat="identity",position="dodge") +
  facet_wrap(~object) +
  ggtitle(paste("c_fidelity ",unique(t$color_fidelity), ", s_fidelity ",unique(t$size_fidelity), ", c_cost ", unique(t$color_cost), ", s_cost ", unique(t$size_cost), ", sp_opt ", unique(t$speaker.opt),sep="")) +  
  theme(axis.text.x=element_text(angle=45,vjust=1,hjust=1),plot.title = element_text(size=10)) 
  
ggsave("graphs/model.vs.empirical.pdf",height=6)