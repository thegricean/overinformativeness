setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/7_overinf_basiclevel_biggersample/results")
d_noattr = read.csv("data/basiclev_manModified_allAttr.csv")

tmp = d_noattr[(d_noattr$sub | d_noattr$basic | d_noattr$super) & d_noattr$targetStatusClickedObj == "target",] %>%
  select(gameid, roundNum, condition, nameClickedObj, alt1Name, alt2Name, sub, basic, super) %>%
  mutate(targetName = tolower(nameClickedObj),
         alt1Name = tolower(alt1Name),
         alt2Name = tolower(alt2Name)) %>%
  mutate(refLevel = ifelse(sub, "sub",
                           ifelse(basic, "basic",
                                  ifelse(super, "super", "other")))) %>%
  select(gameid, roundNum, targetName, alt1Name, alt2Name, refLevel)

write.csv(tmp, "data/exp1_bdaInput.csv", row.names = F, quote = F)

