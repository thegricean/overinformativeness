theme_set(theme_bw(18))

setwd("/home/caroline/cocolab/overinformativeness/experiments/4_numdistractors_basiclevel_newitems/results")

#setwd("C:\\Users\\Caroline\\Desktop\\overinformativeness\\experiments\\4_numdistractors_basiclevel_newitems\\results")
#setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/4_numdistractors_basiclevel_newitems/results")
source("rscripts/helpers.R")
source("rscripts/createLaTeXTable.R")

bdCorrect = read.csv(file="noAttr.csv",sep=",")
bdCorrect$superMentioned = ifelse(bdCorrect$superClassMentioned | bdCorrect$superclassattributeMentioned, T, F)
bdCorrect$typeLength = nchar(as.character(bdCorrect$nameClickedObj))
bdCorrect$basiclevelLength = nchar(as.character(bdCorrect$basiclevelClickedObj))
bdCorrect$TypeShorter = ifelse(bdCorrect$typeLength < bdCorrect$basiclevelLength, "type_shorter_than_BL","type_longer_than_BL")
bdCorrect$typeNumOfChar2bins = ifelse(bdCorrect$typeLength < 9, "01-08", "9+" )
bdCorrect$typeNumOfChar4bins = ifelse(bdCorrect$typeLength < 4, "01-03",
                                      ifelse((bdCorrect$typeLength < 7 & bdCorrect$typeLength > 3), "04-06", 
                                             ifelse((bdCorrect$typeLength < 10 & bdCorrect$typeLength > 6), "07-09", "10+" )))
bdCorrect$typeNumOfChar6bins = ifelse(bdCorrect$typeLength < 4, "01-03",
                                      ifelse((bdCorrect$typeLength < 6 & bdCorrect$typeLength > 3), "04-05", 
                                             ifelse((bdCorrect$typeLength < 8 & bdCorrect$typeLength > 5), "06-07", 
                                                    ifelse((bdCorrect$typeLength < 10 & bdCorrect$typeLength > 7), "08-09",  
                                                           ifelse((bdCorrect$typeLength < 12 & bdCorrect$typeLength > 9), "10-11", "12+" )))))
bdCorrect$typeNumOfChar8bins = ifelse(bdCorrect$typeLength < 4, "01-03",
                                      ifelse((bdCorrect$typeLength < 6 & bdCorrect$typeLength > 3), "04-05", 
                                             ifelse((bdCorrect$typeLength < 8 & bdCorrect$typeLength > 5), "06-07", 
                                                    ifelse((bdCorrect$typeLength < 10 & bdCorrect$typeLength > 7), "08-09", 
                                                           ifelse((bdCorrect$typeLength < 12 & bdCorrect$typeLength > 9), "10-11", 
                                                                  ifelse((bdCorrect$typeLength < 14 & bdCorrect$typeLength > 11), "12-13", 
                                                                         ifelse((bdCorrect$typeLength < 16 & bdCorrect$typeLength > 13), "14-15", "16+" )))))))
bdCorrect$typeBasiclevelLengthRatio = bdCorrect$typeLength / bdCorrect$basiclevelLength
lengthRatioMedian = 2
lengthRatioMean = 1.9890

# 2 bins analysis MEDIAN

bdCorrect$lengthRatio2bins = ifelse(bdCorrect$typeBasiclevelLengthRatio < lengthRatioMedian, "smaller_typeBLRatio", "bigger_typeBLRatio" )

lengthRatio1stQu = 1.5
lengthRatio3rdQu = 2.25

bdCorrect$lengthRatio4bins = ifelse(bdCorrect$typeBasiclevelLengthRatio < lengthRatio1stQu, "01_smallest_typeBLRatio", 
                                    ifelse(bdCorrect$typeBasiclevelLengthRatio < lengthRatioMedian, "02_smaller_typeBLRatio", 
                                           ifelse(bdCorrect$typeBasiclevelLengthRatio < lengthRatio3rdQu, "03_bigger_typeBLRatio", "04_biggest_typeBLRatio" )))

bdCorrect$lengthRatio2binsMean = ifelse(bdCorrect$typeBasiclevelLengthRatio < lengthRatioMean, "smaller_typeBLRatio", "bigger_typeBLRatio" )

frequencies = read.table(file="data/frequencyChart.csv",sep=",", header=T, quote="")

bdCorrect$relFreqType = ifelse(bdCorrect$nameClickedObj == "bedsideTable", (subset(frequencies, noun == "bedsideTable"))$relFreq, 
                               ifelse(bdCorrect$nameClickedObj == "blackBear", (subset(frequencies, noun == "blackBear"))$relFreq, 
                                      ifelse(bdCorrect$nameClickedObj == "catfish", (subset(frequencies, noun == "catfish"))$relFreq, 
                                             ifelse(bdCorrect$nameClickedObj == "clownFish", (subset(frequencies, noun == "clownFish"))$relFreq, 
                                                    ifelse(bdCorrect$nameClickedObj == "coffeeTable", (subset(frequencies, noun == "coffeeTable"))$relFreq, 
                                                           ifelse(bdCorrect$nameClickedObj == "convertible", (subset(frequencies, noun == "convertible"))$relFreq, 
                                                                  ifelse(bdCorrect$nameClickedObj == "daisy", (subset(frequencies, noun == "daisy"))$relFreq, 
                                                                         ifelse(bdCorrect$nameClickedObj == "dalmatian", (subset(frequencies, noun == "dalmatian"))$relFreq, 
                                                                                ifelse(bdCorrect$nameClickedObj == "diningTable", (subset(frequencies, noun == "diningTable"))$relFreq, 
                                                                                       ifelse(bdCorrect$nameClickedObj == "dressShirt", (subset(frequencies, noun == "dressShirt"))$relFreq, 
                                                                                              ifelse(bdCorrect$nameClickedObj == "eagle", (subset(frequencies, noun == "eagle"))$relFreq, 
                                                                                                     ifelse(bdCorrect$nameClickedObj == "germanShepherd", (subset(frequencies, noun == "germanShepherd"))$relFreq, 
                                                                                                            ifelse(bdCorrect$nameClickedObj == "goldFish", (subset(frequencies, noun == "goldFish"))$relFreq, 
                                                                                                                   ifelse(bdCorrect$nameClickedObj == "grizzlyBear", (subset(frequencies, noun == "grizzlyBear"))$relFreq, 
                                                                                                                          ifelse(bdCorrect$nameClickedObj == "gummyBears", (subset(frequencies, noun == "gummyBears"))$relFreq, 
                                                                                                                                 ifelse(bdCorrect$nameClickedObj == "hawaiiShirt", (subset(frequencies, noun == "hawaiiShirt"))$relFreq, 
                                                                                                                                        ifelse(bdCorrect$nameClickedObj == "hummingBird", (subset(frequencies, noun == "hummingBird"))$relFreq, 
                                                                                                                                               ifelse(bdCorrect$nameClickedObj == "husky", (subset(frequencies, noun == "husky"))$relFreq, 
                                                                                                                                                      ifelse(bdCorrect$nameClickedObj == "jellyBeans", (subset(frequencies, noun == "jellyBeans"))$relFreq, 
                                                                                                                                                             ifelse(bdCorrect$nameClickedObj == "mnMs", (subset(frequencies, noun == "mnMs"))$relFreq, 
                                                                                                                                                                    ifelse(bdCorrect$nameClickedObj == "minivan", (subset(frequencies, noun == "minivan"))$relFreq, 
                                                                                                                                                                           ifelse(bdCorrect$nameClickedObj == "pandaBear", (subset(frequencies, noun == "pandaBear"))$relFreq, 
                                                                                                                                                                                  ifelse(bdCorrect$nameClickedObj == "parrot", (subset(frequencies, noun == "parrot"))$relFreq, 
                                                                                                                                                                                         ifelse(bdCorrect$nameClickedObj == "picnicTable", (subset(frequencies, noun == "picnicTable"))$relFreq, 
                                                                                                                                                                                                ifelse(bdCorrect$nameClickedObj == "pigeon", (subset(frequencies, noun == "pigeon"))$relFreq, 
                                                                                                                                                                                                       ifelse(bdCorrect$nameClickedObj == "polarBear", (subset(frequencies, noun == "polarBear"))$relFreq, 
                                                                                                                                                                                                              ifelse(bdCorrect$nameClickedObj == "poloShirt", (subset(frequencies, noun == "poloShirt"))$relFreq, 
                                                                                                                                                                                                                     ifelse(bdCorrect$nameClickedObj == "pug", (subset(frequencies, noun == "pug"))$relFreq, 
                                                                                                                                                                                                                            ifelse(bdCorrect$nameClickedObj == "rose", (subset(frequencies, noun == "rose"))$relFreq, 
                                                                                                                                                                                                                                   ifelse(bdCorrect$nameClickedObj == "skittles", (subset(frequencies, noun == "skittles"))$relFreq, 
                                                                                                                                                                                                                                          ifelse(bdCorrect$nameClickedObj == "sportsCar", (subset(frequencies, noun == "sportsCar"))$relFreq, 
                                                                                                                                                                                                                                                 ifelse(bdCorrect$nameClickedObj == "sunflower", (subset(frequencies, noun == "sunflower"))$relFreq, 
                                                                                                                                                                                                                                                        ifelse(bdCorrect$nameClickedObj == "suv", (subset(frequencies, noun == "suv"))$relFreq, 
                                                                                                                                                                                                                                                               ifelse(bdCorrect$nameClickedObj == "swordFish", (subset(frequencies, noun == "swordFish"))$relFreq, 
                                                                                                                                                                                                                                                                      ifelse(bdCorrect$nameClickedObj == "tShirt", (subset(frequencies, noun == "tShirt"))$relFreq, 
                                                                                                                                                                                                                                                                             ifelse(bdCorrect$nameClickedObj == "tulip", (subset(frequencies, noun == "tulip"))$relFreq, "NA"))))))))))))))))))))))))))))))))))))
# length of basiclevels:

bdCorrect$relFreqBasiclevel = ifelse(bdCorrect$basiclevelClickedObj == "bear", (subset(frequencies, noun == "bear"))$relFreq, 
                                     ifelse(bdCorrect$basiclevelClickedObj == "bird", (subset(frequencies, noun == "bird"))$relFreq, 
                                            ifelse(bdCorrect$basiclevelClickedObj == "candy", (subset(frequencies, noun == "candy"))$relFreq, 
                                                   ifelse(bdCorrect$basiclevelClickedObj == "car", (subset(frequencies, noun == "car"))$relFreq, 
                                                          ifelse(bdCorrect$basiclevelClickedObj == "dog", (subset(frequencies, noun == "dog"))$relFreq, 
                                                                 ifelse(bdCorrect$basiclevelClickedObj == "fish", (subset(frequencies, noun == "fish"))$relFreq, 
                                                                        ifelse(bdCorrect$basiclevelClickedObj == "flower", (subset(frequencies, noun == "flower"))$relFreq, 
                                                                               ifelse(bdCorrect$basiclevelClickedObj == "shirt", (subset(frequencies, noun == "shirt"))$relFreq,
                                                                                      ifelse(bdCorrect$basiclevelClickedObj == "table", (subset(frequencies, noun == "table"))$relFreq, "NA")))))))))

# length of superclasses:

bdCorrect$relFreqSuperdomain = ifelse(bdCorrect$superdomainClickedObj == "animal", (subset(frequencies, noun == "animal"))$relFreq, 
                                      ifelse(bdCorrect$superdomainClickedObj == "clothing", (subset(frequencies, noun == "clothing"))$relFreq, 
                                             ifelse(bdCorrect$superdomainClickedObj == "furniture", (subset(frequencies, noun == "furniture"))$relFreq, 
                                                    ifelse(bdCorrect$superdomainClickedObj == "plant", (subset(frequencies, noun == "plant"))$relFreq, 
                                                           ifelse(bdCorrect$superdomainClickedObj == "snack", (subset(frequencies, noun == "snack"))$relFreq, 
                                                                  ifelse(bdCorrect$superdomainClickedObj == "vehicle", (subset(frequencies, noun == "vehicle"))$relFreq, "NA"))))))

# Convert to numeric:
bdCorrect$relFreqType = as.numeric(bdCorrect$relFreqType)
bdCorrect$relFreqBasiclevel = as.numeric(bdCorrect$relFreqBasiclevel)
bdCorrect$relFreqSuperdomain = as.numeric(bdCorrect$relFreqSuperdomain)

medianFreqType = 4.970e-07

bdCorrect$freqMedian2bins = ifelse(bdCorrect$relFreqType < medianFreqType, "less_frequent", "more_frequent")
head(bdCorrect$freqMedian2bins)

firstQuFreqType = 1.63e-07
thirdQuFreqType = 1.05e-06

head(bdCorrect$relFreqType)
summary(bdCorrect$relFreqType)

bdCorrect$freqMedian4bins = ifelse(bdCorrect$relFreqType < firstQuFreqType, "least_frequent", 
                                   ifelse(bdCorrect$relFreqType < medianFreqType, "less_frequent",
                                          ifelse(bdCorrect$relFreqType < thirdQuFreqType,"more_frequent", "most_frequent")))

bdCorrect$typeFreqToBasiclevelFreqRatio = bdCorrect$relFreqType / bdCorrect$relFreqBasiclevel

head(bdCorrect$typeFreqToBasiclevelFreqRatio)
summary(bdCorrect$typeFreqToBasiclevelFreqRatio)

# 2 bins

medianFreqRatio = 0.0062600
meanFreqRatio = 0.0327200

bdCorrect$freqMedianRatio2bins = ifelse(bdCorrect$typeFreqToBasiclevelFreqRatio < medianFreqRatio, "smaller_ratio_Type/BL", "bigger_ratio_Type/BL")
head(bdCorrect$freqMedianRatio2bins)

bdCorrect$freqMeanRatio2bins = ifelse(bdCorrect$typeFreqToBasiclevelFreqRatio < meanFreqRatio, "smaller_ratio_Type/BL", "bigger_ratio_Type/BL")

firstQuFreqRatio = 0.0023190
thirdQuFreqRatio = 0.0265000

head(bdCorrect$relFreqType)
summary(bdCorrect$relFreqType)

bdCorrect$freqMedianRatio4bins = ifelse(as.numeric(bdCorrect$typeFreqToBasiclevelFreqRatio) < firstQuFreqRatio, "01 smallest_ratio_Type/BL", 
                                        ifelse(as.numeric(bdCorrect$typeFreqToBasiclevelFreqRatio) < medianFreqRatio, "02 smaller_ratio_Type/BL",
                                               ifelse(as.numeric(bdCorrect$typeFreqToBasiclevelFreqRatio) < thirdQuFreqRatio,"03 bigger_ratio_Type/BL", "04 biggest_ratio_Type/BL")))

bdCorrect$TypeLength = nchar(as.character(bdCorrect$nameClickedObj))
bdCorrect$BasicLevelLength = nchar(as.character(bdCorrect$basiclevelClickedObj))
bdCorrect$SuperLength = nchar(as.character(bdCorrect$superdomainClickedObj))
bdCorrect$logTypeLength = log(bdCorrect$TypeLength)
bdCorrect$logBasicLevelLength = log(bdCorrect$BasicLevelLength)
bdCorrect$logSuperLength = log(bdCorrect$SuperLength)

bdCorrect$TypeFreq = bdCorrect$relFreqType
bdCorrect$BasicLevelFreq = bdCorrect$relFreqBasiclevel
bdCorrect$SuperFreq = bdCorrect$relFreqSuperdomain

bdCorrect$logTypeFreq = log(bdCorrect$relFreqType)
bdCorrect$logBasicLevelFreq = log(bdCorrect$relFreqBasiclevel)
bdCorrect$logSuperFreq = log(bdCorrect$relFreqSuperdomain)

bdCorrect$binnedlogTypeLength = cut_number(bdCorrect$logTypeLength,2,labels=c("short","long"))
bdCorrect$binnedlogTypeFreq = cut_number(bdCorrect$logTypeFreq,2,labels=c("low-frequency","high-frequency"))
bdCorrect$ratioTypeToBasicLength = bdCorrect$TypeLength/bdCorrect$BasicLevelLength
bdCorrect$ratioTypeToSuperLength = bdCorrect$TypeLength/bdCorrect$SuperLength
#bdCorrect$ratioTypeToBasicFreq = bdCorrect$TypeFreq/bdCorrect$BasicLevelFreq
#bdCorrect$ratioTypeToSuperFreq = bdCorrect$TypeFreq/bdCorrect$SuperFreq
bdCorrect$ratioTypeToBasicFreq = bdCorrect$logTypeFreq - bdCorrect$logBasicLevelFreq
bdCorrect$ratioTypeToSuperFreq = bdCorrect$logTypeFreq - bdCorrect$logSuperFreq

  
#### MIXED EFFECTS MODEL ANALYSIS FOR TYPE MENTION WITH DOMAIN-LEVEL RANDOM EFFECTS

centered = cbind(bdCorrect, myCenter(bdCorrect[,c("TypeLength","BasicLevelLength","SuperLength","logTypeLength","logBasicLevelLength","logSuperLength","TypeFreq","BasicLevelFreq","SuperFreq","logTypeFreq","logBasicLevelFreq","logSuperFreq","ratioTypeToBasicFreq","ratioTypeToBasicLength","ratioTypeToSuperLength","ratioTypeToSuperFreq")]))

pairscor.fnc(centered[,c("TypeLength","BasicLevelLength","SuperLength","logTypeLength","logBasicLevelLength","logSuperLength","TypeFreq","BasicLevelFreq","SuperFreq","logTypeFreq","logBasicLevelFreq","logSuperFreq","ratioTypeToBasicFreq","ratioTypeToSuperFreq","ratioTypeToBasicLength","ratioTypeToSuperLength")])

#contrasts(bdCorrect$condition) = cbind(c(1,0,0,0),c(0,0,1,0),c(0,0,0,1))
contrasts(centered$condition) = cbind("12.vs.rest"=c(3/4,-1/4,-1/4,-1/4),"22.vs.3"=c(0,2/3,-1/3,-1/3),"23.vs.33"=c(0,0,1/2,-1/2))

# only absolute type length/freq
m = glmer(typeMentioned ~ condition * clogTypeLength * clogTypeFreq + (1 + clogTypeFreq|gameid) + (1|basiclevelClickedObj), family="binomial",data=centered)
summary(m)

# ratio of type to basic level freq
m = glmer(typeMentioned ~ condition + cratioTypeToBasicLength + cratioTypeToBasicFreq +  cratioTypeToSuperLength + cratioTypeToSuperFreq + cratioTypeToBasicLength:cratioTypeToBasicFreq + cratioTypeToSuperLength:cratioTypeToSuperFreq + condition:cratioTypeToBasicLength + condition:cratioTypeToBasicFreq + condition:cratioTypeToSuperLength + condition:cratioTypeToSuperFreq + condition:cratioTypeToBasicLength:cratioTypeToBasicFreq + condition:cratioTypeToSuperLength:cratioTypeToSuperFreq + (1|gameid), family="binomial",data=centered)
summary(m)


# collapse across 22 and 23 conditions
bdCorrect$redCondition = as.factor(ifelse(bdCorrect$condition == "distr12","sub_necessary",ifelse(bdCorrect$condition == "distr33","super_sufficient","basic_sufficient")))
table(bdCorrect$redCondition)

# exclude frequency outliers? there are none if you do difference of logs
#tmp = bdCorrect[bdCorrect$ratioTypeToBasicFreq > 2*sd(bdCorrect$ratioTypeToBasicFreq),]

centered = cbind(bdCorrect, myCenter(bdCorrect[,c("TypeLength","BasicLevelLength","SuperLength","logTypeLength","logBasicLevelLength","logSuperLength","TypeFreq","BasicLevelFreq","SuperFreq","logTypeFreq","logBasicLevelFreq","logSuperFreq","ratioTypeToBasicFreq","ratioTypeToSuperFreq","ratioTypeToBasicLength","ratioTypeToSuperLength")]))

contrasts(centered$redCondition) = cbind("sub.vs.rest"=c(-1/3,2/3,-1/3),"basic.vs.super"=c(1/2,0,-1/2))
contrasts(centered$condition) = cbind("12.vs.rest"=c(3/4,-1/4,-1/4,-1/4),"22.vs.3"=c(0,2/3,-1/3,-1/3),"23.vs.33"=c(0,0,1/2,-1/2))

m = glmer(typeMentioned ~ redCondition * cTypeLength * clogTypeFreq + (1|gameid) + (1|basiclevelClickedObj), family="binomial",data=centered)
summary(m)

m.1 = glmer(typeMentioned ~ redCondition * cTypeLength * clogTypeFreq + (1|gameid) + (1+cTypeLength|basiclevelClickedObj), family="binomial",data=centered)
summary(m.1)

anova(m,m.1) # adding by-item slopes for length doesn't do anything

m.2 = glmer(typeMentioned ~ redCondition * cTypeLength * clogTypeFreq + (1|gameid) + (1+clogTypeFreq|basiclevelClickedObj), family="binomial",data=centered)
summary(m.2)

anova(m,m.2)

m.3 = glmer(typeMentioned ~ redCondition * cTypeLength * clogTypeFreq + (1|gameid) + (1+clogTypeFreq+cTypeLength|basiclevelClickedObj), family="binomial",data=centered)
summary(m.3)

anova(m.2,m.3) # nope, useless

# ratio of type to basic level freq
m = glmer(typeMentioned ~ redCondition + cratioTypeToBasicLength + cratioTypeToBasicFreq + cratioTypeToBasicLength:cratioTypeToBasicFreq + (1|gameid) + (1|basiclevelClickedObj) , family="binomial",data=centered) 
summary(m)
createLatexTable(m,predictornames=c("Intercept","Condition sub.vs.rest","Condition basic.vs.super","Length","Frequency","Length:Frequency"))

m.nointer = glmer(typeMentioned ~ redCondition + cratioTypeToBasicLength + cratioTypeToBasicFreq + (1|gameid) + (1|basiclevelClickedObj) , family="binomial",data=centered) 
summary(m.nointer)

anova(m.nointer,m) # interaction important

m.sup2 = glmer(typeMentioned ~ redCondition + cratioTypeToBasicLength + cratioTypeToBasicFreq + cratioTypeToBasicLength:cratioTypeToBasicFreq + cratioTypeToSuperLength + cratioTypeToSuperFreq + (1|gameid) + (1|basiclevelClickedObj) , family="binomial",data=centered) 
summary(m.sup2)

anova(m,m.sup2) #nope

m.allconds = glmer(typeMentioned ~ condition + cratioTypeToBasicLength + cratioTypeToBasicFreq + cratioTypeToBasicLength:cratioTypeToBasicFreq + (1|gameid) + (1|basiclevelClickedObj) , family="binomial",data=centered) 
summary(m.allconds)
# the BIC of this model is higher than that of simple m (886 vs 881) -- ie, adding the extra condition predictor isn't justified.


m.1 = glmer(typeMentioned ~ redCondition + cratioTypeToBasicLength + cratioTypeToBasicFreq + cratioTypeToBasicLength:cratioTypeToBasicFreq + redCondition:cratioTypeToBasicLength + redCondition:cratioTypeToBasicFreq +  (1|gameid) + (1|basiclevelClickedObj), family="binomial",data=centered) 
summary(m.1)

anova(m,m.1) # nope

m.2 = glmer(typeMentioned ~ redCondition + cratioTypeToBasicLength + cratioTypeToBasicFreq + cratioTypeToBasicLength:cratioTypeToBasicFreq + redCondition:cratioTypeToBasicLength + redCondition:cratioTypeToBasicFreq + redCondition:cratioTypeToBasicLength:cratioTypeToBasicFreq +  (1|gameid) + (1|basiclevelClickedObj), family="binomial",data=centered) 
summary(m.2)

anova(m,m.2) # nope

m.sup1 = glmer(typeMentioned ~ redCondition + cratioTypeToBasicLength + cratioTypeToBasicFreq + cratioTypeToBasicLength:cratioTypeToBasicFreq + cratioTypeToSuperLength + cratioTypeToSuperFreq + cratioTypeToSuperLength:cratioTypeToSuperFreq + (1|gameid) + (1|basiclevelClickedObj) , family="binomial",data=centered) 
summary(m.sup1)

anova(m,m.sup1) # nope



m.noitem = glmer(typeMentioned ~ redCondition + cratioTypeToBasicLength + cratioTypeToBasicFreq + cratioTypeToBasicLength:cratioTypeToBasicFreq + (1|gameid) , family="binomial",data=centered) 
summary(m.noitem)

anova(m.noitem,m) # definitely by-item variation

m.nosubj = glmer(typeMentioned ~ redCondition + cratioTypeToBasicLength + cratioTypeToBasicFreq + cratioTypeToBasicLength:cratioTypeToBasicFreq + (1|basiclevelClickedObj) , family="binomial",data=centered) 
summary(m.nosubj)

anova(m.nosubj,m) # definitely by-subject variation




### plots for cogsci paper

# overall, fig 1
agr = bdCorrect %>%
  select(typeMentioned,basiclevelMentioned,superClassMentioned, condition) %>%
  gather(Utt,Mentioned,-condition) %>%
  group_by(Utt,condition) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
summary(agr)
dodge = position_dodge(.9)
agr$Utt = as.factor(ifelse(agr$Utt == "typeMentioned","sub",ifelse(agr$Utt == "basiclevelMentioned","basic","super")))
agr$Utterance = factor(x=as.character(agr$Utt),levels=c("sub","basic","super"))

ggplot(agr, aes(x=condition,y=Probability)) +
  geom_bar(stat="identity",position=dodge) +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  facet_wrap(~Utterance) +
  ylab("Proportion of utterance choice") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/cogsci/graphs/results-collapsed.pdf",height=4.1,width=7)

# overall, fig 1
agr = bdCorrect %>%
  select(typeMentioned,basiclevelMentioned,superClassMentioned, condition, basiclevelClickedObj) %>%
  gather(Utt,Mentioned,-condition, -basiclevelClickedObj) %>%
  group_by(Utt,condition,basiclevelClickedObj) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
summary(agr)
dodge = position_dodge(.9)
agr$Utt = as.factor(ifelse(agr$Utt == "typeMentioned","sub",ifelse(agr$Utt == "basiclevelMentioned","basic","super")))
agr$Utterance = factor(x=as.character(agr$Utt),levels=c("sub","basic","super"))

ggplot(agr, aes(x=condition,y=Probability)) +
  geom_bar(stat="identity",position=dodge) +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  facet_grid(basiclevelClickedObj~Utterance) +
  ylab("Proportion of utterance choice") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/cogsci/graphs/results-bydomain.pdf",height=10,width=7)



# for all random effects structures that allow the model to converge, the interaction between frequency and length is significant at (at most) <.01
#bdCorrect$cutlogTypeLength = cut(bdCorrect$logTypeLength,breaks=quantile(bdCorrect$logTypeLength,probs=c(0,.5,1)))
bdCorrect$binnedTypeLength = cut_number(bdCorrect$ratioTypeToBasicLength,3,labels=c("short","mid","long"))
bdCorrect$binnedlogTypeFreq = cut_number(bdCorrect$ratioTypeToBasicFreq,2)#,labels=c("low","high"))
summary(bdCorrect)

agr = bdCorrect %>%
  select(typeMentioned, redCondition, binnedTypeLength, binnedlogTypeFreq) %>%
  group_by(redCondition, binnedTypeLength, binnedlogTypeFreq) %>%
  summarise(Probability=mean(typeMentioned),ci.low=ci.low(typeMentioned),ci.high=ci.high(typeMentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
summary(agr)
dodge = position_dodge(.9)
agr$Condition = factor(x=as.character(agr$redCondition),levels=c("sub_necessary","basic_sufficient","super_sufficient"))

ggplot(agr, aes(x=binnedlogTypeFreq,y=Probability,fill=binnedTypeLength)) +
  geom_bar(stat="identity",position=dodge) +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  ylab("Probability of sub level mention") +
  xlab("Frequency  bin") +
  facet_wrap(~Condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/cogsci/graphs/freq-length-interaction-bycond.pdf",height=5,width=9)

bdCorrect$binnedTypeLength = cut(bdCorrect$ratioTypeToBasicLength,c(0,1,2,max(bdCorrect$ratioTypeToBasicLength)),labels=c("short","mid","long"))#,labels=c("short","mid","long"))
bdCorrect$binnedlogTypeFreq = cut_number(bdCorrect$ratioTypeToBasicFreq,2,labels=c("low","high"))
summary(bdCorrect)
table(bdCorrect$binnedTypeLength,bdCorrect$binnedlogTypeFreq)

agr = bdCorrect %>%
  select(typeMentioned, binnedTypeLength, binnedlogTypeFreq) %>%
  group_by(binnedTypeLength, binnedlogTypeFreq) %>%
  summarise(Probability=mean(typeMentioned),ci.low=ci.low(typeMentioned),ci.high=ci.high(typeMentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
summary(agr)
dodge = position_dodge(.9)

library(wesanderson)

ggplot(agr, aes(x=binnedlogTypeFreq,y=Probability,fill=binnedTypeLength)) +
  geom_bar(stat="identity",position=dodge,color="black") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  xlab("Frequency") +
  scale_fill_manual(values=wes_palette("Darjeeling2"),name="Length") +
  scale_y_continuous(name="Probability of sub level mention") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/cogsci/graphs/freq-length-interaction.pdf",height=4.2,width=6)

bdCorrect$binnedTypeLength = cut_number(bdCorrect$ratioTypeToBasicLength,2,labels=c("short","long"))#,labels=c("short","mid","long"))
bdCorrect$binnedTypeLength = cut(bdCorrect$ratioTypeToBasicLength,2,labels=c("short","long"))#,labels=c("short","mid","long"))

agr = bdCorrect %>%
  select(typeMentioned, binnedTypeLength,redCondition) %>%
  group_by(binnedTypeLength,redCondition) %>%
  summarise(Probability=mean(typeMentioned),ci.low=ci.low(typeMentioned),ci.high=ci.high(typeMentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
summary(agr)
dodge = position_dodge(.9)
agr$Condition = factor(x=as.character(agr$redCondition),levels=c("sub_necessary","basic_sufficient","super_sufficient"))

library(wesanderson)

ggplot(agr, aes(x=binnedTypeLength,y=Probability)) +
  geom_bar(stat="identity",position=dodge,color="black") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  xlab("Sub level length") +
  scale_fill_manual(values=wes_palette("Darjeeling2"),name="Length") +
  scale_y_continuous(name="Proportion of sub level mention") +
  facet_wrap(~Condition) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/cogsci/graphs/length-effect.pdf",height=4.2,width=6)



