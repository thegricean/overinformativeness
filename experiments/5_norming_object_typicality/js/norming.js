// Returns a random integer between min (included) and max (excluded)
// Using Math.round() will give you a non-uniform distribution!
function getRandomInt(min, max) {
  return Math.floor(Math.random() * (max - min)) + min;
}

function make_slides(f) {
  var   slides = {};
	preload(
["images/bathrobe.png","images/belt.jpg"],
{after: function() { console.log("everything's loaded now") }}
)  

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
	    $(".sliderbutton").show();    	
	$("#objectlabel").val("");	
	  this.stim = stim;
	  console.log(this.stim);
	var contextsentence = "How good of a "+stim.objecttype+" is this?";
	var objimagehtml = '<img src="images/'+stim.objecttype+'/'+stim.item+'.jpg" style="height:190px;">';

	$("#contextsentence").html(contextsentence);
	$("#objectimage").html(objimagehtml);
	  console.log(this);
     $(".contbutton").click(function() {
	  var ok_to_go_on = true;
	  console.log($("#objectlabel").val());
	  if ($("#objectlabel").val().length < 2) {
	  	ok_to_go_on = false;
	  }
      if (ok_to_go_on) {
	$(".contbutton").unbind("click");      	
	stim.objectlabel = $("#objectlabel").val();         	
        exp.data_trials.push({
          "objecttype" : stim.objecttype,
          "slide_number_in_experiment" : exp.phase,
          "item": stim.item,
            "rt" : Date.now() - _s.trial_start,
	    "response" : stim.objectlabel
        });
          $(".err").hide();
          _stream.apply(_s); 
      } else {
        $(".err").show();
      }
	});
	  
      },
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
	{
	"item": "blackBear",
	"objecttype": "bear"
	},
	{
	"item": "grizzlyBear",
	"objecttype": "bear"
	},
	{
	"item": "koalaBear",
	"objecttype": "bear"
	},
	{
	"item": "pandaBear",
	"objecttype": "bear"
	},
	{
	"item": "polarBear",
	"objecttype": "bear"
	},
	{
	"item": "eagle",
	"objecttype": "bird"
	},
	{
	"item": "hummingBird",
	"objecttype": "bird"
	},
	{
	"item": "parrot",
	"objecttype": "bird"
	},
	{
	"item": "pigeon",
	"objecttype": "bird"
	},
	{
	"item": "sparrow",
	"objecttype": "bird"
	},
	{
	"item": "dalmatian",
	"objecttype": "dog"
	},
	{
	"item": "germanShepherd",
	"objecttype": "dog"
	},
	{
	"item": "greyhound",
	"objecttype": "dog"
	},
	{
	"item": "husky",
	"objecttype": "dog"
	},
	{
	"item": "pug",
	"objecttype": "dog"
	},
	{
	"item": "candyCorn",
	"objecttype": "candy"
	},
	{
	"item": "gummyBears",
	"objecttype": "candy"
	},
	{
	"item": "jellyBeans",
	"objecttype": "candy"
	},
	{
	"item": "mnMs",
	"objecttype": "candy"
	},
	{
	"item": "skittles",
	"objecttype": "candy"
	},
	{
	"item": "daisy",
	"objecttype": "flower"
	},
	{
	"item": "lily",
	"objecttype": "flower"
	},
	{
	"item": "rose",
	"objecttype": "flower"
	},
	{
	"item": "sunflower",
	"objecttype": "flower"
	},
	{
	"item": "tulip",
	"objecttype": "flower"
	},
	{
	"item": "convertible",
	"objecttype": "car"
	},
	{
	"item": "minivan",
	"objecttype": "car"
	},
	{
	"item": "sedan",
	"objecttype": "car"
	},
	{
	"item": "sportsCar",
	"objecttype": "car"
	},
	{
	"item": "suv",
	"objecttype": "car"
	},
	{
	"item": "catfish",
	"objecttype": "fish"
	},
	{
	"item": "clownFish",
	"objecttype": "fish"
	},
	{
	"item": "discusFish",
	"objecttype": "fish"
	},
	{
	"item": "goldFish",
	"objecttype": "fish"
	},
	{
	"item": "swordFish",
	"objecttype": "fish"
	},
	{
	"item": "campShirt",
	"objecttype": "shirt"
	},
	{
	"item": "dressShirt",
	"objecttype": "shirt"
	},
	{
	"item": "hawaiiShirt",
	"objecttype": "shirt"
	},
	{
	"item": "poloShirt",
	"objecttype": "shirt"
	},
	{
	"item": "tShirt",
	"objecttype": "shirt"
	},
	{
	"item": "bedsideTable",
	"objecttype": "table"
	},
	{
	"item": "coffeeTable",
	"objecttype": "table"
	},
	{
	"item": "diningTable",
	"objecttype": "table"
	},
	{
	"item": "picnicTable",
	"objecttype": "table"
	},
	{
	"item": "sideTable",
	"objecttype": "table"
	},
	
  ]).slice(0,45);

  function makeStim(i) {
    //get item
    var item = items[i];
    var item_id = item.item;
    var objtype = item.objecttype;
      
      return {
	  "item": item_id,
	  "objecttype":objtype,
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
