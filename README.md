# Overinformativeness

## Interesting phenomena to replicate/model

| Paper			| Language		| Result| ToDo | Progress |
| --------------|:-------------:| ----- | ---- | -------- |
| Pechmann 1989; Belke & Meyer 2002; Engelhardt et al 2006, Gatt et al 2011, many others | English, Dutch | **Speakers** overspecify color more than size. Gatt, when size sufficient: 78.6%d/80.2%e (cs), 21.1%d/16.5%e (s), 0.3%d/3.3%e (c). Gatt, when color sufficient: 10.2%d/8.1%e (cs), 0.3%d/0%e (s), 89.5%d/91.9%e (c) | replicate empirically? | got this! see model overinformativeness.church,  which derives overmodification preferences not from sth special about color/size costs, but from differential noise in color and size dimension |
|  | Dutch | **Speakers** overspecify more as number of distractors increases | replicate, model |
| Davies & Katsos 2009, 2013; Koolen et al, 2013 Cognitive Science | English | **Speakers** overspecify less in simpler visual arrays | figure out what is meant by "simplicity" here and model? |
| Sedivy 2003	| English		| **Speakers** use color more over-informatively when the color is less predictable from the noun category. So, people say "yellow cup" a lot even when there is only one cup, but they don't say "yellow banana" when there is only one banana. |  Replicate in Robert's interactive paradigm |
| Westerbeek et al 2014 | Dutch | The probability that **speakers** redundantly include color in their descriptions is almost linearly predicted by the degree of color atypicality. Smaller effect: color mentioned more for objects with simple (ie not very informative as to type) shapes, eg oranges vs fire trucks. | replicate as part of Sedivy 2003 replication |
| Sedivy 2003	| English		| **Listeners** draw more/faster contrastive inferences from color modifiers when the color is predictable. Ie there's early convergence on the yellow banana but not on the yellow cup.| Clever way to replicate that doesn't require eye-tracking?|
| Koolen et al 2013 | Dutch | **Speakers** overspecify color less (at ~5%) when all objects are of the same (very similar) color than when there is a lot of color variation (~25%) | |
| Gatt et al 2013 | Dutch | **Weird datapoint**: No difference in overspecification rates for size, color, pattern| |

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

## Ajective ordering restrictions/preferences 

### Sproat & Shih 1991

- generally: 
	1. SIZE > COLOR > PROVENANCE
	2. QUALITY > SHAPE
	3. SIZE > SHAPE
	4. POSSESSIVE > SPEAKER-ORIENTED > SUBJECT-ORIENTED > MANNER/THEMATIC (Cinque 1994)
	5. VALUE > DIMENSION > PHYSICAL PROPERTY > SPEED > HUMAN PROPENSITY > AGE > COLOR (Dixon, 1982)
	
- Mandarin allows both SIZE COLOR and COLOR SIZE, but only if both modifiers are "-de"-marked, otherwise only SIZE COLOR

- propose two types of modification: 
	1. direct (subtypes: hierarchical & parallel) 
	2. indirect (via coindexation), based on manner of theta-role assignment (this bit is a little dubious)

- according to them, indirect modification plays out in Mandarin as relative clauses, in Arabic as adjunction 

- their primary claim: "Restrictions on the ordering of multiple adjectival modifiers --- henceforth AOR --- obtain iff the adjectives involved are hierarchical direct modifiers."

- what matters: linear ordering or head proximity? they say head proximity.

- semantic factors: absoluteness as major determinant of ordering pref (color, shape as examples --> but: these too need not be absolute; is there already evidence out there or can we show this?)

- missing piece of the puzzle for them: why should AOR be confined to cases of direct hierarchical modification cross-linguistically?

- Claim: violation of preferences needs special comma intonation, then can be interpreted as parallel (ie independent modification of head noun).
	(1a) She loves all those Oriental, orange, wonderful ivories.
	(1b) *She loves all those Oriental orange wonderful ivories.	
	(2a) She loves all those wonderful, orange, Oriental, ivories.
	(2b) She loves all those wonderful orange Oriental ivories.

- they dismiss the possibility that determiners are modifiers, but it's not clear that one should!! eg German. And that the possessives and other non-canonical definite determiners in the partitive "some" database follow the modified rather than the unmodified head pattern

- Cross-linguistic generalizations:
	1. Direct modification & associated cluster of properties (ie AOR following universal pattern): Dutch, Greek, Kannada, Mokilese (in Mokilese, pattern in reverse because it has only post-nominal modification)
	2. Indirect modification & associated cluster of properties (ie no AOR): Japanese, Thai, Arabic
	3. Parallel modiifcation: French -- no AOR postnominally, but only few adjectives allowed to occur pre-nominally
	
- in English: reordering adjectives that differ in absoluteness is a lot worse than reordering adjectives that don't differ in absoluteness

### Wulff 2003

- In a sequence of adjectives, those denoting non-inherent qualities precede inherent adjectives (cf. Whorf 1945; Biber et al. 1999:599)

- Adjectives which are less dependent on comparison are put nearer to the head noun (cf. Martin 1969b; Posner 1986)

- Quirk et al. (1985: 1341) argue for a subjective-objective gradience determining AO such that “modifiers relating to properties which are (relatively) inherent in the head of the noun phrase . . . will tend to be placed nearer to the head and be preceded by modifiers concerned with what is relatively a matter of opinion.” --> see also Hetzron’s (1978) subjectivity-objectivity gradience and hypothesized order of adjectives, 13 classes

- semantically congruent adjectives ("poor wretched child" vs "poor happy child") have (i) significantly more stable ordering preferences in attributive as well as predicative contexts, (ii) significantly subjectively stronger prenominal ordering preferences, and (iii) are judged significantly more acceptable (cf. Richards 1977:494–499). With semantically incongruent adjectives, the factor of affective loading comes into play: Richards argues the ordering of incongruent adjectives is governed by a ‘first the good news, then the bad news’ principle

- Lockhart and Martin (1969) were able to demonstrate that those adjectives that tend to stand closest to a noun are the ones which are remembered most easily upon the occurrence of the noun. --> semantic association! "Local proximity to the head noun indicates greater noun-specific frequency." (Posner 1986)

- Finally, the general frequency of the adjective has been claimed to influence its position in a string (cf., e.g., Bock 1982) such that more frequent adjectives precede less frequent ones.

### Futrell 2010

- goal: push an information-theoretic account of the function-form relationship in German noun class (gender)

- usefulness of gender: it gives you an early cue to noun form, semantics, and NP referent (if applicable); that is, it reduces the noun's entropy along multiple dimensions

- But how does that relate to our finding that things typically get less noisy as you approach the noun?

- Reflexes of efficient noun class system in German:
	
	- frequently co-occurring (and thus a priori more confusable) nouns are more likely than chance to be in different genders
	
	

## Preliminary results

### Modeling

#### Threshold semantics models

**Note: this is now outdated, but might be re-integrated at some later point.**

Played around with different shapes of priors and utterance costs and values to communicate. For all combinations (3675, see overinformativeness.md) ran model and created some visualizations of the most interesting effects.

**Assumptions**

- four utterances: silence, color, size, color-and-size. The semantics of color and size is: 'true' if actual color/size above some threshold (to be inferred). The semantics of color-and-size is the conjunction of the individual meanings. Semantics of silence is 'true'.

- utterance costs:
	
	- uniform: same cost for each utterance
		
	- prefer-fewer-words: silence 10 times as likely as color/size, which in turn are ten times as likely as color-and-size
		
	- prefer-fewer-words-and-color: silence 2.5 times as likely as color, which is 4 times as likely as size, which is ten times as likely as color-and-size
		
- both size and color are expressed on the same discretized scale with 5 values

- each object to be communicated has two values, one for color and one for size (gives 25 potential objects)

- there are seven possible priors on each dimension (color, size), giving 49 different combinations of priors: flat, super-left-peak, left-peak, mid-peak, super-mid-peak, right-peak, super-right-peak

- The model is an S2 speaker that chooses an utterance from among the above 4, given an object (ie two values from the scale) and knowledge about that object type's color and size prior. The speaker reasons (mh-query) about a pragmatic L1 listener who infers the object's color and size. The pragmatic listener reasons (enumeration-query) about what an S1 speaker would have said who knows about the object's color and size value, the object types' color and size priors, and the thresholds for using 'color' and 'size'. The S1 tries to be informative (enumeration-query) to a literal listener who knows the thresholds, object type priors, and utterance and infers (enumeration-query) object values. 

**Speaker results** --- utterance probabilities for objects that match in size and color value as well as in object type size and color prior.

- Most basic result: as object value increases, silence becomes less likely -- this is just in the nature of the threshold semantics. 

- What is said instead of silence dpends on both costs and priors.
	
	- when costs are uniform, color-and-size is almost always the preferred alternative -- this is of course heavily dependent on the fact that we're looking here only at objects that are identical in value on both dimensions
	
	- when there's a penalty for each added word, color-and-size is only really good for communicating high-value objects when the priors are very left-peaked, otherwise color-and-size is never used. Color and size individually are sometimes used, but mostly the word penalty gives silence a huge boost. 
	
	- when there's a penalty for added words, but less for color than for size, color-and-size is used even less (and again only for communicating high-value objects with very left peaked priors). Silence is now a somewhat less viable option than when every word counts. Color is increasingly used to communicate high value objects, especially when the prior is left or mid peaked. 
 

![Plot of speaker probabilities for matched variance priors and object values](/church_playground/threshold_models/firsttry/graphs/matched_variance.jpg "Matched variances and object values")

#### Boolean property models

Get rid of the threshold semantics and instead model features like size and color as binary things. Eg assume four utterances: "blue", "yellow", "big", "small", and combinations thereof. The semantics of each is just true if property holds, false otherwise. Create contexts as worlds consisting of different numbers of objects with different properties.  (Make blue/yellow and big/small mutually exclusive.) Then do just standard RSA with varying costs (uniform, penalty for each additional word, penalty for each additional word unless that word is color, smaller penalty for adding color). Vary priors on features.

Get to the point where you can look at the effect of the following factors on overspecification
- increasing number of objects in world
- increasing color variance in world
- predictability of color from word

### Experiments

Wait for the modeling results, then start replicating exps in table above and figure out potentially new exps if model makes interesting new predictions.


