theme_set(theme_bw(18))

#setwd("/home/caroline/cocolab/overinformativeness/experiments/4_numdistractors_basiclevel_newitems/results")

#setwd("C:\\Users\\Caroline\\Desktop\\overinformativeness\\experiments\\4_numdistractors_basiclevel_newitems\\results")
setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/4_numdistractors_basiclevel_newitems/results")
source("rscripts/helpers.R")
source("rscripts/createLaTeXTable.R")

bdCorrect = read.csv(file="noAttr.csv",sep=",")
bdCorrect$nameClickedObj = tolower(as.character(bdCorrect$nameClickedObj))
bdCorrect[bdCorrect$nameClickedObj == "hummingbird" & (bdCorrect$alt1Name == "chick" | bdCorrect$alt2Name == "chick"),]$condition = "distr12"
# there are eight cases that are marked as both basic level and type mentioned. i'm going to interpret these as type mentions.
bdCorrect[bdCorrect$basiclevelMentioned & bdCorrect$typeMentioned,]$basiclevelMentioned = F
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

bdCorrect$relFreqType = ifelse(bdCorrect$nameClickedObj == "bedsidetable", (subset(frequencies, noun == "bedsideTable"))$relFreq, 
                               ifelse(bdCorrect$nameClickedObj == "blackbear", (subset(frequencies, noun == "blackBear"))$relFreq, 
                                      ifelse(bdCorrect$nameClickedObj == "catfish", (subset(frequencies, noun == "catfish"))$relFreq, 
                                             ifelse(bdCorrect$nameClickedObj == "clownfish", (subset(frequencies, noun == "clownFish"))$relFreq, 
                                                    ifelse(bdCorrect$nameClickedObj == "coffeetable", (subset(frequencies, noun == "coffeeTable"))$relFreq, 
                                                           ifelse(bdCorrect$nameClickedObj == "convertible", (subset(frequencies, noun == "convertible"))$relFreq, 
                                                                  ifelse(bdCorrect$nameClickedObj == "daisy", (subset(frequencies, noun == "daisy"))$relFreq, 
                                                                         ifelse(bdCorrect$nameClickedObj == "dalmatian", (subset(frequencies, noun == "dalmatian"))$relFreq, 
                                                                                ifelse(bdCorrect$nameClickedObj == "diningtable", (subset(frequencies, noun == "diningTable"))$relFreq, 
                                                                                       ifelse(bdCorrect$nameClickedObj == "dressshirt", (subset(frequencies, noun == "dressShirt"))$relFreq, 
                                                                                              ifelse(bdCorrect$nameClickedObj == "eagle", (subset(frequencies, noun == "eagle"))$relFreq, 
                                                                                                     ifelse(bdCorrect$nameClickedObj == "germanshepherd", (subset(frequencies, noun == "germanShepherd"))$relFreq, 
                                                                                                            ifelse(bdCorrect$nameClickedObj == "goldfish", (subset(frequencies, noun == "goldFish"))$relFreq, 
                                                                                                                   ifelse(bdCorrect$nameClickedObj == "grizzlybear", (subset(frequencies, noun == "grizzlyBear"))$relFreq, 
                                                                                                                          ifelse(bdCorrect$nameClickedObj == "gummybears", (subset(frequencies, noun == "gummyBears"))$relFreq, 
                                                                                                                                 ifelse(bdCorrect$nameClickedObj == "hawaiishirt", (subset(frequencies, noun == "hawaiiShirt"))$relFreq, 
                                                                                                                                        ifelse(bdCorrect$nameClickedObj == "hummingbird", (subset(frequencies, noun == "hummingBird"))$relFreq, 
                                                                                                                                               ifelse(bdCorrect$nameClickedObj == "husky", (subset(frequencies, noun == "husky"))$relFreq, 
                                                                                                                                                      ifelse(bdCorrect$nameClickedObj == "jellybeans", (subset(frequencies, noun == "jellyBeans"))$relFreq, 
                                                                                                                                                             ifelse(bdCorrect$nameClickedObj == "mnms", (subset(frequencies, noun == "mnMs"))$relFreq, 
                                                                                                                                                                    ifelse(bdCorrect$nameClickedObj == "minivan", (subset(frequencies, noun == "minivan"))$relFreq, 
                                                                                                                                                                           ifelse(bdCorrect$nameClickedObj == "pandabear", (subset(frequencies, noun == "pandaBear"))$relFreq, 
                                                                                                                                                                                  ifelse(bdCorrect$nameClickedObj == "parrot", (subset(frequencies, noun == "parrot"))$relFreq, 
                                                                                                                                                                                         ifelse(bdCorrect$nameClickedObj == "picnictable", (subset(frequencies, noun == "picnicTable"))$relFreq, 
                                                                                                                                                                                                ifelse(bdCorrect$nameClickedObj == "pigeon", (subset(frequencies, noun == "pigeon"))$relFreq, 
                                                                                                                                                                                                       ifelse(bdCorrect$nameClickedObj == "polarbear", (subset(frequencies, noun == "polarBear"))$relFreq, 
                                                                                                                                                                                                              ifelse(bdCorrect$nameClickedObj == "poloshirt", (subset(frequencies, noun == "poloShirt"))$relFreq, 
                                                                                                                                                                                                                     ifelse(bdCorrect$nameClickedObj == "pug", (subset(frequencies, noun == "pug"))$relFreq, 
                                                                                                                                                                                                                            ifelse(bdCorrect$nameClickedObj == "rose", (subset(frequencies, noun == "rose"))$relFreq, 
                                                                                                                                                                                                                                   ifelse(bdCorrect$nameClickedObj == "skittles", (subset(frequencies, noun == "skittles"))$relFreq, 
                                                                                                                                                                                                                                          ifelse(bdCorrect$nameClickedObj == "sportscar", (subset(frequencies, noun == "sportsCar"))$relFreq, 
                                                                                                                                                                                                                                                 ifelse(bdCorrect$nameClickedObj == "sunflower", (subset(frequencies, noun == "sunflower"))$relFreq, 
                                                                                                                                                                                                                                                        ifelse(bdCorrect$nameClickedObj == "suv", (subset(frequencies, noun == "suv"))$relFreq, 
                                                                                                                                                                                                                                                               ifelse(bdCorrect$nameClickedObj == "swordfish", (subset(frequencies, noun == "swordFish"))$relFreq, 
                                                                                                                                                                                                                                                                      ifelse(bdCorrect$nameClickedObj == "tshirt", (subset(frequencies, noun == "tShirt"))$relFreq, 
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

# add average empirical lengths
lengths = read.csv("data/lengthChart_uniformLabels.csv")
row.names(lengths) = lengths$noun
lengths$totalLength = nchar(as.character(lengths$noun))
ggplot(lengths, aes(x=totalLength,y=average_length)) +
  geom_point() +
  geom_abline(slope=1,xintercept=0) +
  geom_text(aes(label=noun))
ggsave("graphs_basiclevel/total-vs-average-item-length.pdf")
bdCorrect$meanTypeLength = lengths[tolower(as.character(bdCorrect$nameClickedObj)),]$average_length
bdCorrect$meanBasicLength =  lengths[as.character(bdCorrect$basiclevelClickedObj),]$average_length
bdCorrect$meanSuperLength =  lengths[as.character(bdCorrect$superdomainClickedObj),]$average_length
bdCorrect$ratioTypeToBasicMeanLength = bdCorrect$meanTypeLength/bdCorrect$meanBasicLength
bdCorrect$ratioTypeToSuperMeanLength = bdCorrect$meanTypeLength/bdCorrect$meanSuperLength
bdCorrect$redCondition = as.factor(ifelse(bdCorrect$condition == "distr12","sub_necessary",ifelse(bdCorrect$condition == "distr33","super_sufficient","basic_sufficient")))

# add typicality values
typs = read.table("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/5_norming_object_typicality_phrasing1/results/data/itemtypicalities.txt",header=T,quote="",sep="\t")
head(typs)
ttyps = droplevels(subset(typs, itemtype == "target"))
row.names(ttyps) = paste(ttyps$labeltype, ttyps$item)
bdCorrect$TypeTyp = ttyps[paste("sub",as.character(bdCorrect$nameClickedObj)),]$meanresponse
bdCorrect$BasicTyp = ttyps[paste("basic",as.character(bdCorrect$nameClickedObj)),]$meanresponse
bdCorrect$SuperTyp = ttyps[paste("super",as.character(bdCorrect$nameClickedObj)),]$meanresponse
bdCorrect$ratioTypeToBasicTypicality = bdCorrect$TypeTyp/bdCorrect$BasicTyp
bdCorrect$ratioTypeToSuperTypicality = bdCorrect$TypeTyp/bdCorrect$SuperTyp

# find examples for paper
t = ttyps[ttyps$labeltype != "super",]
agr = t %>%
  group_by(item) %>%
  summarise(ratio=meanresponse[labeltype == "sub"]/meanresponse[labeltype == "basic"])
agr[agr$ratio == max(agr$ratio),] # bedside table
agr[agr$ratio == min(agr$ratio),] # daisy

#### MIXED EFFECTS MODEL ANALYSIS FOR TYPE MENTION WITH DOMAIN-LEVEL RANDOM EFFECTS

centered = cbind(bdCorrect, myCenter(bdCorrect[,c("TypeLength","BasicLevelLength","SuperLength","logTypeLength","logBasicLevelLength","logSuperLength","TypeFreq","BasicLevelFreq","SuperFreq","logTypeFreq","logBasicLevelFreq","logSuperFreq","ratioTypeToBasicFreq","ratioTypeToBasicLength","ratioTypeToSuperLength","ratioTypeToSuperFreq","ratioTypeToBasicMeanLength","ratioTypeToSuperMeanLength")]))

#pairscor.fnc(centered[,c("TypeLength","BasicLevelLength","SuperLength","logTypeLength","logBasicLevelLength","logSuperLength","TypeFreq","BasicLevelFreq","SuperFreq","logTypeFreq","logBasicLevelFreq","logSuperFreq","ratioTypeToBasicFreq","ratioTypeToSuperFreq","ratioTypeToBasicLength","ratioTypeToSuperLength")])

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
bdCorrect$binaryCondition = as.factor(ifelse(bdCorrect$condition == "distr12","sub_necessary","nonsub_sufficient"))
table(bdCorrect$redCondition)
table(bdCorrect$binaryCondition)

# exclude frequency outliers? there are none if you do difference of logs
#tmp = bdCorrect[bdCorrect$ratioTypeToBasicFreq > 2*sd(bdCorrect$ratioTypeToBasicFreq),]
tmp = bdCorrect[bdCorrect$ratioTypeToBasicTypicality < mean(bdCorrect$ratioTypeToBasicTypicality) + 3*sd(bdCorrect$ratioTypeToBasicTypicality),]

centered = cbind(bdCorrect, myCenter(bdCorrect[,c("TypeLength","BasicLevelLength","SuperLength","logTypeLength","logBasicLevelLength","logSuperLength","TypeFreq","BasicLevelFreq","SuperFreq","logTypeFreq","logBasicLevelFreq","logSuperFreq","ratioTypeToBasicFreq","ratioTypeToSuperFreq","ratioTypeToBasicLength","ratioTypeToSuperLength","ratioTypeToBasicMeanLength","ratioTypeToSuperMeanLength","ratioTypeToBasicTypicality","ratioTypeToSuperTypicality","binaryCondition")]))

contrasts(centered$redCondition) = cbind("sub.vs.rest"=c(-1/3,2/3,-1/3),"basic.vs.super"=c(1/2,0,-1/2))
contrasts(centered$condition) = cbind("12.vs.rest"=c(3/4,-1/4,-1/4,-1/4),"22.vs.3"=c(0,2/3,-1/3,-1/3),"23.vs.33"=c(0,0,1/2,-1/2))

# m = glmer(typeMentioned ~ redCondition * cTypeLength * clogTypeFreq + (1|gameid) + (1|basiclevelClickedObj), family="binomial",data=centered)
# summary(m)
# 
# m.1 = glmer(typeMentioned ~ redCondition * cTypeLength * clogTypeFreq + (1|gameid) + (1+cTypeLength|basiclevelClickedObj), family="binomial",data=centered)
# summary(m.1)
# 
# anova(m,m.1) # adding by-item slopes for length doesn't do anything
# 
# m.2 = glmer(typeMentioned ~ redCondition * cTypeLength * clogTypeFreq + (1|gameid) + (1+clogTypeFreq|basiclevelClickedObj), family="binomial",data=centered)
# summary(m.2)
# 
# anova(m,m.2)
# 
# m.3 = glmer(typeMentioned ~ redCondition * cTypeLength * clogTypeFreq + (1|gameid) + (1+clogTypeFreq+cTypeLength|basiclevelClickedObj), family="binomial",data=centered)
# summary(m.3)
# 
# anova(m.2,m.3) # nope, useless

# ratio of type to basic freq & length (pre-coded)
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


# ratio of type to basic freq & length (empirical means)
m.m = glmer(typeMentioned ~ redCondition + cratioTypeToBasicMeanLength + cratioTypeToBasicFreq + cratioTypeToBasicMeanLength:cratioTypeToBasicFreq + (1|gameid) + (1|basiclevelClickedObj) , family="binomial",data=centered) 
summary(m.m)

m.m.nointer = glmer(typeMentioned ~ redCondition + cratioTypeToBasicMeanLength + cratioTypeToBasicFreq + (1|gameid) + (1|basiclevelClickedObj) , family="binomial",data=centered) 
summary(m.m.nointer)

anova(m.m.nointer,m.m) # interaction important

m.m.1 = glmer(typeMentioned ~ redCondition + cratioTypeToBasicMeanLength + cratioTypeToBasicFreq + cratioTypeToBasicMeanLength:cratioTypeToBasicFreq + redCondition:cratioTypeToBasicMeanLength + redCondition:cratioTypeToBasicFreq +  (1|gameid) + (1|basiclevelClickedObj), family="binomial",data=centered) 
summary(m.m.1)

anova(m.m,m.m.1) # nope

# add typicality
m.m.t = glmer(typeMentioned ~ redCondition + cratioTypeToBasicMeanLength + cratioTypeToBasicFreq + cratioTypeToBasicTypicality + cratioTypeToBasicMeanLength:cratioTypeToBasicFreq + (1|gameid) + (1|basiclevelClickedObj) , family="binomial",data=centered) 
summary(m.m.t)
createLatexTable(m.m.t,predictornames=c("Intercept","Condition sub.vs.rest","Condition basic.vs.super","Length","Frequency","Typicality","Length:Frequency"))

anova(m.m,m.m.t) # typicality very important!

<<<<<<< HEAD
# plot the coefficients for cogsci talk
coefs = as.data.frame(summary(m.m.t)$coefficients)
coefs[,1] = round(coefs[,1],digits=2)
coefs[,2] = round(coefs[,2],digits=2)
coefs[,3] = round(coefs[,3],digits=1)
row.names(coefs) = c("Intercept","Informativeness (sub vs other)", "Informativeness (basic vs super)", "Length", "Frequency","Typicality","Length/Frequency interaction")
colnames(coefs) = c("Coefficient","SE","z","p")
coefs$Predictor = row.names(coefs)
coefs = coefs[coefs$Predictor != "Intercept",]
head(coefs)
coefs$Pred = factor(x=coefs$Predictor,levels=rev(c("Informativeness (sub vs other)", "Informativeness (basic vs super)", "Length", "Frequency","Typicality","Length/Frequency interaction")))
ggplot(coefs, aes(x=Pred,y=Coefficient,color=Pred)) +
  geom_errorbar(aes(ymin=Coefficient-SE,ymax=Coefficient+SE),width=0,size=1.5,color="gray70") +
  geom_point(size=4) +
  coord_flip() +
  geom_hline(yintercept=0,color="gray60",linetype="dashed") +
  theme(legend.position="none",axis.title.y=element_blank())
ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/cogsci/graphs/coefficientplot.png",height=4.5,width=9)

=======
>>>>>>> df080bffb41e084391dd1d71abbfe7df07e1843f
m.m.t.binary = glmer(typeMentioned ~ cbinaryCondition + cratioTypeToBasicMeanLength + cratioTypeToBasicFreq + cratioTypeToBasicTypicality + cratioTypeToBasicMeanLength:cratioTypeToBasicFreq + (1|gameid) + (1|basiclevelClickedObj) , family="binomial",data=centered) 
summary(m.m.t.binary)

anova(m.m.t.binary,m.m.t) # model comparison to report in paper: three-level condition variable is necessary, ie the findings can't just be explained as "people choose the basic level term unless forced to be more specific"!

library(MuMIn)
r.squaredGLMM(m.m)
r.squaredGLMM(m.m.t)

m.m.t.norandom = glm(typeMentioned ~ redCondition + cratioTypeToBasicMeanLength + cratioTypeToBasicFreq + cratioTypeToBasicTypicality + cratioTypeToBasicMeanLength:cratioTypeToBasicFreq, family="binomial",data=centered) 
summary(m.m.t.norandom)

empirical = centered %>%
  select(typeMentioned)
empirical$Fitted = fitted(m.m.t.norandom)
empirical$Prediction = ifelse(empirical$Fitted >= .5, T, F)
empirical$FittedM = fitted(m.m.t)
empirical$PredictionM = ifelse(empirical$FittedM >= .5, T, F)
cor(empirical$typeMentioned,empirical$Prediction)
cor(empirical$typeMentioned,empirical$PredictionM)

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

# overall, collapse item22 and item23 into "basic sufficient"
agr = bdCorrect %>%
  select(typeMentioned,basiclevelMentioned,superClassMentioned, redCondition) %>%
  gather(Utt,Mentioned,-redCondition) %>%
  group_by(Utt,redCondition) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
summary(agr)
dodge = position_dodge(.9)
agr$Utt = as.factor(ifelse(agr$Utt == "typeMentioned","sub",ifelse(agr$Utt == "basiclevelMentioned","basic","super")))
agr$Utterance = factor(x=as.character(agr$Utt),levels=c("sub","basic","super"))
agr$Condition = factor(x=agr$redCondition,levels=c("sub_necessary","basic_sufficient","super_sufficient"))

ggplot(agr, aes(x=Condition,y=Probability)) +
  geom_bar(stat="identity",position=dodge) +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  facet_wrap(~Utterance) +
  ylab("Proportion of utterance choice") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/cogsci/graphs/results-collapsed-reduced.pdf",height=4.5,width=7)
ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/cogsci/graphs/results-collapsed-reduced.png",height=4.5,width=7)

colors = scales::hue_pal()(3)

ggplot(agr, aes(x=Condition,y=Probability,fill=Condition)) +
  geom_bar(stat="identity",position=dodge) +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  facet_wrap(~Utterance) +
  ylab("Proportion of utterance choice") +
  scale_fill_manual(values=colors) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1),legend.position="none")
ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/cogsci/graphs/results-collapsed-reduced-colors.pdf",height=4.5,width=7)
ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/cogsci/graphs/results-collapsed-reduced-colors.png",height=4.5,width=7)

ggplot(agr, aes(x=Condition,y=Probability,fill=Condition)) +
  geom_bar(stat="identity",position=dodge) +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  facet_wrap(~Utterance) +
  ylab("Proportion of utterance choice") +
  scale_fill_manual(values=c(colors[1],"gray30","gray30")) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1),legend.position="none")
ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/cogsci/graphs/results-collapsed-reduced-color-sub.pdf",height=4.5,width=7)
ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/cogsci/graphs/results-collapsed-reduced-color-sub.png",height=4.5,width=7)

ggplot(agr, aes(x=Condition,y=Probability,fill=Condition)) +
  geom_bar(stat="identity",position=dodge) +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  facet_wrap(~Utterance) +
  ylab("Proportion of utterance choice") +
  scale_fill_manual(values=c("gray30",colors[2],"gray30")) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1),legend.position="none")
ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/cogsci/graphs/results-collapsed-reduced-color-basic.pdf",height=4.5,width=7)
ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/cogsci/graphs/results-collapsed-reduced-color-basic.png",height=4.5,width=7)

ggplot(agr, aes(x=Condition,y=Probability,fill=Condition)) +
  geom_bar(stat="identity",position=dodge) +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  facet_wrap(~Utterance) +
  ylab("Proportion of utterance choice") +
  scale_fill_manual(values=c("gray30","gray30",colors[3])) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1),legend.position="none")
ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/cogsci/graphs/results-collapsed-reduced-color-super.pdf",height=4.5,width=7)
ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/cogsci/graphs/results-collapsed-reduced-color-super.png",height=4.5,width=7)


<<<<<<< HEAD
agr = bdCorrect %>%
  select(typeMentioned,basiclevelMentioned,superClassMentioned, redCondition) %>%
  gather(Utt,Mentioned,-redCondition) %>%
  group_by(Utt,redCondition) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
summary(agr)
dodge = position_dodge(.9)
agr$Utt = as.factor(ifelse(agr$Utt == "typeMentioned","sub",ifelse(agr$Utt == "basiclevelMentioned","basic","super")))
agr$Utterance = factor(x=as.character(agr$Utt),levels=c("sub","basic","super"))
agr$Condition = factor(x=agr$redCondition,levels=c("sub_necessary","basic_sufficient","super_sufficient"))
agr$data="empirical"

infomodel = data.frame(Utterance=agr$Utterance,Condition=agr$Condition,Probability=c(.5,0,.33,0,0,.33,.5,1,.33))
infomodel$data="model"

ag = merge(agr[,c("Probability","Utterance","Condition","YMin","YMax")],infomodel,all=T)
ag[is.na(ag$data),]$data="empirical"

ggplot(ag, aes(x=Condition,y=Probability,fill=data)) +
  geom_bar(stat="identity",position=dodge,color="black") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  facet_wrap(~Utterance) +
  ylab("Probability of utterance") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/cogsci/graphs/results-empirical-info-only.png",height=4.5,width=9)

agzero = ag
agzero[agzero$data=="empirical",]$Probability = 0
agzero[agzero$data=="empirical",]$YMin = 0
agzero[agzero$data=="empirical",]$YMax = 0
ggplot(agzero, aes(x=Condition,y=Probability,fill=data)) +
  geom_bar(stat="identity",position=dodge,color="black") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  facet_wrap(~Utterance) +
  ylab("Probability of utterance") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/cogsci/graphs/results-empirical-info-only-noemp.png",height=4.5,width=9)

=======
>>>>>>> df080bffb41e084391dd1d71abbfe7df07e1843f
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

# switch x and y axis
bdCorrect$binnedTypeLength = cut(bdCorrect$ratioTypeToBasicLength,c(0,mean(bdCorrect$ratioTypeToBasicLength),4.67),labels=c("short","long"))#,labels=c("short","mid","long"))
bdCorrect$binnedlogTypeFreq = cut(bdCorrect$ratioTypeToBasicFreq,c(-12,mean(bdCorrect$ratioTypeToBasicFreq),0),labels=c("low","high"))
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

ggplot(agr, aes(x=binnedTypeLength,y=Probability,fill=binnedlogTypeFreq)) +
  geom_bar(stat="identity",position=dodge,color="black") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  xlab("Length") +
  scale_fill_manual(values=wes_palette("Darjeeling2"),name="Frequency") +
  scale_y_continuous(name="Probability of sub level mention") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/cogsci/graphs/freq-length-interaction.pdf",height=4.2,width=6)


# main effect of length
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
agr$Condition = factor(x=gsub("_","\n",as.character(agr$redCondition)),levels=c("sub\nnecessary","basic\nsufficient","super\nsufficient"))

library(wesanderson)

pl = ggplot(agr, aes(x=binnedTypeLength,y=Probability)) +
  geom_bar(stat="identity",position=dodge,color="black") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  scale_x_discrete(name="Sub level length",breaks=c("short","long"),labels=c("short\n ","long\n ")) +
  scale_fill_manual(values=wes_palette("Darjeeling2"),name="Length") +
  scale_y_continuous(name="Proportion of sub level mention",breaks=seq(0,1,.2)) +
  facet_wrap(~Condition) +
  theme(axis.title.y = element_blank(),axis.title.x = element_text(size=16),axis.text.y = element_text(size=12),plot.margin=unit(c(0,0,0,0), "cm"))
  #theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
#ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/cogsci/graphs/length-effect.pdf",height=4.2,width=6)


# main effect of typicality
bdCorrect$binnedTypeTypicality = cut_number(bdCorrect$ratioTypeToBasicTypicality,2,labels=c("less typical","more typical"))#,labels=c("short","mid","long"))


agr = bdCorrect %>%
  select(typeMentioned, binnedTypeTypicality,redCondition) %>%
  group_by(binnedTypeTypicality,redCondition) %>%
  summarise(Probability=mean(typeMentioned),ci.low=ci.low(typeMentioned),ci.high=ci.high(typeMentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
summary(agr)
dodge = position_dodge(.9)
agr$Condition = factor(x=gsub("_","\n",as.character(agr$redCondition)),levels=c("sub\nnecessary","basic\nsufficient","super\nsufficient"))
#agr$Condition = factor(x=as.character(agr$redCondition),levels=c("sub_necessary","basic_sufficient","super_sufficient"))
agr$Typicality = factor(x=as.character(agr$binnedTypeTypicality),levels=c("more typical","less typical"))
library(wesanderson)

pt = ggplot(agr, aes(x=Typicality,y=Probability)) +
  geom_bar(stat="identity",position=dodge,color="black") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25, position=dodge) +
  scale_x_discrete(name="Sub level typicality",breaks=c("more typical","less typical"),labels=c("more\ntypical","less\ntypical")) +
  #scale_fill_manual(values=wes_palette("Darjeeling2"),name="Length") +
  scale_y_continuous(name="Proportion of sub level mention",breaks=seq(0,1,.2)) +
  facet_wrap(~Condition) +
  theme(axis.title.y = element_blank(),axis.title.x = element_text(size=16),axis.text.y = element_text(size=12),plot.margin=unit(c(0,0,0,0), "cm"))
  #theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1, size=7))
#ggsave("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/cogsci/graphs/typicality-effect.pdf",height=4.2,width=6)

# pairscor.fnc(centered[,c("ratioTypeToBasicLength","ratioTypeToBasicFreq","ratioTypeToBasicTypicality")])
# bdCorrect[bdCorrect$ratioTypeToBasicTypicality > 1.5,]

library(gridExtra)
pdf("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/writing/2016/cogsci/graphs/length-typicality.pdf",height=4.5,width=8.7)
grid.arrange(pl,pt,nrow=1, left = textGrob("Proportion of sub level mention", rot = 90, vjust = 1,gp = gpar(cex = 1.3)))
dev.off()

t = as.data.frame(table(bdCorrect$nameClickedObj,bdCorrect$condition))
nrow(t[t$Freq < 4,])

eagle = bdCorrect[bdCorrect$nameClickedObj == "eagle",]
nrow(eagle)
agre = eagle %>%
  select(typeMentioned,basiclevelMentioned,superClassMentioned, condition) %>%
  gather(Utt,Mentioned,-condition) %>%
  group_by(Utt,condition) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agre = as.data.frame(agre)
agre$YMin = agre$Probability - agre$ci.low
agre$YMax = agre$Probability + agre$ci.high
summary(agre)
dodge = position_dodge(.9)
agre$Utt = as.factor(ifelse(agre$Utt == "typeMentioned","sub",ifelse(agre$Utt == "basiclevelMentioned","basic","super")))
agre$Utterance = factor(x=as.character(agre$Utt),levels=c("sub","basic","super"))

ggplot(agre, aes(x=condition,y=Probability)) +
  geom_bar(stat="identity",position=dodge,color="black") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax)) +
  facet_wrap(~Utterance)
ggsave("graphs/eagle-empirical.pdf",width=7)  

hummingbird = bdCorrect[bdCorrect$nameClickedObj == "hummingbird",]
nrow(hummingbird)
agre = hummingbird %>%
  select(typeMentioned,basiclevelMentioned,superClassMentioned, condition) %>%
  gather(Utt,Mentioned,-condition) %>%
  group_by(Utt,condition) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agre = as.data.frame(agre)
agre$YMin = agre$Probability - agre$ci.low
agre$YMax = agre$Probability + agre$ci.high
summary(agre)
dodge = position_dodge(.9)
agre$Utt = as.factor(ifelse(agre$Utt == "typeMentioned","sub",ifelse(agre$Utt == "basiclevelMentioned","basic","super")))
agre$Utterance = factor(x=as.character(agre$Utt),levels=c("sub","basic","super"))

ggplot(agre, aes(x=condition,y=Probability)) +
  geom_bar(stat="identity",position=dodge,color="black") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax)) +
  facet_wrap(~Utterance)
ggsave("graphs/hummingbird-empirical.pdf",width=7,height=3.5) 


jellybeans = bdCorrect[bdCorrect$nameClickedObj == "jellybeans",]
nrow(jellybeans)
agre = jellybeans %>%
  select(typeMentioned,basiclevelMentioned,superClassMentioned, condition) %>%
  gather(Utt,Mentioned,-condition) %>%
  group_by(Utt,condition) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agre = as.data.frame(agre)
agre$YMin = agre$Probability - agre$ci.low
agre$YMax = agre$Probability + agre$ci.high
summary(agre)
dodge = position_dodge(.9)
agre$Utt = as.factor(ifelse(agre$Utt == "typeMentioned","sub",ifelse(agre$Utt == "basiclevelMentioned","basic","super")))
agre$Utterance = factor(x=as.character(agre$Utt),levels=c("sub","basic","super"))

ggplot(agre, aes(x=condition,y=Probability)) +
  geom_bar(stat="identity",position=dodge,color="black") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax)) +
  facet_wrap(~Utterance)
ggsave("graphs/jellybeans-empirical.pdf",width=7,height=3.5) 

bedsidetable = bdCorrect[bdCorrect$nameClickedObj == "bedsidetable",]
nrow(bedsidetable)
agre = bedsidetable %>%
  select(typeMentioned,basiclevelMentioned,superClassMentioned, condition) %>%
  gather(Utt,Mentioned,-condition) %>%
  group_by(Utt,condition) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agre = as.data.frame(agre)
agre$YMin = agre$Probability - agre$ci.low
agre$YMax = agre$Probability + agre$ci.high
summary(agre)
dodge = position_dodge(.9)
agre$Utt = as.factor(ifelse(agre$Utt == "typeMentioned","sub",ifelse(agre$Utt == "basiclevelMentioned","basic","super")))
agre$Utterance = factor(x=as.character(agre$Utt),levels=c("sub","basic","super"))

ggplot(agre, aes(x=condition,y=Probability)) +
  geom_bar(stat="identity",position=dodge,color="black") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax)) +
  facet_wrap(~Utterance)
ggsave("graphs/bedsidetable-empirical.pdf",width=7,height=3.5) 

eagle[,c("alt1Name","alt2Name")]
hummingbird[,c("alt1Name","alt2Name","condition")]#,"typeMentioned")]
jellybeans[,c("alt1Name","alt2Name","condition")]#,"typeMentioned")]
bedsidetable[,c("alt1Name","alt2Name","condition")]#,"typeMentioned")]

# get unique combinations of distractors
bdCorrect$DistractorCombo = as.factor(ifelse(as.character(bdCorrect$alt1Name) < as.character(bdCorrect$alt2Name), paste(bdCorrect$alt1Name, bdCorrect$alt2Name), paste(bdCorrect$alt2Name, bdCorrect$alt1Name)))

write.csv(unique(bdCorrect[,c("nameClickedObj","condition","DistractorCombo")]),file="unique_conditions.csv",row.names=F,quote=F)
