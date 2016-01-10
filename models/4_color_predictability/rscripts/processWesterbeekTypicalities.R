theme_set(theme_bw(18))
setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/4_color_predictability/")
#source("rscripts/helpers.R")


costs = c(.1, .2, .1, .2, .1, .2, .1, .2, .1, .2, .1, .2)
exp(-costs)/sum(exp(-costs))

costs = c(.1, .01, .1, .01, .1, .01, .1, .01, .1, .01, .1, .01)

exp(-costs)/sum(exp(-costs))

# to rescale typicality values (0-100) to fidelity values (.6-1). We start at .6 so there's still a *general* bias to actually retrieve the correct value and it's not entirely random:
#(a/1.00)*(1.00-.60) + .60

# typicality values from westerbeek et al 2015
d = data.frame(Object = rep(c("pepper","apple","banana","carrot","cheese","corn","grapes","lemon","lettuce","orange","pear","pineapple","pumpkin","tomato"),each=5), Color = rep(c("blue","yellow","green","orange","red"),14) ,RawTypicality = c(2,91,88,76,97,5,58,60,92,93,19,91,37,25,6,13,18,14,98,6,3,98,5,51,9,9,97,19,38,5,16,57,97,17,17,7,95,5,71,5,3,67,92,4,3,13,47,19,91,10,5,40,68,33,18,12,75,10,54,18,2,39,12,98,21,3,21,38,65,97))

d$Fidelity = (d$RawTypicality/100)*(1.00-.60)+.60
sums = d %>%
  group_by(Object) %>%
  summarise(Sum=sum(RawTypicality))# for turning the raw typicality values into distributions
sums = as.data.frame(sums)
row.names(sums) = sums$Object

d$Probability = d$RawTypicality/sums[as.character(d$Object),]$Sum
tail(d,10)

softmax <- function(x,lambda) 
{
  return(exp(lambda*log(x))/sum(exp(lambda*log(x))))
}

spread = d %>%
  select(Probability,Color,Object) %>%
  group_by(Object) %>%
  spread(Color,Probability)
spread

paste(d$Color,d$Fidelity)
unique(d$Object)
row.names(d) = paste(d$Color, d$Object)

# experiment 1 results from westerbeek et al 2015 (too bad there are no error bars...)
exp1 = data.frame(Object = c("cheese","pumpkin","carrot","grapes","corn","pepper","tomato","lemon","apple","lettuce","banana","orange","pepper","pineapple","pear","apple","pineapple","cheese","orange","pear","pumpkin","corn","tomato","banana","carrot","grapes","grapes","pumpkin","pineapple","orange","banana","carrot","apple","lemon","lemon","cheese","corn","pear","lettuce","lettuce","tomato","pepper"),Color=c("yellow","orange","orange","green","yellow","red","red","yellow","red","green","yellow","orange","orange","yellow","green","yellow","orange","orange","yellow","yellow","yellow","orange","green","orange","yellow","red","blue","green","green","red","red","red","blue","green","red","green","red","blue","orange","red","blue","blue"),RedundantProbability=c(.13,.23,.13,.18,.08,.35,.17,.13,.15,.15,.15,.10,.55,.18,.10,.38,.2,.33,.65,.18,.65,.3,.68,.40,.65,.41,.6,.73,.48,.76,.85,.51,.88,.72,.84,.75,.65,.83,.73,.74,.85,.7))
exp1$Typicality = d[paste(exp1$Color,exp1$Object),]$RawTypicality
exp1$Typicality01 = exp1$Typicality/100
exp1$PriorProbability = d[paste(exp1$Color,exp1$Object),]$Probability
exp1$logPriorProbability = log(exp1$PriorProbability)

ggplot(exp1, aes(x=Typicality01,y=RedundantProbability,color=Color,group=1)) +
  geom_point() +
  geom_smooth(method="lm",color="gray60") +
  ylab("Probability of redundancy") +
  xlab("Typicality of color") +
  geom_text(aes(label=paste(Color,Object)),size=3) +
  scale_color_manual(values=c("blue","green","orange","red","yellow")) +
  guides(color=F)
ggsave("graphs/westerbeek-results.pdf",height=3.5,width=5)

ggplot(exp1, aes(x=PriorProbability,y=RedundantProbability,color=Color,group=1)) +
  geom_point() +
  geom_smooth(method="lm",color="gray60") +
  ylab("Probability of redundancy") +
  xlab("Prior probability of color") +
  geom_text(aes(label=paste(Color,Object)),size=3) +
  scale_color_manual(values=c("blue","green","orange","red","yellow")) +
  guides(color=F)
ggsave("graphs/westerbeek-results-bypriorprob.pdf",height=3.5,width=5)

ggplot(exp1, aes(x=logPriorProbability,y=RedundantProbability,color=Color,group=1)) +
  geom_point() +
  geom_smooth(method="lm",color="gray60") +
  ylab("Probability of redundancy") +
  xlab("Log prior probability of color") +
  geom_text(aes(label=paste(Color,Object)),size=3) +
  scale_color_manual(values=c("blue","green","orange","red","yellow")) +
  guides(color=F)
ggsave("graphs/westerbeek-results-bylogpriorprob.pdf",height=3.5,width=5)

m.typ = lm(RedundantProbability~Typicality01,data=exp1)
summary(m.typ)

m.prior = lm(RedundantProbability~PriorProbability,data=exp1)
summary(m.prior)

m.logprior = lm(RedundantProbability~logPriorProbability,data=exp1)
summary(m.logprior)

m.typprior = lm(RedundantProbability~Typicality01 + PriorProbability,data=exp1)
summary(m.typprior) # r2: .79, adjusted: .78

m.typlogprior = lm(RedundantProbability~Typicality01 + logPriorProbability,data=exp1)
summary(m.typlogprior) # r2: .79, adjusted: .78

m.typbyprior = lm(RedundantProbability~Typicality01*PriorProbability,data=exp1)
summary(m.typbyprior) # r2: .81, adjusted: .8

m.typbylogprior = lm(RedundantProbability~Typicality01*logPriorProbability,data=exp1)
summary(m.typbylogprior) # r2: .8, adjusted: .79

anova(m.typ,m.typprior)
anova(m.prior,m.typprior)
anova(m.typprior,m.typbyprior)

anova(m.typ,m.typlogprior)
anova(m.logprior,m.typlogprior)
anova(m.typlogprior,m.typbylogprior)
exp1$TypicalityBin = cut_number(exp1$Typicality01,3)
exp1$PriorProbabilityBin = cut_number(exp1$PriorProbability,3)
exp1$logPriorProbabilityBin = cut_number(exp1$logPriorProbability,3)

ggplot(exp1, aes(x=PriorProbability,y=RedundantProbability,color=TypicalityBin)) +
  geom_point() +
  geom_smooth(method="lm") +
  ylab("Probability of redundancy") +
  xlab("Prior probability of color")
ggsave("graphs/westerbeek-results-priorbytypicality.pdf",height=3.5,width=6)

ggplot(exp1, aes(x=logPriorProbability,y=RedundantProbability,color=TypicalityBin)) +
  geom_point() +
  geom_smooth(method="lm") +
  ylab("Probability of redundancy") +
  xlab("Log prior probability of color")
ggsave("graphs/westerbeek-results-logpriorbytypicality.pdf",height=3.5,width=6)

ggplot(exp1, aes(x=Typicality,y=RedundantProbability,color=PriorProbabilityBin)) +
  geom_point() +
  geom_smooth(method="lm") +
  ylab("Probability of redundancy") +
  xlab("Color typicality")

ggplot(exp1, aes(x=Typicality,y=RedundantProbability,color=logPriorProbabilityBin)) +
  geom_point() +
  geom_smooth(method="lm") +
  ylab("Probability of redundancy") +
  xlab("Color typicality")



