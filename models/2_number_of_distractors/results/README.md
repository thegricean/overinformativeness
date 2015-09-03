# Preliminary results 

We use the model in overinformativeness.church to generate predictions for the situation in which there is a big red object, a small red object, and a varying number of additional small (either red or yellow)  objects (where objects don't differ in type). The model predicts an increase in redundant color use with increasing number of distractors when the color of the distractors is different from the color of the target object, but not when it's the same. A similar effect is *not* predicted for redundant size use. Utterance probabilities are shown for speaker optimalities of 5, 10, and 15. Beyond 4 distractors, there is no additional effect of number of distractors (because overmodification is already at ceiling).

![Plot of model predicted speaker probabilities for situation described in Gatt et al 2011 as a function of number and property of distractors](/models/2_number_of_distractors/results/graphs/cf.999_sf.8_ccss.1_spopt5.jpg "Model (speaker optimality = 5)")

![Plot of model predicted speaker probabilities for situation described in Gatt et al 2011 as a function of number and property of distractors](/models/2_number_of_distractors/results/graphs/cf.999_sf.8_ccss.1_spopt10.jpg "Model (speaker optimality = 10)")

![Plot of model predicted speaker probabilities for situation described in Gatt et al 2011 as a function of number and property of distractors](/models/2_number_of_distractors/results/graphs/cf.999_sf.8_ccss.1_spopt15.jpg "Model (speaker optimality = 15)")

Note that when distractortype is "varied", that means that there is one distractor that shares the non-distinguishing feature with the target (eg, when the target is big and red, and size is sufficient to distinguish, this distractor is small and red) and all other distractors share neither feature with the target (ie in our example, all other distractors are small and yellow). 