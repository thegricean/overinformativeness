# Overinformativeness

## Interesting phenomena to replicate/model

| Paper			| Language		| Result|
| --------------|:-------------:| -----:|
| Sedivy 2003	| English		| bla|

1. Sedivy (2003), English: in production, people tend to be more over-informative in terms of producing a color term when the color is less predictable from the category denoted by the noun than if it is more predictable. So, people say "yellow cup" a lot even when there is only one cup, but they don't say "yellow banana" when there is only one banana. In comprehension, color modifiers lead to contrastive inferences when the color is predictable, but not when it's not. Ie there's early convergence on the yellow banana but not on the yellow cup.

	- **replicate production result in Robert's interactive paradigm**
	
	- come up with a clever way to replicate the comprehension experiment that doesn't require eye-tracking?
	
2. Westerbeek et al (2014), Dutch: the probability that speakers redundantly include color in their descriptions is almost linearly predicted by the degree of color atypicality. Smaller effect: color mentioned more for objects with simple (ie not very informative as to type) shapes, eg oranges vs fire trucks.

3. Davies & Katsos (2009, 2013), English: lower overspecification rates in simpler visual arrays

4. Pechmann (1989), Koolen et al (2011), Dutch: more overspecification as number of distractors increases

## State of the field (from Davies & Katsos, in press; Koolen et al, 2011)

Speakers are sometimes overinformative / overspecify their referring expressions. Why? When? Generally: **hearer- vs speaker-oriented reasons for overinforming**/overspecifying REs.

### Speaker-oriented reasons for overspecifying

- incrementality (buy time, not enough time to figure out what's discriminating and what isn't, Pechmann 1989)

- perceptual salience (especially color is overspecified -- but what's the reference for there being variation within color? variation within color suggests it's not something monolithic about *color*, but something about **the function that different colors in different contexts serve**)

- overspecification can be detrimental for listeners (Engelhardt et al 2010; Sedivy et al 1999)

### Hearer/addressee-oriented reasons for overspecifying

- facilitation of hearer's reference resolution (subset identification, hearer incrementality considerations, Deutsch 1976, Nadig & Sedivy 2002, Paraboni et al 2006, Engelhardt et al 2006, Arts et al 2011, Davies & Katsos 2009) -- think about the fact that in general, visual scenes are incredibly complex, it may be that **on average, color is more helpful in carving up world perceptually than size is. More generally: things that are easier to distinguish perceptually should be more involved in overspecification?** 

- levels of informativeness interact with discourse goals (unclear whether it's speaker- or hearer-oriented, Maes, Arts & Noordman 2004): more overspecification when teaching hearer a long-term skill than on one-shot tasks; more overspecification when perceptual common ground is high; generally: Davies rightly says overspecification is expected when precision is important and risk of misunderstanding high

- Pechmann 1989 brings up information theory: redundant information is good because it can help compensate for partial loss of information. He then immediately dismisses this by saying that the redundant information isn't truly redundant because it's not distinguishing and at best can reduce the size of the domain. --> but when in dire straits, that may be a good start!!

### The relevance of prior experience

- most studies only take into account current context while ignoring past experience

- issue of conceptual pacts / lexical entrainment -- sometimes you don't want to let go of the information that was at one point helpful, simply because it's now easy to retrieve from memory

### Pragmatic inferences associated with overspecification

- contrastive inference (presence of extra modifiers suggests contrast, ie gives additional information about *background*, via reasoning about why the speaker went to the trouble fo producing extra modifiers when they wouldn't otherwise be necessary; but we want to retain assumption of speaker cooperativity, so they must be necessary for disambiguation, so there must be a contrasting object present) --> ** but then what does this mean for all the cases that are truly overinformative?**

### Cognitive reasons for overspecification

- overspecification may result from incomplete consideration of common ground **how is this different from the speaker-oriented reasons above?**

- visual processing and optimal linguistic encoding may compromise each other through sharing of cognitive resources

### Laundry list of overspecification results

- lower overspecification rates in simpler visual arrays (Davies & Katsos, 2009, 2013)

- more overspecification as number of distractors increases (Pechmann 1989, Koolen et al 2011)

- color vs size: people overspecify color 21% of the time (Pechmann 1989)

- 50% overspecification of size adjectives with a privileged contrast (Nadig & Sedivy 2002)

- 33% location overspecification in "put the apple on the towel on the other towel" type sentences in one-referent contexts (Engelhardt et al 2006)

- "type and colour omnipresent" (Pechmann and others) -- conclusion: these help create a perceptual gestalt **there are syntactic reasons to mention the type because they're usually nouns -- what about languages where they're not nouns? what about other languages more generally?**

- more overspecification when talking to a real speaker (van der Wege 2009)

- Mitchell, Reiter, and Van Deemter (2013) investigate effects of atypicality and show that speakers prefer to mention the shape or material of objects when it is atypical (e.g., "octagonal mug", "wooden key") --> but they didn't look for a gradient effect, only binary typical/atypical

### Laundry list of potentially relevant results from vision (taken mostly from Westerbeek et al 2014)

- For objects that have one or more typical colors associated with them (i.e., color-diagnostic objects, for example tomatoes which are typically red), this knowledge contains color information (e.g., Tanaka, Weiskopf, & Williams, 2001).

- Recognition is slower when (color-diagnostic) objects are presented in atypical colors than when they are typically colored (e.g., Naor-Raz, Tarr, & Kersten, 2003; Tanaka et al., 2001; Therriault, Yaxley, & Zwaan, 2009).

- Furthermore, the contribution of color in object recognition is stronger for objects with a simple and unchar- acteristic shape (e.g., oranges) than for objects with more complex shapes (e.g., fire trucks; Price & Humphreys, 1989).

- objects that have a color different from stored object knowledge are known to attract visual attention. Becker, Pashler, and Lubin (2007) eye-tracked participants who were presented with naturalistic scenes containing an object in an atypical color (a green hand), or in a typical color (a flesh-colored hand). Participants fixated earlier, more often, and longer on the green hand than on the normal hand. This result could not be ascribed to green being more salient than flesh-color, which Becker et al. controlled for by swapping the hand's color with a mug (which is equally typical in green or flesh- color).

## Are we Bayesian referring expression generators? (Gatt et al, 2013)

- pose a challenge for RSA (Frank & Goodman 2012 style): people overspecify, so RSA is never going to make the right predictions for situations in which you don't artificially restrict the alternatives.  

- various REG algorithms:
	- **Full Brevity Algorithm** (Dale 1989): search expressions in order of length until distinguishing one is found. Problem: intractable in the worst case.
	- **Greedy Algorithm** (Dale 1989): incremental adding of a single property at a time, at each stage considering which one excludes the greatest number of distractor items
	- **Incremental Algorithm** (Dale & Reiter 1995): start to de-emphasize discriminatory power, start to emphasize preference/salience. Properties arranged in fixed linear order determined by degree of prefernce; go through list and include property if at least one distractor is excluded
	- **RSA** (Frank & Goodman 2012): basically the Greedy Algorithm with stochasticity; can't get all the preference-based results --> **Judith, make sure you get a good overview of what the preference-based results are!! eg they claim that "overspecification may actually be detrimental to listeners", citing Engelhardt et al -- read this! --, but it's not clear that it always is; find the counter-refs; this is important because it affects how strongly you can sell the `people aren't rational' line**
	- **PRO** (van Gompel et al 2012): motivated by the color-over-size-preference lightbulb experiment; combines discriminatory power & preference, as well as stochasticity; 2 parameters: preference for color, eagernes to overspecify


## General points/questions

Has anyone compiled a list of overspecification rates for different modifiers (color, size, location, age, orientation, etc)?

General focus on definite descriptions: definite determiner, head noun, one or more (pre- or post-nominal) modifiers. What happens if we move away from that?

Adjectives have typical ordering preferences (Pechmann 1989 and references therein): eg in English size before color, but violations are OK when there's contrastive stress on the color adjective or when color is particularly salient. Different languages, different preferences, which might give some insight into incrementality vs other explanations by looking at how people operate within the bounds of grammer (or are willing to violate rules). Tom Wasow mentioned Richard Futtrell's undergrad thesis on German vs English, where the finding is that there's a lot less overspecification in German, which has grammatical gender, than in English. Explanation: prenominal overspecification (eg "cute small puppy") serves as probabilistic cue to referent, just as grammatical gender is in German.


Koolen et al 2011 (like so many others) frames the issue as one of how to decide which attributes to include in a target description, rather than talking about which words to use, even though one property can be referred to in many different ways ("red", "reddish", "bright", "colored"). Does anyone look at the way that the number of an object's features (if we even want to commit to such a number existing...) interacts with the number of utterance alternatives for referring to that feature (if we want to commit to such a number existing...)?

So we know that people like to overspecify color but not size/shape. What if there's a contextual QUD that really favors information about size/shape but doesn't care about color? Is there any research on this?

Gatt et al's notion of 'utility'. There's not sth inherently evil to utility; in fact, you can build preferences into the utility function. All you can say is that the utility function is not yet complex enough to capture people's actual preferences yet.

Can we get preferences with costs of *utterances* alone? Or with prior salience of *properties*? Generally, those guys collapse utterance and property concept. This doesn't seem right, because you could in preinciple use different utterances to refer to the same property, so there must be at least two separate things going on that in these simple cases maybe collapse into one.

There's something unsatisfying about just saying there are preferences. **Where do the preferences come from?** And can you shift the preferences around contextually, either with the QUD or with visual properties of the scene (eg by making the differences in color much smaller and the differences in size much larger)? That seems to me to be the more interesting thing. 

**Here's an interesting issue:**

- on the one hand, people generate inferences from modificational material in order to avoid thinking the speaker overspecifies (contrastive inferences used in a lot of Tanenhaus offspring work, eg Sedivy, Heller), especially with size adjectives

- on the other hand, there doesn't seem to be a cost to "actual" overspecification (in general....)

- Can we think about this from a noisy channel perspective? In essence, "actual" overspecification is redundant signal. Consider two different scenarios.
		
	1. We know that either for the speaker or for us, it's plausibly hard to produce/interpret the referential expression right (ie when there's either difficulty, incrementality-related; or there's eg a complex visual scene or maybe other objects that I might misinterprets as being reasonable referents for the expression produced).
		
		--> in this case, we should be happy with redundant signal, because we know the signal serves no "meaning" purpose but just helps us buy time/ensure communicative success in one way or another. This predicts that in this case we shouldn't get any inference (or cognitive cost if inference not warranted) from overspecification.
		
	2. We know that there's an easy way to refer to things; properties that one would mention are very salient in common ground, the space of alternatives is small.
		
		--> in this case, extra signal would be surprising and we should try to draw inferences from it, and if there are no plausible inferences, we should be confused.
		
==> This is basically like the way Flo and I (and Roger and his student Mark Myslin) have been thinking about things: extra signal can be produced either because it helps with processing, or because you want to convey some meaning. Ie plausibility of processing difficulty as explaining away redundancy.

**What findings does this go well with?**

- Julie Sedivy's 2003 findings: 

	1. In production, people tend to be more over-informative in terms of producing a color term when the color is less predictable from the category denoted by the noun than if it is more predictable. So, people say "yellow cup" a lot even when there is only one cup, but they don't say "yellow banana" when there is only one banana.

	2. In comprehension, color modifiers lead to contrastive inferences when the color is predictable, but not when it's not. Ie there's early convergence on the yellow banana but not on the yellow cup.

- more overspecification when talking to a real speaker (van der Wege 2009)

- lower overspecification rates in simpler visual arrays (Davies & Katsos, 2009, 2013)

- more overspecification as number of distractors increases (Pechmann 1989, Koolen et al 2011)

- Does it fit in with Engelhardt et al 2006 findings? 
Their design: 4 sentence types*2 referent confexts (either one or two referents): 
(1) Put the apple on the towel.
(2) Put the apple in the box.
(3) Put the apple on the towel on the other towel.
(4) Put the apple on the towel in the box.

	1. Production -- yes: People produce modifier in two-referent conditions all the time (good), but even in one-referent conditions 1/3 of the time (and more for towel than box, but this is probably because of the non-uniqueness of "towel")

	2. Listener ratings of utterances in different contexts -- neutral: modifier better than no-modifier in two-referent condition, but maybe slightly worse in one-referent condition, but barely

	3. Eye-tracking in only one-referent contexts -- these results are pretty opaque: they're a little slower to look to the target location with the modifier than without -- it would have been interesting to see the breakup by modifier, seeing as how they preferred the modifier when both origin and target location were the same (eg both towels). Our prediction in this case: cost goes away.

## TODO

### Noah's email comments

- is degree of OS goal relative?

- expt comparing naming-to-select expriment (scene in cg) to naming-to-describe (scene not in cg)?

- is this all about colors?

- stability as a determining factor in referential exp selection? arrangement is not reliable…

- and what about the impact of free vars (e.g. for size)?

- QUD?

- corpus-based costs?

- noise in channel or interpretation (stability) means that ‘unnecessary’ modifiers can be probabilistically useful.

  - but cf sedivy “yellow banana” wrt channel noise.

- see futrell thesis on pronominal adjs vs gender.

- “explaining away” manipulations of “noise”.. leads to differentially interpreting the over specified expressions?

- interaction with the “frame”: full expression with predicate. implicates quite different goals, etc.

- RSA:

  - cost, interpretation stability, perceptual stability, lexical class.
	
  - baseline: RSA + corpus determined costs? then add correlation of properties? then add lexical class?


