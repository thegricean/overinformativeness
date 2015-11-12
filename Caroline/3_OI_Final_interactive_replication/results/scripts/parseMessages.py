import os, csv

#for p in os.listdir(pdir)
csv_messagenames = ["../../data/message/2015-101-12-13-28-16-803_3341-596ae6ba-1c69-4024-bba8-d6299c490dcd.csv"] 

csv_trialnames = ["../../data/clickObj/2015-101-12-13-28-16-803_3341-596ae6ba-1c69-4024-bba8-d6299c490dcd.csv"]

messagelines = []
triallines = []

messagereaders = [csv.DictReader(open(fn, 'rb'),delimiter=",",quotechar='\"') for fn in csv_messagenames]

for r in messagereaders:
	messagelines.extend(list(r))

trialreaders = [csv.DictReader(open(fn, 'rb'),delimiter=",",quotechar='\"') for fn in csv_trialnames]

for r in trialreaders:
	triallines.extend(list(r))
	headers = r.fieldnames		


def getMessages(trial, messages):
	speakermessages = []
	listenermessages = []
	times = []
	
	for m in messages:
		if m['roundNum'] == str(trial):
			if m['sender'] == 'speaker':
				speakermessages.append(m['contents'])
			else:
				listenermessages.append(m['contents'])
			times.append(m['time'])
			
	mess = {'nummessages': len(speakermessages) + len(listenermessages),
			'numsmessages': len(speakermessages),
			'numlmessages': len(listenermessages),			 
			'listenermessages': listenermessages,
			'speakermessages': speakermessages,
			'times': times}		
			
	return mess


for trial in range(1,len(triallines)+1):
	mess = getMessages(trial,messagelines)
	i = trial - 1
	print triallines[i].keys()	
	triallines[i]['numMessages'] = mess['nummessages']
	triallines[i]['numSMessages'] = mess['numsmessages']	
	triallines[i]['numLMessages'] = mess['numlmessages']		
	triallines[i]['speakerMessages'] = "___".join(mess['speakermessages'])
	triallines[i]['listenerMessages'] = "___".join(mess['listenermessages'])
	triallines[i]['messageTimeStamps'] = "___".join(mess['times'])
	triallines[i]['refExp']	= mess['speakermessages'][0]
	if triallines[i][' condition'] != "filler":
		size,color,typ = triallines[i][' nameClickedObj'].split("_")
	else:
		size = "NA"
		color = "NA"
		typ = triallines[i][' nameClickedObj']
	triallines[i]['clickedSize'] = size
	triallines[i]['clickedColor'] = color
	triallines[i]['clickedType'] = typ
	refexp = [m.lower() for m in mess['speakermessages'][0].split()]
	sizementioned = False
	colormentioned = False	
	typementioned = False	
	if size in refexp:
		sizementioned = True
	if color in refexp:
		colormentioned = True
	if typ in refexp:
		typementioned = True
	triallines[i]['sizeMentioned'] = sizementioned
	triallines[i]['colorMentioned'] = colormentioned	
	triallines[i]['typeMentioned'] = typementioned	
		
	

headers.append('numMessages')
headers.append('numSMessages')	
headers.append('numLMessages')
headers.append('speakerMessages')
headers.append('listenerMessages')
headers.append('messageTimeStamps')
headers.append('refExp')
headers.append('sizeMentioned')
headers.append('colorMentioned')
headers.append('typeMentioned')
headers.append('clickedType')
headers.append('clickedSize')
headers.append('clickedColor')



print headers

print triallines[0].keys()

w = csv.DictWriter(open("../data/results.csv", "wb"),fieldnames=headers,restval="NA",delimiter="\t")
w.writeheader()
w.writerows(triallines)
			