setwd("/Users/cocolab/overinformativeness/Caroline/frequencyTextFiles_forOI6")

# code to extract words from google ngram corpori:
# grep -E "^([dD]ress [Ss]hirts?)_NOUN" googlebooks-eng-all-2gram-20120701-dr > dr.txt
# grep -E "^([sS]hirts?|[sS]kittles?|[sS]nacks?|[sS]uvs?|SUVs?|[sS]wordfish)_NOUN" googlebooks-eng-all-1gram-20120701-s > s.txt


#load("b.txt")
b = read.table(file="b.txt",sep="\t", header=T, quote=" ")

head(b)
nrow(b)

# bear:
bear = droplevels(subset(b, noun == "bear_NOUN" | noun == "bears_NOUN" | noun == "Bear_NOUN" | noun == "Bears_NOUN"))
head(bear)
nrow(bear)
bearNew = droplevels(subset(bear, year > 1959))
head(bearNew)
nrow(bearNew)
# frequency bearNew
freqBear = sum(bearNew$match_count)
freqBear

# bird:
bird = droplevels(subset(b, noun == "bird_NOUN" | noun == "birds_NOUN" | noun == "Bird_NOUN" | noun == "Birds_NOUN"))
head(bird)
nrow(bird)
# bird starting 1960
birdNew = droplevels(subset(bird, year > 1959))
head(birdNew)
nrow(birdNew)
# frequency
freqBird = sum(birdNew$match_count)
freqBird

#load("be.txt")
be = read.table(file="be.txt",sep="\t", header=T, quote=" ")

head(be)
nrow(be)

# bedside table:
bedsideTable = be
head(bedsideTable)
nrow(bedsideTable)
bedsideTableNew = droplevels(subset(bedsideTable, year > 1959))
head(bedsideTableNew)
nrow(bedsideTableNew)
# frequency bedside tableNew
freqBedsideTable = sum(bedsideTableNew$match_count)
freqBedsideTable

#load("bl.txt")
bl = read.table(file="bl.txt",sep="\t", header=T, quote=" ")

head(bl)
nrow(bl)

# black bear:
blackBear = bl
head(blackBear)
nrow(blackBear)
blackBearNew = droplevels(subset(blackBear, year > 1959))
head(blackBearNew)
nrow(blackBearNew)
# frequency black bearNew
freqBlackBear = sum(blackBearNew$match_count)
freqBlackBear


#load("c.txt")
c = read.table(file="c.txt",sep="\t", header=T, quote=" ")

head(c)
nrow(c)


# candy:
candy = droplevels(subset(c, noun == "candy_NOUN" | noun == "candies_NOUN" | noun == "Candy_NOUN" | noun == "Candies_NOUN"))
head(candy)
nrow(candy)
# candy starting 1960
candyNew = droplevels(subset(candy, year > 1959))
head(candyNew)
nrow(candyNew)
# frequency
freqCandy = sum(candyNew$match_count)
freqCandy

# car:
car = droplevels(subset(c, noun == "car_NOUN" | noun == "cars_NOUN" | noun == "Car_NOUN" | noun == "Cars_NOUN"))
head(car)
nrow(car)
# car starting 1960
carNew = droplevels(subset(car, year > 1959))
head(carNew)
nrow(carNew)
# frequency
freqCar = sum(carNew$match_count)
freqCar

# catfish:
catfish = droplevels(subset(c, noun == "catfish_NOUN" | noun == "Catfish_NOUN"))
head(catfish)
nrow(catfish)
# catfish starting 1960
catfishNew = droplevels(subset(catfish, year > 1959))
head(catfishNew)
nrow(catfishNew)
# frequency
freqCatfish = sum(catfishNew$match_count)
freqCatfish

# convertible:
convertible = droplevels(subset(c, noun == "convertible_NOUN" | noun == "convertibles_NOUN" | noun == "Convertible_NOUN" | noun == "Convertibles_NOUN"))
head(convertible)
nrow(convertible)
# convertible starting 1960
convertibleNew = droplevels(subset(convertible, year > 1959))
head(convertibleNew)
nrow(convertibleNew)
# frequency
freqConvertible = sum(convertibleNew$match_count)
freqConvertible

#load("cl.txt")
cl = read.table(file="cl.txt",sep="\t", header=T, quote=" ")

head(cl)
nrow(cl)

# clown fish1:
clownFish1 = cl
head(clownFish1)
nrow(clownFish1)
clownFishNew1 = droplevels(subset(clownFish1, year > 1959))
head(clownFishNew1)
nrow(clownFishNew1)
# frequency clown fishNew1
freqClownfish1 = sum(clownFishNew1$match_count)
freqClownfish1

# clown fish2:
clownFish2 = droplevels(subset(c, noun == "clownfish_NOUN" | noun == "Clownfish_NOUN"))
head(clownFish2)
nrow(clownFish2)
clownFishNew2 = droplevels(subset(clownFish2, year > 1959))
head(clownFishNew2)
nrow(clownFishNew2)
# frequency clown fishNew2
freqClownfish2 = sum(clownFishNew2$match_count)
freqClownfish2

# frequency clownFish ALL
freqClownfish1 = sum(clownFishNew1$match_count)
freqClownfish2 = sum(clownFishNew2$match_count)
freqClownfish = (freqClownfish1 + freqClownfish2)
freqClownfish

#load("co.txt")
co = read.table(file="co.txt",sep="\t", header=T, quote=" ")

head(co)
nrow(co)

# coffee table:
coffeeTable = co
head(coffeeTable)
nrow(coffeeTable)
coffeeTableNew = droplevels(subset(coffeeTable, year > 1959))
head(coffeeTableNew)
nrow(coffeeTableNew)
# frequency coffeeTableNew
freqCoffeeTable = sum(coffeeTableNew$match_count)
freqCoffeeTable

#load("di.txt")
di = read.table(file="di.txt",sep="\t", header=T, quote=" ")

head(di)
nrow(di)

# dining table:
diningTable = di
head(diningTable)
nrow(diningTable)
diningTableNew = droplevels(subset(diningTable, year > 1959))
head(diningTableNew)
nrow(diningTableNew)
# frequency diningTableNew
freqDiningTable = sum(diningTableNew$match_count)
freqDiningTable


#load("dre.txt")
dre = read.table(file="dre.txt",sep="\t", header=T, quote=" ")

head(dre)
nrow(dre)

#load("dr.txt")
dr = read.table(file="dr.txt",sep="\t", header=T, quote=" ")

head(dr)
nrow(dr)


# dressShirt1:
dressShirt1 = dre
head(dressShirt1)
nrow(dressShirt1)
dressShirtNew1 = droplevels(subset(dressShirt1, year > 1959))
head(dressShirtNew1)
nrow(dressShirtNew1)
# frequency dressShirtNew1
freqDressShirt1 = sum(dressShirtNew1$match_count)
freqDressShirt1

# dressShirt2:
dressShirt2 = dr
head(dressShirt2)
nrow(dressShirt2)
dressShirtNew2 = droplevels(subset(dressShirt2, year > 1959))
head(dressShirtNew2)
nrow(dressShirtNew2)
# frequency dressShirtNew2
freqDressShirt2 = sum(dressShirtNew2$match_count)
freqDressShirt2

# frequency dressShirt ALL
freqDressShirt1 = sum(dressShirtNew1$match_count)
freqDressShirt2 = sum(dressShirtNew2$match_count)
freqDressShirt = (freqDressShirt1 + freqDressShirt2)
freqDressShirt



#load("e.txt")
e = read.table(file="e.txt",sep="\t", header=T, quote=" ")

head(e)
nrow(e)


# eagle:
eagle = droplevels(subset(e, noun == "eagle_NOUN" | noun == "eagles_NOUN" | noun == "Eagle_NOUN" | noun == "Eagles_NOUN"))
head(eagle)
nrow(eagle)
# eagle starting 1960
eagleNew = droplevels(subset(eagle, year > 1959))
head(eagleNew)
nrow(eagleNew)
# frequency
freqEagle = sum(eagleNew$match_count)
freqEagle

#load("f.txt")
f = read.table(file="f.txt",sep="\t", header=T, quote=" ")

head(f)
nrow(f)

# fish:
fish = droplevels(subset(f, noun == "fish_NOUN" | noun == "Fish_NOUN"))
head(fish)
nrow(fish)
# fish starting 1960
fishNew = droplevels(subset(fish, year > 1959))
head(fishNew)
nrow(fishNew)
# frequency
freqFish = sum(fishNew$match_count)
freqFish

#load("ge.txt")
ge = read.table(file="ge.txt",sep="\t", header=T, quote=" ")

head(ge)
nrow(ge)

# germanShepherd: (REDO)
germanShepherd = ge
head(germanShepherd)
nrow(germanShepherd)
# germanShepherd starting 1960
germanShepherdNew = droplevels(subset(germanShepherd, year > 1959))
head(germanShepherdNew)
nrow(germanShepherdNew)
# frequency
freqGermanShepherd = sum(germanShepherdNew$match_count)
freqGermanShepherd

#load("g.txt")
g = read.table(file="g.txt",sep="\t", header=T, quote=" ")

head(g)
nrow(g)

#load("go.txt")
go = read.table(file="go.txt",sep="\t", header=T, quote=" ")

head(go)
nrow(go)

# gold fish1:
goldFish1 = go
head(goldFish1)
nrow(goldFish1)
goldFishNew1 = droplevels(subset(goldFish1, year > 1959))
head(goldFishNew1)
nrow(goldFishNew1)
# frequency gold fishNew1
freqGoldfish1 = sum(goldFishNew1$match_count)
freqGoldfish1

# gold fish2:
goldFish2 = droplevels(subset(g, noun == "goldfish_NOUN" | noun == "Goldfish_NOUN"))
head(goldFish2)
nrow(goldFish2)
goldFishNew2 = droplevels(subset(goldFish2, year > 1959))
head(goldFishNew2)
nrow(goldFishNew2)
# frequency gold fishNew2
freqGoldfish2 = sum(goldFishNew2$match_count)
freqGoldfish2

# frequency goldFish ALL
freqGoldfish1 = sum(goldFishNew1$match_count)
freqGoldfish2 = sum(goldFishNew2$match_count)
freqGoldfish = (freqGoldfish1 + freqGoldfish2)
freqGoldfish


#load("gr.txt")
gr = read.table(file="gr.txt",sep="\t", header=T, quote=" ")

head(gr)
nrow(gr)

# grizzlyBear:
grizzlyBear = gr
head(grizzlyBear)
nrow(grizzlyBear)
# grizzlyBear starting 1960
grizzlyBearNew = droplevels(subset(grizzlyBear, year > 1959))
head(grizzlyBearNew)
nrow(grizzlyBearNew)
# frequency
freqGrizzlyBear = sum(grizzlyBearNew$match_count)
freqGrizzlyBear

#load("gu.txt")
gu = read.table(file="gu.txt",sep="\t", header=T, quote=" ")

head(gu)
nrow(gu)

# gummyBears1:
gummyBears1 = gu
head(gummyBears1)
nrow(gummyBears1)
gummyBearsNew1 = droplevels(subset(gummyBears1, year > 1959))
head(gummyBearsNew1)
nrow(gummyBearsNew1)
# frequency
freqGummyBears1 = sum(gummyBearsNew1$match_count)
freqGummyBears1

# gummyBears:
gummyBears2 = droplevels(subset(g, noun == "gummybears_NOUN" | noun == "Gummybears_NOUN" | noun == "gummybear_NOUN" | noun == "Gummybear_NOUN"))
head(gummyBears2)
nrow(gummyBears2)
gummyBearsNew2 = droplevels(subset(gummyBears2, year > 1959))
head(gummyBearsNew2)
nrow(gummyBearsNew2)
# frequency gummyBearsNew2
freqGummyBears2 = sum(gummyBearsNew2$match_count)
freqGummyBears2

# frequency gummyBears ALL
freqGummyBears1 = sum(gummyBearsNew1$match_count)
freqGummyBears2 = sum(gummyBearsNew2$match_count)
freqGummyBears = (freqGummyBears1 + freqGummyBears2)
freqGummyBears


#load("ha.txt")
ha = read.table(file="ha.txt",sep="\t", header=T, quote=" ")

head(ha)
nrow(ha)

# hawaiiShirt:
hawaiiShirt = ha
head(hawaiiShirt)
nrow(hawaiiShirt)
# hawaiiShirt starting 1960
hawaiiShirtNew = droplevels(subset(hawaiiShirt, year > 1959))
head(hawaiiShirtNew)
nrow(hawaiiShirtNew)
# frequency
freqHawaiiShirt = sum(hawaiiShirtNew$match_count)
freqHawaiiShirt

#load("hu.txt")
hu = read.table(file="hu.txt",sep="\t", header=T, quote=" ")

head(hu)
nrow(hu)

#load("h.txt")
h = read.table(file="h.txt",sep="\t", header=T, quote=" ")

head(h)
nrow(h)

# hummingBird1:
hummingBird1 = hu
head(hummingBird1)
nrow(hummingBird1)
hummingBirdNew1 = droplevels(subset(hummingBird1, year > 1959))
head(hummingBirdNew1)
nrow(hummingBirdNew1)
# frequency
freqHummingBird1 = sum(hummingBirdNew1$match_count)
freqHummingBird1

# hummingBird:
hummingBird2 = droplevels(subset(h, noun == "hummingbird_NOUN" | noun == "hummingbirds_NOUN"| noun == "Hummingbird_NOUN"| noun == "Hummingbirds_NOUN"))
head(hummingBird2)
nrow(hummingBird2)
hummingBirdNew2 = droplevels(subset(hummingBird2, year > 1959))
head(hummingBirdNew2)
nrow(hummingBirdNew2)
# frequency
freqHummingBird2 = sum(hummingBirdNew2$match_count)
freqHummingBird2

# frequency hummingBird ALL
freqHummingBird1 = sum(hummingBirdNew1$match_count)
freqHummingBird2 = sum(hummingBirdNew2$match_count)
freqHummingBird = (freqHummingBird1 + freqHummingBird2)
freqHummingBird


#load("j.txt")
j = read.table(file="j.txt",sep="\t", header=T, quote=" ")

head(j)
nrow(j)

#load("je.txt")
je = read.table(file="je.txt",sep="\t", header=T, quote=" ")

head(je)
nrow(je)

# jellyBeans1:
jellyBeans1 = je
head(jellyBeans1)
nrow(jellyBeans1)
jellyBeansNew1 = droplevels(subset(jellyBeans1, year > 1959))
head(jellyBeansNew1)
nrow(jellyBeansNew1)
# frequency
freqJellyBeans1 = sum(jellyBeansNew1$match_count)
freqJellyBeans1

# jellyBeans:
jellyBeans2 = j
head(jellyBeans2)
nrow(jellyBeans2)
jellyBeansNew2 = droplevels(subset(jellyBeans2, year > 1959))
head(jellyBeansNew2)
nrow(jellyBeansNew2)
# frequency
freqJellyBeans2 = sum(jellyBeansNew2$match_count)
freqJellyBeans2

# frequency jellyBeans ALL
freqJellyBeans1 = sum(jellyBeansNew1$match_count)
freqJellyBeans2 = sum(jellyBeansNew2$match_count)
freqJellyBeans = (freqJellyBeans1 + freqJellyBeans2)
freqJellyBeans


#load("m.txt")
m = read.table(file="m.txt",sep="\t", header=T, quote=" ")

head(m)
nrow(m)

# mnMs:
mnMs = m
head(mnMs)
nrow(mnMs)
# mnMs starting 1960
mnMsNew = droplevels(subset(mnMs, year > 1959))
head(mnMsNew)
nrow(mnMsNew)
# frequency
freqMnMs = sum(mnMsNew$match_count)
freqMnMs

#load("mi.txt")
mi = read.table(file="mi.txt",sep="\t", header=T, quote=" ")

head(mi)
nrow(mi)

# minivan:
minivan = mi
head(minivan)
nrow(minivan)
# minivan starting 1960
minivanNew = droplevels(subset(minivan, year > 1959))
head(minivanNew)
nrow(minivanNew)
# frequency
freqMinivan = sum(minivanNew$match_count)
freqMinivan

#load("p.txt")
p = read.table(file="p.txt",sep="\t", header=T, quote=" ")

head(p)
nrow(p)

# parrot:
parrot = droplevels(subset(p, noun == "parrot_NOUN" | noun == "parrots_NOUN" | noun == "Parrot_NOUN" | noun == "Parrots_NOUN"))
head(parrot)
nrow(parrot)
# parrot starting 1960
parrotNew = droplevels(subset(parrot, year > 1959))
head(parrotNew)
nrow(parrotNew)
# frequency
freqParrot = sum(parrotNew$match_count)
freqParrot

# pigeon:
pigeon = droplevels(subset(p, noun == "pigeon_NOUN" | noun == "pigeons_NOUN" | noun == "Pigeon_NOUN" | noun == "Pigeons_NOUN"))
head(pigeon)
nrow(pigeon)
# pigeon starting 1960
pigeonNew = droplevels(subset(pigeon, year > 1959))
head(pigeonNew)
nrow(pigeonNew)
# frequency
freqPigeon = sum(pigeonNew$match_count)
freqPigeon

#load("pa.txt")
pa = read.table(file="pa.txt",sep="\t", header=T, quote=" ")

head(pa)
nrow(pa)

# pandaBear:
pandaBear = pa
head(pandaBear)
nrow(pandaBear)
# pandaBear starting 1960
pandaBearNew = droplevels(subset(pandaBear, year > 1959))
head(pandaBearNew)
nrow(pandaBearNew)
# frequency
freqPandaBear = sum(pandaBearNew$match_count)
freqPandaBear

#load("pi.txt")
pi = read.table(file="pi.txt",sep="\t", header=T, quote=" ")

head(pi)
nrow(pi)

# picnicTable:
picnicTable = pi
head(picnicTable)
nrow(picnicTable)
# picnicTable starting 1960
picnicTableNew = droplevels(subset(picnicTable, year > 1959))
head(picnicTableNew)
nrow(picnicTableNew)
# frequency
freqPicnicTable = sum(picnicTableNew$match_count)
freqPicnicTable

#load("polo.txt")
polo = read.table(file="polo.txt",sep="\t", header=T, quote=" ")

head(polo)
nrow(polo)

# poloShirt:
poloShirt = polo
head(poloShirt)
nrow(poloShirt)
# poloShirt starting 1960
poloShirtNew = droplevels(subset(poloShirt, year > 1959))
head(poloShirtNew)
nrow(poloShirtNew)
# frequency
freqPoloShirt = sum(poloShirtNew$match_count)
freqPoloShirt

#load("polar.txt")
polar = read.table(file="polar.txt",sep="\t", header=T, quote=" ")

head(polar)
nrow(polar)

# polarBear:
polarBear = polar
head(polarBear)
nrow(polarBear)
# polarBear starting 1960
polarBearNew = droplevels(subset(polarBear, year > 1959))
head(polarBearNew)
nrow(polarBearNew)
# frequency
freqPolarBear = sum(polarBearNew$match_count)
freqPolarBear

#load("s.txt")
s = read.table(file="s.txt",sep="\t", header=T, quote=" ")

head(s)
nrow(s)

# shirt:
shirt = droplevels(subset(s, noun == "shirt_NOUN" | noun == "shirts_NOUN" | noun == "Shirt_NOUN" | noun == "Shirts_NOUN"))
head(shirt)
nrow(shirt)
# shirt starting 1960
shirtNew = droplevels(subset(shirt, year > 1959))
head(shirtNew)
nrow(shirtNew)
# frequency
freqShirt = sum(shirtNew$match_count)
freqShirt

# skittles:
skittles = droplevels(subset(s, noun == "skittles_NOUN" | noun == "Skittles_NOUN"))
head(skittles)
nrow(skittles)
# skittles starting 1960
skittlesNew = droplevels(subset(skittles, year > 1959))
head(skittlesNew)
nrow(skittlesNew)
# frequency
freqSkittles = sum(skittlesNew$match_count)
freqSkittles

# snack:
snack = droplevels(subset(s, noun == "snack_NOUN" | noun == "snacks_NOUN" | noun == "Snack_NOUN" | noun == "Snacks_NOUN"))
head(snack)
nrow(snack)
# snack starting 1960
snackNew = droplevels(subset(snack, year > 1959))
head(snackNew)
nrow(snackNew)
# frequency
freqSnack = sum(snackNew$match_count)
freqSnack

# suv:
suv = droplevels(subset(s, noun == "suv_NOUN" | noun == "suvs_NOUN" | noun == "Suv_NOUN" | noun == "Suvs_NOUN" | noun == "SUV_NOUN" | noun == "SUVs_NOUN"))
head(suv)
nrow(suv)
# suv starting 1960
suvNew = droplevels(subset(suv, year > 1959))
head(suvNew)
nrow(suvNew)
# frequency
freqSuv = sum(suvNew$match_count)
freqSuv

#load("sw.txt")
sw = read.table(file="sw.txt",sep="\t", header=T, quote=" ")

head(sw)
nrow(sw)

# sword fish1:
swordFish1 = sw
head(swordFish1)
nrow(swordFish1)
swordFishNew1 = droplevels(subset(swordFish1, year > 1959))
head(swordFishNew1)
nrow(swordFishNew1)
# frequency
freqSwordfish1 = sum(swordFishNew1$match_count)
freqSwordfish1

# sword fish2:
swordFish2 = droplevels(subset(s, noun == "swordfish_NOUN" | noun == "Swordfish_NOUN"))
head(swordFish2)
nrow(swordFish2)
swordFishNew2 = droplevels(subset(swordFish2, year > 1959))
head(swordFishNew2)
nrow(swordFishNew2)
# frequency
freqSwordfish2 = sum(swordFishNew2$match_count)
freqSwordfish2

# frequency swordFish ALL
freqSwordfish1 = sum(swordFishNew1$match_count)
freqSwordfish2 = sum(swordFishNew2$match_count)
freqSwordfish = (freqSwordfish1 + freqSwordfish2)
freqSwordfish


#load("sp.txt")
sp = read.table(file="sp.txt",sep="\t", header=T, quote=" ")

head(sp)
nrow(sp)

# sportsCar:
sportsCar = sp
head(sportsCar)
nrow(sportsCar)
# sportsCar starting 1960
sportsCarNew = droplevels(subset(sportsCar, year > 1959))
head(sportsCarNew)
nrow(sportsCarNew)
# frequency
freqSportsCar = sum(sportsCarNew$match_count)
freqSportsCar


#load("t.txt")
t = read.table(file="t.txt",sep="\t", header=T, quote=" ")

head(t)
nrow(t)

# tShirt:
tShirt = t
head(tShirt)
nrow(tShirt)
# tShirt starting 1960
tShirtNew = droplevels(subset(tShirt, year > 1959))
head(tShirtNew)
nrow(tShirtNew)
# frequency
freqTshirt = sum(tShirtNew$match_count)
freqTshirt

#load("ta.txt")
ta = read.table(file="ta.txt",sep="\t", header=T, quote=" ")

head(ta)
nrow(ta)

# table:
table = ta
head(table)
nrow(table)
# table starting 1960
tableNew = droplevels(subset(table, year > 1959))
head(tableNew)
nrow(tableNew)
# frequency
freqTable = sum(tableNew$match_count)
freqTable

