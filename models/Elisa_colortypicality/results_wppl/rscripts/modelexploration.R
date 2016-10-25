setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/Elisa_colortypicality/")


######### PLOT LISTENER #########

dlistener = read.table(paste("results_wppl/data/listener_exploration.csv",sep=""),sep=",")

# fix headers:
colnames(dlistener) = c("alpha","lengthWeight","","","cost_color","cost_type","utterance","object","probability") 
head(dlistener)
summary(dlistener)

bananatestplot = dlistener[dlistener$V17 %in% c("banana","yellow_banana"),]
summary(bananatestplot)
nrow(bananatestplot)

bananatestplot = unique(bananatestplot[,c("V3","V4","V6","V7","V8","V10","V17","V18","V19")])
head(bananatestplot)

ggplot(bananatestplot,aes(x=V18,y=V19,color=as.factor(V3),group=interaction(V3,V7,V8),shape=as.factor(V8),linetype=as.factor(V7))) +
  geom_point() +
  geom_line() +
  facet_grid(V17~V4) +
  theme(axis.text.x = element_text(angle=45,hjust=1,vjust=1))
