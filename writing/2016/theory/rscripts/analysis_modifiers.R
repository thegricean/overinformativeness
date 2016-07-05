setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/7_overinf_basiclevel_biggersample/results")
source("rscripts/helpers.r")

d = read.csv(file="data/results_for_regression.csv",quote="")
# This dataset includes the 6 cases where the insufficient dimension was underinformatively produced
d[d$redUtterance == "other",]

# To exclude these:
t = droplevels(subset(d, redUtterance %in% c("minimal","redundant")))
t$SceneVariation = t$NumDiff/t$NumDistractors
t$Item = as.factor(as.character(t$Item))
nrow(t)

centered = cbind(t, myCenter(t[,c("SufficientProperty","NumDistractors","NumSameDistractors","roundNum","SceneVariation","SceneVariation")]))
contrasts(centered$redUtterance)
contrasts(centered$SufficientProperty)

pairscor.fnc(centered[,c("redUtterance","SufficientProperty","NumDistractors","NumSameDistractors","SceneVariation","SceneVariation")])

# reported in paper along with Fig. 8
m = glmer(redUtterance ~ cSufficientProperty*cSceneVariation + (1+cSceneVariation|gameid) + (1|Item), data=centered, family="binomial")
summary(m)

# reported in paper along with Fig. 8
m.simple = glmer(redUtterance ~ SufficientProperty*cSceneVariation - cSceneVariation + (1+cSceneVariation|gameid) + (1|Item), data=centered, family="binomial")
summary(m.simple)

# do the analysis only on those cases that have variation > 0
centered = cbind(t[t$SceneVariation > 0,], myCenter(t[t$SceneVariation > 0,c("SufficientProperty","NumDistractors","NumSameDistractors","roundNum","SceneVariation","SceneVariation")]))
contrasts(centered$redUtterance)
contrasts(centered$SufficientProperty)

pairscor.fnc(centered[,c("redUtterance","SufficientProperty","NumDistractors","NumSameDistractors","SceneVariation","SceneVariation")])
m = glmer(redUtterance ~ cSufficientProperty*cSceneVariation + (1+cSceneVariation|gameid) + (1|Item), data=centered, family="binomial")
summary(m) # doing the analysis only on the ratio > 0 cases gets rid of the interaction, ie variation has the same effect on color-redundant and size-redunant trials. (that is, the big scene variation slop in hte color-redundant condition was driven mostly by the 0-ratio cases)

### ARRGH TYPICALITY ANALYSIS IS A MESS

# figure out effect of typicality (only on size-sufficient trials since we don't have size norms) -- this is for later part of paper
size = droplevels(subset(t, SufficientProperty == "size"))
size = droplevels(subset(t, SufficientProperty == "size" & SceneVariation > 0))
size$ratioTypicalityUnModmod = size$ColorTypicalityUnModified/size$ColorTypicalityModified
size$ratioTypicalityModUnmod = size$ColorTypicalityModified/size$ColorTypicalityUnModified
size$diffTypicalityModUnmod = size$ColorTypicalityModified - size$ColorTypicalityUnModified
size$diffOtherTypicalityModUnmod = size$OtherColorTypicalityModified - size$OtherColorTypicalityUnModified
size$ratioTypDiffs = size$diffTypicalityModUnmod/size$diffOtherTypicalityModUnmod
size$diffTypDiffs = size$diffTypicalityModUnmod - size$diffOtherTypicalityModUnmod

cor(size$diffTypDiffs,size$ColorTypicality)
cor(size$ratioTypDiffs,size$ColorTypicality)
cor(size$diffTypicalityModUnmod,size$ColorTypicality)
cor(size$ratioTypicalityUnModmod,size$ColorTypicality)
cor(size$ratioTypicalityModUnmod,size$ColorTypicality)
cor(size$ColorTypicalityModified,size$ColorTypicality)
cor(size$ColorTypicalityUnModified,size$ColorTypicality)
mean(size$ColorTypicalityModified)
sd(size$ColorTypicalityModified)
mean(size$ColorTypicalityUnModified)
sd(size$ColorTypicalityUnModified)

Mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

Mode(size$ColorTypicalityModified)
median(size$ColorTypicalityModified)
Mode(size$ColorTypicalityUnModified)
median(size$ColorTypicalityUnModified)

# histogram of typicalities
gathered = size %>%
  select(ColorTypicalityModified,ColorTypicalityUnModified) %>%
  gather(TypicalityType,Value)
gathered$UtteranceType = as.factor(ifelse(gathered$TypicalityType == "ColorTypicalityModified","modified","unmodified"))

dens = ggplot(gathered, aes(x=Value,fill=UtteranceType)) +
  geom_density(alpha=.3) +
  xlab("Typicality") +
  scale_fill_discrete(name="Utterance type")

diffs = ggplot(size, aes(x=diffTypicalityModUnmod)) +
  geom_histogram(binwidth=.03) +
  xlab("Difference between modified and unmodified typicality") +
  geom_vline(xintercept=0,color="blue")

library(gridExtra)
pdf("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/theory/pics/typicality-dists.pdf",height=3,width=9)
grid.arrange(dens,diffs,nrow=1)
dev.off()

centered = cbind(size, myCenter(size[,c("SufficientProperty","NumDistractors","NumSameDistractors","roundNum","SceneVariation","ColorTypicality","normTypicality","TypicalityDiff","ColorTypicalityModified","normTypicalityModified","TypicalityDiffModified","ColorTypicalityUnModified","normTypicalityUnModified","TypicalityDiffUnModified","ratioTypicalityUnModmod","ratioTypicalityModUnmod","diffTypicalityModUnmod","ratioTypDiffs","diffTypDiffs")]))
contrasts(centered$redUtterance)
summary(centered)
nrow(centered)

pairscor.fnc(centered[,c("SceneVariation","ratioTypicalityModUnmod","redUtterance","diffTypicalityModUnmod")])

# "pure typicality"
m = glmer(redUtterance ~ cSceneVariation+cColorTypicality + (1|gameid) + (1|Item), data=centered, family="binomial")
summary(m)

m = glmer(redUtterance ~ cColorTypicality + (1+cColorTypicality|gameid) + (1|Item), data=centered, family="binomial")
summary(m)

agr = size %>%
  group_by(Item,ColorTypicality) %>%
  summarize(Probability=mean(redundant),CILow=ci.low(redundant),CIHigh=ci.high(redundant))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$CILow
agr$YMax = agr$Probability + agr$CIHigh

ggplot(agr, aes(x=ColorTypicality,y=Probability)) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax)) +
  geom_smooth(method="lm")

agr = size %>%
  group_by(Item,ColorTypicality,SceneVariation) %>%
  summarize(Probability=mean(redundant),CILow=ci.low(redundant),CIHigh=ci.high(redundant))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$CILow
agr$YMax = agr$Probability + agr$CIHigh

ggplot(agr, aes(x=ColorTypicality,y=Probability)) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax)) +
  geom_smooth(method="lm") +
  facet_wrap(~SceneVariation)

agr = size %>%
  group_by(Item,diffTypDiffs,SceneVariation) %>%
  summarize(Probability=mean(redundant),CILow=ci.low(redundant),CIHigh=ci.high(redundant))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$CILow
agr$YMax = agr$Probability + agr$CIHigh

ggplot(agr, aes(x=diffTypDiffs,y=Probability)) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax)) +
  geom_smooth(method="lm") +
  facet_wrap(~SceneVariation)

m.scene = glmer(redUtterance ~ cSceneVariation + (1|gameid) + (1|Item), data=centered, family="binomial")
summary(m.scene)



m.diff = glmer(redUtterance ~ cdiffTypicalityModUnmod + (1+cdiffTypicalityModUnmod|gameid) + (1+cdiffTypicalityModUnmod|Item), data=centered, family="binomial")
summary(m.diff)

# the following two are currently reported in the paper
m.diff = glmer(redUtterance ~ cSceneVariation+cdiffTypicalityModUnmod + (1+cdiffTypicalityModUnmod|gameid) + (1|Item), data=centered, family="binomial")
summary(m.diff)

m.puretyp = glmer(redUtterance ~ cSceneVariation+cColorTypicality + (1+cColorTypicality|gameid) + (1|Item), data=centered, family="binomial")
summary(m.puretyp)

anova(m.scene,m.ratio)

agr = size %>%
  group_by(Item,diffTypicalityModUnmod,SceneVariation) %>%
  summarize(Probability=mean(redundant),CILow=ci.low(redundant),CIHigh=ci.high(redundant))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$CILow
agr$YMax = agr$Probability + agr$CIHigh

ggplot(agr, aes(x=diffTypicalityModUnmod,y=Probability)) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax)) +
  geom_smooth(method="lm") 

