setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/7_overinf_basiclevel_biggersample/results")
source("rscripts/helpers.r")

d = read.csv(file="data/results_for_regression.csv",quote="")
# This dataset includes the 6 cases where the insufficient dimension was underinformatively produced
d[d$redUtterance == "other",]

# To exclude these:
t = droplevels(subset(targets, redUtterance %in% c("minimal","redundant")))
t$SceneVariation = t$NumDiff/t$NumDistractors
t$Item = as.factor(as.character(t$Item))
nrow(t)

centered = cbind(t, myCenter(t[,c("SufficientProperty","NumDistractors","NumSameDistractors","roundNum","SceneVariation","SceneVariation")]))
contrasts(centered$redUtterance)
contrasts(centered$SufficientProperty)

pairscor.fnc(centered[,c("redUtterance","SufficientProperty","NumDistractors","NumSameDistractors","SceneVariation","SceneVariation")])

# reported in paper along with Fig. 4
m = glmer(redUtterance ~ cSufficientProperty*cSceneVariation + (1+cSceneVariation|gameid) + (1|Item), data=centered, family="binomial")
summary(m)

# reported in paper along with Fig. 4
m.simple = glmer(redUtterance ~ SufficientProperty*cSceneVariation - cSceneVariation + (1+cSceneVariation|gameid) + (1|Item), data=centered, family="binomial")
summary(m.simple)


# do the analysis only on those cases that have variation > 0
centered = cbind(t[t$SceneVariation > 0,], myCenter(t[t$SceneVariation > 0,c("SufficientProperty","NumDistractors","NumSameDistractors","roundNum","SceneVariation","SceneVariation")]))
contrasts(centered$redUtterance)
contrasts(centered$SufficientProperty)

pairscor.fnc(centered[,c("redUtterance","SufficientProperty","NumDistractors","NumSameDistractors","SceneVariation","SceneVariation")])
m = glmer(redUtterance ~ cSufficientProperty*cSceneVariation + (1+cSceneVariation|gameid) + (1|Item), data=centered, family="binomial")
summary(m) # doing the analysis only on the ratio > 0 cases gets rid of the interaction, ie variation has the same effect on color-redundant and size-redunant trials. (that is, the big scene variation slop in hte color-redundant condition was driven mostly by the 0-ratio cases)


# figure out effect of typicality (only on size-sufficient trials since we don't have size norms) -- this is for later part of paper
size = droplevels(subset(t, SufficientProperty == "size"))

centered = cbind(size, myCenter(size[,c("SufficientProperty","NumDistractors","NumSameDistractors","roundNum","SceneVariation","ColorTypicality","normTypicality","TypicalityDiff","ColorTypicalityModified","normTypicalityModified","TypicalityDiffModified","ColorTypicalityUnModified","normTypicalityUnModified","TypicalityDiffUnModified","SceneVariation")]))
contrasts(centered$redUtterance)
summary(centered)
nrow(centered)

pairscor.fnc(centered[,c("redUtterance","SufficientProperty","NumDistractors","NumSameDistractors","SceneVariation","ColorTypicality","normTypicality","TypicalityDiff","SceneVariation")])

# "pure typicality"
m = glmer(redUtterance ~ cSceneVariation+cColorTypicality + (1|gameid) + (1|Item), data=centered, family="binomial")
summary(m)

m.norm = glmer(redUtterance ~ cSceneVariation+cnormTypicality + (1|gameid) + (1|Item), data=centered, family="binomial")
summary(m.norm)

m.diff = glmer(redUtterance ~ cSceneVariation+cTypicalityDiff + (1|gameid) + (1|Item), data=centered, family="binomial")
summary(m.diff)

# "unmodified" typicality gets slightly worse BIC
m = glmer(redUtterance ~ cSceneVariation+cColorTypicalityUnModified + (1|gameid) + (1|Item), data=centered, family="binomial")
summary(m)

m.norm = glmer(redUtterance ~ cSceneVariation+cnormTypicalityUnModified + (1|gameid) + (1|Item), data=centered, family="binomial")
summary(m.norm)

m.diff = glmer(redUtterance ~ cSceneVariation+cTypicalityDiffUnModified + (1|gameid) + (1|Item), data=centered, family="binomial")
summary(m.diff)

# "modified" typicality gets slightly worse BIC
m = glmer(redUtterance ~ cSceneVariation+cColorTypicalityModified + (1|gameid) + (1|Item), data=centered, family="binomial")
summary(m)

m.norm = glmer(redUtterance ~ cSceneVariation+cnormTypicalityModified + (1|gameid) + (1|Item), data=centered, family="binomial")
summary(m.norm)

m.diff = glmer(redUtterance ~ cSceneVariation+cTypicalityDiffModified + (1|gameid) + (1|Item), data=centered, family="binomial")
summary(m.diff)

# figure out effect of typicality on only those cases with at least some scene variation
size = droplevels(subset(t, SufficientProperty == "size" & SceneVariation > 0))

centered = cbind(size, myCenter(size[,c("SufficientProperty","NumDistractors","NumSameDistractors","roundNum","SceneVariation","ColorTypicality","normTypicality","TypicalityDiff")]))
contrasts(centered$redUtterance)
summary(centered)
nrow(centered)

pairscor.fnc(centered[,c("redUtterance","SufficientProperty","NumDistractors","NumSameDistractors","SceneVariation","ColorTypicality","normTypicality","TypicalityDiff")])

m = glmer(redUtterance ~ cSceneVariation+cColorTypicality + (1|gameid) + (1|Item), data=centered, family="binomial")
summary(m)

m.norm = glmer(redUtterance ~ cSceneVariation+cnormTypicality + (1|gameid) + (1|Item), data=centered, family="binomial")
summary(m.norm) # both scene variation and color typicality matter!

m.diff = glmer(redUtterance ~ cSceneVariation+cTypicalityDiff + (1|gameid) + (1|Item), data=centered, family="binomial")
summary(m.diff)

# write the cases of size overspecification
t = subset(targets, redUtterance == "redundant" & SufficientProperty == "color")
tred = t[,c("clickedType","clickedColor","clickedSize","SceneVariation")]
tred[order(tred[,c("clickedType")]),]
write.csv(tred[order(tred[,c("clickedType")]),],file="data/size_overspecification.csv",quote=F,row.names=F)

