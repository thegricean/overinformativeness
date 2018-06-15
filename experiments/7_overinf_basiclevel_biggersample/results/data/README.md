# Results from Clean-up (for internal documentation) and documention of renaming of files

At some stages of the project we had data files containing some subset of trials (e.g., without "other" mentions, only incorrect...). For a better overview, all files are renamed and (renamed) old versions of files are put in the separate folder "discarded".

Note: the color/size experiment is referred to as exp1 and the basic levels experiment is referred to as exp3.

Note: The new repo RE_production contains a subset of files from the old overinformativeness repo (only those necessary for reproduction).

Note: There was some confusion because of a wonky participant pair with game ID 2370-c and 12 completed trials: There was either a technical error or participant noncompliance going on: There are only listener messages (no speaker messages), which are mostly incomprehensible (e.g., "asdf"), yet half of the trials were correct. Initially, Caroline exluded this participant pair during manual pre-processing, thus they were not present in any of the old files. However, when Judith redid some analyses for the big paper, the pair was reincluded, and there was thus a discrepancy between the old and new files, in particular between RE_production/data/raw/production_exp1_exp3/rawdata_exp1_exp3.csv and RE_production/data/raw/production_exp1_exp3/data_exp1_preManualTypoCorrection.csv (new) and RE_production/data/raw/production_exp1_exp3/data_exp1_postManualTypoCorrection.csv (old).

The agreed-upon solution to this is the following: It is now noted in the paper, that these 6 trials per condition were excluded due to missing speaker messages during manual pre-processing. There is also a note in preprocessing_exp1.R and preprocessing:exp3.R.

## List of old and new file names with remarks

| old file name		| new file name | remarks |
| :--------------:|------------------| -------- |
| basiclevCor_manModified | exp1/exp1_cor_manModified | old file with (only a few) manually coded variables and only correct trials of exp3 (also, is missing 2370-c, just like all post-manually processed files)
| basiclev_manModified | exp3/exp3_manModified_noAttr |  earlier post-processing file without variables encoding attribute mentions, also it has some formatting problem when loading into R (several columns with only NAs are attached to data frame) (also, is missing 2370-c, just like all post-manually processed files)
| basiclevCor_manModified_allAttr | data_exp3_postManualTypoCorrection |  final post-processed data of exp3
| bdaInput | exp3_bdaInput | data fed into BDA; used to be generated in rscripts/BDAinput, but is now part of rscripts/preprocessing_exp3
| colsizeCor_manModified | exp1/exp1_cor_manModified.csv | same as old files data_bda_modifiers and data_modifiers
| colsizeIncor_manModified | exp1/exp1_incor_manModified.csv | 
| colsize_manModified | data_exp1_postManualTypoCorrection | pair with game ID 2370-c was excluded
| data_bda_modifiers | exp1/data_bda_exp1_cor_missing_2370 | this exp1 file only contains correct trials (also, is missing 2370-c, just like all post-manually processed files)
| data_bda_modifiers_maxdifftypicality | exp1/data_bda_exp1_maxdifftypicality_for_exploration | this exp1 file only contains correct trials (also, is missing 2370-c, just like all post-manually processed files), for exploration
| data_bda_modifiers_noother | exp1/data_bda_exp1_noother_cor_missing_2370 | this exp1 file only contains correct trials (also, is missing 2370-c, just like all post-manually processed files), for exploration, "other" mentions are excluded
| data_bda_modifiers_reduced_noother | exp1/data_bda_exp1_reduced_noother_cor_missing_2370 | this exp1 file only contains correct trials (also, is missing 2370-c, just like all post-manually processed files), for exploration, "other" mentions are excluded, reduced
| data_modifiers | exp1/data_exp1_cor.csv | same as old files data_bda_modifiers and colsizeCor_manModified
| results | rawdata_exp1_exp3.csv | new file contains pair with game D 2370-c. Some formatting errors were removed (some rows were spilling over to new columns, because parsing algorithm didn't correctly parse multiple messages from one speaker)
| results_for_regression | exp1/results_for_regression_exp1_cor_and_2370_missing.csv | this exp1 file only contains correct trials (also, is missing 2370-c, just like all post-manually processed files) 
| size_overspecification | exp1/size_overspecification_exp1_for_exploration | 
| unique_conditions_modifiers | unique_conditions/unique_conditions_exp1_ | 
| unique_conditions_modifiers_maxdifftypicality | unique_conditions/unique_conditions_exp1_maxdifftypicality | 
| unique_conditions_modifiers_noother | unique_conditions/unique_conditions_exp1_noother | 
| unique_conditions_modifiers_reduced | unique_conditions/unique_conditions_exp1_reduced | 
| unique_conditions_modifiers_reduced_noother | unique_conditions/unique_conditions_exp1_reduced_noother | 
| unique_conditions | unique_conditions/unique_conditions_exp3 | 
| frequencyChart | cost/exp3_frequency | 
| lengthChart | cost/exp3_length | 
| lengthChart_uniformLabels | cost/exp3_length_uniformLabels | Identical to exp3_length file, just with all lower-case letters
| lengthChart_uniformLabels_forExploration | cost/exp3_length_uniformLabels_forExploration | lengths for Caroline's model exploration in thesis
| length_calculations.ods | cost/exp3_length_manual_compilation.csv | This is a file that compiles the lengths of different instances of sub, basic, and super mentions. Initially this should have been automatically, however, it was difficult to foresee which alternatives would be uttered by participants; i.e., many alternatives could not be automatically coded. Thus this document lists all possible speaker referring expressions, their length, and their count, as well as the average empirical length and standard deviation.
| incomplete_pairs_info.ods | incomplete_pairs_info.ods | missing pair was added (gameid: 2370-c), as well as info that it was excluded after manual processing


