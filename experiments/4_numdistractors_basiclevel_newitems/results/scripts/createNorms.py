# this script generates code for the norming.js file so you don't have to code all items by hand

f = open("../data/norms.txt")
lines = [l.rstrip().split() for l in f.readlines()[1:]]
f.close()

targets  = []
dists = []
distss = []

for l in lines:
	if l[2] == "target":
		targets.append(l)
	elif l[2] == "dist_super":
		dists.append(l)
	elif l[2] == "dist_samesuper":		
		distss.append(l)
	else:
		print "unknown item type"

outfile = open("../data/helpercode.txt","w")

for t in targets:
	outfile.write("{\n")
	outfile.write("\"item\": \""+t[0]+"\",\n")
	outfile.write("\"label\": \""+t[1]+"\",\n")
	outfile.write("\"itemtype\": \""+t[2]+"\",\n")
	outfile.write("\"labeltype\": \""+t[3]+"\"\n")
	outfile.write("},\n")

for t in dists:
	outfile.write("{\n")
	outfile.write("\"item\": \""+t[0]+"\",\n")
	outfile.write("\"label\": \""+t[1]+"\",\n")
	outfile.write("\"itemtype\": \""+t[2]+"\",\n")
	outfile.write("\"labeltype\": \""+t[3]+"\"\n")
	outfile.write("},\n")

for t in distss:
	outfile.write("{\n")
	outfile.write("\"item\": \""+t[0]+"\",\n")
	outfile.write("\"label\": \""+t[1]+"\",\n")
	outfile.write("\"itemtype\": \""+t[2]+"\",\n")
	outfile.write("\"labeltype\": \""+t[3]+"\"\n")
	outfile.write("},\n")


outfile.close()
