f = open("../raw/results.txt")
lines = [[[lin.split(",,,") for lin in li.split(",,,,")] for li in l.rstrip().split(",,,,,")] for l in f.readlines()]
f.close()

outfile = open("../parsed/results.txt","w")

allutterances = {"tomato":0,"red_tomato":0,"red":0,"apple":0,"yellow_apple":0,"yellow":0,"pepper":0,"blue_pepper":0,"blue":0}

headers = lines[0][0][0][0].split(",,")[0].split(",")[0:5] + allutterances.keys()
print len(headers)

outfile.write(",".join(headers)+"\n")

for lin in lines:
	for li in lin:
		for l in li:
			for case in l:
				utts = {"tomato":0,"red_tomato":0,"red":0,"apple":0,"yellow_apple":0,"yellow":0,"pepper":0,"blue_pepper":0,"blue":0}
#				try:
				splited = case.split(",,")
	#			print len(splited)
	#			if len(splited) > 2:
	#				print splited			
				if splited[0] == "":
	#				print splited
					hpos = 1
					rpos = 2
				else:
					hpos = 0
					rpos = 1			
				if len(splited) != 1:
					results = splited[rpos].split(",")
					splagain = splited[hpos].split(",")
					caseutts = splagain[5:]
					for i,k in enumerate(caseutts):
						utts[k] = results[6+i]
					if len(results) < 8:
						if len(caseutts[0].split("_")) == 2:
							utts[results[0]] = 0
						else:
							print "implement what to do if only minimal utterance gets mass"
		#				print results
		#			print results
		#			print caseutts
		#			if results[0] in ["red","blue","yellow"]:
					outfile.write(",".join(["_".join(results[:2])]+results[2:6]+[str(utts[u]) for u in utts.keys()])+"\n")
				else:
					print splited


