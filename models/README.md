# Model results for modified NPs

## Model versions

This table keeps track of the different parameters associated with informativeness, utterance cost, and property or utterance typicality in different model versions.

| Model | Info | Cost | Typicality | Results |
| ----- | --------------- | ---- | ---------- | ------- |
| 1 | yes | uniform | one param each for size and color | |
| 2 | yes | one param each for size and color | one param each for size and color | |
| 3a | yes | one param each for size and color | raw empirical for color, param for size, param for color (for cases where color doesn't match) | |
| 3b | yes | one param each for size and color | rescaled empirical for color, param for size, param for color (for cases where color doesn't match) | |
| 4 | yes | one param each for size and color | param for size; for color, interpolate between empirical and fixed param| |

## Model 3 results

The difference between model 3a and 3b is that the typicality values used in 3a are the raw ones (between 0 and 1), in 3b they're rescaled to fit between .5 and 1. 3a captures the empirical typicality effect better than 3b, but in the correlation scatterplot, 3b looks slightly better. 

![3a](/models/1_basic_overinformativeness/results_bda/graphs/predictives-costs-typicalities-raw.pdf)

## ToDo

- [x] find examples with large typicality diffs between unmodified NOUN and modified COLOR NOUN versions, and check whether model predicts that in those cases, color overmodification is greater
- [] more generally, make plots (y: prob of overmodification, x: scene variation, facet: sufficient dimension) exploring effect (color aes) of **informativeness** (0-10), **cost** (0-5), **typicality** (0-1)
- [] add model results to table
- [] write down version of model that interpolates between empirical typicality and fixed color typicality parameter and do whole exploration again (model 4 in table)
