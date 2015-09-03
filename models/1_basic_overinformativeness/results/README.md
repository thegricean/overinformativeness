# Preliminary results 

We use the model in overinformativeness.church to generate predictions for the situation in which there is a big red object, a small red object, and a small yellow object (where objects don't differ in type). This is formally equivalent to the situations described in [Gatt, van Gompel, Krahmer, and van Deemter (2011, CogSci)](http://staff.um.edu.mt/albert.gatt/pubs/precogsci2011.pdf). Model predictions for optimal parameters (eye-balling) are shown alongside the empirical data for both Dutch and English from the paper. Graphs with a fuller exploration of the parameter space are in /graphs.

The results look really nice and fall out purely from an asymmetry in how noisy the predicates are.


![Plot of model predicted speaker probabilities for situation described in Gatt et al 2011](/models/1_basic_overinformativeness/results/graphs/model.vs.empirical.jpg "Model vs empirical")


The model has the following free parameters: **color cost, size cost, color fidelity, size fidelity, speaker optimality**. 

| Parameter        | Range            | Optimal |
| -----------------| -----------------| --------|
| Color cost | .1 - 1 in increments of .1 | .1  |
| Size cost | .1 - 1 in increments of .1 | .1  (.2 in some cases, but cost asymmetry not necessary!) |
| Color fidelity | .5 .6 .7 .75 .8 .85 .9 .999 | .8, .85, .9, .999 (but mostly .999) |
| Size fidelity | .5 .6 .7 .75 .8 .85 .9 .999 | .7, .75, .8 |
| Speaker optimality | 1 - 18 in increments of 1 | >10 for basic overinformativeness effect, >15 for the color-only preference when referring to the small yellow object|

**Important things of note:**

1. NO COST ASYMMETRY NECESSARY (in fact, cost asymmetries make results worse, except in certain cases when size costs .2 and color .1)

2. very high speaker optimality necessary -- do we care about this?

3. asymmetry in fidelity necessary -- ie, color fidelity needs to be higher than size fidelity. This is awesome and as we hoped.

# Next steps

1. Modeling: get the 'number of distractors' effect

2. Modeling: think about how to get the color predictability effect (global QUD type of mechanism?)

3. Figure out exactly what the empirical results are for the color variation results (ie, how was color variation actually manipulated, what do the contexts look like?)

4. Modeling: ask Albert for the 2011 dataset (for later modeling)

5. Get familiar with Robert's paradigm to do production study a la Gatt (need to validate first, ie do we get similar results with written production as the Dutch have been getting in spoken production?)

6. Run experiment with adjectives that are between SIZE and COLOR on the ordering preference scale: empirically, are overmodification rates correlated with position on the scale? (eg age, texture, shape, material)
