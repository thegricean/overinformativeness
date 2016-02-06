# Over `overinformativeness': rational redundant referring expressions

### Intro

Referring is one of the most basic and prevalent uses of language, so we're probably pretty good at it. What does `being good at it' mean? Generally, trying to abide by Gricean maxims, including: be as informative as possible but not more informative than necessary. For the past 40 years, researchers have been noticing that speakers don't seem to abide by the second part of that in their production of referring expressions: they often include modifiers that aren't necessary for uniquely determining reference. Similarly, they often choose to refer to an object at a level of abstraction that is more specific than necessary for determining unique reference. 
 
This has posed a challenge for rational accounts of language use (including the Gricean one): what accounts for these deviations from what the simple Gricean picture predicts? Why this extra expenditure of useless effort? Why this seeming blindness to the level of informativeness requirement? Is it just that speakers aren't economical after all? Or is there some utility in being redundant and overly specific? **This paragraph will introduce informativeness, cost, typicality**

Here, we show that introducing noisy truth functions into the semantics of referring expressions can account both for the systematic patterns of overinformativeness in modified referring expressions as well as for speakers' preference to refer at the basic level (and deviations from that preference in certain cases).

#### Review of phenomena to capture in modified REs

1. Color-size asymmetry (Pechmann, Sedivy, Engelhardt, Gatt)

2. Scene variation (Koolen, Katsos & Davies)

3. Typicality effects (Westerbeek, Sedivy, Mitchell)

#### Review of phenomena to capture in nominal REs

1. Basic level preference (Rosch)

2. Rich interactions between informativeness, cost (length/frequency), typicality


### Modeling REs -- failures of basic RSA followed by the one trick to rule them all

1. Basic RSA framework (without cost) and 

	- why it can't capture overmodified REs 
	
	- why it can't capture basic level prefs (*introduce experiment here?*)
	
2. RSA with cost

	- why it still can't capture overmodified REs
	
	- how it starts capturing basic level prefs	

3. RSA with noisy truth functions
	
	- intuition for noisy truth functions (in terms of typicality? average global success probability of using a particular utterance?)

### Modeling REs -- how noisy truth functions solve all our problems

1. noise parameters for color and size captures color-size asymmetry (eg as documented by Gatt)

	- replication of Gatt study but with overall lower overmodification rates
	
	- BDA, get posteriors over color and size fidelity & cost

2. noise parameters for color and size capture scene variation effects (eg as documented by Koolen)

	- novel scene variation study based on Gatt replication
	
	- BDA --> would be cool of posteriors over color and size fidelity come out similar as in 1.
	
3. noise parameters for each color-noun combination captures color typicality effects (eg as documented by Westerbeek)

	- open problem: compositionality

4. how to get typicality effects compositionally
		
5. adding noise values (typicality norms) to nominal RE model improves model fit: especially where the super level term would be otherwise preferred both on informativeness and cost grounds, the basic level gets an extra boost *(because less confusable? we need to get more data. i still don't fully understand all this)* 
 
