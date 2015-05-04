f = open("prior_results.txt","rb")
lines = [l.rstrip() for l in f.readlines()]
f.close()

headers = ["ColorPrior","SizePrior","ColorValue","SizeValue","Costs","ProbColor","ProbSize","ProbColorSize","ProbSilence"]

cnt = 0

results = []

for l in lines:
	splited = l.split(",,,")
	for s in splited:
		sp = s.split(",")
		if len(sp) < 5:
			continue
		else:
			if len(sp) == 107:
				sp = sp[2:]
			elif len(sp) == 106:
				sp = sp[1:]
		colorprior, sizeprior, colorvalue, sizevalue, costy = sp[:5]
		samples = sp[5:]
		results.append([colorprior, sizeprior, str(colorvalue), str(sizevalue), costy,str(samples.count("adj-color")/100.0),str(samples.count("adj-size")/100.0),str(samples.count("adj-size-color")/100.0),str(samples.count("no-utt")/100.0)])
#		print sp
#		print colorprior
#		print sizeprior
#		print colorvalue
#		print sizevalue
#		print costy
#		print "\n"

outfile = open("modelresults.txt","wb")
outfile.write("\t".join(headers)+"\n")
outfile.write("\n".join(["\t".join(r) for r in results]))
outfile.close()