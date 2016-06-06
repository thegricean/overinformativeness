theme_set(theme_bw(18))

setwd("/home/caroline/cocolab/overinformativeness/models/basic_level_reference/modelExploration")
#setwd("~/cogsci/projects/stanford/projects/overinformativeness/models/basic_level_reference/modelExploration")

source("rscripts/helpers.R")

#load("data/r.RData")
lengthData = read.table(file="speakerOutput_manipulate_Length_global.csv",sep=",", header=T, quote="")
head(lengthData)
freqData = read.table(file="speakerOutput_manipulate_Freq_global.csv",sep=",", header=T, quote="")
head(freqData)
nrow(freqData)

#length analysis

