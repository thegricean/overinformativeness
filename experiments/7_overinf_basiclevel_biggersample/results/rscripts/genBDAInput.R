setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/7_overinf_basiclevel_biggersample/results")
d_noattr = read.csv("data/basiclev_manModified_allAttr.csv")

tmp = d_noattr %>%
  select(gameid, roundNum, condition, nameClickedObj, alt1Name, alt2Name, typeMentioned, basiclevelMentioned, superClassMentioned) %>%
  mutate(targetName = tolower(nameClickedObj),
         alt1Name = tolower(alt1Name),
         alt2Name = tolower(alt2Name)) %>%
  mutate(refLevel = ifelse(typeMentioned, "sub",
                           ifelse(basiclevelMentioned, "basic",
                                  ifelse(superClassMentioned, "super", "other")))) %>%
  select(gameid, roundNum, targetName, alt1Name, alt2Name, refLevel)

write.csv(tmp, "./data/bdaInput.csv", row.names = F, quote = F)

