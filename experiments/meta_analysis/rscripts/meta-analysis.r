theme_set(theme_bw(18))

setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/meta_analysis/")
source("rscripts/helpers.r")

d1 = read.table(file="../12_production_calibration/results/data/norming.csv",sep=",", header=T)[,c("workerid","target_item","target_color","condition","slide_number_in_experiment","response")]
d1$Exp = "12"
d2 = read.table(file="../14_production_calibration_dtyp/results/data/norming.csv",sep=",", header=T)[,c("workerid","target_item","target_color","condition","slide_number_in_experiment","response")]
d2$Exp = "14"
d2$workerid = d2$workerid + 15
d3 = read.table(file="../15_prod_calibr_dtyp_cleverDaxy/results/data/norming.csv",sep=",", header=T)[,c("workerid","target_item","target_color","condition","slide_number_in_experiment","response")]
d3$Exp = "15"
d3$workerid = d3$workerid + 30
d4 = read.table(file="../16_prod_calibr_bob/results/data/norming.csv",sep=",", header=T)[,c("workerid","target_item","target_color","condition","slide_number_in_experiment","response")]
d4$Exp = "16"
d4$workerid = d4$workerid + 45
d5 = read.table(file="../17_prod_calibr_noInformTrial/results/data/norming.csv",sep=",", header=T)[,c("workerid","target_item","target_color","condition","slide_number_in_experiment","response")]
d5$Exp = "17"
d5$workerid = d5$workerid + 60
d6 = read.table(file="../18_prod_calibr_targetColorContext/results/data/norming.csv",sep=",", header=T)[,c("workerid","target_item","target_color","condition","slide_number_in_experiment","response")]
d6$Exp = "18"
d6$workerid = d6$workerid + 75
d7 = read.table(file="../19_18_enhanced/results/data/norming.csv",sep=",", header=T)[,c("workerid","target_item","target_color","condition","slide_number_in_experiment","response")]
d7$Exp = "19"
d7$workerid = d7$workerid + 90

d = rbind(d1,d2)
d = rbind(d,d3)
d = rbind(d,d4)
d = rbind(d,d5)
d = rbind(d,d6)
d$condition = as.character(d$condition)
d = rbind(d,d7)
d$Exp = as.factor(as.character(d$Exp))
d$condition = as.factor(as.character(d$condition))

head(d)
nrow(d)
summary(d)
totalnrow = nrow(d)
d$Trial = d$slide_number_in_experiment - 3
length(unique(d$workerid))

typ = read.table(file="../11_color_norming/results/data/meantypicalities.csv",sep=",",header=T)
row.names(typ) = paste(typ$Color,typ$Item)
head(typ)

# process production data
production = d[d$condition %in% c("informative","overinformative"),]
production$NormedTypicality = typ[paste(production$target_color,production$target_item),]$Typicality
production$binaryTypicality = as.factor(ifelse(production$NormedTypicality > .5, "typical", "atypical"))
production <- production[,colSums(is.na(production))<nrow(production)]
production$ColorMentioned = ifelse(grepl("green|purple|white|black|brown|purple|violet|yellow|gold|orange|silver|blue|pink|red", production$response, ignore.case = TRUE), T, F)
production$CleanedResponse = gsub("([bB]ananna|[Bb]annna|[Bb]anna|[Bb]annana|[Bb]anan)","banana",as.character(production$response))
production$CleanedResponse = gsub("[Cc]arot|[Cc]arrrot","carrot",as.character(production$CleanedResponse))
production$CleanedResponse = gsub("([Tt]omaot|tmatoe|tamato)","tomato",as.character(production$CleanedResponse))
production$CleanedResponse = gsub("[Aa]ppe","apple",as.character(production$CleanedResponse))
production$ItemMentioned = ifelse(grepl("apple|banana|orange|carrot|tomato|pear|pepper", production$CleanedResponse, ignore.case = TRUE), T, F)
prop.table(table(production$ColorMentioned,production$ItemMentioned))

production[!production$ColorMentioned & !production$ItemMentioned,c("response","condition","workerid")]
production[!production$ColorMentioned & !production$ItemMentioned,]$target_item
production[!production$ColorMentioned & !production$ItemMentioned,]$target_color

production[production$ColorMentioned & !production$ItemMentioned,c("response","workerid")]


#exclude cases where locative modifiers were used
production = droplevels(production[!(!production$ColorMentioned & !production$ItemMentioned),])
nrow(production) # 1932 cases to analyze

table(production$condition,production$binaryTypicality)
table(production$condition,production$binaryTypicality,production$target_item)
agr = production %>%
  group_by(condition,binaryTypicality) %>%
  summarise(PropColorMentioned=mean(ColorMentioned),ci.low=ci.low(ColorMentioned),ci.high=ci.high(ColorMentioned))
agr = as.data.frame(agr)
agr$YMin = agr$PropColorMentioned - agr$ci.low
agr$YMax = agr$PropColorMentioned + agr$ci.high

ggplot(agr, aes(x=binaryTypicality,y=PropColorMentioned,color=condition)) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25)
ggsave("graphs/png/distribution_effect_production.png",height=3.5,width=6)

# by subject
agr = production %>%
  group_by(condition,binaryTypicality,workerid) %>%
  summarise(PropColorMentioned=mean(ColorMentioned),ci.low=ci.low(ColorMentioned),ci.high=ci.high(ColorMentioned))
agr = as.data.frame(agr)
agr$YMin = agr$PropColorMentioned - agr$ci.low
agr$YMax = agr$PropColorMentioned + agr$ci.high

ggplot(agr, aes(x=binaryTypicality,y=PropColorMentioned,color=condition)) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~workerid)
ggsave("graphs/png/distribution_effect_production_bysubject.png",height=8.5)


# by trial
production$FirstTrial = ifelse(production$Trial == 1, "first","not-first")
agr = production %>%
  group_by(condition,binaryTypicality,FirstTrial) %>%
  summarise(PropColorMentioned=mean(ColorMentioned),ci.low=ci.low(ColorMentioned),ci.high=ci.high(ColorMentioned))
agr = as.data.frame(agr)
agr$YMin = agr$PropColorMentioned - agr$ci.low
agr$YMax = agr$PropColorMentioned + agr$ci.high

ggplot(agr, aes(x=binaryTypicality,y=PropColorMentioned,color=condition)) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~FirstTrial)
ggsave("graphs/png/distribution_effect_production_byfirsttrial.png",height=3.5)


# condition on whether or not item was mentioned
table(production$condition,production$binaryTypicality)
agr = production %>%
  group_by(condition,binaryTypicality,ItemMentioned) %>%
  summarise(PropColorMentioned=mean(ColorMentioned),ci.low=ci.low(ColorMentioned),ci.high=ci.high(ColorMentioned))
agr = as.data.frame(agr)
agr$YMin = agr$PropColorMentioned - agr$ci.low
agr$YMax = agr$PropColorMentioned + agr$ci.high

ggplot(agr, aes(x=binaryTypicality,y=PropColorMentioned,color=condition)) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(~ItemMentioned)
ggsave("graphs/png/distribution_effect_production_byitemmention.png",height=3.5)


agr = production %>%
  group_by(condition,target_item,NormedTypicality,ItemMentioned) %>%
  summarise(PropColorMentioned=mean(ColorMentioned),ci.low=ci.low(ColorMentioned),ci.high=ci.high(ColorMentioned))
agr = as.data.frame(agr)
agr$YMin = agr$PropColorMentioned - agr$ci.low
agr$YMax = agr$PropColorMentioned + agr$ci.high

ggplot(agr, aes(x=NormedTypicality,y=PropColorMentioned,color=target_item,linetype=condition,group=interaction(condition,target_item))) +
  geom_point() +
  geom_line() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(~ItemMentioned)
ggsave("graphs/png/production_byitem.png",height=3.5)

centered = cbind(production,myCenter(production[,c("binaryTypicality","condition")]))
m = glmer(ColorMentioned ~ cbinaryTypicality*ccondition + (1|workerid) + (1|target_item), data=centered, family="binomial")
summary(m)

ranef(m)

m = glm(ColorMentioned ~ binaryTypicality, data=production, family="binomial")
summary(m)
