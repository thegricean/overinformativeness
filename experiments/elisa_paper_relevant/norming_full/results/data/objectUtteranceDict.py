import csv

def transformString(utt):
	pos = 0
	noun = ""
	adj = ""

	for letter in utt:
		if letter != "_":
			pos += 1
		else:
			break

	for index in range(pos):
		adj += utt[index]

	for index in range(pos+1,len(utt)):
		noun += utt[index]

	return adj + " " + noun


with open('rerun_less15.csv', 'rb') as csvfile:
	uttObjDict = csv.reader(csvfile, delimiter=',', quotechar='|')
	for row in uttObjDict:
		print "{"
		print "\"label\"" + ": " + "\"" + row[1] + "\"" + ","
		print "\"item\"" + ": " + "[\"" + transformString(row[0]) + "\"]" + ","
		print "},"


# {
# "label": "avocado_red",
# "item": ["black avocado", "green avocado", "red avocado"]
# },