# Automatic preprocessing of data from 7_overinf_biggersample

theme_set(theme_bw(18))

setwd("/home/caroline/cocolab/overinformativeness/experiments/7_overinf_basiclevel_biggersample/results")
source("rscripts/helpers.R")

###Annotation check file###

d = read.table(file="data/results.csv",sep=",", header=T, quote="")
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

write.table(basiclevCor,file="basiclevCor.csv", sep="\t")










