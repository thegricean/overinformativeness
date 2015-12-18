f = open("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/5_norming_object_typicality_phrasing1/item-combos.txt")
lines = [l.rstrip() for l in f.readlines()]
f.close()

items = []

i = 0

while i < len(lines):
	l = lines[i]
	if "item" in l:
		item = l.split(": ")[1][:-1].strip("\"")
		i = i + 1
		l = lines[i]
		label = l.split(": ")[1].strip("\"")
		if label.startswith("a "):
			label = label[2:]
		if label.startswith("an "):
			label = label[3:]
		sp = label.split()
		if len(sp) > 1:
			label = "".join(sp)	
		i = i + 1
		items.append(",".join([item.lower(),label.lower()]))
	else:
		i = i + 1
		
ofile = open("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/5_norming_object_typicality_phrasing1/item-combos.csv","w") 		
ofile.write("\n".join(items))
ofile.close()