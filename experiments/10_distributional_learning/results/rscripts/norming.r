theme_set(theme_bw(18))
setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/10_distributional_learning/results")
source("rscripts/helpers.r")

d = read.table(file="data/norming.csv",sep=",", header=T)#, quote="")
head(d)
nrow(d)
summary(d)
totalnrow = nrow(d)
d$Trial = d$slide_number_in_experiment - 1
length(unique(d$workerid))

typ = read.table(file="../../11_color_norming/results/data/meantypicalities.csv",sep=",",header=T)
row.names(typ) = paste(typ$Color,typ$Item)
head(typ)

# look at turker comments
unique(d$comments)

ggplot(d, aes(rt)) +
  geom_histogram() +
  scale_x_continuous(limits=c(0,15000))

ggplot(d, aes(log(rt))) +
  geom_histogram() 

summary(d$Answer.time_in_minutes)
ggplot(d, aes(Answer.time_in_minutes)) +
  geom_histogram()

ggplot(d, aes(gender)) +
  stat_count()

ggplot(d, aes(asses)) +
  stat_count()

ggplot(d, aes(age)) +
  geom_histogram()
table(d$age)

ggplot(d, aes(education)) +
  stat_count()

ggplot(d, aes(language)) +
  stat_count()

ggplot(d, aes(enjoyment)) +
  stat_count()

# process typicality data
typicality = droplevels(d[!is.na(d$position_in_exposure),])
typicality <- typicality[,colSums(is.na(typicality))<nrow(typicality)]
typicality$NormedTypicality = typ[paste(typicality$color,typicality$item),]$Typicality
typicality$binaryTypicality = as.factor(ifelse(typicality$NormedTypicality > .5, "typical", "atypical"))

summary(production)
summary(typicality)
typicality$response = as.numeric(as.character(typicality$response))

agr = typicality %>%
  group_by(item,color,proportion,binaryTypicality) %>%
  summarise(MeanTypicality = mean(response),ci.low=ci.low(response),ci.high=ci.high(response))
agr = as.data.frame(agr)
agr$YMin = agr$MeanTypicality - agr$ci.low
agr$YMax = agr$MeanTypicality + agr$ci.high

ggplot(agr, aes(x=proportion,y=MeanTypicality,color=color)) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25)  +
  facet_wrap(~item)
ggsave("graphs/meantypicality_byitem.pdf")

ggplot(agr, aes(x=proportion,y=MeanTypicality,color=binaryTypicality)) +
  geom_point() +
  geom_smooth(method="lm") 
ggsave("graphs/meantypicality.pdf")

table(typicality$item,typicality$binaryTypicality,typicality$proportion)

# process production data
production = droplevels(d[is.na(d$position_in_exposure),])
production$NormedTypicality = typ[paste(production$target_color,production$target_item),]$Typicality
production$binaryTypicality = as.factor(ifelse(production$NormedTypicality > .5, "typical", "atypical"))
production <- production[,colSums(is.na(production))<nrow(production)]
production$ColorMentioned = ifelse(grepl("green|purple|white|black|brown|purple|violet|yellow|gold|orange|silver|blue|pink|red", production$response, ignore.case = TRUE), T, F)
production$CleanedResponse = gsub("([bB]ananna|[Bb]annna|[Bb]annana)","banana",as.character(production$response))
production$ItemMentioned = ifelse(grepl("apple|banana|orange|carrot|tomato|pear", production$CleanedResponse, ignore.case = TRUE), T, F)
prop.table(table(production$ColorMentioned,production$ItemMentioned))
# 1% cases of neither type nor color mention (eg, bad location modifiers like "the first one" or taboo-like reference to item like "long skinny vegetable")
production[!production$ColorMentioned & !production$ItemMentioned,]$response
# another 15% where color is mentioned but not type -- this seems to be just 3 subject who are being contrarian
production[production$ColorMentioned & !production$ItemMentioned,c("response","condition")]
table(production[production$ColorMentioned & !production$ItemMentioned,]$target_item,production[production$ColorMentioned & !production$ItemMentioned,]$binaryTypicality)
table(production[production$ColorMentioned & !production$ItemMentioned,]$target_item,production[production$ColorMentioned & !production$ItemMentioned,]$workerid)

# read in the distribtion info 
untyp = unique(typicality[,c("item","color","workerid","proportion")])
row.names(untyp) = paste(untyp$color,untyp$item,untyp$workerid)
production$Proportion = untyp[paste(production$target_color,production$target_item,production$workerid),]$proportion
head(production)

#exclude cases where locative modifiers were used
production = droplevels(production[!(!production$ColorMentioned & !production$ItemMentioned),])

agr = production %>%
  group_by(Proportion,condition,binaryTypicality) %>%
  summarise(PropColorMentioned=mean(ColorMentioned),ci.low=ci.low(ColorMentioned),ci.high=ci.high(ColorMentioned))
agr = as.data.frame(agr)
agr$YMin = agr$PropColorMentioned - agr$ci.low
agr$YMax = agr$PropColorMentioned + agr$ci.high

ggplot(agr, aes(x=Proportion,y=PropColorMentioned,color=condition)) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~binaryTypicality)
ggsave("graphs/distribution_effect_production.pdf",height=3.5)

# condition on whether or not item was mentioned
agr = production %>%
  group_by(Proportion,condition,binaryTypicality,ItemMentioned) %>%
  summarise(PropColorMentioned=mean(ColorMentioned),ci.low=ci.low(ColorMentioned),ci.high=ci.high(ColorMentioned))
agr = as.data.frame(agr)
agr$YMin = agr$PropColorMentioned - agr$ci.low
agr$YMax = agr$PropColorMentioned + agr$ci.high

ggplot(agr, aes(x=Proportion,y=PropColorMentioned,color=condition)) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(ItemMentioned~binaryTypicality)
ggsave("graphs/distribution_effect_production_byitemmention.pdf",height=6.5)

agr = production %>%
  group_by(Proportion,condition,binaryTypicality,workerid) %>%
  summarise(PropColorMentioned=mean(ColorMentioned),ci.low=ci.low(ColorMentioned),ci.high=ci.high(ColorMentioned))
agr = as.data.frame(agr)
agr$YMin = agr$PropColorMentioned - agr$ci.low
agr$YMax = agr$PropColorMentioned + agr$ci.high

ggplot(agr, aes(x=Proportion,y=PropColorMentioned,color=condition)) +
  geom_jitter(width = 10,height=0) +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(workerid~binaryTypicality)
ggsave("graphs/distribution_effect_production_bysubject.pdf",height=25)

agr = production %>%
  group_by(Proportion,condition,binaryTypicality,target_item) %>%
  summarise(PropColorMentioned=mean(ColorMentioned),ci.low=ci.low(ColorMentioned),ci.high=ci.high(ColorMentioned))
agr = as.data.frame(agr)
agr$YMin = agr$PropColorMentioned - agr$ci.low
agr$YMax = agr$PropColorMentioned + agr$ci.high

ggplot(agr, aes(x=Proportion,y=PropColorMentioned,color=condition)) +
  geom_jitter(width = 10,height=0) +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(target_item~binaryTypicality)
ggsave("graphs/distribution_effect_production_byitem.pdf",height=10)

m = glmer(ColorMentioned ~ Proportion*binaryTypicality + (1+Proportion|workerid), data=production[production$condition == "overinformative",], family="binomial")
summary(m)
