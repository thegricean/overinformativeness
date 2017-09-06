f = open("../raw/results.txt")
lines = [l.rstrip().split(",,,") for l in f.readlines()]
f.close()

outfile = open("../parsed/results_one.txt","w")

allutterances = {"fan":0,"tv":0,"desk":0,"couch":0,"chair":0,"big_fan":0,"small_fan":0,"green_fan":0,"blue_fan":0,"gray_fan":0,"red_fan":0,"brown_fan":0,"big_green_fan":0,"small_green_fan":0,"big_blue_fan":0,"small_blue_fan":0,"big_gray_fan":0,"small_gray_fan":0,"big_red_fan":0,"small_red_fan":0,"big_brown_fan":0,"small_brown_fan":0,"big_tv":0,"small_tv":0,"green_tv":0,"blue_tv":0,"gray_tv":0,"red_tv":0,"brown_tv":0,"big_green_tv":0,"small_green_tv":0,"big_blue_tv":0,"small_blue_tv":0,"big_gray_tv":0,"small_gray_tv":0,"big_red_tv":0,"small_red_tv":0,"big_brown_tv":0,"small_brown_tv":0,"big_desk":0,"small_desk":0,"green_desk":0,"blue_desk":0,"gray_desk":0,"red_desk":0,"brown_desk":0,"big_green_desk":0,"small_green_desk":0,"big_blue_desk":0,"small_blue_desk":0,"big_gray_desk":0,"small_gray_desk":0,"big_red_desk":0,"small_red_desk":0,"big_brown_desk":0,"small_brown_desk":0,"big_couch":0,"small_couch":0,"green_couch":0,"blue_couch":0,"gray_couch":0,"red_couch":0,"brown_couch":0,"big_green_couch":0,"small_green_couch":0,"big_blue_couch":0,"small_blue_couch":0,"big_gray_couch":0,"small_gray_couch":0,"big_red_couch":0,"small_red_couch":0,"big_brown_couch":0,"small_brown_couch":0,"big_chair":0,"small_chair":0,"green_chair":0,"blue_chair":0,"gray_chair":0,"red_chair":0,"brown_chair":0,"big_green_chair":0,"small_green_chair":0,"big_blue_chair":0,"small_blue_chair":0,"big_gray_chair":0,"small_gray_chair":0,"big_red_chair":0,"small_red_chair":0,"big_brown_chair":0,"small_brown_chair":0,"big_one":0,"small_one":0,"green_one":0,"blue_one":0,"gray_one":0,"red_one":0,"brown_one":0,"big_green_one":0,"small_green_one":0,"big_blue_one":0,"small_blue_one":0,"big_gray_one":0,"small_gray_one":0,"big_red_one":0,"small_red_one":0,"big_brown_one":0,"small_brown_one":0}

headers = lines[0][0].split(",,")[0].split(",")[0:10] + allutterances.keys()
print len(headers)

outfile.write(",".join(headers)+"\n")

for l in lines:
	for case in l:
		utts = {"fan":0,"tv":0,"desk":0,"couch":0,"chair":0,"big_fan":0,"small_fan":0,"green_fan":0,"blue_fan":0,"gray_fan":0,"red_fan":0,"brown_fan":0,"big_green_fan":0,"small_green_fan":0,"big_blue_fan":0,"small_blue_fan":0,"big_gray_fan":0,"small_gray_fan":0,"big_red_fan":0,"small_red_fan":0,"big_brown_fan":0,"small_brown_fan":0,"big_tv":0,"small_tv":0,"green_tv":0,"blue_tv":0,"gray_tv":0,"red_tv":0,"brown_tv":0,"big_green_tv":0,"small_green_tv":0,"big_blue_tv":0,"small_blue_tv":0,"big_gray_tv":0,"small_gray_tv":0,"big_red_tv":0,"small_red_tv":0,"big_brown_tv":0,"small_brown_tv":0,"big_desk":0,"small_desk":0,"green_desk":0,"blue_desk":0,"gray_desk":0,"red_desk":0,"brown_desk":0,"big_green_desk":0,"small_green_desk":0,"big_blue_desk":0,"small_blue_desk":0,"big_gray_desk":0,"small_gray_desk":0,"big_red_desk":0,"small_red_desk":0,"big_brown_desk":0,"small_brown_desk":0,"big_couch":0,"small_couch":0,"green_couch":0,"blue_couch":0,"gray_couch":0,"red_couch":0,"brown_couch":0,"big_green_couch":0,"small_green_couch":0,"big_blue_couch":0,"small_blue_couch":0,"big_gray_couch":0,"small_gray_couch":0,"big_red_couch":0,"small_red_couch":0,"big_brown_couch":0,"small_brown_couch":0,"big_chair":0,"small_chair":0,"green_chair":0,"blue_chair":0,"gray_chair":0,"red_chair":0,"brown_chair":0,"big_green_chair":0,"small_green_chair":0,"big_blue_chair":0,"small_blue_chair":0,"big_gray_chair":0,"small_gray_chair":0,"big_red_chair":0,"small_red_chair":0,"big_brown_chair":0,"small_brown_chair":0,"big_one":0,"small_one":0,"green_one":0,"blue_one":0,"gray_one":0,"red_one":0,"brown_one":0,"big_green_one":0,"small_green_one":0,"big_blue_one":0,"small_blue_one":0,"big_gray_one":0,"small_gray_one":0,"big_red_one":0,"small_red_one":0,"big_brown_one":0,"small_brown_one":0}
		try:
			splited = case.split(",,")
			splagain = splited[1].split(",")
			if splagain[0] == "object":
				results = splited[2].split(",")
#				print results
				caseutts = splagain[9:]
				for i,k in enumerate(caseutts):
					utts[k] = results[10+i]
				outfile.write(",".join(results[:10]+[str(utts[u]) for u in utts.keys()])+"\n")
				print len(results[:10]+[str(utts[u]) for u in utts.keys()])
			else:
				results = splited[1].split(",")
				caseutts = splited[0].split(",")[10:]
#				print splited[0].split(",")
				for i,k in enumerate(caseutts):
					utts[k] = results[10+i]
				if results[0] == "o1":
					outfile.write(",".join(results[:10]+[str(utts[u]) for u in utts.keys()])+"\n")
#				print len(results[:10]+[str(utts[u]) for u in utts.keys()])					
		except IndexError:
#			print splagain
			continue


