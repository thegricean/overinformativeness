
theme_set(theme_bw(18))
setwd("~/cogsci/projects/stanford/projects/overinformativeness/church_playground/threshold_models/firsttry/")
source("rscripts/helpers.r")

r = read.table("data/modelresults.txt", header=T, sep="\t",quote="")
nrow(r)
r$ColorPr = paste(r$ColorPrior,"(c)")
r$SizePr = paste(r$SizePrior,"(s)")
r$MatchedPrior = as.factor(ifelse(r$ColorPrior == r$SizePrior, "matched","not matched"))
r$ColorPrior = factor(x=as.character(r$ColorPr), levels=c("flat (c)","super-left-peak (c)","left-peak (c)","mid-peak (c)","super-mid-peak (c)","right-peak (c)","super-right-peak (c)"))
r$SizePrior = factor(x=as.character(r$SizePr), levels=c("flat (s)","super-left-peak (s)","left-peak (s)","mid-peak (s)","super-mid-peak (s)","right-peak (s)","super-right-peak (s)"))

r$ValueCombo = as.factor(paste(r$ColorValue,r$SizeValue))
r$MatchedObject = as.factor(ifelse(r$ColorValue == r$SizeValue, "matched", "not matched"))
levels(r$ValueCombo)
head(r)
summary(r)


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

#plot only cases of matched priors and object values
matched = droplevels(subset(r, MatchedPrior == "matched" & MatchedObject == "matched"))
nrow(matched)
head(matched)

gat = matched %>% gather(Utterance, Probability, ProbColor:ProbSilence)
gat$Cost = factor(x=as.character(gat$Costs), levels=c("uniform","prefer-fewer-words","prefer-fewer-words-and-color"))
gat$Utterance = gsub("Prob","",gat$Utterance)
gat$Utterance = as.character(gat$Utterance)

# add priors:
priors = data.frame(ColorValue=rep(seq(0,0.4,by=0.1),21),
                    Cost=rep(rep(levels(gat$Cost),each=5),7),
                    Utterance="Prior",
                    ColorPrior=rep(levels(gat$ColorPrior),each=15),
                    Probability=c(rep(c(.2,.2,.2,.2,.2),3),rep(c(.96,.01,.01,.01,.01),3),rep(c(.7,.2,.06,.03,.01),3),rep(c(.05,.2,.5,.2,.05),3),rep(c(.01,.1,.78,.1,.01),3),rep(c(.01,.03,.06,.2,.7),3),rep(c(.01,.01,.01,.01,.96),3)))
head(priors)

gatp = merge(gat, priors, all=T)
gatp$Utterance = factor(x=as.character(gatp$Utterance),levels=c("Prior","Silence","Color","Size","ColorSize"))
summary(gatp)

ggplot(gatp, aes(x=ColorValue,y=Probability,color=Utterance,group=Utterance)) +
  geom_point() +
  geom_line(size=2) +
  scale_color_manual(values=c("gray60","black","red","blue","purple")) +
  xlab("Object value (same for 'color' and 'size')") +
  facet_grid(ColorPrior~Cost)
ggsave("graphs/matched_variance.pdf",width=12,height=10)
ggsave("graphs/matched_variance.jpg",width=12,height=10)
