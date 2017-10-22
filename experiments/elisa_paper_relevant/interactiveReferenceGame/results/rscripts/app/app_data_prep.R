library(dplyr)
library(ggplot2)
library(bootstrap)
library(lme4)
library(tidyr)

theme_set(theme_bw(18))
setwd("/Users/elisakreiss/Documents/Stanford/overinformativeness/experiments/elisa_paper_relevant/interactiveReferenceGame/results/rscripts/app")

typ <- read.table(file="data/meantyp_short.csv",sep=",", header=T,check.names = FALSE)
typ$obj = paste(typ$Color,typ$Item,sep = "_")

# df_nonoise <- read.table(file="data/visualizationPredictives.csv",sep=",", header=T,check.names = FALSE)
# df_nonoise$obj = df_nonoise$target

empRef <- read.table(file="data/empiricalReferenceProbs.csv",sep=",", header=T,check.names = FALSE)
empRef$obj <- empRef$target
empRef <- empRef[,c('uttType','condition','empiricProb','obj')]

df_addnoise1 <- read.table(file="data/vizNoiseAddPredictives_1.csv",sep=",", header=T,check.names = FALSE)
df_addnoise2 <- read.table(file="data/vizNoiseAddPredictives_2.csv",sep=",", header=T,check.names = FALSE)
df_addnoise3 <- read.table(file="data/vizNoiseAddPredictives_3.csv",sep=",", header=T,check.names = FALSE)
df_addnoise4 <- read.table(file="data/vizNoiseAddPredictives_4.csv",sep=",", header=T,check.names = FALSE)
df_addnoise5 <- read.table(file="data/vizNoiseAddPredictives_5.csv",sep=",", header=T,check.names = FALSE)

df_addnoise <- rbind(df_addnoise1, df_addnoise2, df_addnoise3, df_addnoise4, df_addnoise5)
# df_nonoise$noiseRate <- 0
# df_nonoise$noise <- 1
# df_nonoise <- df_nonoise[,c('condition','obj', 'alpha','colorCost','typeCost','lengthWeight','typWeight','uttType','modelPrediction','noise','noiseRate')]
df_addnoise$noise <- ifelse(df_addnoise$noiseRate == 0, 1, 2)
df_addnoise <- df_addnoise[,c('condition','obj', 'alpha','colorCost','typeCost','lengthWeight','typWeight','uttType','modelPrediction','noise','noiseRate')]

# full_df <- rbind(df_addnoise,df_nonoise)
# no pink
# full_df <- df_addnoise[!(df_addnoise$obj == 'pink_carrot' | df_addnoise$obj == 'orange_carrot' | df_addnoise$obj == 'brown_carrot'),]
# full_df <- full_df[!(full_df$obj == 'pink_tomato' | full_df$obj == 'red_tomato' | full_df$obj == 'green_tomato'),]
full_df <- df_addnoise
df <- left_join(full_df,empRef)
df$Typicality = typ$Typicality[match(df$obj, typ$obj)]

df <- df[,c('condition','alpha','colorCost','typeCost','lengthWeight','typWeight','uttType','modelPrediction','noise','noiseRate','empiricProb','Typicality')]

# write.csv(df, "data/completeDataPredictives_nopink.csv", row.names = FALSE)
write.csv(df, "data/completeDataPredictives.csv", row.names = FALSE)