library(dplyr)
library(ggplot2)
library(bootstrap)
library(lme4)
library(tidyr)
library(here)

theme_set(theme_bw(18))
# setwd("/Users/elisakreiss/Documents/Business/Projects/Overinformativeness/overinformativeness/experiments/elisa_paper_relevant/interactiveReferenceGame/results")
source(here("rscripts","helpers.r"))

d = read.table(file=here("data","results.csv"),sep="\t", header=T, quote="")
d[d$listenerMessages != "",c("listenerMessages","speakerMessages")]
# exclude NA referential expressions 
d = droplevels(d[!(is.na(d$refExp)),])
# 59 pairs
unique(d$gameid)

# exclude participants that were not paid because they didn't finish it
d = droplevels(d[!(d$gameid == "6444-b" | d$gameid == "4924-4"), ])
# exclude tabu players
d = droplevels(d[!(d$gameid == "1544-1" | d$gameid == "4885-8" | d$gameid == "8360-7" | d$gameid == "4624-5" | d$gameid == "5738-a" | d$gameid == "8931-5" | d$gameid == "8116-a" | d$gameid == "6180-c" | d$gameid == "1638-6" | d$gameid == "6836-b"), ])
# 47 pairs
# figure out how often target was chosen
table(d$context,d$targetStatusClickedObj)
# exclude trials with distractor choices
d = droplevels(d[d$targetStatusClickedObj == "target",])

# get meantypicalities from previous study
typ = read.csv(file=here("..", "..", "norming_comp_object", "results", "data", "meantypicalities.csv"))
typ = typ[as.character(typ$Item) == as.character(typ$utterance),]
row.names(typ) = paste(typ$Color,typ$Item)

production = d
production$clickedColor = ifelse(as.character(production$clickedColor) == 'pink', 'purple', as.character(production$clickedColor))
production$NormedTypicality = typ[paste(production$clickedColor,production$clickedType),]$Typicality
production$binaryTypicality = as.factor(ifelse(production$NormedTypicality > .5, "typical", "atypical"))

# utterance analysis / categorization
###
# step-by-step categorization
#
# # basic categories/labels, no spelling errors
# production$ColorMentioned = ifelse(grepl("green|purple|white|black|brown|yellow|orange|blue|pink|red|grey", production$refExp, ignore.case = TRUE), T, F)
# production$ItemMentioned = ifelse(grepl("apple|banana|carrot|tomato|pear|pepper|avocado", production$refExp, ignore.case = TRUE), T, F)
# # sorted utterances
# nrow(production[production$ItemMentioned | production$ColorMentioned,])
# #
# # identify utterances with negation,... to exclude them from ItemMentioned and ColorMentioned
# production$CatMentioned = ifelse(grepl("fruit|fru7t|veg|veggi|veggie|vegetable", production$refExp, ignore.case = TRUE), T, F)
# production$NegationMentioned = ifelse(grepl("not|isnt|arent|isn't|aren't|non", production$refExp, ignore.case = TRUE), T, F)
# production$ColorModifierMentioned = ifelse(grepl("normal|abnormal|healthy|dying|natural|regular|funky|rotten|noraml|norm", production$refExp, ignore.case = TRUE), T, F)
# production$DescriptionMentioned = ifelse(grepl("like|round|sauce|long|rough|grass|doc|bunnies|bunny|same|stem|inside|ground|with|smile|monkey|sphere", production$refExp, ignore.case = TRUE), T, F)
# production$Other = ifelse(production$CatMentioned | production$NegationMentioned | production$ColorModifierMentioned | production$DescriptionMentioned, T, F)
# # utterances that have an identified color/type and no negation,...
# nrow(production[!production$Other & (production$ItemMentioned | production$ColorMentioned),])
# # remaining trials without "other"
# nrow(production[!production$Other,])
# #
# # suffixes, abbreviations, non-precoded labels
# production$ColorMentioned = ifelse(grepl("green|purple|white|black|brown|violet|yellow|gold|orange|silver|blue|blu|pink|dark|purp|yel|gree|red|grey|neon|blac|lavender|pinkish|gray", production$refExp, ignore.case = TRUE), T, F)
# production$ItemMentioned = ifelse(grepl("apple|banana|carrot|tomato|pear|pepper|avocado|jalapeno|guacamole", production$refExp, ignore.case = TRUE), T, F)
# # utterances that have an identified color/type and no negation,...
# nrow(production[!production$Other & (production$ItemMentioned | production$ColorMentioned),])
# #
# # unsorted utterances
# # nrow(production[!production$ColorMentioned & !production$ItemMentioned & !production$Other,])
###

# clean responses
production$CleanedResponse = gsub("(^| )([bB]ananna|[Bb]annna|[Bb]anna|[Bb]annana|[Bb]anan|[Bb]ananaa|ban|bana|banada|nana|bannan|babanana|B)($| )"," banana",as.character(production$refExp))
production$CleanedResponse = gsub("(^| )([Cc]arot|[Cc]arrrot|[Cc]arrott|car|carrpt|carrote|carr)($| )"," carrot",as.character(production$CleanedResponse))
production$CleanedResponse = gsub("(^| )([Pp]earr|pea)$"," pear",as.character(production$CleanedResponse))
production$CleanedResponse = gsub("(^| )([Tt]omaot|tokm|tmatoe|tamato|toato|tom|[Tt]omatoe|tomamt|tomtato|toamoat|mato|totomato|tomatop)($| )"," tomato",as.character(production$CleanedResponse))
production$CleanedResponse = gsub("(^| )([Aa]ppe|appple|APPLE|appl|app|apale|aple|ap)($| )"," apple",as.character(production$CleanedResponse))
production$CleanedResponse = gsub("(^| )([Pp]eper|pepp|peppre|pep|bell|jalapeno|jalpaeno|eppper|jalpaeno?)($| )"," pepper",as.character(production$CleanedResponse))
production$CleanedResponse = gsub("(^| )([Aa]vacado|avodado|avacdo|[Aa]vacadfo|avo|avacoda|avo|advocado|avavcado|avacodo|guacamole|gaucamole|guacolome|advacado|avacado,|avacado\\\\)($| )"," avocado",as.character(production$CleanedResponse))
# categorize responses
production$ColorMentioned = ifelse(grepl("green|purple|white|black|brown|purple|violet|yellow|gold|orange|prange|silver|blue|blu|pink|red|purlpe|pruple|puyrple|purplke|yllow|grean|dark|purp|yel|gree|gfeen|bllack|blakc|grey|neon|gray|blck|blu|blac|lavender|ornage|pinkish|^or ", production$refExp, ignore.case = TRUE), T, F)
production$ItemMentioned = ifelse(grepl("apple|banana|carrot|tomato|pear|pepper|avocado|jalpaeno?", production$CleanedResponse, ignore.case = TRUE), T, F)
production$CatMentioned = ifelse(grepl("fruit|fru7t|veg|veggi|veggie|vegetable", production$CleanedResponse, ignore.case = TRUE), T, F)
production$NegationMentioned = ifelse(grepl("not|isnt|arent|isn't|aren't|non", production$CleanedResponse, ignore.case = TRUE), T, F)
production$ColorModifierMentioned = ifelse(grepl("normal|abnormal|healthy|dying|natural|regular|funky|rotten|noraml|norm", production$CleanedResponse, ignore.case = TRUE), T, F)
production$DescriptionMentioned = ifelse(grepl("like|round|sauce|long|rough|grass|doc|bunnies|bunny|same|stem|inside|ground|with|smile|monkey|sphere", production$CleanedResponse, ignore.case = TRUE), T, F)
production$Other = ifelse(production$CatMentioned | production$NegationMentioned | production$ColorModifierMentioned | production$DescriptionMentioned, T, F)

# summarize utterance types
production$UtteranceType = as.factor(
  ifelse(production$ItemMentioned & production$ColorMentioned & !production$Other, "color_and_type", 
         ifelse(production$ColorMentioned & !production$ItemMentioned & !production$Other, "color", 
                ifelse(production$ItemMentioned & !production$ColorMentioned & !production$Other, "type", 
                       "OTHER"))))

production$Color = ifelse(production$UtteranceType == "color",1,0)
production$ColorAndType = ifelse(production$UtteranceType == "color_and_type",1,0)
production$Type = ifelse(production$UtteranceType == "type",1,0)
# we don't specify 'other' here again because utterances that are not Cat,Neg,ColorMod,Description are "Hi" or "Hello" or clarification questions such as "do you know if i can just tell u what the picture is or do i have to tell u it's color?" and therefore non-interpretable
# those are 6 utterances (they are still though in UtteranceType == "OTHER")
# production$Other = ifelse(production$UtteranceType == "OTHER",1,0)
production$Item = production$clickedType
production$Half = ifelse(production$roundNum < 21,1,2)


# plot histogram of mentioned features by context
agr = production %>%
  select(ColorMentioned,ItemMentioned,context) %>%
  gather(Feature,Mentioned,-context)
agr$Feature = gsub("Mentioned","",as.character(agr$Feature))
agr = droplevels(subset(agr,Mentioned == "TRUE"))
head(agr)
# plot
ggplot(agr, aes(x=Feature)) +
  stat_count() +
  facet_wrap(~context)
ggsave(here("graphs","empiricalData","mentioned_features_by_context.png"),width=8,height=3.5)


# plot utterance choice proportions with error bars
agr = production %>%
  select(Color,Type,ColorAndType,Other,context) %>%
  gather(Utterance,Mentioned,-context) %>%
  group_by(Utterance,context) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
# change order of Utterance column
agr$Utterance <- as.character(agr$Utterance)
agr$Utterance <- factor(agr$Utterance, levels=c("Type", "Color", "ColorAndType", "Other"))
# change context names to have nicer facet labels 
levels(agr$context) = c("informative","informative\nwith color competitor", "overinformative", "overinformative\nwith color competitor")
# plot
ggplot(agr, aes(x=Utterance,y=Probability)) +
  geom_bar(stat="identity",width=.2,fill="orange",colour="orange") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.15,colour="grey") +
  facet_wrap(~context) +
  scale_x_discrete(labels=c("Only Type", "Only Color", "Color + Type", "Other")) +
  theme(axis.title=element_text(size=14,colour="#757575")) +
  theme(axis.text.x=element_text(angle=45,hjust=1,vjust=1,size=11,colour="#757575")) +
  theme(axis.text.y=element_text(size=10,colour="#757575")) +
  theme(axis.ticks=element_line(size=.25,colour="#757575"), axis.ticks.length=unit(.75,"mm")) +
  theme(strip.text.x=element_text(size=12,colour="#757575")) +
  theme(strip.background=element_rect(colour="#939393",fill="white")) +
  theme(panel.background=element_rect(colour="#939393"))
ggsave(here("graphs","empiricalData","mentioned_features_by_context_other.png"),width=7,height=7)


# plot utterance choice proportions by binary typicality
agr = production %>%
  select(Color,Type,ColorAndType,Other,binaryTypicality,context) %>%
  gather(Utterance,Mentioned,-context,-binaryTypicality) %>%
  group_by(Utterance,context,binaryTypicality) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
# change order of Utterance column
agr$Utterance <- as.character(agr$Utterance)
agr$Utterance <- factor(agr$Utterance, levels=c("Type", "Color", "ColorAndType", "Other"))
# change context names to have nicer facet labels 
levels(agr$context) = c("informative","informative\nwith color competitor", "overinformative", "overinformative\nwith color competitor")
# plot
ggplot(agr, aes(x=binaryTypicality,y=Probability,color=Utterance,group=Utterance)) +
  geom_point() +
  geom_line() +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~context) +
  scale_color_discrete(name="Utterance",
                       breaks=c("Type", "Color", "ColorAndType", "Other"),
                       labels=c("Only Type", "Only Color", "Color + Type", "Other")) +
  theme(axis.title=element_text(size=14,colour="#757575")) +
  theme(axis.text.x=element_text(size=11,colour="#757575")) +
  theme(axis.text.y=element_text(size=10,colour="#757575")) +
  theme(axis.ticks=element_line(size=.25,colour="#757575"), axis.ticks.length=unit(.75,"mm")) +
  theme(strip.text.x=element_text(size=12,colour="#757575")) +
  theme(legend.title=element_text(size=14,color="#757575")) +
  theme(legend.text=element_text(size=11,colour="#757575")) +
  theme(strip.background=element_rect(colour="#939393",fill="white")) +
  theme(panel.background=element_rect(colour="#939393"))
ggsave(here("graphs","empiricalData","utterance_by_binarytyp.png"),width=10,height=6.5)


# plot utterance choice proportions by typicality
agr = production %>%
  select(Color,Type,ColorAndType,Other,NormedTypicality,context) %>%
  gather(Utterance,Mentioned,-context,-NormedTypicality) %>%
  group_by(Utterance,context,NormedTypicality) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
# change order of Utterance column
agr$Utterance <- as.character(agr$Utterance)
agr$Utterance <- factor(agr$Utterance, levels=c("Type", "Color", "ColorAndType", "Other"))
# change context names to have nicer facet labels 
levels(agr$context) = c("informative","informative\nwith color competitor", "overinformative", "overinformative\nwith color competitor")
# plot
ggplot(agr, aes(x=NormedTypicality,y=Probability,color=Utterance)) +
  geom_point(size=.5) +
  geom_smooth(method="lm",size=.6) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~context) +
  scale_color_discrete(name="Utterance",
                       breaks=c("Type", "Color", "ColorAndType", "Other"),
                       labels=c("Only Type", "Only Color", "Color + Type", "Other")) +
  theme(axis.title=element_text(size=14,colour="#757575")) +
  theme(axis.text.x=element_text(size=10,colour="#757575")) +
  theme(axis.text.y=element_text(size=10,colour="#757575")) +
  theme(axis.ticks=element_line(size=.25,colour="#757575"), axis.ticks.length=unit(.75,"mm")) +
  theme(strip.text.x=element_text(size=12,colour="#757575")) +
  theme(legend.title=element_text(size=14,color="#757575")) +
  theme(legend.text=element_text(size=11,colour="#757575")) +
  theme(strip.background=element_rect(colour="#939393",fill="white")) +
  theme(panel.background=element_rect(colour="#939393"))
ggsave(here("graphs","empiricalData","utterance_by_conttyp.png"),width=12,height=9)

# plot typical vs atypical by item
# value for typical/atypical separation in mean of all midtypical object ratings
# result in 1020 typical vs 922 atypical entries
production$binTyp = ifelse(production$NormedTypicality >= 0.784, 'typical', 'atypical')
production$binContext = ifelse(production$context == "overinformative-cc", 'overinformative', 
                               ifelse(production$context == "informative-cc", 'informative', as.character(production$context)))

agr = production %>%
  group_by(binContext,clickedType,binTyp) %>%
  summarise(PropColorMentioned=mean(ColorMentioned),ci.low=ci.low(ColorMentioned),ci.high=ci.high(ColorMentioned))
agr = as.data.frame(agr)
agr$YMin = agr$PropColorMentioned - agr$ci.low
agr$YMax = agr$PropColorMentioned + agr$ci.high

agr$binTyp = factor(agr$binTyp, levels=c("typical","atypical"))

ggplot(agr, aes(x=binTyp,y=PropColorMentioned,color=clickedType,linetype=binContext,group=interaction(binContext,clickedType))) +
  geom_point() +
  geom_line() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  xlab("Typicality") +
  ylab("Proportion of  \n mentioning color") +
  theme(axis.title=element_text(size=25,colour="#757575")) +
  theme(axis.text.x=element_text(size=20,colour="#757575")) +
  theme(axis.text.y=element_text(size=20,colour="#757575")) +
  theme(axis.ticks=element_line(size=.25,colour="#757575"), axis.ticks.length=unit(.75,"mm")) +
  theme(legend.title=element_text(size=25,color="#757575")) +
  theme(legend.text=element_text(size=20,colour="#757575")) +
  guides(color=guide_legend(title="Object")) +
  guides(linetype=guide_legend(title="Context"))
ggsave(here("graphs","empiricalData","byitem_variability.png"),width=12,height=6)


# plot typical vs atypical by subject
# value for typical/atypical separation in mean of all midtypical object ratings
# result in 1020 typical vs 922 atypical entries
production$binTyp = ifelse(production$NormedTypicality >= 0.784, 'typical', 'atypical')
production$binContext = ifelse(production$context == "overinformative-cc", 'overinformative', 
                               ifelse(production$context == "informative-cc", 'informative', as.character(production$context)))

agr = production %>%
  group_by(binContext,binTyp,gameid) %>%
  summarise(PropColorMentioned=mean(ColorMentioned),ci.low=ci.low(ColorMentioned),ci.high=ci.high(ColorMentioned))
agr = as.data.frame(agr)
agr$YMin = agr$PropColorMentioned - agr$ci.low
agr$YMax = agr$PropColorMentioned + agr$ci.high

agr$binTyp = factor(agr$binTyp, levels=c("typical","atypical"))

ggplot(agr, aes(x=binTyp,y=PropColorMentioned,color=gameid,linetype=binContext,group=interaction(binContext,gameid))) +
  geom_point() +
  geom_line() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  # geom_smooth() +
  xlab("Typicality") +
  ylab("Proportion of  \n mentioning color") +
  theme(axis.title=element_text(size=25,colour="#757575")) +
  theme(axis.text.x=element_text(size=20,colour="#757575")) +
  theme(axis.text.y=element_text(size=20,colour="#757575")) +
  theme(axis.ticks=element_line(size=.25,colour="#757575"), axis.ticks.length=unit(.75,"mm")) +
  theme(legend.title=element_text(size=25,color="#757575")) +
  theme(legend.text=element_text(size=20,colour="#757575")) +
  guides(color=guide_legend(title="Object")) +
  guides(linetype=guide_legend(title="Context"))
ggsave(here("graphs","empiricalData","bysubject_variability.png"),width=12,height=6)

# plot utterance choice proportions by typicality thick for poster/thesis
agr = production %>%
  select(Color,Type,ColorAndType,Other,NormedTypicality,context) %>%
  gather(Utterance,Mentioned,-context,-NormedTypicality) %>%
  group_by(Utterance,context,NormedTypicality) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
# change order of Utterance column
agr$Utterance <- as.character(agr$Utterance)
agr$Utterance <- factor(agr$Utterance, levels=c("Type", "Color", "ColorAndType", "Other"))
agr$Utterance <- ifelse(agr$Utterance == "Type", "Only Type",
                        ifelse(agr$Utterance == "Color", "Only Color",
                               ifelse(agr$Utterance == "ColorAndType", "Color + Type",
                                      ifelse(agr$Utterance == "Other", "Other","ERROR"))))
# change context names to have nicer facet labels 
levels(agr$context) = c("informative","informative-cc", "overinformative", "overinformative-cc")
# plot
ggplot(agr, aes(x=NormedTypicality,y=Probability,color=Utterance)) +
  geom_point(size=2) +
  geom_smooth(method="lm",size=2.25) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~context) +
  # scale_color_discrete(name="Utterance",
  #                      breaks=c("Type", "Color", "ColorAndType", "Other"),
  #                      labels=c("Only Type", "Only Color", "Color + Type", "Other")) +
  xlab("Typicality") +
  ylab("Empirical utterance proportion") +
  coord_cartesian(xlim=c(0.4,1),ylim=c(0, 1)) +
  scale_color_manual(values=c("#56B4E9", "#E69F00", "#9fdf9f", "#999999")) +
  theme(axis.title=element_text(size=25,colour="#757575")) +
  theme(axis.text.x=element_text(size=20,colour="#757575")) +
  theme(axis.text.y=element_text(size=20,colour="#757575")) +
  theme(axis.ticks=element_line(size=.5,colour="#757575"), axis.ticks.length=unit(1,"mm")) +
  theme(strip.text.x=element_text(size=25,colour="#757575")) +
  theme(legend.position="top") +
  theme(legend.title=element_text(size=25,color="#757575")) +
  theme(legend.text=element_text(size=20,colour="#757575")) +
  labs(color = "Utterance") +
  theme(strip.background=element_rect(colour="#939393",fill="white")) +
  theme(panel.background=element_rect(colour="#939393"))
ggsave(here("graphs","empiricalData","utterance_by_conttyp_poster.png"),width=12,height=9)
# ggsave("../../../../../../Uni/BachelorThesis/graphs/empiricalProportions.png",width=12,height=7)


# plot utterance choice proportions by typicality for color/non-color
agr = production %>%
  select(ColorMentioned,Type,Other,NormedTypicality,context) %>%
  gather(Utterance,Mentioned,-context,-NormedTypicality) %>%
  group_by(Utterance,context,NormedTypicality) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
# change order of Utterance column
agr$Utterance <- as.character(agr$Utterance)
agr$Utterance <- factor(agr$Utterance, levels=c("ColorMentioned", "Type", "Other"))
# change context names to have nicer facet labels 
levels(agr$context) = c("informative","informative\nwith color competitor", "overinformative", "overinformative\nwith color competitor")
# plot
ggplot(agr, aes(x=NormedTypicality,y=Probability,color=Utterance)) +
  geom_point(size=2) +
  geom_smooth(method="lm",size=2.25) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~context) +
  scale_color_discrete(name="Utterance",
                       breaks=c("ColorMentioned", "Type", "Other"),
                       labels=c("Color Mentioned", "Type Only", "Other")) +
  xlab("Typicality") +
  ylab("Empirical utterance proportion") +
  theme(axis.title=element_text(size=25,colour="#757575")) +
  theme(axis.text.x=element_text(size=20,colour="#757575")) +
  theme(axis.text.y=element_text(size=20,colour="#757575")) +
  theme(axis.ticks=element_line(size=.5,colour="#757575"), axis.ticks.length=unit(1,"mm")) +
  theme(legend.title=element_text(size=25,color="#757575")) +
  theme(legend.text=element_text(size=20,colour="#757575")) +
  theme(strip.background=element_rect(colour="#939393",fill="white")) +
  theme(panel.background=element_rect(colour="#939393"))
ggsave(here("graphs","empiricalData","utterance_by_conttyp_colorNoncolor.png"),width=12,height=9)
