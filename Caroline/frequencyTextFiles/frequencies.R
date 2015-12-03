setwd("/Users/cocolab/overinformativeness/Caroline/frequencyTextFiles")
source("rscripts/helpers.r")

#load("a.txt")
a = read.table(file="a.txt",sep="\t", header=T, quote=" ")

head(a)
nrow(a)

# ambulance:
ambulance = droplevels(subset(a, noun == "ambulance_NOUN" | noun == "ambulances_NOUN" | noun == "Ambulance_NOUN" | noun == "Ambulances_NOUN"))
head(ambulance)
nrow(ambulance)
# ambulance starting 1960
ambulanceNew = droplevels(subset(ambulance, year > 1959))
head(ambulanceNew)
nrow(ambulanceNew)
# frequency
freqAmbulance = sum(ambulanceNew$match_count)
freqAmbulance

# animal:
animal = droplevels(subset(a, noun == "animal_NOUN" | noun == "animals_NOUN" | noun == "Animal_NOUN" | noun == "Animals_NOUN"))
head(animal)
nrow(animal)
# animal starting 1960
animalNew = droplevels(subset(animal, year > 1959))
head(animalNew)
nrow(animalNew)
# frequency
freqAnimal = sum(animalNew$match_count)
freqAnimal


#load("b.txt")
b = read.table(file="b.txt",sep="\t", header=T, quote=" ")

head(b)
nrow(b)

# banjo:
banjo = droplevels(subset(b, noun == "banjo_NOUN" | noun == "banjos_NOUN" | noun == "Banjo_NOUN" | noun == "Banjos_NOUN"))
head(banjo)
nrow(banjo)
banjoNew = droplevels(subset(banjo, year > 1959))
head(banjoNew)
nrow(banjoNew)
# frequency banjoNew
freqBanjo = sum(banjoNew$match_count)
freqBanjo

# bathrobe:
bathrobe = droplevels(subset(b, noun == "bathrobe_NOUN" | noun == "bathrobes_NOUN" | noun == "Bathrobe_NOUN" | noun == "Bathrobes_NOUN"))
head(bathrobe)
nrow(bathrobe)
# bathrobe starting 1960
bathrobeNew = droplevels(subset(bathrobe, year > 1959))
head(bathrobeNew)
nrow(bathrobeNew)
# frequency
freqBathrobe = sum(bathrobeNew$match_count)
freqBathrobe

# bed:
bed = droplevels(subset(b, noun == "bed_NOUN" | noun == "beds_NOUN" | noun == "Bed_NOUN" | noun == "Beds_NOUN"))
head(bed)
nrow(bed)
# bed starting 1960
bedNew = droplevels(subset(bed, year > 1959))
head(bedNew)
nrow(bedNew)
# frequency
freqBed = sum(bedNew$match_count)
freqBed

# belt:
belt = droplevels(subset(b, noun == "belt_NOUN" | noun == "belts_NOUN" | noun == "Belt_NOUN" | noun == "Belts_NOUN"))
head(belt)
nrow(belt)
# belt starting 1960
beltNew = droplevels(subset(belt, year > 1959))
head(beltNew)
nrow(beltNew)
# frequency
freqBelt = sum(beltNew$match_count)
freqBelt

# bike:
bike = droplevels(subset(b, noun == "bike_NOUN" | noun == "bikes_NOUN" | noun == "Bike_NOUN" | noun == "Bikes_NOUN"))
head(bike)
nrow(bike)
# bike starting 1960
bikeNew = droplevels(subset(bike, year > 1959))
head(bikeNew)
nrow(bikeNew)
# frequency
freqBike = sum(bikeNew$match_count)
freqBike

# boat:
boat = droplevels(subset(b, noun == "boat_NOUN" | noun == "boats_NOUN" | noun == "Boat_NOUN" | noun == "Boats_NOUN"))
head(boat)
nrow(boat)
# boat starting 1960
boatNew = droplevels(subset(boat, year > 1959))
head(boatNew)
nrow(boatNew)
# frequency
freqBoat = sum(boatNew$match_count)
freqBoat

# bookcase:
bookcase = droplevels(subset(b, noun == "bookcase_NOUN" | noun == "bookcases_NOUN" | noun == "Bookcase_NOUN" | noun == "Bookcases_NOUN"))
head(bookcase)
nrow(bookcase)
# bookcase starting 1960
bookcaseNew = droplevels(subset(bookcase, year > 1959))
head(bookcaseNew)
nrow(bookcaseNew)
# frequency
freqBookcase = sum(bookcaseNew$match_count)
freqBookcase

# bra:
bra = droplevels(subset(b, noun == "bra_NOUN" | noun == "bras_NOUN" | noun == "Bra_NOUN" | noun == "Bras_NOUN"))
head(bra)
nrow(bra)
# bra starting 1960
braNew = droplevels(subset(bra, year > 1959))
head(braNew)
nrow(braNew)
# frequency
freqBra = sum(braNew$match_count)
freqBra

# building:
building = droplevels(subset(b, noun == "building_NOUN" | noun == "buildings_NOUN" | noun == "Building_NOUN" | noun == "Buildings_NOUN"))
head(building)
nrow(building)
# building starting 1960
buildingNew = droplevels(subset(building, year > 1959))
head(buildingNew)
nrow(buildingNew)
# frequency
freqBuilding = sum(buildingNew$match_count)
freqBuilding

#load("c.txt")
c = read.table(file="c.txt",sep="\t", header=T, quote=" ")

head(c)
nrow(c)


# carrot:
carrot = droplevels(subset(c, noun == "carrot_NOUN" | noun == "carrots_NOUN" | noun == "Carrot_NOUN" | noun == "Carrots_NOUN"))
head(carrot)
nrow(carrot)
# carrot starting 1960
carrotNew = droplevels(subset(carrot, year > 1959))
head(carrotNew)
nrow(carrotNew)
# frequency
freqCarrot = sum(carrotNew$match_count)
freqCarrot

# clarinet:
clarinet = droplevels(subset(c, noun == "clarinet_NOUN" | noun == "clarinets_NOUN" | noun == "Clarinet_NOUN" | noun == "Clarinets_NOUN"))
head(clarinet)
nrow(clarinet)
# clarinet starting 1960
clarinetNew = droplevels(subset(clarinet, year > 1959))
head(clarinetNew)
nrow(clarinetNew)
# frequency
freqClarinet = sum(clarinetNew$match_count)
freqClarinet

# clothing:
clothing = droplevels(subset(c, noun == "clothing_NOUN" | noun == "Clothing_NOUN"))
head(clothing)
nrow(clothing)
# clothing starting 1960
clothingNew = droplevels(subset(clothing, year > 1959))
head(clothingNew)
nrow(clothingNew)
# frequency
freqClothing = sum(clothingNew$match_count)
freqClothing

# corn:
corn = droplevels(subset(c, noun == "corn_NOUN" | noun == "Corn_NOUN"))
head(corn)
nrow(corn)
# corn starting 1960
cornNew = droplevels(subset(corn, year > 1959))
head(cornNew)
nrow(cornNew)
# frequency
freqCorn = sum(cornNew$match_count)
freqCorn

# cottage:
cottage = droplevels(subset(c, noun == "cottage_NOUN" | noun == "cottages_NOUN" | noun == "Cottage_NOUN" | noun == "Cottages_NOUN"))
head(cottage)
nrow(cottage)
# cottage starting 1960
cottageNew = droplevels(subset(cottage, year > 1959))
head(cottageNew)
nrow(cottageNew)
# frequency
freqCottage = sum(cottageNew$match_count)
freqCottage


#load("d.txt")
d = read.table(file="d.txt",sep="\t", header=T, quote=" ")

head(d)
nrow(d)


# daisy:
daisy = droplevels(subset(d, noun == "daisy_NOUN" | noun == "daisies_NOUN" | noun == "Daisy_NOUN" | noun == "Daisies_NOUN"))
head(daisy)
nrow(daisy)
# daisy starting 1960
daisyNew = droplevels(subset(daisy, year > 1959))
head(daisyNew)
nrow(daisyNew)
# frequency
freqDaisy = sum(daisyNew$match_count)
freqDaisy

# dalmatian:
dalmatian = droplevels(subset(d, noun == "dalmatian_NOUN" | noun == "dalmatians_NOUN" | noun == "Dalmatian_NOUN" | noun == "Dalmatians_NOUN"))
head(dalmatian)
nrow(dalmatian)
# dalmatian starting 1960
dalmatianNew = droplevels(subset(dalmatian, year > 1959))
head(dalmatianNew)
nrow(dalmatianNew)
# frequency
freqDalmatian = sum(dalmatianNew$match_count)
freqDalmatian

# dog:
dog = droplevels(subset(d, noun == "dog_NOUN" | noun == "dogs_NOUN" | noun == "Dog_NOUN" | noun == "Dogs_NOUN"))
head(dog)
nrow(dog)
# dog starting 1960
dogNew = droplevels(subset(dog, year > 1959))
head(dogNew)
nrow(dogNew)
# frequency
freqDog = sum(dogNew$match_count)
freqDog

#load("e.txt")
e = read.table(file="e.txt",sep="\t", header=T, quote=" ")

head(e)
nrow(e)


# eggplant:
eggplant = droplevels(subset(e, noun == "eggplant_NOUN" | noun == "eggplants_NOUN" | noun == "Eggplant_NOUN" | noun == "Eggplants_NOUN"))
head(eggplant)
nrow(eggplant)
# eggplant starting 1960
eggplantNew = droplevels(subset(eggplant, year > 1959))
head(eggplantNew)
nrow(eggplantNew)
# frequency
freqEggplant = sum(eggplantNew$match_count)
freqEggplant

#load("f.txt")
f = read.table(file="f.txt",sep="\t", header=T, quote=" ")

head(f)
nrow(f)

# firetruck:
firetruck = droplevels(subset(f, noun == "firetruck_NOUN" | noun == "firetrucks_NOUN" | noun == "Firetruck_NOUN" | noun == "Firetrucks_NOUN"))
head(firetruck)
nrow(firetruck)
# firetruck starting 1960
firetruckNew1 = droplevels(subset(firetruck, year > 1959))
head(firetruckNew1)
nrow(firetruckNew1)

#load("fi.txt")
fi = read.table(file="fi.txt",sep="\t", header=T, quote=" ")

head(fi)
nrow(fi)

# firetruck:
firetruck = droplevels(subset(fi, noun == "firetruck_NOUN" | noun == "Firetruck_NOUN" | noun == "FireTruck_NOUN" | noun == "fireTruck_NOUN" | noun == "firetrucks_NOUN" | noun == "Firetrucks_NOUN" | noun == "FireTrucks_NOUN" | noun == "fireTrucks_NOUN"))
head(firetruck)
nrow(firetruck)
# firetruck starting 1960
firetruckNew2 = droplevels(subset(firetruck, year > 1959))
head(firetruckNew2)
nrow(firetruckNew2)

# frequency firetruck
freqFiretruck1 = sum(firetruckNew1$match_count)
freqFiretruck2 = sum(firetruckNew2$match_count)
freqFiretruck = (freqFiretruck1 + freqFiretruck2)
freqFiretruck


# flower:
flower = droplevels(subset(f, noun == "flower_NOUN" | noun == "flowers_NOUN" | noun == "Flower_NOUN" | noun == "Flowers_NOUN"))
head(flower)
nrow(flower)
# flower starting 1960
flowerNew = droplevels(subset(flower, year > 1959))
head(flowerNew)
nrow(flowerNew)
# frequency
freqFlower = sum(flowerNew$match_count)
freqFlower

# food:
food = droplevels(subset(f, noun == "food_NOUN" | noun == "Food_NOUN"))
head(food)
nrow(food)
# food starting 1960
foodNew = droplevels(subset(food, year > 1959))
head(foodNew)
nrow(foodNew)
# frequency
freqFood = sum(foodNew$match_count)
freqFood

# fruit:
fruit = droplevels(subset(f, noun == "fruit_NOUN" | noun == "Fruit_NOUN"))
head(fruit)
nrow(fruit)
# fruit starting 1960
fruitNew = droplevels(subset(fruit, year > 1959))
head(fruitNew)
nrow(fruitNew)
# frequency
freqFruit = sum(fruitNew$match_count)
freqFruit

# furniture:
furniture = droplevels(subset(f, noun == "furniture_NOUN" | noun == "Furniture_NOUN"))
head(furniture)
nrow(furniture)
# furniture starting 1960
furnitureNew = droplevels(subset(furniture, year > 1959))
head(furnitureNew)
nrow(furnitureNew)
# frequency
freqFurniture = sum(furnitureNew$match_count)
freqFurniture

#load("ge.txt")
ge = read.table(file="ge.txt",sep="\t", header=T, quote=" ")

head(ge)
nrow(ge)

# germanShepherd:
germanShepherd = droplevels(subset(ge, noun == "germanShepherd_NOUN" | noun == "GermanShepherd_NOUN" | noun == "germanshepherd_NOUN" | noun == "Germanshepherd_NOUN" | noun == "germanShepherds_NOUN" | noun == "GermanShepherds_NOUN" | noun == "germanshepherds_NOUN" | noun == "Germanshepherds_NOUN"))
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

# grapefruit:
grapefruit = droplevels(subset(g, noun == "grapefruit_NOUN" | noun == "grapefruits_NOUN" | noun == "Grapefruit_NOUN" | noun == "Grapefruits_NOUN"))
head(grapefruit)
nrow(grapefruit)
# grapefruit starting 1960
grapefruitNew = droplevels(subset(grapefruit, year > 1959))
head(grapefruitNew)
nrow(grapefruitNew)
# frequency
freqGrapefruit = sum(grapefruitNew$match_count)
freqGrapefruit

#load("h.txt")
h = read.table(file="h.txt",sep="\t", header=T, quote=" ")

head(h)
nrow(h)

# house:
house = droplevels(subset(h, noun == "house_NOUN" | noun == "houses_NOUN" | noun == "House_NOUN" | noun == "Houses_NOUN"))
head(house)
nrow(house)
# house starting 1960
houseNew = droplevels(subset(house, year > 1959))
head(houseNew)
nrow(houseNew)
# frequency
freqHouse = sum(houseNew$match_count)
freqHouse

# husky:
husky = droplevels(subset(h, noun == "husky_NOUN" | noun == "huskies_NOUN" | noun == "Husky_NOUN" | noun == "Huskies_NOUN"))
head(husky)
nrow(husky)
# husky starting 1960
huskyNew = droplevels(subset(husky, year > 1959))
head(huskyNew)
nrow(huskyNew)
# frequency
freqHusky = sum(huskyNew$match_count)
freqHusky

#load("i.txt")
i = read.table(file="i.txt",sep="\t", header=T, quote=" ")

head(i)
nrow(i)

# igloo:
igloo = droplevels(subset(i, noun == "igloo_NOUN" | noun == "igloos_NOUN" | noun == "Igloo_NOUN" | noun == "Igloos_NOUN"))
head(igloo)
nrow(igloo)
# igloo starting 1960
iglooNew = droplevels(subset(igloo, year > 1959))
head(iglooNew)
nrow(iglooNew)
# frequency
freqIgloo = sum(iglooNew$match_count)
freqIgloo

# instrument:
instrument = droplevels(subset(i, noun == "instrument_NOUN" | noun == "instruments_NOUN" | noun == "Instrument_NOUN" | noun == "Instruments_NOUN"))
head(instrument)
nrow(instrument)
# instrument starting 1960
instrumentNew = droplevels(subset(instrument, year > 1959))
head(instrumentNew)
nrow(instrumentNew)
# frequency
freqInstrument = sum(instrumentNew$match_count)
freqInstrument


#load("k.txt")
k = read.table(file="k.txt",sep="\t", header=T, quote=" ")

head(k)
nrow(k)

# kiwi:
kiwi = droplevels(subset(k, noun == "kiwi_NOUN" | noun == "kiwis_NOUN" | noun == "Kiwi_NOUN" | noun == "Kiwis_NOUN"))
head(kiwi)
nrow(kiwi)
# kiwi starting 1960
kiwiNew = droplevels(subset(kiwi, year > 1959))
head(kiwiNew)
nrow(kiwiNew)
# frequency
freqKiwi = sum(kiwiNew$match_count)
freqKiwi

#load("l.txt")
l = read.table(file="l.txt",sep="\t", header=T, quote=" ")

head(l)
nrow(l)

# lamp:
lamp = droplevels(subset(l, noun == "lamp_NOUN" | noun == "lamps_NOUN" | noun == "Lamp_NOUN" | noun == "Lamps_NOUN"))
head(lamp)
nrow(lamp)
# lamp starting 1960
lampNew = droplevels(subset(lamp, year > 1959))
head(lampNew)
nrow(lampNew)
# frequency
freqLamp = sum(lampNew$match_count)
freqLamp

# lime:
lime = droplevels(subset(l, noun == "lime_NOUN" | noun == "limes_NOUN" | noun == "Lime_NOUN" | noun == "Limes_NOUN"))
head(lime)
nrow(lime)
# lime starting 1960
limeNew = droplevels(subset(lime, year > 1959))
head(limeNew)
nrow(limeNew)
# frequency
freqLime = sum(limeNew$match_count)
freqLime

#load("m.txt")
m = read.table(file="m.txt",sep="\t", header=T, quote=" ")

head(m)
nrow(m)

# mushroom:
mushroom = droplevels(subset(m, noun == "mushroom_NOUN" | noun == "mushrooms_NOUN" | noun == "Mushroom_NOUN" | noun == "Mushrooms_NOUN"))
head(mushroom)
nrow(mushroom)
# mushroom starting 1960
mushroomNew = droplevels(subset(mushroom, year > 1959))
head(mushroomNew)
nrow(mushroomNew)
# frequency
freqMushroom = sum(mushroomNew$match_count)
freqMushroom

#load("o.txt")
o = read.table(file="o.txt",sep="\t", header=T, quote=" ")

head(o)
nrow(o)

# object:
object = droplevels(subset(o, noun == "object_NOUN" | noun == "objects_NOUN" | noun == "Object_NOUN" | noun == "Objects_NOUN"))
head(object)
nrow(object)
# object starting 1960
objectNew = droplevels(subset(object, year > 1959))
head(objectNew)
nrow(objectNew)
# frequency
freqObject = sum(objectNew$match_count)
freqObject


#load("p.txt")
p = read.table(file="p.txt",sep="\t", header=T, quote=" ")

head(p)
nrow(p)

# piano:
piano = droplevels(subset(p, noun == "piano_NOUN" | noun == "pianos_NOUN" | noun == "Piano_NOUN" | noun == "Pianos_NOUN"))
head(piano)
nrow(piano)
# piano starting 1960
pianoNew = droplevels(subset(piano, year > 1959))
head(pianoNew)
nrow(pianoNew)
# frequency
freqPiano = sum(pianoNew$match_count)
freqPiano

# pineapple:
pineapple = droplevels(subset(p, noun == "pineapple_NOUN" | noun == "pineapples_NOUN" | noun == "Pineapple_NOUN" | noun == "Pineapples_NOUN"))
head(pineapple)
nrow(pineapple)
# pineapple starting 1960
pineappleNew = droplevels(subset(pineapple, year > 1959))
head(pineappleNew)
nrow(pineappleNew)
# frequency
freqPineapple = sum(pineappleNew$match_count)
freqPineapple

# plant:
plant = droplevels(subset(p, noun == "plant_NOUN" | noun == "plants_NOUN" | noun == "Plant_NOUN" | noun == "Plants_NOUN"))
head(plant)
nrow(plant)
# plant starting 1960
plantNew = droplevels(subset(plant, year > 1959))
head(plantNew)
nrow(plantNew)
# frequency
freqPlant = sum(plantNew$match_count)
freqPlant

# pug:
pug = droplevels(subset(p, noun == "pug_NOUN" | noun == "pugs_NOUN" | noun == "Pug_NOUN" | noun == "Pugs_NOUN"))
head(pug)
nrow(pug)
# pug starting 1960
pugNew = droplevels(subset(pug, year > 1959))
head(pugNew)
nrow(pugNew)
# frequency
freqPug = sum(pugNew$match_count)
freqPug

#load("r.txt")
r = read.table(file="r.txt",sep="\t", header=T, quote=" ")

head(r)
nrow(r)

# rose:
rose = droplevels(subset(r, noun == "rose_NOUN" | noun == "roses_NOUN" | noun == "Rose_NOUN" | noun == "Roses_NOUN"))
head(rose)
nrow(rose)
# rose starting 1960
roseNew = droplevels(subset(rose, year > 1959))
head(roseNew)
nrow(roseNew)
# frequency
freqRose = sum(roseNew$match_count)
freqRose

#load("s.txt")
s = read.table(file="s.txt",sep="\t", header=T, quote=" ")

head(s)
nrow(s)

# saxophone:
saxophone = droplevels(subset(s, noun == "saxophone_NOUN" | noun == "saxophones_NOUN" | noun == "Tent_NOUN" | noun == "Saxophones_NOUN" | noun == "Sax_NOUN" | noun == "sax_NOUN"))
head(saxophone)
nrow(saxophone)
# saxophone starting 1960
saxophoneNew = droplevels(subset(saxophone, year > 1959))
head(saxophoneNew)
nrow(saxophoneNew)
# frequency
freqSaxophone = sum(saxophoneNew$match_count)
freqSaxophone

# sunflower:
sunflower = droplevels(subset(s, noun == "sunflower_NOUN" | noun == "sunflowers_NOUN" | noun == "Sunflower_NOUN" | noun == "Sunflowers_NOUN"))
head(sunflower)
nrow(sunflower)
# sunflower starting 1960
sunflowerNew = droplevels(subset(sunflower, year > 1959))
head(sunflowerNew)
nrow(sunflowerNew)
# frequency
freqSunflower = sum(sunflowerNew$match_count)
freqSunflower

# swimsuit:
swimsuit = droplevels(subset(s, noun == "swimsuit_NOUN" | noun == "swimsuits_NOUN" | noun == "Swimsuit_NOUN" | noun == "Swimsuits_NOUN"))
head(swimsuit)
nrow(swimsuit)
# swimsuit starting 1960
swimsuitNew = droplevels(subset(swimsuit, year > 1959))
head(swimsuitNew)
nrow(swimsuitNew)
# frequency
freqSwimsuit = sum(swimsuitNew$match_count)
freqSwimsuit

#load("t.txt")
t = read.table(file="t.txt",sep="\t", header=T, quote=" ")

head(t)
nrow(t)

# tent:
tent = droplevels(subset(t, noun == "tent_NOUN" | noun == "tents_NOUN" | noun == "Tent_NOUN" | noun == "Tents_NOUN"))
head(tent)
nrow(tent)
# tent starting 1960
tentNew = droplevels(subset(tent, year > 1959))
head(tentNew)
nrow(tentNew)
# frequency
freqTent = sum(tentNew$match_count)
freqTent

# trailer:
trailer = droplevels(subset(t, noun == "trailer_NOUN" | noun == "trailers_NOUN" | noun == "Trailer_NOUN" | noun == "Trailers_NOUN"))
head(trailer)
nrow(trailer)
# trailer starting 1960
trailerNew = droplevels(subset(trailer, year > 1959))
head(trailerNew)
nrow(trailerNew)
# frequency
freqTrailer = sum(trailerNew$match_count)
freqTrailer

# tulip:
tulip = droplevels(subset(t, noun == "tulip_NOUN" | noun == "tulips_NOUN" | noun == "Tulip_NOUN" | noun == "Tulips_NOUN"))
head(tulip)
nrow(tulip)
# tulip starting 1960
tulipNew = droplevels(subset(tulip, year > 1959))
head(tulipNew)
nrow(tulipNew)
# frequency
freqTulip = sum(tulipNew$match_count)
freqTulip

#load("v.txt")
v = read.table(file="v.txt",sep="\t", header=T, quote=" ")

head(v)
nrow(v)

# vegetable:
vegetable = droplevels(subset(v, noun == "vegetable_NOUN" | noun == "vegetables_NOUN" | noun == "Vegetable_NOUN" | noun == "Vegetables_NOUN"))
head(vegetable)
nrow(vegetable)
# vegetable starting 1960
vegetableNew = droplevels(subset(vegetable, year > 1959))
head(vegetableNew)
nrow(vegetableNew)
# frequency
freqVegetable = sum(vegetableNew$match_count)
freqVegetable

# vehicle:
vehicle = droplevels(subset(v, noun == "vehicle_NOUN" | noun == "vehicles_NOUN" | noun == "Vehicle_NOUN" | noun == "Vehicles_NOUN"))
head(vehicle)
nrow(vehicle)
# vehicle starting 1960
vehicleNew = droplevels(subset(vehicle, year > 1959))
head(vehicleNew)
nrow(vehicleNew)
# frequency
freqVehicle = sum(vehicleNew$match_count)
freqVehicle

#load("w.txt")
w = read.table(file="w.txt",sep="\t", header=T, quote=" ")

head(w)
nrow(w)

# wardrobe:
wardrobe = droplevels(subset(w, noun == "wardrobe_NOUN" | noun == "wardrobes_NOUN" | noun == "Wardrobe_NOUN" | noun == "Wardrobes_NOUN"))
head(wardrobe)
nrow(wardrobe)
# wardrobe starting 1960
wardrobeNew = droplevels(subset(wardrobe, year > 1959))
head(wardrobeNew)
nrow(wardrobeNew)
# frequency
freqWardrobe = sum(wardrobeNew$match_count)
freqWardrobe



