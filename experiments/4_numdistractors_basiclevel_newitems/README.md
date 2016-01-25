# Results

## Pros

- We get the general ordering and gradience in redundant color use predicted by the model

## Cons

- Haven't yet figured out whether we can get exact quantitative fit. In particular: redundancy is at floor empirically when all distractors have the same color as the target -- but the model predicts redundancy should never fall below a certain level (eg with lambda 5, color fidelity .999, and size fidelity .8, it bottoms out at .3. You need to explore the parameter space and see what it is (if anything) that drives the floor down. It may turn out that we need color typicality to get this (since for typical colors, you're less likely to mention it and our objects tend to be pretty realistic).

- Currently, our data were collected in two separate experiments. It would be nice if we could get it all from one.

## Conclusion

Implement color predictability model and figure out whether you can get the redundancy floor to drop.

We need to run one more big experiment?