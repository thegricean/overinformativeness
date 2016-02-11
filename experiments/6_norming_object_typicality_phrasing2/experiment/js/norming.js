// Returns a random integer between min (included) and max (excluded)
// Using Math.round() will give you a non-uniform distribution!
function getRandomInt(min, max) {
  return Math.floor(Math.random() * (max - min)) + min;
}

function make_slides(f) {
  var   slides = {};
// 	preload(
// ["images/bathrobe.png","images/belt.jpg"],
// {after: function() { console.log("everything's loaded now") }}
// )  

  slides.i0 = slide({
     name : "i0",
     start: function() {
      exp.startT = Date.now();
     }
  });

  slides.instructions = slide({
    name : "instructions",
    button : function() {
      exp.go(); //use exp.go() if and only if there is no "present" data.
    }
  });

  slides.objecttrial = slide({
    name : "objecttrial",
    present : exp.all_stims,
    start : function() {
	$(".err").hide();
    },
      present_handle : function(stim) {
    	this.trial_start = Date.now();
    	this.init_sliders();
      exp.sliderPost = {};
	//$("#objectlabel").val("");	
	  this.stim = stim;
	  console.log(this.stim);
	var contextsentence = "How good of a description is this?";
	var contextlabel = "\"" +stim.label+ "\"";
	var objimagehtml = '<img src="images/'+stim.item+'.jpg" style="height:190px;">';

	$("#contextsentence").html(contextsentence);
	$("#contextlabel").html(contextlabel);
	$("#objectimage").html(objimagehtml);
	  console.log(this);
	},
	button : function() {
	  if (exp.sliderPost > -1 && exp.sliderPost < 16) {
        $(".err").hide();
        this.log_responses();
        _stream.apply(this); //use exp.go() if and only if there is no "present" data.
      } else {
        $(".err").show();
      }
    },
    init_sliders : function() {
      utils.make_slider("#single_slider", function(event, ui) {
        exp.sliderPost = ui.value;
        //$("#number_guess").html(Math.round(ui.value*N));
      });
    },
    log_responses : function() {
        exp.data_trials.push({
          "label" : this.stim.label,
          "slide_number_in_experiment" : exp.phase,
          "item": this.stim.item,
          "rt" : Date.now() - _s.trial_start,
	      "response" : exp.sliderPost
        });
    }
 //     $(".contbutton").click(function() {
	//   var ok_to_go_on = true;
	//   console.log($("#objectlabel").val());
	//   if ($("#objectlabel").val().length < 2) {
	//   	ok_to_go_on = false;
	//   }
 //      if (ok_to_go_on) {
	// $(".contbutton").unbind("click");      	
	// stim.objectlabel = $("#objectlabel").val();         	
 //        exp.data_trials.push({
     //      "objecttype" : stim.objecttype,
     //      "slide_number_in_experiment" : exp.phase,
     //      "item": stim.item,
     //        "rt" : Date.now() - _s.trial_start,
	    // "response" : stim.objectlabel
 //        });
 //          $(".err").hide();
 //          _stream.apply(_s); 
 //      } else {
 //        $(".err").show();
 //      }
	// });
	  
    //  },
  });

  slides.subj_info =  slide({
    name : "subj_info",
    submit : function(e){
      //if (e.preventDefault) e.preventDefault(); // I don't know what this means.
      exp.subj_data = {
        language : $("#language").val(),
        enjoyment : $("#enjoyment").val(),
        asses : $('input[name="assess"]:checked').val(),
        age : $("#age").val(),
        gender : $("#gender").val(),
        education : $("#education").val(),
        comments : $("#comments").val(),
      };
      exp.go(); //use exp.go() if and only if there is no "present" data.
    }
  });

  slides.thanks = slide({
    name : "thanks",
    start : function() {
      exp.data= {
          "trials" : exp.data_trials,
          "catch_trials" : exp.catch_trials,
          "system" : exp.system,
          "condition" : exp.condition,
          "subject_information" : exp.subj_data,
          "time_in_minutes" : (Date.now() - exp.startT)/60000
      };
      setTimeout(function() {turk.submit(exp.data);}, 1000);
    }
  });

  return slides;
}

/// init ///
function init() {

  var items = _.shuffle([
	// {
	// "item": "blackBear",
	// "objecttype": "bear"
	// },
	// {
	// "item": "grizzlyBear",
	// "objecttype": "bear"
	// },
	// {
	// "item": "koalaBear",
	// "objecttype": "bear"
	// },
	// {
	// "item": "pandaBear",
	// "objecttype": "bear"
	// },
	// {
	// "item": "polarBear",
	// "objecttype": "bear"
	// },
	// {
	// "item": "eagle",
	// "objecttype": "bird"
	// },
	// {
	// "item": "hummingBird",
	// "objecttype": "bird"
	// },
	// {
	// "item": "parrot",
	// "objecttype": "bird"
	// },
	// {
	// "item": "pigeon",
	// "objecttype": "bird"
	// },
	// {
	// "item": "sparrow",
	// "objecttype": "bird"
	// },
	// {
	// "item": "dalmatian",
	// "objecttype": "dog"
	// },
	// {
	// "item": "germanShepherd",
	// "objecttype": "dog"
	// },
	// {
	// "item": "greyhound",
	// "objecttype": "dog"
	// },
	// {
	// "item": "husky",
	// "objecttype": "dog"
	// },
	// {
	// "item": "pug",
	// "objecttype": "dog"
	// },
	// {
	// "item": "candyCorn",
	// "objecttype": "candy"
	// },
	// {
	// "item": "gummyBears",
	// "objecttype": "candy"
	// },
	// {
	// "item": "jellyBeans",
	// "objecttype": "candy"
	// },
	// {
	// "item": "mnMs",
	// "objecttype": "candy"
	// },
	// {
	// "item": "skittles",
	// "objecttype": "candy"
	// },
	// {
	// "item": "daisy",
	// "objecttype": "flower"
	// },
	// {
	// "item": "lily",
	// "objecttype": "flower"
	// },
	// {
	// "item": "rose",
	// "objecttype": "flower"
	// },
	// {
	// "item": "sunflower",
	// "objecttype": "flower"
	// },
	// {
	// "item": "tulip",
	// "objecttype": "flower"
	// },
	// {
	// "item": "convertible",
	// "objecttype": "car"
	// },
	// {
	// "item": "minivan",
	// "objecttype": "car"
	// },
	// {
	// "item": "sedan",
	// "objecttype": "car"
	// },
	// {
	// "item": "sportsCar",
	// "objecttype": "car"
	// },
	// {
	// "item": "suv",
	// "objecttype": "car"
	// },
	// {
	// "item": "catfish",
	// "objecttype": "fish"
	// },
	// {
	// "item": "clownFish",
	// "objecttype": "fish"
	// },
	// {
	// "item": "discusFish",
	// "objecttype": "fish"
	// },
	// {
	// "item": "goldFish",
	// "objecttype": "fish"
	// },
	// {
	// "item": "swordFish",
	// "objecttype": "fish"
	// },
	// {
	// "item": "campShirt",
	// "objecttype": "shirt"
	// },
	// {
	// "item": "dressShirt",
	// "objecttype": "shirt"
	// },
	// {
	// "item": "hawaiiShirt",
	// "objecttype": "shirt"
	// },
	// {
	// "item": "poloShirt",
	// "objecttype": "shirt"
	// },
	// {
	// "item": "tShirt",
	// "objecttype": "shirt"
	// },
	// {
	// "item": "bedsideTable",
	// "objecttype": "table"
	// },
	// {
	// "item": "coffeeTable",
	// "objecttype": "table"
	// },
	// {
	// "item": "diningTable",
	// "objecttype": "table"
	// },
	// {
	// "item": "picnicTable",
	// "objecttype": "table"
	// },
	// {
	// "item": "sideTable",
	// "objecttype": "table"
	// },


	//dog1s typeLabel 36
	{
	"item": "blackBear",
	"label": "black bear"
	},
	{
	"item": "grizzlyBear",
	"label": "grizzly bear"
	},
	{
	"item": "pandaBear",
	"label": "panda bear"
	},
	{
	"item": "polarBear",
	"label": "polar bear"
	},
	{
	"item": "eagle",
	"label": "eagle"
	},
	{
	"item": "hummingBird",
	"label": "hummingbird"
	},
	{
	"item": "parrot",
	"label": "parrot"
	},
	{
	"item": "pigeon",
	"label": "pigeon"
	},
	{
	"item": "dalmatian",
	"label": "Dalmatian"
	},
	{
	"item": "germanShepherd",
	"label": "German Shepherd"
	},
	{
	"item": "husky",
	"label": "Husky"
	},
	{
	"item": "pug",
	"label": "Pug"
	},
	{
	"item": "gummyBears",
	"label": "gummy bears"
	},
	{
	"item": "jellyBeans",
	"label": "jelly beans"
	},
	{
	"item": "mnMs",
	"label": "M&M's"
	},
	{
	"item": "skittles",
	"label": "Skittles"
	},
	{
	"item": "daisy",
	"label": "daisy"
	},
	{
	"item": "rose",
	"label": "rose"
	},
	{
	"item": "sunflower",
	"label": "sunflower"
	},
	{
	"item": "tulip",
	"label": "tulip"
	},
	{
	"item": "convertible",
	"label": "convertible"
	},
	{
	"item": "minivan",
	"label": "minivan"
	},
	{
	"item": "sportsCar",
	"label": "sports car"
	},
	{
	"item": "suv",
	"label": "SUV"
	},
	{
	"item": "catfish",
	"label": "catfish"
	},
	{
	"item": "clownFish",
	"label": "clownfish"
	},
	{
	"item": "goldFish",
	"label": "goldfish"
	},
	{
	"item": "swordFish",
	"label": "swordfish"
	},
	{
	"item": "dressShirt",
	"label": "dress shirt"
	},
	{
	"item": "hawaiiShirt",
	"label": "Hawaii shirt"
	},
	{
	"item": "poloShirt",
	"label": "polo shirt"
	},
	{
	"item": "tShirt",
	"label": "T-Shirt"
	},
	{
	"item": "bedsideTable",
	"label": "bedside table"
	},
	{
	"item": "coffeeTable",
	"label": "coffee table"
	},
	{
	"item": "diningTable",
	"label": "dining table"
	},
	{
	"item": "picnicTable",
	"label": "picnic table"
	},
	//dog1s BasiclevelLabel 36
	{
	"item": "blackBear",
	"label": "bear"
	},
	{
	"item": "grizzlyBear",
	"label": "bear"
	},
	{
	"item": "pandaBear",
	"label": "bear"
	},
	{
	"item": "polarBear",
	"label": "bear"
	},
	{
	"item": "eagle",
	"label": "bird"
	},
	{
	"item": "hummingBird",
	"label": "bird"
	},
	{
	"item": "parrot",
	"label": "bird"
	},
	{
	"item": "pigeon",
	"label": "bird"
	},
	{
	"item": "dalmatian",
	"label": "dog"
	},
	{
	"item": "germanShepherd",
	"label": "dog"
	},
	{
	"item": "husky",
	"label": "dog"
	},
	{
	"item": "pug",
	"label": "dog"
	},
	{
	"item": "gummyBears",
	"label": "candy"
	},
	{
	"item": "jellyBeans",
	"label": "candy"
	},
	{
	"item": "mnMs",
	"label": "candy"
	},
	{
	"item": "skittles",
	"label": "candy"
	},
	{
	"item": "daisy",
	"label": "flower"
	},
	{
	"item": "rose",
	"label": "flower",
	},
	{
	"item": "sunflower",
	"label": "flower"
	},
	{
	"item": "tulip",
	"label": "flower"
	},
	{
	"item": "convertible",
	"label": "car"
	},
	{
	"item": "minivan",
	"label": "car"
	},
	{
	"item": "sportsCar",
	"label": "car"
	},
	{
	"item": "suv",
	"label": "car"
	},
	{
	"item": "catfish",
	"label": "fish"
	},
	{
	"item": "clownFish",
	"label": "fish"
	},
	{
	"item": "goldFish",
	"label": "fish"
	},
	{
	"item": "swordFish",
	"label": "fish"
	},
	{
	"item": "dressShirt",
	"label": "shirt"
	},
	{
	"item": "hawaiiShirt",
	"label": "shirt"
	},
	{
	"item": "poloShirt",
	"label": "shirt"
	},
	{
	"item": "tShirt",
	"label": "shirt"
	},
	{
	"item": "bedsideTable",
	"label": "table"
	},
	{
	"item": "coffeeTable",
	"label": "table"
	},
	{
	"item": "diningTable",
	"label": "table"
	},
	{
	"item": "picnicTable",
	"label": "table"
	},


	//dog1s domainLabel 36
	{
	"item": "blackBear",
	"label": "animal"
	},
	{
	"item": "grizzlyBear",
	"label": "animal"
	},
	{
	"item": "pandaBear",
	"label": "animal"
	},
	{
	"item": "polarBear",
	"label": "animal"
	},
	{
	"item": "eagle",
	"label": "animal"
	},
	{
	"item": "hummingBird",
	"label": "animal"
	},
	{
	"item": "parrot",
	"label": "animal"
	},
	{
	"item": "pigeon",
	"label": "animal"
	},
	{
	"item": "dalmatian",
	"label": "animal"
	},
	{
	"item": "germanShepherd",
	"label": "animal"
	},
	{
	"item": "husky",
	"label": "animal"
	},
	{
	"item": "pug",
	"label": "animal"
	},
	{
	"item": "gummyBears",
	"label": "snack"
	},
	{
	"item": "jellyBeans",
	"label": "snack"
	},
	{
	"item": "mnMs",
	"label": "snack"
	},
	{
	"item": "skittles",
	"label": "snack"
	},
	{
	"item": "daisy",
	"label": "plant"
	},
	{
	"item": "rose",
	"label": "plant"
	},
	{
	"item": "sunflower",
	"label": "plant"
	},
	{
	"item": "tulip",
	"label": "plant"
	},
	{
	"item": "convertible",
	"label": "vehicle"
	},
	{
	"item": "minivan",
	"label": "vehicle"
	},
	{
	"item": "sportsCar",
	"label": "vehicle"
	},
	{
	"item": "suv",
	"label": "vehicle"
	},
	{
	"item": "catfish",
	"label": "animal"
	},
	{
	"item": "clownFish",
	"label": "animal"
	},
	{
	"item": "goldFish",
	"label": "animal"
	},
	{
	"item": "swordFish",
	"label": "animal"
	},
	{
	"item": "dressShirt",
	"label": "clothing"
	},
	{
	"item": "hawaiiShirt",
	"label": "clothing"
	},
	{
	"item": "poloShirt",
	"label": "clothing"
	},
	{
	"item": "tShirt",
	"label": "clothing"
	},
	{
	"item": "bedsideTable",
	"label": "furniture"
	},
	{
	"item": "coffeeTable",
	"label": "furniture"
	},
	{
	"item": "diningTable",
	"label": "furniture"
	},
	{
	"item": "picnicTable",
	"label": "furniture"
	},


	//dog2s typeLabel 36
	{
	"item": "koalaBear",
	"label": "black bear"
	},
	{
	"item": "koalaBear",
	"label": "grizzly bear"
	},
	{
	"item": "koalaBear",
	"label": "panda bear"
	},
	{
	"item": "koalaBear",
	"label": "polar bear"
	},

	{
	"item": "sparrow",
	"label": "eagle"
	},
	{
	"item": "sparrow",
	"label": "hummingbird"
	},
	{
	"item": "sparrow",
	"label": "parrot"
	},
	{
	"item": "sparrow",
	"label": "pigeon"
	},

	{
	"item": "greyhound",
	"label": "Dalmatian"
	},
	{
	"item": "greyhound",
	"label": "German Shepherd"
	},
	{
	"item": "greyhound",
	"label": "Husky"
	},
	{
	"item": "greyhound",
	"label": "Pug"
	},

	{
	"item": "candyCorn",
	"label": "gummy bears"
	},
	{
	"item": "candyCorn",
	"label": "jelly beans"
	},
	{
	"item": "candyCorn",
	"label": "M&M's"
	},
	{
	"item": "candyCorn",
	"label": "Skittles"
	},

	{
	"item": "lily",
	"label": "daisy"
	},
	{
	"item": "lily",
	"label": "rose"
	},
	{
	"item": "lily",
	"label": "sunflower"
	},
	{
	"item": "lily",
	"label": "tulip"
	},

	{
	"item": "sedan",
	"label": "convertible"
	},
	{
	"item": "sedan",
	"label": "minivan"
	},
	{
	"item": "sedan",
	"label": "sports car"
	},
	{
	"item": "sedan",
	"label": "SUV"
	},

	{
	"item": "discusFish",
	"label": "catfish"
	},
	{
	"item": "discusFish",
	"label": "clownfish"
	},
	{
	"item": "discusFish",
	"label": "goldfish"
	},
	{
	"item": "discusFish",
	"label": "swordfish"
	},

	{
	"item": "campShirt",
	"label": "dress shirt"
	},
	{
	"item": "campShirt",
	"label": "Hawaii shirt"
	},
	{
	"item": "campShirt",
	"label": "polo shirt"
	},
	{
	"item": "campShirt",
	"label": "T-Shirt"
	},

	{
	"item": "sideTable",
	"label": "bedside table"
	},
	{
	"item": "sideTable",
	"label": "coffee table"
	},
	{
	"item": "sideTable",
	"label": "dining table"
	},
	{
	"item": "sideTable",
	"label": "picnic table"
	},

	//dog2s BLLabel 9
	{
	"item": "koalaBear",
	"label": "bear"
	},
	{
	"item": "greyhound",
	"label": "dog"
	},
	{
	"item": "candyCorn",
	"label": "candy"
	},
	{
	"item": "sideTable",
	"label": "table"
	},
	{
	"item": "campShirt",
	"label": "shirt"
	},
	{
	"item": "discusFish",
	"label": "fish"
	},
	{
	"item": "sparrow",
	"label": "bird"
	},
	{
	"item": "lily",
	"label": "flower"
	},
	{
	"item": "sedan",
	"label": "car"
	},

	//dog2s DomainLabel 9
	{
	"item": "koalaBear",
	"label": "animal"
	},
	{
	"item": "greyhound",
	"label": "animal"
	},
	{
	"item": "candyCorn",
	"label": "snack"
	},
	{
	"item": "sideTable",
	"label": "furniture"
	},
	{
	"item": "campShirt",
	"label": "clothing"
	},
	{
	"item": "discusFish",
	"label": "animal"
	},
	{
	"item": "sparrow",
	"label": "animal"
	},
	{
	"item": "lily",
	"label": "plant"
	},
	{
	"item": "sedan",
	"label": "vehicle"
	},

	// Everything else:
	// ambulance
	{
	"item": "ambulance",
	"label": "sports car"
	},
	{
	"item": "ambulance",
	"label": "convertible"
	},
	{
	"item": "ambulance",
	"label": "SUV"
	},
{
	"item": "ambulance",
	"label": "minivan"
	},
{
	"item": "ambulance",
	"label": "dress shirt"
	},
{
	"item": "ambulance",
	"label": "bedside table"
	},
{
	"item": "ambulance",
	"label": "gummy bears"
	},
{
	"item": "ambulance",
	"label": "parrot"
	},
{
	"item": "ambulance",
	"label": "polar bear"
	},
{
	"item": "ambulance",
	"label": "catfish"
	},
{
	"item": "ambulance",
	"label": "jelly beans"
	},
{
	"item": "ambulance",
	"label": "clownfish"
	},
{
	"item": "ambulance",
	"label": "black bear"
	},
{
	"item": "ambulance",
	"label": "goldfish"
	},
{
	"item": "ambulance",
	"label": "Dalmatian"
	},
{
	"item": "ambulance",
	"label": "Skittles"
	},
{
	"item": "ambulance",
	"label": "car"
	},
{
	"item": "ambulance",
	"label": "shirt"
	},
{
	"item": "ambulance",
	"label": "table"
	},
{
	"item": "ambulance",
	"label": "candy"
	},
{
	"item": "ambulance",
	"label": "bird"
	},
{
	"item": "ambulance",
	"label": "bear"
	},
{
	"item": "ambulance",
	"label": "fish"
	},
{
	"item": "ambulance",
	"label": "dog"
	},
{
	"item": "ambulance",
	"label": "vehicle"
	},
{
	"item": "ambulance",
	"label": "clothing"
	},
{
	"item": "ambulance",
	"label": "furniture"
	},
{
	"item": "ambulance",
	"label": "snack"
	},
{
	"item": "ambulance",
	"label": "animal"
	},
{
	"item": "ambulance",
	"label": "German Shepherd"
	},
{
	"item": "ambulance",
	"label": "grizzly bear"
	},
{
	"item": "ambulance",
	"label": "swordfish"
	},
{
	"item": "ambulance",
	"label": "Husky"
	},
{
	"item": "ambulance",
	"label": "T-Shirt"
	},
{
	"item": "ambulance",
	"label": "pigeon"
	},
	// bathrobe
{
	"item": "bathrobe",
	"label": "T-Shirt"
	},
{
	"item": "bathrobe",
	"label": "dress shirt"
	},
	{
	"item": "bathrobe",
	"label": "Hawaii shirt"
	},
	{
	"item": "bathrobe",
	"label": "polo shirt"
	},
{
	"item": "bathrobe",
	"label": "rose"
	},
	{
	"item": "bathrobe",
	"label": "polar bear"
	},
{
	"item": "bathrobe",
	"label": "swordfish"
	},
{
	"item": "bathrobe",
	"label": "tulip"
	},
{
	"item": "bathrobe",
	"label": "coffee table"
	},
{
	"item": "bathrobe",
	"label": "black bear"
	},
{
	"item": "bathrobe",
	"label": "grizzly bear"
	},
{
	"item": "bathrobe",
	"label": "parrot"
	},
{
	"item": "bathrobe",
	"label": "Skittles"
	},
{
	"item": "bathrobe",
	"label": "minivan"
	},
{
	"item": "bathrobe",
	"label": "eagle"
	},
{
	"item": "bathrobe",
	"label": "clownfish"
	},
{
	"item": "bathrobe",
	"label": "SUV"
	},
{
	"item": "bathrobe",
	"label": "shirt"
	},
{
	"item": "bathrobe",
	"label": "flower"
	},
{
	"item": "bathrobe",
	"label": "bear"
	},
{
	"item": "bathrobe",
	"label": "fish"
	},
{
	"item": "bathrobe",
	"label": "table"
	},
{
	"item": "bathrobe",
	"label": "bird"
	},
{
	"item": "bathrobe",
	"label": "candy"
	},
{
	"item": "bathrobe",
	"label": "car"
	},
{
	"item": "bathrobe",
	"label": "clothing"
	},
{
	"item": "bathrobe",
	"label": "plant"
	},
{
	"item": "bathrobe",
	"label": "animal"
	},
{
	"item": "bathrobe",
	"label": "furniture"
	},
{
	"item": "bathrobe",
	"label": "snack"
	},
{
	"item": "bathrobe",
	"label": "vehicle"
	},
{
	"item": "bathrobe",
	"label": "goldfish"
	},
{
	"item": "bathrobe",
	"label": "pug"
	},
{
	"item": "bathrobe",
	"label": "convertible"
	},
{
	"item": "bathrobe",
	"label": "dining table"
	},
{
	"item": "bathrobe",
	"label": "picnic table"
	},
{
	"item": "bathrobe",
	"label": "Husky"
	},
{
	"item": "bathrobe",
	"label": "catfish"
	},
{
	"item": "bathrobe",
	"label": "dog"
	},
	// bed
{
	"item": "bed",
	"label": "coffee table"
	},
	{
	"item": "bed",
	"label": "picnic table"
	},
{
	"item": "bed",
	"label": "dining table"
	},
{
	"item": "bed",
	"label": "jelly beans"
	},
{
	"item": "bed",
	"label": "clownfish"
	},
{
	"item": "bed",
	"label": "Hawaii shirt"
	},
{
	"item": "bed",
	"label": "Dalmatian"
	},
{
	"item": "bed",
	"label": "parrot"
	},
{
	"item": "bed",
	"label": "tulip"
	},
{
	"item": "bed",
	"label": "goldfish"
	},
{
	"item": "bed",
	"label": "panda bear"
	},
{
	"item": "bed",
	"label": "pigeon"
	},
{
	"item": "bed",
	"label": "Husky"
	},
{
	"item": "bed",
	"label": "table"
	},
{
	"item": "bed",
	"label": "candy"
	},
{
	"item": "bed",
	"label": "fish"
	},
{
	"item": "bed",
	"label": "shirt"
	},
{
	"item": "bed",
	"label": "dog"
	},
{
	"item": "bed",
	"label": "bird"
	},
{
	"item": "bed",
	"label": "flower"
	},
{
	"item": "bed",
	"label": "bear"
	},
{
	"item": "bed",
	"label": "furniture"
	},
{
	"item": "bed",
	"label": "snack"
	},
{
	"item": "bed",
	"label": "animal"
	},
{
	"item": "bed",
	"label": "clothing"
	},
{
	"item": "bed",
	"label": "plant"
	},
{
	"item": "bed",
	"label": "bedside table"
	},
{
	"item": "bed",
	"label": "SUV"
	},
{
	"item": "bed",
	"label": "hummingbird"
	},
{
	"item": "bed",
	"label": "German Shepherd"
	},
{
	"item": "bed",
	"label": "grizzly bear"
	},
{
	"item": "bed",
	"label": "black bear"
	},
{
	"item": "bed",
	"label": "catfish"
	},
{
	"item": "bed",
	"label": "car"
	},
{
	"item": "bed",
	"label": "vehicle"
	},
	// bison
{
	"item": "bison",
	"label": "panda bear"
	},
{
	"item": "bison",
	"label": "hummingbird"
	},
{
	"item": "bison",
	"label": "polar bear"
	},
{
	"item": "bison",
	"label": "goldfish"
	},
{
	"item": "bison",
	"label": "pug"
	},
{
	"item": "bison",
	"label": "parrot"
	},
{
	"item": "bison",
	"label": "swordfish"
	},
{
	"item": "bison",
	"label": "black bear"
	},
{
	"item": "bison",
	"label": "eagle"
	},
{
	"item": "bison",
	"label": "catfish"
	},
{
	"item": "bison",
	"label": "clownfish"
	},
{
	"item": "bison",
	"label": "Dalmatian"
	},
{
	"item": "bison",
	"label": "German Shepherd"
	},
{
	"item": "bison",
	"label": "Hawaii shirt"
	},
{
	"item": "bison",
	"label": "Skittles"
	},
{
	"item": "bison",
	"label": "bedside table"
	},
{
	"item": "bison",
	"label": "SUV"
	},
{
	"item": "bison",
	"label": "rose"
	},
{
	"item": "bison",
	"label": "coffee table"
	},
{
	"item": "bison",
	"label": "minivan"
	},
{
	"item": "bison",
	"label": "daisy"
	},
{
	"item": "bison",
	"label": "bear"
	},
{
	"item": "bison",
	"label": "bird"
	},
{
	"item": "bison",
	"label": "fish"
	},
{
	"item": "bison",
	"label": "dog"
	},
{
	"item": "bison",
	"label": "shirt"
	},
{
	"item": "bison",
	"label": "candy"
	},
{
	"item": "bison",
	"label": "table"
	},
{
	"item": "bison",
	"label": "car"
	},
{
	"item": "bison",
	"label": "flower"
	},
{
	"item": "bison",
	"label": "animal"
	},
{
	"item": "bison",
	"label": "clothing"
	},
{
	"item": "bison",
	"label": "snack"
	},
{
	"item": "bison",
	"label": "furniture"
	},
{
	"item": "bison",
	"label": "vehicle"
	},
{
	"item": "bison",
	"label": "plant"
	},
{
	"item": "bison",
	"label": "grizzly bear"
	},
{
	"item": "bison",
	"label": "convertible"
	},
{
	"item": "bison",
	"label": "polo shirt"
	},
{
	"item": "bison",
	"label": "M&M's"
	},
{
	"item": "bison",
	"label": "tulip"
	},
	// bookcase
{
	"item": "bookcase",
	"label": "coffee table"
	},
{
	"item": "bookcase",
	"label": "picnic table"
	},
{
	"item": "bookcase",
	"label": "dining table"
	},
{
	"item": "bookcase",
	"label": "bedside table"
	},
{
	"item": "bookcase",
	"label": "hummingbird"
	},
{
	"item": "bookcase",
	"label": "panda bear"
	},
{
	"item": "bookcase",
	"label": "grizzly bear"
	},
{
	"item": "bookcase",
	"label": "swordfish"
	},
{
	"item": "bookcase",
	"label": "black bear"
	},
{
	"item": "bookcase",
	"label": "pug"
	},
{
	"item": "bookcase",
	"label": "pigeon"
	},
{
	"item": "bookcase",
	"label": "Skittles"
	},
{
	"item": "bookcase",
	"label": "table"
	},
{
	"item": "bookcase",
	"label": "bird"
	},
{
	"item": "bookcase",
	"label": "bear"
	},
{
	"item": "bookcase",
	"label": "fish"
	},
{
	"item": "bookcase",
	"label": "dog"
	},
{
	"item": "bookcase",
	"label": "candy"
	},
{
	"item": "bookcase",
	"label": "furniture"
	},
{
	"item": "bookcase",
	"label": "animal"
	},
{
	"item": "bookcase",
	"label": "snack"
	},
{
	"item": "bookcase",
	"label": "rose"
	},
{
	"item": "bookcase",
	"label": "polo shirt"
	},
{
	"item": "bookcase",
	"label": "clownfish"
	},
{
	"item": "bookcase",
	"label": "tulip"
	},
{
	"item": "bookcase",
	"label": "Husky"
	},
{
	"item": "bookcase",
	"label": "flower"
	},
{
	"item": "bookcase",
	"label": "shirt"
	},
{
	"item": "bookcase",
	"label": "plant"
	},
{
	"item": "bookcase",
	"label": "clothing"
	},
	// chick
	{
	"item": "chick",
	"label": "parrot"
	},
{
	"item": "chick",
	"label": "Husky"
	},
{
	"item": "chick",
	"label": "polar bear"
	},
{
	"item": "chick",
	"label": "pigeon"
	},
{
	"item": "chick",
	"label": "catfish"
	},
{
	"item": "chick",
	"label": "German Shepherd"
	},
{
	"item": "chick",
	"label": "panda bear"
	},
{
	"item": "chick",
	"label": "Pug"
	},
{
	"item": "chick",
	"label": "hummingbird"
	},
{
	"item": "chick",
	"label": "goldfish"
	},
{
	"item": "chick",
	"label": "swordfish"
	},
{
	"item": "chick",
	"label": "dress shirt"
	},
{
	"item": "chick",
	"label": "rose"
	},
{
	"item": "chick",
	"label": "M&M's"
	},
{
	"item": "chick",
	"label": "picnic table"
	},
{
	"item": "chick",
	"label": "Hawaii shirt"
	},
{
	"item": "chick",
	"label": "convertible"
	},
{
	"item": "chick",
	"label": "dog"
	},
{
	"item": "chick",
	"label": "bird"
	},
{
	"item": "chick",
	"label": "bear"
	},
{
	"item": "chick",
	"label": "fish"
	},
{
	"item": "chick",
	"label": "shirt"
	},
{
	"item": "chick",
	"label": "flower"
	},
{
	"item": "chick",
	"label": "candy"
	},
{
	"item": "chick",
	"label": "table"
	},
{
	"item": "chick",
	"label": "car"
	},
{
	"item": "chick",
	"label": "animal"
	},
{
	"item": "chick",
	"label": "clothing"
	},
{
	"item": "chick",
	"label": "plant"
	},
{
	"item": "chick",
	"label": "snack"
	},
{
	"item": "chick",
	"label": "furniture"
	},
{
	"item": "chick",
	"label": "vehicle"
	},
{
	"item": "chick",
	"label": "black bear"
	},
{
	"item": "chick",
	"label": "Dalmatian"
	},
{
	"item": "chick",
	"label": "coffee table"
	},
{
	"item": "chick",
	"label": "gummy bears"
	},

	//chips
{
	"item": "chips",
	"label": "M&M's"
	},
{
	"item": "chips",
	"label": "gummy bears"
	},
{
	"item": "chips",
	"label": "Skittles"
	},
{
	"item": "chips",
	"label": "jelly beans"
	},
{
	"item": "chips",
	"label": "hummingbird"
	},
{
	"item": "chips",
	"label": "tulip"
	},
{
	"item": "chips",
	"label": "polar bear"
	},
{
	"item": "chips",
	"label": "pigeon"
	},
{
	"item": "chips",
	"label": "dress shirt"
	},
{
	"item": "chips",
	"label": "eagle"
	},
{
	"item": "chips",
	"label": "Husky"
	},
{
	"item": "chips",
	"label": "grizzly bear"
	},
{
	"item": "chips",
	"label": "Dalmatian"
	},
{
	"item": "chips",
	"label": "sports car"
	},
{
	"item": "chips",
	"label": "candy"
	},
{
	"item": "chips",
	"label": "bird"
	},
{
	"item": "chips",
	"label": "flower"
	},
{
	"item": "chips",
	"label": "bear"
	},
{
	"item": "chips",
	"label": "shirt"
	},
{
	"item": "chips",
	"label": "dog"
	},
{
	"item": "chips",
	"label": "car"
	},
{
	"item": "chips",
	"label": "snack"
	},
{
	"item": "chips",
	"label": "animal"
	},
{
	"item": "chips",
	"label": "plant"
	},
{
	"item": "chips",
	"label": "clothing"
	},
{
	"item": "chips",
	"label": "vehicle"
	},
{
	"item": "chips",
	"label": "dining table"
	},
{
	"item": "chips",
	"label": "black bear"
	},
{
	"item": "chips",
	"label": "SUV"
	},
{
	"item": "chips",
	"label": "table"
	},
{
	"item": "chips",
	"label": "furniture"
	},
	// cookies
	{
	"item": "cookies",
	"label": "Skittles"
	},
	{
	"item": "cookies",
	"label": "jelly beans"
	},
	{
	"item": "cookies",
	"label": "M&M's"
	},
	{
	"item": "cookies",
	"label": "gummy bears"
	},
	{
	"item": "cookies",
	"label": "polo shirt"
	},
{
	"item": "cookies",
	"label": "sports car"
	},
{
	"item": "cookies",
	"label": "Husky"
	},
{
	"item": "cookies",
	"label": "swordfish"
	},
{
	"item": "cookies",
	"label": "picnic table"
	},
{
	"item": "cookies",
	"label": "pigeon"
	},
{
	"item": "cookies",
	"label": "Dalmatian"
	},
{
	"item": "cookies",
	"label": "tulip"
	},
{
	"item": "cookies",
	"label": "bedside table"
	},
{
	"item": "cookies",
	"label": "sunflower"
	},
{
	"item": "cookies",
	"label": "candy"
	},
{
	"item": "cookies",
	"label": "shirt"
	},
{
	"item": "cookies",
	"label": "car"
	},
{
	"item": "cookies",
	"label": "dog"
	},
{
	"item": "cookies",
	"label": "fish"
	},
{
	"item": "cookies",
	"label": "table"
	},
{
	"item": "cookies",
	"label": "bird"
	},
{
	"item": "cookies",
	"label": "flower"
	},
{
	"item": "cookies",
	"label": "snack"
	},
{
	"item": "cookies",
	"label": "clothing"
	},
{
	"item": "cookies",
	"label": "vehicle"
	},
{
	"item": "cookies",
	"label": "animal"
	},
{
	"item": "cookies",
	"label": "furniture"
	},
{
	"item": "cookies",
	"label": "plant"
	},
{
	"item": "cookies",
	"label": "dress shirt"
	},
{
	"item": "cookies",
	"label": "eagle"
	},
{
	"item": "cookies",
	"label": "convertible"
	},
{
	"item": "cookies",
	"label": "Pug"
	},
{
	"item": "cookies",
	"label": "SUV"
	},
{
	"item": "cookies",
	"label": "black bear"
	},
{
	"item": "cookies",
	"label": "catfish"
	},
{
	"item": "cookies",
	"label": "parrot"
	},
{
	"item": "cookies",
	"label": "rose"
	},
{
	"item": "cookies",
	"label": "polar bear"
	},
{
	"item": "cookies",
	"label": "grizzly bear"
	},
{
	"item": "cookies",
	"label": "bear"
	},
	//cow
{
	"item": "cow",
	"label": "catfish"
	},
{
	"item": "cow",
	"label": "polar bear"
	},
{
	"item": "cow",
	"label": "grizzly bear"
	},
{
	"item": "cow",
	"label": "black bear"
	},
{
	"item": "cow",
	"label": "German Shepherd"
	},
{
	"item": "cow",
	"label": "goldfish"
	},
{
	"item": "cow",
	"label": "panda bear"
	},
{
	"item": "cow",
	"label": "swordfish"
	},
{
	"item": "cow",
	"label": "Husky"
	},
{
	"item": "cow",
	"label": "eagle"
	},
{
	"item": "cow",
	"label": "clownfish"
	},
{
	"item": "cow",
	"label": "Dalmatian"
	},
{
	"item": "cow",
	"label": "parrot"
	},
{
	"item": "cow",
	"label": "gummy bears"
	},
{
	"item": "cow",
	"label": "SUV"
	},
{
	"item": "cow",
	"label": "sunflower"
	},
{
	"item": "cow",
	"label": "minivan"
	},
{
	"item": "cow",
	"label": "fish"
	},
{
	"item": "cow",
	"label": "bear"
	},
{
	"item": "cow",
	"label": "dog"
	},
{
	"item": "cow",
	"label": "bird"
	},
{
	"item": "cow",
	"label": "candy"
	},
{
	"item": "cow",
	"label": "car"
	},
{
	"item": "cow",
	"label": "flower"
	},
{
	"item": "cow",
	"label": "animal"
	},
{
	"item": "cow",
	"label": "snack"
	},
{
	"item": "cow",
	"label": "vehicle"
	},
{
	"item": "cow",
	"label": "plant"
	},
{
	"item": "cow",
	"label": "pigeon"
	},
{
	"item": "cow",
	"label": "rose"
	},
{
	"item": "cow",
	"label": "dress shirt"
	},
{
	"item": "cow",
	"label": "dining table"
	},
{
	"item": "cow",
	"label": "tulip"
	},
{
	"item": "cow",
	"label": "T-Shirt"
	},
{
	"item": "cow",
	"label": "shirt"
	},
{
	"item": "cow",
	"label": "table"
	},
{
	"item": "cow",
	"label": "clothing"
	},
{
	"item": "cow",
	"label": "furniture"
	},
	//crocodile
	{
	"item": "crocodile",
	"label": "pigeon"
	},
{
	"item": "crocodile",
	"label": "grizzly bear"
	},
{
	"item": "crocodile",
	"label": "German Shepherd"
	},
{
	"item": "crocodile",
	"label": "Husky"
	},
{
	"item": "crocodile",
	"label": "Pug"
	},
{
	"item": "crocodile",
	"label": "polar bear"
	},
{
	"item": "crocodile",
	"label": "panda bear"
	},
{
	"item": "crocodile",
	"label": "Dalmatian"
	},
{
	"item": "crocodile",
	"label": "picnic table"
	},
{
	"item": "crocodile",
	"label": "coffee table"
	},
{
	"item": "crocodile",
	"label": "minivan"
	},
{
	"item": "crocodile",
	"label": "tulip"
	},
{
	"item": "crocodile",
	"label": "bedside table"
	},
{
	"item": "crocodile",
	"label": "convertible"
	},
{
	"item": "crocodile",
	"label": "M&M's"
	},
{
	"item": "crocodile",
	"label": "polo shirt"
	},
{
	"item": "crocodile",
	"label": "bird"
	},
{
	"item": "crocodile",
	"label": "bear"
	},
{
	"item": "crocodile",
	"label": "dog"
	},
{
	"item": "crocodile",
	"label": "table"
	},
{
	"item": "crocodile",
	"label": "car"
	},
{
	"item": "crocodile",
	"label": "flower"
	},
{
	"item": "crocodile",
	"label": "candy"
	},
{
	"item": "crocodile",
	"label": "shirt"
	},
{
	"item": "crocodile",
	"label": "animal"
	},
{
	"item": "crocodile",
	"label": "furniture"
	},
{
	"item": "crocodile",
	"label": "vehicle"
	},
{
	"item": "crocodile",
	"label": "plant"
	},
{
	"item": "crocodile",
	"label": "snack"
	},
{
	"item": "crocodile",
	"label": "clothing"
	},
{
	"item": "crocodile",
	"label": "parrot"
	},
{
	"item": "crocodile",
	"label": "hummingbird"
	},
{
	"item": "crocodile",
	"label": "SUV"
	},
{
	"item": "crocodile",
	"label": "clownfish"
	},
{
	"item": "crocodile",
	"label": "dining table"
	},
{
	"item": "crocodile",
	"label": "jelly beans"
	},
{
	"item": "crocodile",
	"label": "fish"
	},
	//dress
	{
	"item": "dress",
	"label": "Hawaii shirt"
	},
{
	"item": "dress",
	"label": "polo shirt"
	},
{
	"item": "dress",
	"label": "T-Shirt"
	},
{
	"item": "dress",
	"label": "dress shirt"
	},
{
	"item": "dress",
	"label": "bedside table"
	},
{
	"item": "dress",
	"label": "Dalmatian"
	},
{
	"item": "dress",
	"label": "panda bear"
	},
{
	"item": "dress",
	"label": "sunflower"
	},
{
	"item": "dress",
	"label": "sports car"
	},
{
	"item": "dress",
	"label": "picnic table"
	},
{
	"item": "dress",
	"label": "catfish"
	},
{
	"item": "dress",
	"label": "minivan"
	},
{
	"item": "dress",
	"label": "M&M's"
	},
{
	"item": "dress",
	"label": "convertible"
	},
{
	"item": "dress",
	"label": "Husky"
	},
{
	"item": "dress",
	"label": "eagle"
	},
{
	"item": "dress",
	"label": "rose"
	},
{
	"item": "dress",
	"label": "coffee table"
	},
{
	"item": "dress",
	"label": "black bear"
	},
{
	"item": "dress",
	"label": "shirt"
	},
{
	"item": "dress",
	"label": "table"
	},
{
	"item": "dress",
	"label": "dog"
	},
{
	"item": "dress",
	"label": "bear"
	},
{
	"item": "dress",
	"label": "flower"
	},
{
	"item": "dress",
	"label": "car"
	},
{
	"item": "dress",
	"label": "fish"
	},
{
	"item": "dress",
	"label": "candy"
	},
{
	"item": "dress",
	"label": "bird"
	},
{
	"item": "dress",
	"label": "clothing"
	},
{
	"item": "dress",
	"label": "furniture"
	},
{
	"item": "dress",
	"label": "animal"
	},
{
	"item": "dress",
	"label": "plant"
	},
{
	"item": "dress",
	"label": "vehicle"
	},
{
	"item": "dress",
	"label": "snack"
	},
{
	"item": "dress",
	"label": "parrot"
	},
{
	"item": "dress",
	"label": "German Shepherd"
	},
{
	"item": "dress",
	"label": "grizzly bear"
	},
{
	"item": "dress",
	"label": "goldfish"
	},
{
	"item": "dress",
	"label": "Skittles"
	},
{
	"item": "dress",
	"label": "swordfish"
	},
{
	"item": "dress",
	"label": "SUV"
	},
{
	"item": "dress",
	"label": "clownfish"
	},
	//elephant
	{
	"item": "elephant",
	"label": "panda bear"
	},
{
	"item": "elephant",
	"label": "eagle"
	},
{
	"item": "elephant",
	"label": "swordfish"
	},
{
	"item": "elephant",
	"label": "hummingbird"
	},
{
	"item": "elephant",
	"label": "parrot"
	},
{
	"item": "elephant",
	"label": "black bear"
	},
{
	"item": "elephant",
	"label": "polar bear"
	},
{
	"item": "elephant",
	"label": "catfish"
	},
{
	"item": "elephant",
	"label": "pigeon"
	},
{
	"item": "elephant",
	"label": "German Shepherd"
	},
{
	"item": "elephant",
	"label": "clownfish"
	},
{
	"item": "elephant",
	"label": "grizzly bear"
	},
{
	"item": "elephant",
	"label": "SUV"
	},
{
	"item": "elephant",
	"label": "dining table"
	},
{
	"item": "elephant",
	"label": "daisy"
	},
{
	"item": "elephant",
	"label": "convertible"
	},
{
	"item": "elephant",
	"label": "bear"
	},
{
	"item": "elephant",
	"label": "bird"
	},
{
	"item": "elephant",
	"label": "fish"
	},
{
	"item": "elephant",
	"label": "dog"
	},
{
	"item": "elephant",
	"label": "car"
	},
{
	"item": "elephant",
	"label": "table"
	},
{
	"item": "elephant",
	"label": "flower"
	},
{
	"item": "elephant",
	"label": "animal"
	},
{
	"item": "elephant",
	"label": "vehicle"
	},
{
	"item": "elephant",
	"label": "furniture"
	},
{
	"item": "elephant",
	"label": "plant"
	},
{
	"item": "elephant",
	"label": "Dalmatian"
	},
{
	"item": "elephant",
	"label": "sports car"
	},
{
	"item": "elephant",
	"label": "bedside table"
	},
{
	"item": "elephant",
	"label": "M&M's"
	},
{
	"item": "elephant",
	"label": "rose"
	},
{
	"item": "elephant",
	"label": "coffee table"
	},
{
	"item": "elephant",
	"label": "dress shirt"
	},
{
	"item": "elephant",
	"label": "candy"
	},
{
	"item": "elephant",
	"label": "shirt"
	},
{
	"item": "elephant",
	"label": "snack"
	},
{
	"item": "elephant",
	"label": "clothing"
	},
	//firetruck
	{
	"item": "firetruck",
	"label": "convertible"
	},
{
	"item": "firetruck",
	"label": "sports car"
	},
{
	"item": "firetruck",
	"label": "SUV"
	},
{
	"item": "firetruck",
	"label": "minivan"
	},
{
	"item": "firetruck",
	"label": "Hawaii shirt"
	},
{
	"item": "firetruck",
	"label": "dining table"
	},
{
	"item": "firetruck",
	"label": "grizzly bear"
	},
{
	"item": "firetruck",
	"label": "swordfish"
	},
{
	"item": "firetruck",
	"label": "catfish"
	},
{
	"item": "firetruck",
	"label": "gummy bears"
	},
{
	"item": "firetruck",
	"label": "polo shirt"
	},
{
	"item": "firetruck",
	"label": "picnic table"
	},
{
	"item": "firetruck",
	"label": "black bear"
	},
{
	"item": "firetruck",
	"label": "German Shepherd"
	},
{
	"item": "firetruck",
	"label": "polar bear"
	},
{
	"item": "firetruck",
	"label": "car"
	},
{
	"item": "firetruck",
	"label": "shirt"
	},
{
	"item": "firetruck",
	"label": "table"
	},
{
	"item": "firetruck",
	"label": "bear"
	},
{
	"item": "firetruck",
	"label": "fish"
	},
{
	"item": "firetruck",
	"label": "candy"
	},
{
	"item": "firetruck",
	"label": "dog"
	},
{
	"item": "firetruck",
	"label": "vehicle"
	},
{
	"item": "firetruck",
	"label": "clothing"
	},
{
	"item": "firetruck",
	"label": "furniture"
	},
{
	"item": "firetruck",
	"label": "animal"
	},
{
	"item": "firetruck",
	"label": "snack"
	},
{
	"item": "firetruck",
	"label": "jelly beans"
	},
{
	"item": "firetruck",
	"label": "tulip"
	},
{
	"item": "firetruck",
	"label": "rose"
	},
{
	"item": "firetruck",
	"label": "hummingbird"
	},
{
	"item": "firetruck",
	"label": "clownfish"
	},
{
	"item": "firetruck",
	"label": "sunflower"
	},
{
	"item": "firetruck",
	"label": "Husky"
	},
{
	"item": "firetruck",
	"label": "pigeon"
	},
{
	"item": "firetruck",
	"label": "eagle"
	},
{
	"item": "firetruck",
	"label": "Skittles"
	},
{
	"item": "firetruck",
	"label": "flower"
	},
{
	"item": "firetruck",
	"label": "bird"
	},
{
	"item": "firetruck",
	"label": "plant"
	},
	// gloves
{
	"item": "gloves",
	"label": "polo shirt"
	},
{
	"item": "gloves",
	"label": "Hawaii shirt"
	},
{
	"item": "gloves",
	"label": "T-Shirt"
	},
{
	"item": "gloves",
	"label": "dress shirt"
	},
{
	"item": "gloves",
	"label": "grizzly bear"
	},
{
	"item": "gloves",
	"label": "German Shepherd"
	},
{
	"item": "gloves",
	"label": "black bear"
	},
{
	"item": "gloves",
	"label": "panda bear"
	},
{
	"item": "gloves",
	"label": "M&M's"
	},
{
	"item": "gloves",
	"label": "sunflower"
	},
{
	"item": "gloves",
	"label": "Skittles"
	},
{
	"item": "gloves",
	"label": "Dalmatian"
	},
{
	"item": "gloves",
	"label": "swordfish"
	},
{
	"item": "gloves",
	"label": "coffee table"
	},
{
	"item": "gloves",
	"label": "shirt"
	},
{
	"item": "gloves",
	"label": "bear"
	},
{
	"item": "gloves",
	"label": "dog"
	},
{
	"item": "gloves",
	"label": "candy"
	},
{
	"item": "gloves",
	"label": "flower"
	},
{
	"item": "gloves",
	"label": "fish"
	},
{
	"item": "gloves",
	"label": "table"
	},
{
	"item": "gloves",
	"label": "clothing"
	},
{
	"item": "gloves",
	"label": "animal"
	},
{
	"item": "gloves",
	"label": "snack"
	},
{
	"item": "gloves",
	"label": "plant"
	},
{
	"item": "gloves",
	"label": "furniture"
	},
{
	"item": "gloves",
	"label": "picnic table"
	},
{
	"item": "gloves",
	"label": "minivan"
	},
{
	"item": "gloves",
	"label": "clownfish"
	},
{
	"item": "gloves",
	"label": "car"
	},
{
	"item": "gloves",
	"label": "vehicle"
	},
	//grasses
	{
	"item": "grasses",
	"label": "rose"
	},
{
	"item": "grasses",
	"label": "sunflower"
	},
{
	"item": "grasses",
	"label": "daisy"
	},
{
	"item": "grasses",
	"label": "tulip"
	},
{
	"item": "grasses",
	"label": "T-Shirt"
	},
{
	"item": "grasses",
	"label": "Skittles"
	},
{
	"item": "grasses",
	"label": "polar bear"
	},
{
	"item": "grasses",
	"label": "clownfish"
	},
{
	"item": "grasses",
	"label": "convertible"
	},
{
	"item": "grasses",
	"label": "goldfish"
	},
{
	"item": "grasses",
	"label": "eagle"
	},
{
	"item": "grasses",
	"label": "black bear"
	},
{
	"item": "grasses",
	"label": "hummingbird"
	},
{
	"item": "grasses",
	"label": "Husky"
	},
{
	"item": "grasses",
	"label": "picnic table"
	},
{
	"item": "grasses",
	"label": "pigeon"
	},
{
	"item": "grasses",
	"label": "flower"
	},
{
	"item": "grasses",
	"label": "shirt"
	},
{
	"item": "grasses",
	"label": "candy"
	},
{
	"item": "grasses",
	"label": "bear"
	},
{
	"item": "grasses",
	"label": "fish"
	},
{
	"item": "grasses",
	"label": "car"
	},
{
	"item": "grasses",
	"label": "bird"
	},
{
	"item": "grasses",
	"label": "dog"
	},
{
	"item": "grasses",
	"label": "table"
	},
{
	"item": "grasses",
	"label": "plant"
	},
{
	"item": "grasses",
	"label": "clothing"
	},
{
	"item": "grasses",
	"label": "snack"
	},
{
	"item": "grasses",
	"label": "animal"
	},
{
	"item": "grasses",
	"label": "vehicle"
	},
{
	"item": "grasses",
	"label": "furniture"
	},
{
	"item": "grasses",
	"label": "panda bear"
	},
{
	"item": "grasses",
	"label": "SUV"
	},
{
	"item": "grasses",
	"label": "M&M's"
	},
{
	"item": "grasses",
	"label": "minivan"
	},
{
	"item": "grasses",
	"label": "Pug"
	},
{
	"item": "grasses",
	"label": "polo shirt"
	},
{
	"item": "grasses",
	"label": "Dalmatian"
	},
{
	"item": "grasses",
	"label": "grizzly bear"
	},
	//horse
	{
	"item": "horse",
	"label": "goldfish"
	},
{
	"item": "horse",
	"label": "clownfish"
	},
{
	"item": "horse",
	"label": "German Shepherd"
	},
{
	"item": "horse",
	"label": "Husky"
	},
{
	"item": "horse",
	"label": "Dalmatian"
	},
{
	"item": "horse",
	"label": "hummingbird"
	},
{
	"item": "horse",
	"label": "swordfish"
	},
{
	"item": "horse",
	"label": "black bear"
	},
{
	"item": "horse",
	"label": "panda bear"
	},
{
	"item": "horse",
	"label": "dress shirt"
	},
{
	"item": "horse",
	"label": "bedside table"
	},
{
	"item": "horse",
	"label": "daisy"
	},
{
	"item": "horse",
	"label": "grizzly bear"
	},
{
	"item": "horse",
	"label": "gummy bears"
	},
{
	"item": "horse",
	"label": "Hawaii shirt"
	},
{
	"item": "horse",
	"label": "fish"
	},
{
	"item": "horse",
	"label": "dog"
	},
{
	"item": "horse",
	"label": "bird"
	},
{
	"item": "horse",
	"label": "bear"
	},
{
	"item": "horse",
	"label": "shirt"
	},
{
	"item": "horse",
	"label": "table"
	},
{
	"item": "horse",
	"label": "flower"
	},
{
	"item": "horse",
	"label": "candy"
	},
{
	"item": "horse",
	"label": "animal"
	},
{
	"item": "horse",
	"label": "clothing"
	},
{
	"item": "horse",
	"label": "furniture"
	},
{
	"item": "horse",
	"label": "plant"
	},
{
	"item": "horse",
	"label": "snack"
	},
{
	"item": "horse",
	"label": "eagle"
	},
{
	"item": "horse",
	"label": "catfish"
	},
{
	"item": "horse",
	"label": "polar bear"
	},
{
	"item": "horse",
	"label": "tulip"
	},
{
	"item": "horse",
	"label": "rose"
	},
{
	"item": "horse",
	"label": "convertible"
	},
{
	"item": "horse",
	"label": "minivan"
	},
{
	"item": "horse",
	"label": "car"
	},
{
	"item": "horse",
	"label": "vehicle"
	},
	//iguana
	{
	"item": "iguana",
	"label": "catfish"
	},
{
	"item": "iguana",
	"label": "pigeon"
	},
{
	"item": "iguana",
	"label": "swordfish"
	},
{
	"item": "iguana",
	"label": "German Shepherd"
	},
{
	"item": "iguana",
	"label": "panda bear"
	},
{
	"item": "iguana",
	"label": "clownfish"
	},
{
	"item": "iguana",
	"label": "goldfish"
	},
{
	"item": "iguana",
	"label": "black bear"
	},
{
	"item": "iguana",
	"label": "Pug"
	},
{
	"item": "iguana",
	"label": "grizzly bear"
	},
{
	"item": "iguana",
	"label": "parrot"
	},
{
	"item": "iguana",
	"label": "bedside table"
	},
{
	"item": "iguana",
	"label": "minivan"
	},
{
	"item": "iguana",
	"label": "convertible"
	},
{
	"item": "iguana",
	"label": "M&M's"
	},
{
	"item": "iguana",
	"label": "sunflower"
	},
{
	"item": "iguana",
	"label": "dining table"
	},
{
	"item": "iguana",
	"label": "fish"
	},
{
	"item": "iguana",
	"label": "bird"
	},
{
	"item": "iguana",
	"label": "dog"
	},
{
	"item": "iguana",
	"label": "bear"
	},
{
	"item": "iguana",
	"label": "table"
	},
{
	"item": "iguana",
	"label": "car"
	},
{
	"item": "iguana",
	"label": "candy"
	},
{
	"item": "iguana",
	"label": "flower"
	},
{
	"item": "iguana",
	"label": "animal"
	},
{
	"item": "iguana",
	"label": "furniture"
	},
{
	"item": "iguana",
	"label": "vehicle"
	},
{
	"item": "iguana",
	"label": "snack"
	},
{
	"item": "iguana",
	"label": "plant"
	},
{
	"item": "iguana",
	"label": "eagle"
	},
{
	"item": "iguana",
	"label": "Husky"
	},
{
	"item": "iguana",
	"label": "jelly beans"
	},
{
	"item": "iguana",
	"label": "sports car"
	},
{
	"item": "iguana",
	"label": "Skittles"
	},
	// ivy
	{
	"item": "ivy",
	"label": "sunflower"
	},
{
	"item": "ivy",
	"label": "tulip"
	},
{
	"item": "ivy",
	"label": "daisy"
	},
{
	"item": "ivy",
	"label": "rose"
	},
{
	"item": "ivy",
	"label": "picnic table"
	},
{
	"item": "ivy",
	"label": "Dalmatian"
	},
{
	"item": "ivy",
	"label": "polar bear"
	},
{
	"item": "ivy",
	"label": "polo shirt"
	},
{
	"item": "ivy",
	"label": "parrot"
	},
{
	"item": "ivy",
	"label": "Pug"
	},
{
	"item": "ivy",
	"label": "black bear"
	},
{
	"item": "ivy",
	"label": "hummingbird"
	},
{
	"item": "ivy",
	"label": "dress shirt"
	},
{
	"item": "ivy",
	"label": "Husky"
	},
{
	"item": "ivy",
	"label": "eagle"
	},
{
	"item": "ivy",
	"label": "Hawaii shirt"
	},
{
	"item": "ivy",
	"label": "flower"
	},
{
	"item": "ivy",
	"label": "table"
	},
{
	"item": "ivy",
	"label": "dog"
	},
{
	"item": "ivy",
	"label": "bear"
	},
{
	"item": "ivy",
	"label": "shirt"
	},
{
	"item": "ivy",
	"label": "bird"
	},
{
	"item": "ivy",
	"label": "plant"
	},
{
	"item": "ivy",
	"label": "furniture"
	},
{
	"item": "ivy",
	"label": "animal"
	},
{
	"item": "ivy",
	"label": "clothing"
	},
{
	"item": "ivy",
	"label": "M&M's"
	},
{
	"item": "ivy",
	"label": "Skittles"
	},
{
	"item": "ivy",
	"label": "clownfish"
	},
{
	"item": "ivy",
	"label": "minivan"
	},
{
	"item": "ivy",
	"label": "T-Shirt"
	},
{
	"item": "ivy",
	"label": "pigeon"
	},
{
	"item": "ivy",
	"label": "catfish"
	},
{
	"item": "ivy",
	"label": "grizzly bear"
	},
{
	"item": "ivy",
	"label": "SUV"
	},
{
	"item": "ivy",
	"label": "gummy bears"
	},
{
	"item": "ivy",
	"label": "candy"
	},
{
	"item": "ivy",
	"label": "fish"
	},
{
	"item": "ivy",
	"label": "car"
	},
{
	"item": "ivy",
	"label": "snack"
	},
{
	"item": "ivy",
	"label": "vehicle"
	},
	//kitten
	{
	"item": "kitten",
	"label": "goldfish"
	},
{
	"item": "kitten",
	"label": "panda bear"
	},
{
	"item": "kitten",
	"label": "German Shepherd"
	},
{
	"item": "kitten",
	"label": "pigeon"
	},
{
	"item": "kitten",
	"label": "black bear"
	},
{
	"item": "kitten",
	"label": "polar bear"
	},
{
	"item": "kitten",
	"label": "swordfish"
	},
{
	"item": "kitten",
	"label": "parrot"
	},
{
	"item": "kitten",
	"label": "clownfish"
	},
{
	"item": "kitten",
	"label": "catfish"
	},
{
	"item": "kitten",
	"label": "hummingbird"
	},
{
	"item": "kitten",
	"label": "grizzly bear"
	},
{
	"item": "kitten",
	"label": "Pug"
	},
{
	"item": "kitten",
	"label": "rose"
	},
{
	"item": "kitten",
	"label": "minivan"
	},
{
	"item": "kitten",
	"label": "T-Shirt"
	},
{
	"item": "kitten",
	"label": "fish"
	},
{
	"item": "kitten",
	"label": "bear"
	},
{
	"item": "kitten",
	"label": "dog"
	},
{
	"item": "kitten",
	"label": "bird"
	},
{
	"item": "kitten",
	"label": "flower"
	},
{
	"item": "kitten",
	"label": "car"
	},
{
	"item": "kitten",
	"label": "shirt"
	},
{
	"item": "kitten",
	"label": "animal"
	},
{
	"item": "kitten",
	"label": "plant"
	},
{
	"item": "kitten",
	"label": "vehicle"
	},
{
	"item": "kitten",
	"label": "clothing"
	},
{
	"item": "kitten",
	"label": "Dalmatian"
	},
{
	"item": "kitten",
	"label": "tulip"
	},
{
	"item": "kitten",
	"label": "Hawaii shirt"
	},
{
	"item": "kitten",
	"label": "picnic table"
	},
{
	"item": "kitten",
	"label": "coffee table"
	},
{
	"item": "kitten",
	"label": "table"
	},
{
	"item": "kitten",
	"label": "furniture"
	},
	//lamp
	{
	"item": "lamp",
	"label": "bedside table"
	},
{
	"item": "lamp",
	"label": "picnic table"
	},
{
	"item": "lamp",
	"label": "dining table"
	},
{
	"item": "lamp",
	"label": "grizzly bear"
	},
{
	"item": "lamp",
	"label": "Hawaii shirt"
	},
{
	"item": "lamp",
	"label": "Husky"
	},
{
	"item": "lamp",
	"label": "eagle"
	},
{
	"item": "lamp",
	"label": "German Shepherd"
	},
{
	"item": "lamp",
	"label": "gummy bears"
	},
{
	"item": "lamp",
	"label": "polar bear"
	},
{
	"item": "lamp",
	"label": "swordfish"
	},
{
	"item": "lamp",
	"label": "catfish"
	},
{
	"item": "lamp",
	"label": "tulip"
	},
{
	"item": "lamp",
	"label": "dress shirt"
	},
	{
	"item": "lamp",
	"label": "Dalmatian"
	},
{
	"item": "lamp",
	"label": "jelly beans"
	},
{
	"item": "lamp",
	"label": "panda bear"
	},
{
	"item": "lamp",
	"label": "minivan"
	},
{
	"item": "lamp",
	"label": "parrot"
	},
{
	"item": "lamp",
	"label": "sports car"
	},
{
	"item": "lamp",
	"label": "goldfish"
	},
{
	"item": "lamp",
	"label": "table"
	},
{
	"item": "lamp",
	"label": "bear"
	},
{
	"item": "lamp",
	"label": "shirt"
	},
{
	"item": "lamp",
	"label": "dog"
	},
{
	"item": "lamp",
	"label": "bird"
	},
{
	"item": "lamp",
	"label": "candy"
	},
{
	"item": "lamp",
	"label": "fish"
	},
{
	"item": "lamp",
	"label": "flower"
	},
{
	"item": "lamp",
	"label": "car"
	},
{
	"item": "lamp",
	"label": "furniture"
	},
{
	"item": "lamp",
	"label": "animal"
	},
{
	"item": "lamp",
	"label": "clothing"
	},
{
	"item": "lamp",
	"label": "snack"
	},
{
	"item": "lamp",
	"label": "plant"
	},
{
	"item": "lamp",
	"label": "vehicle"
	},
{
	"item": "lamp",
	"label": "sunflower"
	},
{
	"item": "lamp",
	"label": "T-Shirt"
	},
{
	"item": "lamp",
	"label": "coffee table"
	},
{
	"item": "lamp",
	"label": "hummingbird"
	},
	// lion
{
	"item": "lion",
	"label": "German Shepherd"
	},
{
	"item": "lion",
	"label": "Pug"
	},
{
	"item": "lion",
	"label": "catfish"
	},
{
	"item": "lion",
	"label": "parrot"
	},
{
	"item": "lion",
	"label": "eagle"
	},
{
	"item": "lion",
	"label": "swordfish"
	},
{
	"item": "lion",
	"label": "sports car"
	},
{
	"item": "lion",
	"label": "goldfish"
	},
{
	"item": "lion",
	"label": "dress shirt"
	},
{
	"item": "lion",
	"label": "jelly beans"
	},
{
	"item": "lion",
	"label": "sunflower"
	},
{
	"item": "lion",
	"label": "SUV"
	},
{
	"item": "lion",
	"label": "coffee table"
	},
{
	"item": "lion",
	"label": "dog"
	},
{
	"item": "lion",
	"label": "fish"
	},
{
	"item": "lion",
	"label": "bird"
	},
{
	"item": "lion",
	"label": "car"
	},
{
	"item": "lion",
	"label": "shirt"
	},
{
	"item": "lion",
	"label": "candy"
	},
{
	"item": "lion",
	"label": "flower"
	},
{
	"item": "lion",
	"label": "table"
	},
{
	"item": "lion",
	"label": "animal"
	},
{
	"item": "lion",
	"label": "vehicle"
	},
{
	"item": "lion",
	"label": "clothing"
	},
{
	"item": "lion",
	"label": "snack"
	},
{
	"item": "lion",
	"label": "plant"
	},
{
	"item": "lion",
	"label": "furniture"
	},
{
	"item": "lion",
	"label": "black bear"
	},
{
	"item": "lion",
	"label": "clownfish"
	},
{
	"item": "lion",
	"label": "pigeon"
	},
{
	"item": "lion",
	"label": "grizzly bear"
	},
{
	"item": "lion",
	"label": "hummingbird"
	},
{
	"item": "lion",
	"label": "T-Shirt"
	},
{
	"item": "lion",
	"label": "polar bear"
	},
{
	"item": "lion",
	"label": "Dalmatian"
	},
{
	"item": "lion",
	"label": "dining table"
	},
{
	"item": "lion",
	"label": "bear"
	},
	//lobster
	{
	"item": "lobster",
	"label": "parrot"
	},
{
	"item": "lobster",
	"label": "Husky"
	},
{
	"item": "lobster",
	"label": "Pug"
	},
{
	"item": "lobster",
	"label": "black bear"
	},
{
	"item": "lobster",
	"label": "catfish"
	},
{
	"item": "lobster",
	"label": "grizzly bear"
	},
{
	"item": "lobster",
	"label": "goldfish"
	},
{
	"item": "lobster",
	"label": "clownfish"
	},
{
	"item": "lobster",
	"label": "Dalmatian"
	},
{
	"item": "lobster",
	"label": "swordfish"
	},
{
	"item": "lobster",
	"label": "pigeon"
	},
{
	"item": "lobster",
	"label": "jelly beans"
	},
{
	"item": "lobster",
	"label": "tulip"
	},
{
	"item": "lobster",
	"label": "Hawaii shirt"
	},
{
	"item": "lobster",
	"label": "dining table"
	},
{
	"item": "lobster",
	"label": "convertible"
	},
{
	"item": "lobster",
	"label": "bird"
	},
{
	"item": "lobster",
	"label": "dog"
	},
{
	"item": "lobster",
	"label": "bear"
	},
{
	"item": "lobster",
	"label": "fish"
	},
{
	"item": "lobster",
	"label": "candy"
	},
{
	"item": "lobster",
	"label": "flower"
	},
{
	"item": "lobster",
	"label": "shirt"
	},
{
	"item": "lobster",
	"label": "table"
	},
{
	"item": "lobster",
	"label": "car"
	},
{
	"item": "lobster",
	"label": "animal"
	},
{
	"item": "lobster",
	"label": "snack"
	},
{
	"item": "lobster",
	"label": "plant"
	},
{
	"item": "lobster",
	"label": "clothing"
	},
{
	"item": "lobster",
	"label": "furniture"
	},
{
	"item": "lobster",
	"label": "vehicle"
	},
{
	"item": "lobster",
	"label": "panda bear"
	},
{
	"item": "lobster",
	"label": "German Shepherd"
	},
{
	"item": "lobster",
	"label": "sports car"
	},
{
	"item": "lobster",
	"label": "SUV"
	},
{
	"item": "lobster",
	"label": "M&M's"
	},
{
	"item": "lobster",
	"label": "Skittles"
	},
{
	"item": "lobster",
	"label": "dress shirt"
	},
	//motorcycle
	{
	"item": "motorcycle",
	"label": "sports car"
	},
{
	"item": "motorcycle",
	"label": "minivan"
	},
{
	"item": "motorcycle",
	"label": "SUV"
	},
{
	"item": "motorcycle",
	"label": "convertible"
	},
{
	"item": "motorcycle",
	"label": "German Shepherd"
	},
{
	"item": "motorcycle",
	"label": "Husky"
	},
{
	"item": "motorcycle",
	"label": "hummingbird"
	},
{
	"item": "motorcycle",
	"label": "polar bear"
	},
{
	"item": "motorcycle",
	"label": "coffee table"
	},
{
	"item": "motorcycle",
	"label": "picnic table"
	},
{
	"item": "motorcycle",
	"label": "polo shirt"
	},
{
	"item": "motorcycle",
	"label": "car"
	},
{
	"item": "motorcycle",
	"label": "dog"
	},
{
	"item": "motorcycle",
	"label": "bird"
	},
{
	"item": "motorcycle",
	"label": "bear"
	},
{
	"item": "motorcycle",
	"label": "table"
	},
{
	"item": "motorcycle",
	"label": "shirt"
	},
{
	"item": "motorcycle",
	"label": "vehicle"
	},
{
	"item": "motorcycle",
	"label": "animal"
	},
{
	"item": "motorcycle",
	"label": "furniture"
	},
{
	"item": "motorcycle",
	"label": "clothing"
	},
{
	"item": "motorcycle",
	"label": "T-Shirt"
	},
{
	"item": "motorcycle",
	"label": "eagle"
	},
{
	"item": "motorcycle",
	"label": "goldfish"
	},
{
	"item": "motorcycle",
	"label": "pigeon"
	},
{
	"item": "motorcycle",
	"label": "grizzly bear"
	},
{
	"item": "motorcycle",
	"label": "swordfish"
	},
{
	"item": "motorcycle",
	"label": "fish"
	},
	//pig
	{
	"item": "pig",
	"label": "clownfish"
	},
{
	"item": "pig",
	"label": "German Shepherd"
	},
{
	"item": "pig",
	"label": "polar bear"
	},
{
	"item": "pig",
	"label": "catfish"
	},
{
	"item": "pig",
	"label": "panda bear"
	},
{
	"item": "pig",
	"label": "Pug"
	},
{
	"item": "pig",
	"label": "Dalmatian"
	},
{
	"item": "pig",
	"label": "eagle"
	},
{
	"item": "pig",
	"label": "parrot"
	},
{
	"item": "pig",
	"label": "pigeon"
	},
{
	"item": "pig",
	"label": "swordfish"
	},
{
	"item": "pig",
	"label": "T-Shirt"
	},
{
	"item": "pig",
	"label": "Hawaii shirt"
	},
{
	"item": "pig",
	"label": "dress shirt"
	},
{
	"item": "pig",
	"label": "fish"
	},
{
	"item": "pig",
	"label": "dog"
	},
{
	"item": "pig",
	"label": "bear"
	},
{
	"item": "pig",
	"label": "bird"
	},
{
	"item": "pig",
	"label": "shirt"
	},
{
	"item": "pig",
	"label": "animal"
	},
{
	"item": "pig",
	"label": "clothing"
	},
{
	"item": "pig",
	"label": "Husky"
	},
{
	"item": "pig",
	"label": "goldfish"
	},
{
	"item": "pig",
	"label": "black bear"
	},
{
	"item": "pig",
	"label": "hummingbird"
	},
{
	"item": "pig",
	"label": "polo shirt"
	},
// popcorn
{
	"item": "popcorn",
	"label": "gummy bears"
	},
{
	"item": "popcorn",
	"label": "jelly beans"
	},
{
	"item": "popcorn",
	"label": "Skittles"
	},
{
	"item": "popcorn",
	"label": "M&M's"
	},
{
	"item": "popcorn",
	"label": "T-Shirt"
	},
{
	"item": "popcorn",
	"label": "Pug"
	},
{
	"item": "popcorn",
	"label": "SUV"
	},
{
	"item": "popcorn",
	"label": "catfish"
	},
{
	"item": "popcorn",
	"label": "German Shepherd"
	},
{
	"item": "popcorn",
	"label": "eagle"
	},
{
	"item": "popcorn",
	"label": "pigeon"
	},
{
	"item": "popcorn",
	"label": "candy"
	},
{
	"item": "popcorn",
	"label": "shirt"
	},
{
	"item": "popcorn",
	"label": "dog"
	},
{
	"item": "popcorn",
	"label": "car"
	},
{
	"item": "popcorn",
	"label": "fish"
	},
{
	"item": "popcorn",
	"label": "bird"
	},
{
	"item": "popcorn",
	"label": "snack"
	},
{
	"item": "popcorn",
	"label": "clothing"
	},
{
	"item": "popcorn",
	"label": "animal"
	},
{
	"item": "popcorn",
	"label": "vehicle"
	},
{
	"item": "popcorn",
	"label": "parrot"
	},
{
	"item": "popcorn",
	"label": "Husky"
	},
{
	"item": "popcorn",
	"label": "coffee table"
	},
{
	"item": "popcorn",
	"label": "hummingbird"
	},
{
	"item": "popcorn",
	"label": "bedside table"
	},
{
	"item": "popcorn",
	"label": "black bear"
	},
{
	"item": "popcorn",
	"label": "convertible"
	},
{
	"item": "popcorn",
	"label": "daisy"
	},
{
	"item": "popcorn",
	"label": "table"
	},
{
	"item": "popcorn",
	"label": "bear"
	},
{
	"item": "popcorn",
	"label": "flower"
	},
{
	"item": "popcorn",
	"label": "furniture"
	},
{
	"item": "popcorn",
	"label": "plant"
	},
	//pottedPlant
	{
	"item": "pottedPlant",
	"label": "rose"
	},
{
	"item": "pottedPlant",
	"label": "tulip"
	},
{
	"item": "pottedPlant",
	"label": "daisy"
	},
{
	"item": "pottedPlant",
	"label": "sunflower"
	},
{
	"item": "pottedPlant",
	"label": "bedside table"
	},
{
	"item": "pottedPlant",
	"label": "convertible"
	},
{
	"item": "pottedPlant",
	"label": "Pug"
	},
{
	"item": "pottedPlant",
	"label": "panda bear"
	},
{
	"item": "pottedPlant",
	"label": "goldfish"
	},
{
	"item": "pottedPlant",
	"label": "pigeon"
	},
{
	"item": "pottedPlant",
	"label": "black bear"
	},
{
	"item": "pottedPlant",
	"label": "parrot"
	},
{
	"item": "pottedPlant",
	"label": "grizzly bear"
	},
{
	"item": "pottedPlant",
	"label": "catfish"
	},
{
	"item": "pottedPlant",
	"label": "flower"
	},
{
	"item": "pottedPlant",
	"label": "table"
	},
{
	"item": "pottedPlant",
	"label": "car"
	},
{
	"item": "pottedPlant",
	"label": "dog"
	},
{
	"item": "pottedPlant",
	"label": "bear"
	},
{
	"item": "pottedPlant",
	"label": "fish"
	},
{
	"item": "pottedPlant",
	"label": "bird"
	},
{
	"item": "pottedPlant",
	"label": "plant"
	},
{
	"item": "pottedPlant",
	"label": "furniture"
	},
{
	"item": "pottedPlant",
	"label": "vehicle"
	},
{
	"item": "pottedPlant",
	"label": "animal"
	},
{
	"item": "pottedPlant",
	"label": "clownfish"
	},
{
	"item": "pottedPlant",
	"label": "German Shepherd"
	},
{
	"item": "pottedPlant",
	"label": "polar bear"
	},
{
	"item": "pottedPlant",
	"label": "picnic table"
	},
	//pretzels
	{
	"item": "pretzels",
	"label": "M&M's"
	},
{
	"item": "pretzels",
	"label": "Skittles"
	},
{
	"item": "pretzels",
	"label": "gummy bears"
	},
{
	"item": "pretzels",
	"label": "jelly beans"
	},
{
	"item": "pretzels",
	"label": "polo shirt"
	},
{
	"item": "pretzels",
	"label": "dress shirt"
	},
{
	"item": "pretzels",
	"label": "minivan"
	},
{
	"item": "pretzels",
	"label": "hummingbird"
	},
{
	"item": "pretzels",
	"label": "catfish"
	},
{
	"item": "pretzels",
	"label": "Husky"
	},
{
	"item": "pretzels",
	"label": "Pug"
	},
{
	"item": "pretzels",
	"label": "rose"
	},
{
	"item": "pretzels",
	"label": "T-Shirt"
	},
{
	"item": "pretzels",
	"label": "sports car"
	},
{
	"item": "pretzels",
	"label": "bedside table"
	},
{
	"item": "pretzels",
	"label": "dining table"
	},
{
	"item": "pretzels",
	"label": "Dalmatian"
	},
{
	"item": "pretzels",
	"label": "candy"
	},
{
	"item": "pretzels",
	"label": "shirt"
	},
{
	"item": "pretzels",
	"label": "car"
	},
{
	"item": "pretzels",
	"label": "bird"
	},
{
	"item": "pretzels",
	"label": "fish"
	},
{
	"item": "pretzels",
	"label": "dog"
	},
{
	"item": "pretzels",
	"label": "flower"
	},
{
	"item": "pretzels",
	"label": "table"
	},
{
	"item": "pretzels",
	"label": "snack"
	},
{
	"item": "pretzels",
	"label": "clothing"
	},
{
	"item": "pretzels",
	"label": "vehicle"
	},
{
	"item": "pretzels",
	"label": "animal"
	},
{
	"item": "pretzels",
	"label": "plant"
	},
{
	"item": "pretzels",
	"label": "furniture"
	},
{
	"item": "pretzels",
	"label": "Hawaii shirt"
	},
{
	"item": "pretzels",
	"label": "polar bear"
	},
{
	"item": "pretzels",
	"label": "grizzly bear"
	},
{
	"item": "pretzels",
	"label": "clownfish"
	},
{
	"item": "pretzels",
	"label": "parrot"
	},
{
	"item": "pretzels",
	"label": "black bear"
	},
{
	"item": "pretzels",
	"label": "picnic table"
	},
{
	"item": "pretzels",
	"label": "coffee table"
	},
{
	"item": "pretzels",
	"label": "bear"
	},
	//rabbit
	{
	"item": "rabbit",
	"label": "panda bear"
	},
{
	"item": "rabbit",
	"label": "hummingbird"
	},
{
	"item": "rabbit",
	"label": "Dalmatian"
	},
{
	"item": "rabbit",
	"label": "Pug"
	},
{
	"item": "rabbit",
	"label": "pigeon"
	},
{
	"item": "rabbit",
	"label": "goldfish"
	},
{
	"item": "rabbit",
	"label": "parrot"
	},
{
	"item": "rabbit",
	"label": "black bear"
	},
{
	"item": "rabbit",
	"label": "eagle"
	},
{
	"item": "rabbit",
	"label": "polar bear"
	},
{
	"item": "rabbit",
	"label": "gummy bears"
	},
{
	"item": "rabbit",
	"label": "T-Shirt"
	},
{
	"item": "rabbit",
	"label": "tulip"
	},
{
	"item": "rabbit",
	"label": "bedside table"
	},
{
	"item": "rabbit",
	"label": "picnic table"
	},
{
	"item": "rabbit",
	"label": "polo shirt"
	},
{
	"item": "rabbit",
	"label": "coffee table"
	},
{
	"item": "rabbit",
	"label": "jelly beans"
	},
{
	"item": "rabbit",
	"label": "M&M's"
	},
{
	"item": "rabbit",
	"label": "sunflower"
	},
{
	"item": "rabbit",
	"label": "bear"
	},
{
	"item": "rabbit",
	"label": "bird"
	},
{
	"item": "rabbit",
	"label": "dog"
	},
{
	"item": "rabbit",
	"label": "fish"
	},
{
	"item": "rabbit",
	"label": "candy"
	},
{
	"item": "rabbit",
	"label": "shirt"
	},
{
	"item": "rabbit",
	"label": "flower"
	},
{
	"item": "rabbit",
	"label": "table"
	},
{
	"item": "rabbit",
	"label": "animal"
	},
{
	"item": "rabbit",
	"label": "snack"
	},
{
	"item": "rabbit",
	"label": "clothing"
	},
{
	"item": "rabbit",
	"label": "plant"
	},
{
	"item": "rabbit",
	"label": "furniture"
	},
{
	"item": "rabbit",
	"label": "catfish"
	},
{
	"item": "rabbit",
	"label": "Husky"
	},
{
	"item": "rabbit",
	"label": "clownfish"
	},
{
	"item": "rabbit",
	"label": "grizzly bear"
	},
{
	"item": "rabbit",
	"label": "convertible"
	},
{
	"item": "rabbit",
	"label": "dining table"
	},
{
	"item": "rabbit",
	"label": "sports car"
	},
{
	"item": "rabbit",
	"label": "car"
	},
{
	"item": "rabbit",
	"label": "vehicle"
	},
	//rhino
	{
	"item": "rhino",
	"label": "goldfish"
	},
{
	"item": "rhino",
	"label": "swordfish"
	},
{
	"item": "rhino",
	"label": "Pug"
	},
{
	"item": "rhino",
	"label": "eagle"
	},
{
	"item": "rhino",
	"label": "pigeon"
	},
{
	"item": "rhino",
	"label": "parrot"
	},
{
	"item": "rhino",
	"label": "panda bear"
	},
{
	"item": "rhino",
	"label": "polar bear"
	},
{
	"item": "rhino",
	"label": "T-Shirt"
	},
{
	"item": "rhino",
	"label": "Hawaii shirt"
	},
{
	"item": "rhino",
	"label": "M&M's"
	},
{
	"item": "rhino",
	"label": "hummingbird"
	},
{
	"item": "rhino",
	"label": "sunflower"
	},
{
	"item": "rhino",
	"label": "sports car"
	},
{
	"item": "rhino",
	"label": "clownfish"
	},
{
	"item": "rhino",
	"label": "Dalmatian"
	},
{
	"item": "rhino",
	"label": "dress shirt"
	},
{
	"item": "rhino",
	"label": "fish"
	},
{
	"item": "rhino",
	"label": "dog"
	},
{
	"item": "rhino",
	"label": "bird"
	},
{
	"item": "rhino",
	"label": "bear"
	},
{
	"item": "rhino",
	"label": "shirt"
	},
{
	"item": "rhino",
	"label": "candy"
	},
{
	"item": "rhino",
	"label": "flower"
	},
{
	"item": "rhino",
	"label": "car"
	},
{
	"item": "rhino",
	"label": "animal"
	},
{
	"item": "rhino",
	"label": "clothing"
	},
{
	"item": "rhino",
	"label": "snack"
	},
{
	"item": "rhino",
	"label": "plant"
	},
{
	"item": "rhino",
	"label": "vehicle"
	},
{
	"item": "rhino",
	"label": "German Shepherd"
	},
{
	"item": "rhino",
	"label": "gummy bears"
	},
{
	"item": "rhino",
	"label": "rose"
	},
{
	"item": "rhino",
	"label": "minivan"
	},
{
	"item": "rhino",
	"label": "coffee table"
	},
{
	"item": "rhino",
	"label": "Skittles"
	},
{
	"item": "rhino",
	"label": "convertible"
	},
{
	"item": "rhino",
	"label": "table"
	},
{
	"item": "rhino",
	"label": "furniture"
	},
	//rosemary
	{
	"item": "rosemary",
	"label": "daisy"
	},
{
	"item": "rosemary",
	"label": "sunflower"
	},
{
	"item": "rosemary",
	"label": "rose"
	},
{
	"item": "rosemary",
	"label": "tulip"
	},
{
	"item": "rosemary",
	"label": "parrot"
	},
{
	"item": "rosemary",
	"label": "eagle"
	},
{
	"item": "rosemary",
	"label": "M&M's"
	},
{
	"item": "rosemary",
	"label": "sports car"
	},
{
	"item": "rosemary",
	"label": "pigeon"
	},
{
	"item": "rosemary",
	"label": "polar bear"
	},
{
	"item": "rosemary",
	"label": "catfish"
	},
{
	"item": "rosemary",
	"label": "Skittles"
	},
{
	"item": "rosemary",
	"label": "flower"
	},
{
	"item": "rosemary",
	"label": "bird"
	},
{
	"item": "rosemary",
	"label": "candy"
	},
{
	"item": "rosemary",
	"label": "car"
	},
{
	"item": "rosemary",
	"label": "bear"
	},
{
	"item": "rosemary",
	"label": "fish"
	},
{
	"item": "rosemary",
	"label": "plant"
	},
{
	"item": "rosemary",
	"label": "animal"
	},
{
	"item": "rosemary",
	"label": "snack"
	},
{
	"item": "rosemary",
	"label": "vehicle"
	},
{
	"item": "rosemary",
	"label": "swordfish"
	},
{
	"item": "rosemary",
	"label": "clownfish"
	},
{
	"item": "rosemary",
	"label": "SUV"
	},
{
	"item": "rosemary",
	"label": "convertible"
	},
{
	"item": "rosemary",
	"label": "T-Shirt"
	},
{
	"item": "rosemary",
	"label": "Husky"
	},
{
	"item": "rosemary",
	"label": "panda bear"
	},
{
	"item": "rosemary",
	"label": "Hawaii shirt"
	},
{
	"item": "rosemary",
	"label": "picnic table"
	},
{
	"item": "rosemary",
	"label": "Dalmatian"
	},
{
	"item": "rosemary",
	"label": "black bear"
	},
{
	"item": "rosemary",
	"label": "shirt"
	},
{
	"item": "rosemary",
	"label": "dog"
	},
{
	"item": "rosemary",
	"label": "table"
	},
{
	"item": "rosemary",
	"label": "clothing"
	},
{
	"item": "rosemary",
	"label": "furniture"
	},
	//sheep
	{
	"item": "sheep",
	"label": "grizzly bear"
	},
{
	"item": "sheep",
	"label": "goldfish"
	},
{
	"item": "sheep",
	"label": "catfish"
	},
{
	"item": "sheep",
	"label": "swordfish"
	},
{
	"item": "sheep",
	"label": "Pug"
	},
{
	"item": "sheep",
	"label": "German Shepherd"
	},
{
	"item": "sheep",
	"label": "pigeon"
	},
{
	"item": "sheep",
	"label": "Dalmatian"
	},
{
	"item": "sheep",
	"label": "eagle"
	},
{
	"item": "sheep",
	"label": "parrot"
	},
{
	"item": "sheep",
	"label": "sports car"
	},
{
	"item": "sheep",
	"label": "SUV"
	},
{
	"item": "sheep",
	"label": "dining table"
	},
{
	"item": "sheep",
	"label": "sunflower"
	},
{
	"item": "sheep",
	"label": "M&M's"
	},
{
	"item": "sheep",
	"label": "picnic table"
	},
{
	"item": "sheep",
	"label": "minivan"
	},
{
	"item": "sheep",
	"label": "convertible"
	},
{
	"item": "sheep",
	"label": "bear"
	},
{
	"item": "sheep",
	"label": "fish"
	},
{
	"item": "sheep",
	"label": "dog"
	},
{
	"item": "sheep",
	"label": "bird"
	},
{
	"item": "sheep",
	"label": "car"
	},
{
	"item": "sheep",
	"label": "table"
	},
{
	"item": "sheep",
	"label": "flower"
	},
{
	"item": "sheep",
	"label": "candy"
	},
{
	"item": "sheep",
	"label": "animal"
	},
{
	"item": "sheep",
	"label": "vehicle"
	},
{
	"item": "sheep",
	"label": "furniture"
	},
{
	"item": "sheep",
	"label": "plant"
	},
{
	"item": "sheep",
	"label": "snack"
	},
{
	"item": "sheep",
	"label": "panda bear"
	},
{
	"item": "sheep",
	"label": "black bear"
	},
{
	"item": "sheep",
	"label": "clownfish"
	},
{
	"item": "sheep",
	"label": "coffee table"
	},
{
	"item": "sheep",
	"label": "Husky"
	},
{
	"item": "sheep",
	"label": "rose"
	},
{
	"item": "sheep",
	"label": "polar bear"
	},
{
	"item": "sheep",
	"label": "bedside table"
	},
{
	"item": "sheep",
	"label": "Hawaii shirt"
	},
{
	"item": "sheep",
	"label": "polo shirt"
	},
{
	"item": "sheep",
	"label": "shirt"
	},
{
	"item": "sheep",
	"label": "clothing"
	},
	//snake
	{
	"item": "snake",
	"label": "clownfish"
	},
{
	"item": "snake",
	"label": "Husky"
	},
{
	"item": "snake",
	"label": "eagle"
	},
{
	"item": "snake",
	"label": "polar bear"
	},
{
	"item": "snake",
	"label": "goldfish"
	},
{
	"item": "snake",
	"label": "grizzly bear"
	},
{
	"item": "snake",
	"label": "Pug"
	},
{
	"item": "snake",
	"label": "hummingbird"
	},
{
	"item": "snake",
	"label": "parrot"
	},
{
	"item": "snake",
	"label": "dining table"
	},
{
	"item": "snake",
	"label": "M&M's"
	},
{
	"item": "snake",
	"label": "Hawaii shirt"
	},
{
	"item": "snake",
	"label": "SUV"
	},
{
	"item": "snake",
	"label": "gummy bears"
	},
{
	"item": "snake",
	"label": "fish"
	},
{
	"item": "snake",
	"label": "dog"
	},
{
	"item": "snake",
	"label": "bird"
	},
{
	"item": "snake",
	"label": "bear"
	},
{
	"item": "snake",
	"label": "table"
	},
{
	"item": "snake",
	"label": "candy"
	},
{
	"item": "snake",
	"label": "shirt"
	},
{
	"item": "snake",
	"label": "car"
	},
{
	"item": "snake",
	"label": "animal"
	},
{
	"item": "snake",
	"label": "furniture"
	},
{
	"item": "snake",
	"label": "snack"
	},
{
	"item": "snake",
	"label": "clothing"
	},
{
	"item": "snake",
	"label": "vehicle"
	},
{
	"item": "snake",
	"label": "catfish"
	},
{
	"item": "snake",
	"label": "Dalmatian"
	},
{
	"item": "snake",
	"label": "panda bear"
	},
{
	"item": "snake",
	"label": "daisy"
	},
{
	"item": "snake",
	"label": "minivan"
	},
{
	"item": "snake",
	"label": "flower"
	},
{
	"item": "snake",
	"label": "plant"
	},
	//socks
	{
	"item": "socks",
	"label": "T-Shirt"
	},
{
	"item": "socks",
	"label": "dress shirt"
	},
{
	"item": "socks",
	"label": "Hawaii shirt"
	},
{
	"item": "socks",
	"label": "polo shirt"
	},
{
	"item": "socks",
	"label": "rose"
	},
{
	"item": "socks",
	"label": "clownfish"
	},
{
	"item": "socks",
	"label": "parrot"
	},
{
	"item": "socks",
	"label": "minivan"
	},
{
	"item": "socks",
	"label": "goldfish"
	},
{
	"item": "socks",
	"label": "hummingbird"
	},
{
	"item": "socks",
	"label": "convertible"
	},
{
	"item": "socks",
	"label": "Husky"
	},
{
	"item": "socks",
	"label": "eagle"
	},
{
	"item": "socks",
	"label": "dining table"
	},
{
	"item": "socks",
	"label": "Dalmatian"
	},
{
	"item": "socks",
	"label": "shirt"
	},
{
	"item": "socks",
	"label": "flower"
	},
{
	"item": "socks",
	"label": "fish"
	},
{
	"item": "socks",
	"label": "bird"
	},
{
	"item": "socks",
	"label": "car"
	},
{
	"item": "socks",
	"label": "dog"
	},
{
	"item": "socks",
	"label": "table"
	},
{
	"item": "socks",
	"label": "clothing"
	},
{
	"item": "socks",
	"label": "plant"
	},
{
	"item": "socks",
	"label": "animal"
	},
{
	"item": "socks",
	"label": "vehicle"
	},
{
	"item": "socks",
	"label": "furniture"
	},
{
	"item": "socks",
	"label": "sunflower"
	},
{
	"item": "socks",
	"label": "jelly beans"
	},
{
	"item": "socks",
	"label": "swordfish"
	},
{
	"item": "socks",
	"label": "M&M's"
	},
{
	"item": "socks",
	"label": "panda bear"
	},
{
	"item": "socks",
	"label": "black bear"
	},
{
	"item": "socks",
	"label": "pigeon"
	},
{
	"item": "socks",
	"label": "SUV"
	},
{
	"item": "socks",
	"label": "German Shepherd"
	},
{
	"item": "socks",
	"label": "bedside table"
	},
{
	"item": "socks",
	"label": "candy"
	},
{
	"item": "socks",
	"label": "bear"
	},
{
	"item": "socks",
	"label": "snack"
	},
	//squirrel
	{
	"item": "squirrel",
	"label": "Pug"
	},
{
	"item": "squirrel",
	"label": "parrot"
	},
{
	"item": "squirrel",
	"label": "Dalmatian"
	},
{
	"item": "squirrel",
	"label": "clownfish"
	},
{
	"item": "squirrel",
	"label": "goldfish"
	},
{
	"item": "squirrel",
	"label": "catfish"
	},
{
	"item": "squirrel",
	"label": "grizzly bear"
	},
{
	"item": "squirrel",
	"label": "hummingbird"
	},
{
	"item": "squirrel",
	"label": "polar bear"
	},
{
	"item": "squirrel",
	"label": "Husky"
	},
{
	"item": "squirrel",
	"label": "pigeon"
	},
{
	"item": "squirrel",
	"label": "German Shepherd"
	},
{
	"item": "squirrel",
	"label": "panda bear"
	},
{
	"item": "squirrel",
	"label": "SUV"
	},
{
	"item": "squirrel",
	"label": "Skittles"
	},
{
	"item": "squirrel",
	"label": "polo shirt"
	},
{
	"item": "squirrel",
	"label": "bedside table"
	},
{
	"item": "squirrel",
	"label": "dining table"
	},
{
	"item": "squirrel",
	"label": "Hawaii shirt"
	},
{
	"item": "squirrel",
	"label": "dog"
	},
{
	"item": "squirrel",
	"label": "bird"
	},
{
	"item": "squirrel",
	"label": "fish"
	},
{
	"item": "squirrel",
	"label": "bear"
	},
{
	"item": "squirrel",
	"label": "car"
	},
{
	"item": "squirrel",
	"label": "candy"
	},
{
	"item": "squirrel",
	"label": "shirt"
	},
{
	"item": "squirrel",
	"label": "table"
	},
{
	"item": "squirrel",
	"label": "animal"
	},
{
	"item": "squirrel",
	"label": "vehicle"
	},
{
	"item": "squirrel",
	"label": "snack"
	},
{
	"item": "squirrel",
	"label": "clothing"
	},
{
	"item": "squirrel",
	"label": "furniture"
	},
{
	"item": "squirrel",
	"label": "black bear"
	},
{
	"item": "squirrel",
	"label": "eagle"
	},
{
	"item": "squirrel",
	"label": "sports car"
	},
{
	"item": "squirrel",
	"label": "convertible"
	},
{
	"item": "squirrel",
	"label": "gummy bears"
	},
{
	"item": "squirrel",
	"label": "daisy"
	},
{
	"item": "squirrel",
	"label": "flower"
	},
{
	"item": "squirrel",
	"label": "plant"
	},
	//train
	{
	"item": "train",
	"label": "minivan"
	},
{
	"item": "train",
	"label": "sports car"
	},
{
	"item": "train",
	"label": "convertible"
	},
{
	"item": "train",
	"label": "SUV"
	},
{
	"item": "train",
	"label": "dress shirt"
	},
{
	"item": "train",
	"label": "T-Shirt"
	},
{
	"item": "train",
	"label": "Dalmatian"
	},
{
	"item": "train",
	"label": "jelly beans"
	},
{
	"item": "train",
	"label": "clownfish"
	},
{
	"item": "train",
	"label": "polar bear"
	},
{
	"item": "train",
	"label": "grizzly bear"
	},
{
	"item": "train",
	"label": "tulip"
	},
{
	"item": "train",
	"label": "gummy bears"
	},
{
	"item": "train",
	"label": "hummingbird"
	},
{
	"item": "train",
	"label": "pigeon"
	},
{
	"item": "train",
	"label": "sunflower"
	},
{
	"item": "train",
	"label": "car"
	},
{
	"item": "train",
	"label": "shirt"
	},
{
	"item": "train",
	"label": "dog"
	},
{
	"item": "train",
	"label": "candy"
	},
{
	"item": "train",
	"label": "fish"
	},
{
	"item": "train",
	"label": "bear"
	},
{
	"item": "train",
	"label": "flower"
	},
{
	"item": "train",
	"label": "bird"
	},
{
	"item": "train",
	"label": "vehicle"
	},
{
	"item": "train",
	"label": "clothing"
	},
{
	"item": "train",
	"label": "animal"
	},
{
	"item": "train",
	"label": "snack"
	},
{
	"item": "train",
	"label": "plant"
	},
{
	"item": "train",
	"label": "black bear"
	},
{
	"item": "train",
	"label": "swordfish"
	},
{
	"item": "train",
	"label": "eagle"
	},
{
	"item": "train",
	"label": "Skittles"
	},
{
	"item": "train",
	"label": "goldfish"
	},
{
	"item": "train",
	"label": "Pug"
	},
{
	"item": "train",
	"label": "panda bear"
	},
{
	"item": "train",
	"label": "Hawaii shirt"
	},
{
	"item": "train",
	"label": "catfish"
	},
{
	"item": "train",
	"label": "coffee table"
	},
{
	"item": "train",
	"label": "table"
	},
{
	"item": "train",
	"label": "furniture"
	},
	//wardrobe
	{
	"item": "wardrobe",
	"label": "bedside table"
	},
{
	"item": "wardrobe",
	"label": "picnic table"
	},
{
	"item": "wardrobe",
	"label": "coffee table"
	},
{
	"item": "wardrobe",
	"label": "dining table"
	},
{
	"item": "wardrobe",
	"label": "hummingbird"
	},
{
	"item": "wardrobe",
	"label": "catfish"
	},
{
	"item": "wardrobe",
	"label": "rose"
	},
{
	"item": "wardrobe",
	"label": "Husky"
	},
{
	"item": "wardrobe",
	"label": "panda bear"
	},
{
	"item": "wardrobe",
	"label": "SUV"
	},
{
	"item": "wardrobe",
	"label": "grizzly bear"
	},
{
	"item": "wardrobe",
	"label": "gummy bears"
	},
{
	"item": "wardrobe",
	"label": "black bear"
	},
{
	"item": "wardrobe",
	"label": "table"
	},
{
	"item": "wardrobe",
	"label": "bird"
	},
{
	"item": "wardrobe",
	"label": "fish"
	},
{
	"item": "wardrobe",
	"label": "flower"
	},
{
	"item": "wardrobe",
	"label": "dog"
	},
{
	"item": "wardrobe",
	"label": "bear"
	},
{
	"item": "wardrobe",
	"label": "car"
	},
{
	"item": "wardrobe",
	"label": "candy"
	},
{
	"item": "wardrobe",
	"label": "furniture"
	},
{
	"item": "wardrobe",
	"label": "animal"
	},
{
	"item": "wardrobe",
	"label": "plant"
	},
{
	"item": "wardrobe",
	"label": "vehicle"
	},
{
	"item": "wardrobe",
	"label": "snack"
	},
{
	"item": "wardrobe",
	"label": "polo shirt"
	},
{
	"item": "wardrobe",
	"label": "tulip"
	},
{
	"item": "wardrobe",
	"label": "M&M's"
	},
{
	"item": "wardrobe",
	"label": "Pug"
	},
{
	"item": "wardrobe",
	"label": "goldfish"
	},
{
	"item": "wardrobe",
	"label": "Dalmatian"
	},
{
	"item": "wardrobe",
	"label": "polar bear"
	},
{
	"item": "wardrobe",
	"label": "shirt"
	},
{
	"item": "wardrobe",
	"label": "clothing"
	}
	
  ]).slice(0,45);

  function makeStim(i) {
    //get item
    var item = items[i];
    var item_id = item.item;
    var label = item.label;
      
      return {
	  "item": item_id,
	  "label":label,
    }
  }
  exp.all_stims = [];
  for (var i=0; i<items.length; i++) {
    exp.all_stims.push(makeStim(i));
  }

  exp.trials = [];
  exp.catch_trials = [];
  exp.condition = {}; //can randomize between subject conditions here
  exp.system = {
      Browser : BrowserDetect.browser,
      OS : BrowserDetect.OS,
      screenH: screen.height,
      screenUH: exp.height,
      screenW: screen.width,
      screenUW: exp.width
    };
  //blocks of the experiment:
  exp.structure=["i0", "objecttrial", 'subj_info', 'thanks'];
  
  exp.data_trials = [];
  //make corresponding slides:
  exp.slides = make_slides(exp);

  exp.nQs = utils.get_exp_length(); //this does not work if there are stacks of stims (but does work for an experiment with this structure)
                    //relies on structure and slides being defined
  $(".nQs").html(exp.nQs);

  $('.slide').hide(); //hide everything

  //make sure turkers have accepted HIT (or you're not in mturk)
  $("#start_button").click(function() {
    if (turk.previewMode) {
      $("#mustaccept").show();
    } else {
      $("#start_button").click(function() {$("#mustaccept").show();});
      exp.go();
    }
  });

  exp.go(); //show first slide
}
