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
	var contextsentence = "What type of "+stim.objecttype+" is this?";
	var objimagehtml = '<img src="images/'+stim.objecttype+'/'+stim.item+'.jpg" style="height:200px;">';

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
	"item": "bathrobe",
	"objecttype": "clothing"
	},
	{
	"item": "belt",
	"objecttype": "clothing"
	},
	{
	"item": "boxershorts",
	"objecttype": "clothing"
	},
	{
	"item": "bra",
	"objecttype": "clothing"
	},
	{
	"item": "dress",
	"objecttype": "clothing"
	},
	{
	"item": "gloves",
	"objecttype": "clothing"
	},
	{
	"item": "shirt",
	"objecttype": "clothing"
	},
	{
	"item": "socks",
	"objecttype": "clothing"
	},
	{
	"item": "swimsuit",
	"objecttype": "clothing"
	},
	{
	"item": "underwear",
	"objecttype": "clothing"
	},
	{
	"item": "beagle",
	"objecttype": "dog"
	},
	{
	"item": "chihuahua",
	"objecttype": "dog"
	},
	{
	"item": "collie",
	"objecttype": "dog"
	},
	{
	"item": "dachshund",
	"objecttype": "dog"
	},
	{
	"item": "dalmatian",
	"objecttype": "dog"
	},
	{
	"item": "germanshepherd",
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
	"item": "lab",
	"objecttype": "dog"
	},
	{
	"item": "pug",
	"objecttype": "dog"
	},
	{
	"item": "daffodil",
	"objecttype": "flower"
	},
	{
	"item": "daisy",
	"objecttype": "flower"
	},
	{
	"item": "dandelion",
	"objecttype": "flower"
	},
	{
	"item": "hibiscus",
	"objecttype": "flower"
	},
	{
	"item": "lily",
	"objecttype": "flower"
	},
	{
	"item": "orchid",
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
	"item": "waterlily",
	"objecttype": "flower"
	},
	{
	"item": "banana",
	"objecttype": "fruit"
	},
	{
	"item": "cherries",
	"objecttype": "fruit"
	},
	{
	"item": "grapefruit",
	"objecttype": "fruit"
	},
	{
	"item": "kiwi",
	"objecttype": "fruit"
	},
	{
	"item": "lime",
	"objecttype": "fruit"
	},
	{
	"item": "orange",
	"objecttype": "fruit"
	},
	{
	"item": "peach",
	"objecttype": "fruit"
	},
	{
	"item": "pineapple",
	"objecttype": "fruit"
	},
	{
	"item": "plum",
	"objecttype": "fruit"
	},
	{
	"item": "strawberry",
	"objecttype": "fruit"
	},
	{
	"item": "armchair",
	"objecttype": "furniture"
	},
	{
	"item": "bed",
	"objecttype": "furniture"
	},
	{
	"item": "bookcase",
	"objecttype": "furniture"
	},
	{
	"item": "chair",
	"objecttype": "furniture"
	},
	{
	"item": "couch",
	"objecttype": "furniture"
	},
	{
	"item": "cupboard",
	"objecttype": "furniture"
	},
	{
	"item": "dresser",
	"objecttype": "furniture"
	},
	{
	"item": "lamp",
	"objecttype": "furniture"
	},
	{
	"item": "table",
	"objecttype": "furniture"
	},
	{
	"item": "wardrobe",
	"objecttype": "furniture"
	},
	{
	"item": "castle",
	"objecttype": "house"
	},
	{
	"item": "cottage",
	"objecttype": "house"
	},
	{
	"item": "doghouse",
	"objecttype": "house"
	},
	{
	"item": "highrise",
	"objecttype": "house"
	},
	{
	"item": "hut",
	"objecttype": "house"
	},
	{
	"item": "igloo",
	"objecttype": "house"
	},
	{
	"item": "rv",
	"objecttype": "house"
	},
	{
	"item": "teepee",
	"objecttype": "house"
	},
	{
	"item": "tent",
	"objecttype": "house"
	},
	{
	"item": "trailer",
	"objecttype": "house"
	},
	{
	"item": "banjo",
	"objecttype": "instrument"
	},
	{
	"item": "clarinet",
	"objecttype": "instrument"
	},
	{
	"item": "drum",
	"objecttype": "instrument"
	},
	{
	"item": "guitar",
	"objecttype": "instrument"
	},
	{
	"item": "piano",
	"objecttype": "instrument"
	},
	{
	"item": "recorder",
	"objecttype": "instrument"
	},
	{
	"item": "saxophone",
	"objecttype": "instrument"
	},
	{
	"item": "trombone",
	"objecttype": "instrument"
	},
	{
	"item": "trumpet",
	"objecttype": "instrument"
	},
	{
	"item": "violin",
	"objecttype": "instrument"
	},
	{
	"item": "broccoli",
	"objecttype": "vegetable"
	},
	{
	"item": "carrot",
	"objecttype": "vegetable"
	},
	{
	"item": "corn",
	"objecttype": "vegetable"
	},
	{
	"item": "eggplant",
	"objecttype": "vegetable"
	},
	{
	"item": "mushroom",
	"objecttype": "vegetable"
	},
	{
	"item": "peas",
	"objecttype": "vegetable"
	},
	{
	"item": "pepper",
	"objecttype": "vegetable"
	},
	{
	"item": "pumpkin",
	"objecttype": "vegetable"
	},
	{
	"item": "tomato",
	"objecttype": "vegetable"
	},
	{
	"item": "zucchini",
	"objecttype": "vegetable"
	},
	{
	"item": "airplane",
	"objecttype": "vehicle"
	},
	{
	"item": "ambulance",
	"objecttype": "vehicle"
	},
	{
	"item": "bike",
	"objecttype": "vehicle"
	},
	{
	"item": "boat",
	"objecttype": "vehicle"
	},
	{
	"item": "car",
	"objecttype": "vehicle"
	},
	{
	"item": "firetruck",
	"objecttype": "vehicle"
	},
	{
	"item": "garbagetruck",
	"objecttype": "vehicle"
	},
	{
	"item": "motorcycle",
	"objecttype": "vehicle"
	},
	{
	"item": "schoolbus",
	"objecttype": "vehicle"
	},
	{
	"item": "train",
	"objecttype": "vehicle"
	}     
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
