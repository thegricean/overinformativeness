# change labels!!!:
# d$orderedFreq = factor(x=freq,c(levels(freq)[2], levels(freq[3], levels(freq)[1]))


theme_set(theme_bw(18))

setwd("/home/caroline/cocolab/overinformativeness/models/basic_level_reference/modelExploration/rscripts")
#setwd("~/cogsci/projects/stanford/projects/overinformativeness/models/basic_level_reference/modelExploration/rscripts")

source("helpers.R")

freqData = read.table(file="../speakerOutput_manipulate_Freq_global.csv",sep=",", header=T, quote="")
head(freqData)
nrow(freqData)

# Add variable with combined freqs of (jeweils) 2 levels: (only looking at those cases where these levels have same freqs)

freqData$freq_basicSuper = ifelse(freqData$freq_basic == freqData$freq_super, freqData$freq_basic, "NaN")
head(freqData)
freqData$freq_subSuper = ifelse(freqData$freq_sub == freqData$freq_super, freqData$freq_sub, "NaN")
head(freqData)
freqData$freq_subBasic = ifelse(freqData$freq_basic == freqData$freq_sub, freqData$freq_basic, "NaN")
head(freqData)

#make new freq datasets where rows are excluded in which the respective 2 levels are not the same
freqDataCombBasicSuper = droplevels(subset(freqData, freq_basicSuper != "NaN"))
head(freqDataCombBasicSuper)
nrow(freqDataCombBasicSuper)

freqDataCombSubSuper = droplevels(subset(freqData, freq_subSuper != "NaN"))
head(freqDataCombSubSuper)
nrow(freqDataCombSubSuper)

freqDataCombSubBasic = droplevels(subset(freqData, freq_subBasic != "NaN"))
head(freqDataCombSubBasic)
nrow(freqDataCombSubBasic)

#freq analysis: freqDataCombBasicSuper

agr = freqDataCombBasicSuper %>%
  select(p_s_sub, p_s_basic, p_s_super, condition, freq_sub, freq_basicSuper) %>%
  gather(Utterance,Mentioned,-condition, -freq_sub, -freq_basicSuper) %>%
  group_by(Utterance,condition, freq_sub, freq_basicSuper) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
head(agr)

ggplot(agr, aes(x=freq_sub,y=Probability, color=freq_basicSuper, group=freq_basicSuper)) +
  geom_point() +
  geom_line() +
  facet_grid(condition~Utterance)
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("../graphs/freqExploration_speakerProb_by_condition_by_freq_sub_by_CombBasicSuperfreq.pdf",width=10,height=10)

#freq analysis: freqDataCombSubSuper

agr = freqDataCombSubSuper %>%
  select(p_s_sub, p_s_basic, p_s_super, condition, freq_basic, freq_subSuper) %>%
  gather(Utterance,Mentioned,-condition, -freq_basic, -freq_subSuper) %>%
  group_by(Utterance,condition, freq_basic, freq_subSuper) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
head(agr)

ggplot(agr, aes(x=freq_basic,y=Probability, color=freq_subSuper, group=freq_subSuper)) +
  geom_point() +
  geom_line() +
  facet_grid(condition~Utterance)
theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("../graphs/freqExploration_speakerProb_by_condition_by_freq_basic_by_CombSubSuperfreq.pdf",width=10,height=10)

#freq analysis: freqDataCombSubBasic

agr = freqDataCombSubBasic %>%
  select(p_s_sub, p_s_basic, p_s_super, condition, freq_super, freq_subBasic) %>%
  gather(Utterance,Mentioned,-condition, -freq_super, -freq_subBasic) %>%
  group_by(Utterance,condition, freq_super, freq_subBasic) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
head(agr)

ggplot(agr, aes(x=freq_super,y=Probability, color=freq_subBasic, group=freq_subBasic)) +
  geom_point() +
  geom_line() +
  facet_grid(condition~Utterance)
theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))
ggsave("../graphs/freqExploration_speakerProb_by_condition_by_freq_super_by_CombSubBasicfreq.pdf",width=10,height=10)

