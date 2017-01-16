## Model versions

1. overinf_baseline.wppl
	- adding up typicalities --> compositional
	- typicalities either 0 or -Infinity
2. overinf\_qualitative\_bananatypicality_theta.wppl
	- adding up typicalities --> compositional
	- typicalities originally are between 0 and 1, but in this version params.theta - typicality
	- idea of introducing theta: be able to make a worse fit by adding a word (blue banana is a worse fit for a yellow banana than just banana)
3. overinf_noisycontext.wppl
	- adding up typicalities --> compositional
	- typicalities are between 0 and 1 - with or without theta?
	- ghost objects are drawn uniformly from whole set
	- similarity measure evaluating possible context in comparison to true context
	- similarity between 0 and 1
4. overinf\_noisycontext_extended.wppl
	- like noisycontext but the similarity measure is not just binary, but evaluates color similarity if type is identical
	- color similarity values still just made-up and not empirical
