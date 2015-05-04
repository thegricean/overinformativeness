
theme_set(theme_bw(18))
setwd("~/cogsci/projects/stanford/projects/overinformativeness/church_playground/threshold_models/firsttry/")
source("rscripts/helpers.r")

r = read.table("data/modelresults.txt", header=T, sep="\t",quote="")
nrow(r)
r$ColorPr = paste(r$ColorPrior,"(c)")
r$SizePr = paste(r$SizePrior,"(s)")
r$ColorPrior = factor(x=as.character(r$ColorPr), levels=c("super-left-peak (c)","left-peak (c)","flat (c)","mid-peak (c)","super-mid-peak (c)","right-peak (c)","super-right-peak (c)"))
r$SizePrior = factor(x=as.character(r$SizePr), levels=c("super-left-peak (s)","left-peak (s)","flat (s)","mid-peak (s)","super-mid-peak (s)","right-peak (s)","super-right-peak (s)"))

r$ValueCombo = as.factor(paste(r$ColorValue,r$SizeValue))
levels(r$ValueCombo)
head(r)

rect = data.frame(xmin=c(0,5.5,10.5,15.5,20.5), xmax=c(5.5,10.5,15.5,20.5,25.5), ymin=rep(-Inf,5), ymax=rep(Inf,5), alpha=c(.1, .2, .3, .4, .5))

uniform = droplevels(subset(r, Costs == "uniform"))
goldensilence = droplevels(subset(r, Costs == "prefer-fewer-words"))
silencecolor = droplevels(subset(r, Costs == "prefer-fewer-words-and-color"))

uni = uniform %>% gather(Utterance, Probability, ProbColor:ProbSilence)
uni$Utterance = gsub("Prob","",uni$Utterance)
head(uni)

p = ggplot(uni, aes(x=ValueCombo, y=Probability, color=Utterance, group=Utterance)) +
  geom_point() +
  geom_rect(data=rect, inherit.aes=F, aes(xmin=xmin,xmax=xmax,ymin=ymin,ymax=ymax,alpha=alpha),fill="yellow") +   
  scale_alpha(range = c(0, .6)) +
  geom_line() + 
  facet_grid(SizePrior ~ ColorPrior) +    
  theme(axis.text.x=element_text(angle=45, vjust=1,hjust=1))
ggsave("graphs/uttprobs_uniformcosts.pdf",height=15,width=30)


gol = goldensilence %>% gather(Utterance, Probability, ProbColor:ProbSilence)
gol$Utterance = gsub("Prob","",gol$Utterance)
head(gol)

p=ggplot(gol, aes(x=ValueCombo, y=Probability, color=Utterance, group=Utterance)) +
  geom_point() +
  geom_rect(data=rect, inherit.aes=F, aes(xmin=xmin,xmax=xmax,ymin=ymin,ymax=ymax,alpha=alpha),fill="yellow") +   
  scale_alpha(range = c(0, .6)) +  
  geom_line() +
  facet_grid(SizePrior ~ ColorPrior)+
  theme(axis.text.x=element_text(angle=45, vjust=1,hjust=1))
ggsave("graphs/uttprobs_goldensilencecosts.pdf",height=15,width=30)


scol = silencecolor %>% gather(Utterance, Probability, ProbColor:ProbSilence)
scol$Utterance = gsub("Prob","",scol$Utterance)
head(scol)

p=ggplot(scol, aes(x=ValueCombo, y=Probability, color=Utterance, group=Utterance)) +
  geom_point() +
  geom_rect(data=rect, inherit.aes=F, aes(xmin=xmin,xmax=xmax,ymin=ymin,ymax=ymax,alpha=alpha),fill="yellow") +   
  scale_alpha(range = c(0, .6)) +  
  geom_line() +
  facet_grid(SizePrior ~ ColorPrior)+
  theme(axis.text.x=element_text(angle=45, vjust=1,hjust=1))
ggsave("graphs/uttprobs_colorsilencecosts.pdf",height=15,width=30)


