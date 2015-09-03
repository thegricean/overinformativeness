f = open("../raw/results.txt")
lines = [l.rstrip().split(",,,") for l in f.readlines()]
f.close()

outfile = open("../parsed/results.txt","w")

allutterances = {"big":0,"red":0,"small":0,"yellow":0,"big_red":0,"small_red":0,"big_yellow":0,"small_yellow":0}

headers = lines[0][0].split(",,")[0].split(",")[0:7] + allutterances.keys()

outfile.write(",".join(headers)+"\n")

for l in lines:
	for case in l:
		utts = {"big":0,"red":0,"small":0,"yellow":0,"big_red":0,"small_red":0,"big_yellow":0,"small_yellow":0}
		try:
			splited = case.split(",,")
			splagain = splited[1].split(",")
			if splagain[0] == "object":
				results = splited[2].split(",")
				caseutts = splagain[7:]
				for i,k in enumerate(caseutts):
					utts[k] = results[7+i]
				outfile.write(",".join(results[:7]+[str(utts[u]) for u in utts.keys()])+"\n")
			else:
				results = splited[1].split(",")
				caseutts = splited[0].split(",")[7:]
				for i,k in enumerate(caseutts):
					utts[k] = results[7+i]
				outfile.write(",".join(results[:7]+[str(utts[u]) for u in utts.keys()])+"\n")
		except IndexError:
			continue


