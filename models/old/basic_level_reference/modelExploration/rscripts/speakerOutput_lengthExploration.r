theme_set(theme_bw(18))

setwd("/home/caroline/cocolab/overinformativeness/models/basic_level_reference/modelExploration/rscripts")
#setwd("~/cogsci/projects/stanford/projects/overinformativeness/models/basic_level_reference/modelExploration/rscripts")

source("helpers.R")

lengthData = read.table(file="../speakerOutput_manipulate_Length_global.csv",sep=",", header=T, quote="")
head(lengthData)
nrow(lengthData)

# Add variable with combined lengths of (jeweils) 2 levels: (only looking at those cases where these levels have same lengths)

lengthData$length_basicSuper = ifelse(lengthData$length_basic == lengthData$length_super, lengthData$length_basic, "NaN")
head(lengthData)
lengthData$length_subSuper = ifelse(lengthData$length_sub == lengthData$length_super, lengthData$length_sub, "NaN")
head(lengthData)
lengthData$length_subBasic = ifelse(lengthData$length_basic == lengthData$length_sub, lengthData$length_basic, "NaN")
head(lengthData)

#make new length datasets where rows are excluded in which the respective 2 levels are not the same
lengthDataCombBasicSuper = droplevels(subset(lengthData, length_basicSuper != "NaN"))
head(lengthDataCombBasicSuper)
nrow(lengthDataCombBasicSuper)

lengthDataCombSubSuper = droplevels(subset(lengthData, length_subSuper != "NaN"))
head(lengthDataCombSubSuper)
nrow(lengthDataCombSubSuper)

lengthDataCombSubBasic = droplevels(subset(lengthData, length_subBasic != "NaN"))
head(lengthDataCombSubBasic)
nrow(lengthDataCombSubBasic)

#length analysis: lengthDataCombBasicSuper

agr = lengthDataCombBasicSuper %>%
  select(p_s_sub, p_s_basic, p_s_super, condition, length_sub, length_basicSuper) %>%
  gather(Utterance,Mentioned,-condition, -length_sub, -length_basicSuper) %>%
  group_by(Utterance,condition, length_sub, length_basicSuper) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
head(agr)

ggplot(agr, aes(x=length_sub,y=Probability, color=length_basicSuper, group=length_basicSuper)) +
  geom_point() +
  geom_line() +
  facet_grid(condition~Utterance)
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("../graphs/lengthExploration_speakerProb_by_condition_by_length_sub_by_CombBasicSuperLength.pdf",width=10,height=10)

#length analysis: lengthDataCombSubSuper

agr = lengthDataCombSubSuper %>%
  select(p_s_sub, p_s_basic, p_s_super, condition, length_basic, length_subSuper) %>%
  gather(Utterance,Mentioned,-condition, -length_basic, -length_subSuper) %>%
  group_by(Utterance,condition, length_basic, length_subSuper) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
head(agr)

ggplot(agr, aes(x=length_basic,y=Probability, color=length_subSuper, group=length_subSuper)) +
  geom_point() +
  geom_line() +
  facet_grid(condition~Utterance)
theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("../graphs/lengthExploration_speakerProb_by_condition_by_length_basic_by_CombSubSuperLength.pdf",width=10,height=10)

#length analysis: lengthDataCombSubBasic

agr = lengthDataCombSubBasic %>%
  select(p_s_sub, p_s_basic, p_s_super, condition, length_super, length_subBasic) %>%
  gather(Utterance,Mentioned,-condition, -length_super, -length_subBasic) %>%
  group_by(Utterance,condition, length_super, length_subBasic) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
head(agr)

ggplot(agr, aes(x=length_super,y=Probability, color=length_subBasic, group=length_subBasic)) +
  geom_point() +
  geom_line() +
  facet_grid(condition~Utterance)
theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("../graphs/lengthExploration_speakerProb_by_condition_by_length_super_by_CombSubBasicLength.pdf",width=10,height=10)
