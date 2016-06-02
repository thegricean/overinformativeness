theme_set(theme_bw(18))

setwd("/home/caroline/cocolab/overinformativeness/models/basic_level_reference/modelExploration/dataExtraction")
#setwd("~/cogsci/projects/stanford/projects/overinformativeness/models/basic_level_reference/modelExploration")

lengths = read.table(file="lengthChart_uniformLabels_biggerSample.csv",sep=",", header=T, quote="")
head(lengths)
freqs = read.table(file="frequencyChart_uniformLabels.csv",sep=",", header=T, quote="")
head(freqs)
nrow(freqs)
typs = read.table(file="itemtypicalitiesREAL.csv",sep=",", header=T, quote="")
head(typs)

#extract LENGTHS:

#overall
mean(lengths$average_length)
#7.029412
min(lengths$average_length)
#3
max(lengths$average_length)
#13.13

#for sub:
sub = droplevels(subset(lengths, level == "sub"))
head(sub)
nrow(sub)
mean(sub$average_length)
#7.761389
min(sub$average_length)
#3
max(sub$average_length)
#13.13

#for basic:
basic = droplevels(subset(lengths, level == "basic"))
head(basic)
nrow(basic)
mean(basic$average_length)
#4.343333
min(basic$average_length)
#3.01
max(basic$average_length)
#5.98

#for super:
super = droplevels(subset(lengths, level == "super"))
head(super)
nrow(super)
mean(super$average_length)
#6.666667
min(super$average_length)
#5
max(super$average_length)
#9

#extract FREQUENCIES:

#overall
mean(freqs$relFreq)
#2.210477e-05
min(freqs$relFreq)
#1.59e-10
max(freqs$relFreq)
#0.000309774

#for sub:
sub = droplevels(subset(freqs, level == "sub"))
head(sub)
nrow(sub)
mean(sub$relFreq)
#1.674502e-06
min(sub$relFreq)
#1.59e-10
max(sub$relFreq)
#2.53e-05

#for basic:
basic = droplevels(subset(freqs, level == "basic"))
head(basic)
nrow(basic)
mean(basic$relFreq)
#7.794756e-05
min(basic$relFreq)
#6.34e-06
max(basic$relFreq)
#0.000309774

#for super:
super = droplevels(subset(freqs, level == "super"))
head(super)
nrow(super)
mean(super$relFreq)
#6.092217e-05
min(super$relFreq)
#4.43e-06
max(super$relFreq)
#0.000155648

# extract TYPICALITIES

###overall
mean(typs$meanresponse)
#0.2356346
min(typs$meanresponse)
#0.00375
max(typs$meanresponse)
#0.9872222

summary(typs)

###sub
sub = droplevels(subset(typs, labeltype == "sub"))
head(sub)
nrow(sub)

##overall sub
mean(sub$meanresponse)
#0.1552354
min(sub$meanresponse)
#0.00375
max(sub$meanresponse)
#0.9872222

##target_typ
target = droplevels(subset(sub, itemtypeNew == "target"))
head(target)
mean(target$meanresponse)
#0.9369443
min(target$meanresponse)
#0.82375
max(target$meanresponse)
#0.9872222

##distrSameBasic_typ
distrSameBasic = droplevels(subset(sub, itemtypeNew == "dist_samebasic"))
head(distrSameBasic)
mean(distrSameBasic$meanresponse)
#0.2646565
min(distrSameBasic$meanresponse)
#0.02375
max(distrSameBasic$meanresponse)
#0.7868421

##distrSameSuper_typ
distrSameSuper = droplevels(subset(sub, itemtypeNew == "dist_samesuper"))
head(distrSameSuper)
mean(distrSameSuper$meanresponse)
#0.04424588
min(distrSameSuper$meanresponse)
#0.00375
max(distrSameSuper$meanresponse)
#0.26375

##distrDiffSuper_typ
distrDiffSuper = droplevels(subset(sub, itemtypeNew == "dist_diffsuper"))
#--> all typs zero

#basic
basic = droplevels(subset(typs, labeltype == "basic"))
head(basic)
nrow(basic)

##overall basic
mean(basic$meanresponse)
#0.3519748
min(basic$meanresponse)
#0.004
max(basic$meanresponse)
#0.9766667

##target_typ
target = droplevels(subset(basic, itemtypeNew == "target"))
head(target)
mean(target$meanresponse)
#0.8803017
min(target$meanresponse)
#0.4873333
max(target$meanresponse)
#0.9730769

##distrSameBasic_typ
distrSameBasic = droplevels(subset(basic, itemtypeNew == "dist_samebasic"))
head(distrSameBasic)
mean(distrSameBasic$meanresponse)
#0.861241
min(distrSameBasic$meanresponse)
#0.4953333
max(distrSameBasic$meanresponse)
#0.9766667

##distrSameSuper_typ
distrSameSuper = droplevels(subset(basic, itemtypeNew == "dist_samesuper"))
head(distrSameSuper)
mean(distrSameSuper$meanresponse)
#0.06146359
min(distrSameSuper$meanresponse)
#0.004
max(distrSameSuper$meanresponse)
#0.3881818

##distrDiffSuper_typ
distrDiffSuper = droplevels(subset(basic, itemtypeNew == "dist_diffsuper"))
#--> all typs zero 

#super
super = droplevels(subset(typs, labeltype == "super"))
head(super)
nrow(super)

##overall super
mean(super$meanresponse)
#0.293862
min(super$meanresponse)
#0.005
max(super$meanresponse)
#0.957

##target_typ
target = droplevels(subset(super, itemtypeNew == "target"))
head(target)
mean(target$meanresponse)
#0.8244489
min(target$meanresponse)
#0.5246154
max(target$meanresponse)
#0.957

##distrSameBasic_typ
distrSameBasic = droplevels(subset(super, itemtypeNew == "dist_samebasic"))
head(distrSameBasic)
mean(distrSameBasic$meanresponse)
#0.8160308
min(distrSameBasic$meanresponse)
#0.616
max(distrSameBasic$meanresponse)
#0.8823077

##distrSameSuper_typ
distrSameSuper = droplevels(subset(super, itemtypeNew == "dist_samesuper"))
head(distrSameSuper)
mean(distrSameSuper$meanresponse)
#0.8028321
min(distrSameSuper$meanresponse)
#0.515
max(distrSameSuper$meanresponse)
#0.9392308

##distrDiffSuper_typ
distrDiffSuper = droplevels(subset(super, itemtypeNew == "dist_diffsuper"))
head(distrDiffSuper)
mean(distrDiffSuper$meanresponse)
#0.04304787
min(distrDiffSuper$meanresponse)
#0.005
max(distrDiffSuper$meanresponse)
#0.6188235

# mean typicalities, lengths and frequencies for 12 label_Condition_combinations:

# 1)  item12_sub: sub_length = 7.761389, sub_freq = 1.674502e-06, typ_t = 0.9369443, typ_d1 = 0.2646565, typ_d2 = 0.04424588, mean(typ_d1, typ_d2) = 0.1544512
# 2)  item22_sub: sub_length = 7.761389, sub_freq = 1.674502e-06, typ_t = 0.9369443, typ_d1 = 0.04424588, typ_d2 = 0.04424588, mean(typ_d1, typ_d2) = 0.04424588
# 3)  item23_sub: sub_length = 7.761389, sub_freq = 1.674502e-06, typ_t = 0.9369443, typ_d1 = 0.04424588, typ_d2 = 0, mean(typ_d1, typ_d2) = 0.02212294
# 4)  item33_sub: sub_length = 7.761389, sub_freq = 1.674502e-06, typ_t = 0.9369443, typ_d1 = 0, typ_d2 = 0, mean(typ_d1, typ_d2) = 0
# 5)  item12_basic: basic_length = 4.343333, basic_freq = 7.794756e-05, typ_t = 0.8803017, typ_d1 = 0.861241, typ_d2 = 0.06146359, mean(typ_d1, typ_d2) = 0.4613523
# 6)  item22_basic: basic_length = 4.343333, basic_freq = 7.794756e-05, typ_t = 0.8803017, typ_d1 = 0.06146359, typ_d2 = 0.06146359, mean(typ_d1, typ_d2) = 0.06146359
# 7)  item23_basic: basic_length = 4.343333, basic_freq = 7.794756e-05, typ_t = 0.8803017, typ_d1 = 0.06146359, typ_d2 = 0, mean(typ_d1, typ_d2) = 0.03073179
# 8)  item33_basic: basic_length = 4.343333, basic_freq = 7.794756e-05, typ_t = 0.8803017, typ_d1 = 0, typ_d2 = 0, mean(typ_d1, typ_d2) = 0
# 9)  item12_super: super_length = 6.666667, super_freq = 6.092217e-05, typ_t = 0.8244489, typ_d1 = 0.8160308, typ_d2 = 0.8028321, mean(typ_d1, typ_d2) = 0.8094314
# 10) item22_super: super_length = 6.666667, super_freq = 6.092217e-05, typ_t = 0.8244489, typ_d1 = 0.8028321, typ_d2 = 0.8028321, mean(typ_d1, typ_d2) = 0.8028321
# 11) item23_super: super_length = 6.666667, super_freq = 6.092217e-05, typ_t = 0.8244489, typ_d1 = 0.8028321, typ_d2 = 0.04304787, mean(typ_d1, typ_d2) = 0.42294
# 12) item33_super: super_length = 6.666667, super_freq = 6.092217e-05, typ_t = 0.8244489, typ_d1 = 0.04304787, typ_d2 = 0.04304787, mean(typ_d1, typ_d2) = 0.04304787

# global length: 7.029412
# global frequency: 2.210477e-05
