f = open("../raw/results.txt")
lines = [l.rstrip().split(",,,") for l in f.readlines()]
f.close()

outfile = open("../parsed/results.txt","w")

outfile.write(lines[0][0].split(",,")[0]+"\n")

for l in lines:
	for case in l:
		try:
			splited = case.split(",,")
			splagain = splited[1].split(",")
			if splagain[0] == "object":
				outfile.write(splited[2]+"\n")
			else:
				outfile.write(splited[1]+"\n")
		except IndexError:
			continue


