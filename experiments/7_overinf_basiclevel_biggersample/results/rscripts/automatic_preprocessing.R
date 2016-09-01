# Automatic preprocessing of data from 7_overinf_biggersample

theme_set(theme_bw(18))

setwd("/home/caroline/cocolab/overinformativeness/experiments/7_overinf_basiclevel_biggersample/results/rscripts")
source("helpers.R")

###Annotation check file###

d = read.table(file="../data/results.csv",sep=",", header=T, quote="")
head(d)
summary(d)
totalnrow = nrow(d)
nrow(d)

# colorSize trials:

colsize = droplevels(d[d$trialType != "subSuperTrial",])
colsizerows = nrow(colsize)
head(colsize)
summary(colsize)

# drop incorrect trials:
colsizeCor = droplevels(colsize[!is.na(colsize$targetStatusClickedObj) & colsize$targetStatusClickedObj != "distractor",])
head(colsizeCor)
print(paste("percentage of excluded trials because distractor was chosen: ", (colsizerows -nrow(colsizeCor))*100/colsizerows))

colsizeCor$colors = ifelse(grepl("green|purple|white|black|brown|violet|yellow|gold|orange|silver|blue|pink|red", colsizeCor$refExp, ignore.case = TRUE), T, F)
summary(colsizeCor)

colsizeCor$sizes = ifelse(grepl("big|small|bigger|smaller|tiny|huge|large|larger|little|biggest|smallest|largest", colsizeCor$refExp, ignore.case = TRUE), T, F)
summary(colsizeCor)

colsizeCor$types = ifelse(grepl("avocado|balloon|cap|belt|bike|billiardball|binder|book|bracelet|bucket|butterfly|candle|chair|coat hanger|comb|cushion|guitar|flower|frame|golf ball|hair dryer|jacket|napkin|ornament|pepper|phone|rock|rug|shoe|stapler|tack|teacup|toothbrush|turtle|wedding cake|yarn", colsizeCor$refExp, ignore.case = TRUE), T, F)
summary(colsizeCor)

colsizeCor$oneMentioned = ifelse(grepl(" one|thing|item|object", colsizeCor$refExp, ignore.case = TRUE), T, F)
colsizeCor$theMentioned = ifelse(grepl("the |a |an ", colsizeCor$refExp, ignore.case = TRUE), T, F)

summary(colsizeCor)

write.table(colsizeCor,file="colsizeCor.csv", sep="\t")

data2 = read.table(file="../data/colsize_manModified.csv",sep=",", header=T, quote="")
head(data2)
summary(data2)
data3 = droplevels(data2[!is.na(data2$targetStatusClickedObj) & data2$targetStatusClickedObj != "distractor",])
head(data3)
summary(data3)

##########################################################################################################

# basiclevel trials:

basiclev = droplevels(d[d$trialType != "colorSizeTrial",])
basiclevRow = nrow(basiclev)
nrow(basiclev)
head(basiclev)
summary(basiclev)

# drop incorrect trials:
basiclevCor = droplevels(basiclev[!is.na(basiclev$targetStatusClickedObj) & basiclev$targetStatusClickedObj != "distractor",])
head(basiclevCor)
print(paste("percentage of excluded trials because distractor was chosen: ", (basiclevRow -nrow(basiclevCor))*100/basiclevRow))
nrow(basiclevCor)

basiclevCor$sub = ifelse(grepl("bedside table|black bear|catfish|clownfish|coffee table|convertible|daisy|dalmatian|dining table|dress shirt|eagle|German Shepherd|goldfish|grizzly bear|gummybears|hawaii shirt|hummingbird|husky|jellybeans|M&Ms|minivan|panda bear|parrot|picnic table|pigeon|polar bear|polo shirt|pug|rose|skittles|sports car|sunflower|suv|swordfish|T-Shirt|tulip", basiclevCor$refExp, ignore.case = TRUE), T, F)
summary(basiclevCor)

basiclevCor$basic = ifelse(grepl("bear|bird|candy|car|dog|fish|flower|shirt|table", basiclevCor$refExp, ignore.case = TRUE), T, F)
summary(basiclevCor)

basiclevCor$super = ifelse(grepl("animal|clothing|furniture|plant|vehicle|snack", basiclevCor$refExp, ignore.case = TRUE), T, F)
summary(basiclevCor)

basiclevCor$oneMentioned = ifelse(grepl(" one|thing|item|object", basiclevCor$refExp, ignore.case = TRUE), T, F)
basiclevCor$theMentioned = ifelse(grepl("the |a |an ", basiclevCor$refExp, ignore.case = TRUE), T, F)

summary(basiclevCor)

#write.table(basiclevCor,file="basiclevCor.csv", sep="\t")


######################################################################################################

# Extracting data from manually modified file: 1) basic levels

bl = read.table(file="../data/basiclev_manModified_allAttr.csv",sep=",", header=T, quote="")
head(bl)
blrows = nrow(bl)

blCor = droplevels(bl[!is.na(bl$targetStatusClickedObj) & bl$targetStatusClickedObj != "distractor",])
head(blCor)
print(paste("percentage of excluded trials because distractor was chosen: ", (blrows -nrow(blCor))*100/blrows))
corRows = nrow(blCor) #2146

summary(blCor)

print(paste("percentage of automatically labelled trials: ", (1548)*100/corRows))
print(paste("percentage of manually added trials: ", (323)*100/corRows))
print(paste("percentage of total excluded correct trials: ", (corRows - 1871)*100/corRows))

print(paste("percentage of trials where 2 levels were mentioned: ", (26)*100/corRows))

print(paste("percentage of sub mentions where an additional modifier was used: ", (82)*100/924))
print(paste("percentage of basic mentions where an additional modifier was used: ", (177)*100/925))
print(paste("percentage of super mentions where an additional modifier was used: ", (14)*100/21))

###Analyze manually modified + correct modifier trials###

data = read.table(file="../data/colsize_manModified.csv",sep=",", header=T, quote="")
head(data)
colsizeCor = droplevels(data[!is.na(data$targetStatusClickedObj) & data$targetStatusClickedObj != "distractor",])
head(colsizeCor)
nrow(colsizeCor)
summary(colsizeCor)
write.table(colsizeCor,file="colsizeCor_manModified.csv", sep="\t")

# Look at trials not included in analysis
colsizeCor_excluded1 = droplevels(colsizeCor[colsizeCor$automaticallyLabelledTrials != "TRUE",])
head(colsizeCor_excluded1)
nrow(colsizeCor_excluded1)
summary(colsizeCor_excluded1)

colsizeCor_excluded = droplevels(colsizeCor_excluded1[colsizeCor_excluded1$manuallyAddedTrials != "TRUE",])
head(colsizeCor_excluded)
nrow(colsizeCor_excluded)
summary(colsizeCor_excluded)
write.table(colsizeCor_excluded,file="colsizeCor_excluded_manModified.csv", sep="\t")

#number of automatically classified utts: 2047/2138
#number of manually added utts: 32/2138 (42)
#Total included trials: 2079



###Extract incorrect modifier trials###

d = read.table(file="../data/colsize_manModified.csv",sep=",", header=T, quote="")
head(d)
nrow(d)

# only incorrect trials:
colsizeIncor = droplevels(d[!is.na(d$targetStatusClickedObj) & d$targetStatusClickedObj != "target",])
head(colsizeIncor)
nrow(colsizeIncor)

write.table(colsizeIncor,file="colsizeIncor.csv", sep="\t")





