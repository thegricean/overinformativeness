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
	var contextsentence = "How typical is this for "+stim.label+"?";
	//var contextsentence = "How typical is this for "+stim.basiclevel+"?";
	//var objimagehtml = '<img src="images/'+stim.basiclevel+'/'+stim.item+'.jpg" style="height:190px;">';
	var objimagehtml = '<img src="images/'+stim.item+'.jpg" style="height:190px;">';

	$("#contextsentence").html(contextsentence);
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
     //      "basiclevel" : stim.basiclevel,
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
  	//dog1s typeLabel 36
	{
	"item": "blackBear",
	"label": "a black bear"
	},
	{
	"item": "grizzlyBear",
	"label": "a grizzly bear"
	},
	{
	"item": "pandaBear",
	"label": "a panda bear"
	},
	{
	"item": "polarBear",
	"label": "a polar bear"
	},
	{
	"item": "eagle",
	"label": "an eagle"
	},
	{
	"item": "hummingBird",
	"label": "a hummingbird"
	},
	{
	"item": "parrot",
	"label": "a parrot"
	},
	{
	"item": "pigeon",
	"label": "a pigeon"
	},
	{
	"item": "dalmatian",
	"label": "a Dalmatian"
	},
	{
	"item": "germanShepherd",
	"label": "a German Shepherd"
	},
	{
	"item": "husky",
	"label": "a Husky"
	},
	{
	"item": "pug",
	"label": "a Pug"
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
	"label": "a daisy"
	},
	{
	"item": "rose",
	"label": "a rose"
	},
	{
	"item": "sunflower",
	"label": "a sunflower"
	},
	{
	"item": "tulip",
	"label": "a tulip"
	},
	{
	"item": "convertible",
	"label": "a convertible"
	},
	{
	"item": "minivan",
	"label": "a minivan"
	},
	{
	"item": "sportsCar",
	"label": "a sports car"
	},
	{
	"item": "suv",
	"label": "a suv"
	},
	{
	"item": "catfish",
	"label": "a catfish"
	},
	{
	"item": "clownFish",
	"label": "a clownfish"
	},
	{
	"item": "goldFish",
	"label": "a goldfish"
	},
	{
	"item": "swordFish",
	"label": "a swordfish"
	},
	{
	"item": "dressShirt",
	"label": "a dress shirt"
	},
	{
	"item": "hawaiiShirt",
	"label": "a Hawaii shirt"
	},
	{
	"item": "poloShirt",
	"label": "a polo shirt"
	},
	{
	"item": "tShirt",
	"label": "a T-Shirt"
	},
	{
	"item": "bedsideTable",
	"label": "a bedside table"
	},
	{
	"item": "coffeeTable",
	"label": "a coffee table"
	},
	{
	"item": "diningTable",
	"label": "a dining table"
	},
	{
	"item": "picnicTable",
	"label": "a picnic table"
	},
	//dog1s BasiclevelLabel 36
	{
	"item": "blackBear",
	"label": "a bear"
	},
	{
	"item": "grizzlyBear",
	"label": "a bear"
	},
	{
	"item": "pandaBear",
	"label": "a bear"
	},
	{
	"item": "polarBear",
	"label": "a bear"
	},
	{
	"item": "eagle",
	"label": "a bird"
	},
	{
	"item": "hummingBird",
	"label": "a bird"
	},
	{
	"item": "parrot",
	"label": "a bird"
	},
	{
	"item": "pigeon",
	"label": "a bird"
	},
	{
	"item": "dalmatian",
	"label": "a dog"
	},
	{
	"item": "germanShepherd",
	"label": "a dog"
	},
	{
	"item": "husky",
	"label": "a dog"
	},
	{
	"item": "pug",
	"label": "a dog"
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
	"label": "a flower"
	},
	{
	"item": "rose",
	"label": "a flower",
	},
	{
	"item": "sunflower",
	"label": "a flower"
	},
	{
	"item": "tulip",
	"label": "a flower"
	},
	{
	"item": "convertible",
	"label": "a car"
	},
	{
	"item": "minivan",
	"label": "a car"
	},
	{
	"item": "sportsCar",
	"label": "a car"
	},
	{
	"item": "suv",
	"label": "a car"
	},
	{
	"item": "catfish",
	"label": "a fish"
	},
	{
	"item": "clownFish",
	"label": "a fish"
	},
	{
	"item": "goldFish",
	"label": "a fish"
	},
	{
	"item": "swordFish",
	"label": "a fish"
	},
	{
	"item": "dressShirt",
	"label": "a shirt"
	},
	{
	"item": "hawaiiShirt",
	"label": "a shirt"
	},
	{
	"item": "poloShirt",
	"label": "a shirt"
	},
	{
	"item": "tShirt",
	"label": "a shirt"
	},
	{
	"item": "bedsideTable",
	"label": "a table"
	},
	{
	"item": "coffeeTable",
	"label": "a table"
	},
	{
	"item": "diningTable",
	"label": "a table"
	},
	{
	"item": "picnicTable",
	"label": "a table"
	},


	//dog1s domainLabel 36
	{
	"item": "blackBear",
	"label": "an animal"
	},
	{
	"item": "grizzlyBear",
	"label": "an animal"
	},
	{
	"item": "pandaBear",
	"label": "an animal"
	},
	{
	"item": "polarBear",
	"label": "an animal"
	},
	{
	"item": "eagle",
	"label": "an animal"
	},
	{
	"item": "hummingBird",
	"label": "an animal"
	},
	{
	"item": "parrot",
	"label": "an animal"
	},
	{
	"item": "pigeon",
	"label": "an animal"
	},
	{
	"item": "dalmatian",
	"label": "an animal"
	},
	{
	"item": "germanShepherd",
	"label": "an animal"
	},
	{
	"item": "husky",
	"label": "an animal"
	},
	{
	"item": "pug",
	"label": "an animal"
	},
	{
	"item": "gummyBears",
	"label": "a snack"
	},
	{
	"item": "jellyBeans",
	"label": "a snack"
	},
	{
	"item": "mnMs",
	"label": "a snack"
	},
	{
	"item": "skittles",
	"label": "a snack"
	},
	{
	"item": "daisy",
	"label": "a plant"
	},
	{
	"item": "rose",
	"label": "a plant"
	},
	{
	"item": "sunflower",
	"label": "a plant"
	},
	{
	"item": "tulip",
	"label": "a plant"
	},
	{
	"item": "convertible",
	"label": "a vehicle"
	},
	{
	"item": "minivan",
	"label": "a vehicle"
	},
	{
	"item": "sportsCar",
	"label": "a vehicle"
	},
	{
	"item": "suv",
	"label": "a vehicle"
	},
	{
	"item": "catfish",
	"label": "an animal"
	},
	{
	"item": "clownFish",
	"label": "an animal"
	},
	{
	"item": "goldFish",
	"label": "an animal"
	},
	{
	"item": "swordFish",
	"label": "an animal"
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
	"label": "a black bear"
	},
	{
	"item": "koalaBear",
	"label": "a grizzly bear"
	},
	{
	"item": "koalaBear",
	"label": "a panda bear"
	},
	{
	"item": "koalaBear",
	"label": "a polar bear"
	},

	{
	"item": "sparrow",
	"label": "an eagle"
	},
	{
	"item": "sparrow",
	"label": "a hummingbird"
	},
	{
	"item": "sparrow",
	"label": "a parrot"
	},
	{
	"item": "sparrow",
	"label": "a pigeon"
	},

	{
	"item": "greyhound",
	"label": "a Dalmatian"
	},
	{
	"item": "greyhound",
	"label": "a German Shepherd"
	},
	{
	"item": "greyhound",
	"label": "a Husky"
	},
	{
	"item": "greyhound",
	"label": "a Pug"
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
	"label": "a daisy"
	},
	{
	"item": "lily",
	"label": "a rose"
	},
	{
	"item": "lily",
	"label": "a sunflower"
	},
	{
	"item": "lily",
	"label": "a tulip"
	},

	{
	"item": "sedan",
	"label": "a convertible"
	},
	{
	"item": "sedan",
	"label": "a minivan"
	},
	{
	"item": "sedan",
	"label": "a sports car"
	},
	{
	"item": "sedan",
	"label": "a suv"
	},

	{
	"item": "discusFish",
	"label": "a catfish"
	},
	{
	"item": "discusFish",
	"label": "a clownfish"
	},
	{
	"item": "discusFish",
	"label": "a goldfish"
	},
	{
	"item": "discusFish",
	"label": "a swordfish"
	},

	{
	"item": "campShirt",
	"label": "a dress shirt"
	},
	{
	"item": "campShirt",
	"label": "a Hawaii shirt"
	},
	{
	"item": "campShirt",
	"label": "a polo shirt"
	},
	{
	"item": "campShirt",
	"label": "a T-Shirt"
	},

	{
	"item": "sideTable",
	"label": "a bedside table"
	},
	{
	"item": "sideTable",
	"label": "a coffee table"
	},
	{
	"item": "sideTable",
	"label": "a dining table"
	},
	{
	"item": "sideTable",
	"label": "a picnic table"
	},

	//dog2s BLLabel 9
	{
	"item": "koalaBear",
	"label": "a bear"
	},
	{
	"item": "greyhound",
	"label": "a dog"
	},
	{
	"item": "candyCorn",
	"label": "candy"
	},
	{
	"item": "sideTable",
	"label": "a table"
	},
	{
	"item": "campShirt",
	"label": "a shirt"
	},
	{
	"item": "discusFish",
	"label": "a fish"
	},
	{
	"item": "sparrow",
	"label": "a bird"
	},
	{
	"item": "lily",
	"label": "a flower"
	},
	{
	"item": "sedan",
	"label": "a car"
	},

	//dog2s DomainLabel 9
	{
	"item": "koalaBear",
	"label": "an animal"
	},
	{
	"item": "greyhound",
	"label": "an animal"
	},
	{
	"item": "candyCorn",
	"label": "a snack"
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
	"label": "an animal"
	},
	{
	"item": "sparrow",
	"label": "an animal"
	},
	{
	"item": "lily",
	"label": "a plant"
	},
	{
	"item": "sedan",
	"label": "a vehicle"
	},

	// 

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
