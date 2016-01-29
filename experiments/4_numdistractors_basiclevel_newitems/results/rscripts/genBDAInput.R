
d_noattr = read.csv("~/Repos/overinformativeness/experiments/4_numdistractors_basiclevel_newitems/results/noAttr.csv")

tmp = d_noattr %>%
  select(gameid, roundNum, condition, nameClickedObj, alt1Name, alt2Name, typeMentioned, basiclevelMentioned, superClassMentioned) %>%
  mutate(targetName = nameClickedObj) %>%
  mutate(refLevel = ifelse(typeMentioned, "type",
                           ifelse(basiclevelMentioned, "basic",
                                  ifelse(superClassMentioned, "super", "other")))) %>%
  select(gameid, roundNum, nameClickedObj, alt1Name, alt2Name, refLevel)

write.csv(tmp, "bdaInput.csv", row.names = F, quote = F)

