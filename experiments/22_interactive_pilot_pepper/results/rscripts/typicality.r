theme_set(theme_bw(18))
setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/22_interactive_pilot_pepper/results")
source("rscripts/helpers.r")

d = read.table(file="data/results.csv",sep="\t", header=T, quote="")
nrow(d)
head(d)
unique(d$listenerMessages)
d[d$listenerMessages != "",c("listenerMessages","speakerMessages")]
summary(d)

# look at turker comments
comments = read.table(file="../mturk/overinf.csv",sep=",", header=T, quote="")

unique(comments$comments)

ggplot(comments, aes(ratePartner)) +
  stat_count()

ggplot(comments, aes(thinksHuman)) +
  stat_count()

ggplot(comments, aes(nativeEnglish)) +
  stat_count()

ggplot(comments, aes(totalLength)) +
  geom_histogram()

# first figure out how often target was chosen -- exclude trials where it wasn't?
table(d$context,d$targetStatusClickedObj)

# exclude NA referential experssions 
d = d[!(is.na(d$refExp)),]

# exclude trials with distractor choices
d = droplevels(d[d$targetStatusClickedObj == "target",])
nrow(d)

# how many unique pairs?
length(levels(d$gameid)) 

table(d$context,d$typeMentioned)
table(d$context,d$colorMentioned)

typ = read.table(file="../../11_color_norming/results/data/meantypicalities.csv",sep=",",header=T)
row.names(typ) = paste(typ$Color,typ$Item)
head(typ)

production = d
production$NormedTypicality = typ[paste(production$clickedColor,production$clickedType),]$Typicality
production$binaryTypicality = as.factor(ifelse(production$NormedTypicality > .5, "typical", "atypical"))
#production <- production[,colSums(is.na(production))<nrow(production)]
production$ColorMentioned = ifelse(grepl("green|purple|white|black|brown|purple|violet|yellow|gold|orange|silver|blue|pink|red|purlpe|pruple|yllow|grean|dark", production$refExp, ignore.case = TRUE), T, F)
production$CleanedResponse = gsub("([bB]ananna|[Bb]annna|[Bb]anna|[Bb]annana|[Bb]anan|[Bb]ananaa)","banana",as.character(production$refExp))
production$CleanedResponse = gsub("[Cc]arot|[Cc]arrrot","carrot",as.character(production$CleanedResponse))
production$CleanedResponse = gsub("([Tt]omaot|tmatoe|tamato|toato)","tomato",as.character(production$CleanedResponse))
production$CleanedResponse = gsub("[Aa]ppe|APPLE","apple",as.character(production$CleanedResponse))
production$CleanedResponse = gsub("[Pp]eper","pepper",as.character(production$CleanedResponse))
production$CleanedResponse = gsub("[Aa]vacado|[Aa]vacadfo","avocado",as.character(production$CleanedResponse))
production$ItemMentioned = ifelse(grepl("apple|banana|carrot|tomato|pear|pepper|avocado", production$CleanedResponse, ignore.case = TRUE), T, F)
production$CatMentioned = ifelse(grepl("fruit|veg|veggi|veggie", production$CleanedResponse, ignore.case = TRUE), T, F)

prop.table(table(production$ColorMentioned,production$ItemMentioned))

production[!production$ColorMentioned & !production$ItemMentioned,c("CleanedResponse","context","gameid")]
production[!production$ColorMentioned & production$ItemMentioned,c("CleanedResponse","context","gameid")]

production$UtteranceType = as.factor(ifelse(production$ItemMentioned & production$ColorMentioned, "color_and_type", ifelse(production$ColorMentioned & !production$CatMentioned & !production$ItemMentioned, "color", ifelse(production$ItemMentioned & !production$ColorMentioned & !production$CatMentioned, "type", ifelse(!production$ItemMentioned & !production$ColorMentioned & production$CatMentioned, "cat", ifelse(!production$ItemMentioned & production$ColorMentioned & production$CatMentioned, "color_and_cat","OTHER"))))))

production[production$UtteranceType == "OTHER",c("gameid","refExp","context")]
table(production[production$UtteranceType == "OTHER",]$gameid) 

production$Color = ifelse(production$UtteranceType == "color",1,0)
production$ColorAndType = ifelse(production$UtteranceType == "color_and_type",1,0)
production$Type = ifelse(production$UtteranceType == "type",1,0)
production$ColorAndCat = ifelse(production$UtteranceType == "color_and_cat",1,0)
production$Cat = ifelse(production$UtteranceType == "cat",1,0)
production$Other = ifelse(production$UtteranceType == "OTHER",1,0)
production$Item = production$clickedType
production$Half = ifelse(production$roundNum < 28,1,2)

# plot histogram of mentioned features by context
agr = production %>%
  select(ColorMentioned,ItemMentioned,context) %>%
  gather(Feature,Mentioned,-context)
agr$Feature = gsub("Mentioned","",as.character(agr$Feature))
agr = droplevels(subset(agr,Mentioned == "TRUE"))
head(agr)

ggplot(agr, aes(x=Feature)) +
  stat_count() +
  facet_wrap(~context)
ggsave("graphs/mentioned_features_by_context.png",width=8,height=3.5)

# plot utterance choice proportions with error bars
agr = production %>%
  select(Color,Type,ColorAndType,ColorAndCat,Cat,Other,context) %>%
  gather(Utterance,Mentioned,-context) %>%
  group_by(Utterance,context) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

ggplot(agr, aes(x=Utterance,y=Probability)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~context) +
  theme(axis.text.x=element_text(angle=45,hjust=1,vjust=1))
ggsave("graphs/mentioned_features_by_context_other.pdf",width=10,height=3.5)

# plot utterance choice proportions by typicality
agr = production %>%
  select(Color,Type,ColorAndType,Other,binaryTypicality,context) %>%
  gather(Utterance,Mentioned,-context,-binaryTypicality) %>%
  group_by(Utterance,context,binaryTypicality) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

ggplot(agr, aes(x=binaryTypicality,y=Probability,color=Utterance,group=Utterance)) +
  geom_point() +
  geom_line() +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~context)
ggsave("graphs/utterance_by_binarytyp.png",width=10,height=3.5)

# plot utterance choice proportions by typicality
agr = production %>%
  select(Color,Type,ColorAndType,Other,NormedTypicality,context) %>%
  gather(Utterance,Mentioned,-context,-NormedTypicality) %>%
  group_by(Utterance,context,NormedTypicality) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

ggplot(agr, aes(x=NormedTypicality,y=Probability,color=Utterance)) +
  geom_point() +
  geom_smooth(method="lm") +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~context)
ggsave("graphs/utterance_by_conttyp.png",width=10,height=3.5)

# plot utterance choice proportions by typicality
agr = production %>%
  select(Color,Type,ColorAndType,Other,binaryTypicality,context,Half) %>%
  gather(Utterance,Mentioned,-context,-binaryTypicality,-Half) %>%
  group_by(Utterance,context,binaryTypicality,Half) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

ggplot(agr, aes(x=binaryTypicality,y=Probability,color=Utterance,group=Utterance)) +
  geom_point() +
  geom_line() +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(Half~context)
ggsave("graphs/utterance_by_binarytyp_byhalf.png",width=10,height=3.5)

write.csv(production,file="data/results-22.csv")

