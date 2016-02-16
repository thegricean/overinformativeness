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
    condition = ["size", "color"];
    this.condition = stim.condition[Math.floor(Math.random() * 2)];
    this.color = stim.color[Math.floor(Math.random() * 2)];
    this.size = stim.size[Math.floor(Math.random() * 2)];
	var contextsentence = "How typical is this <strong>"+this.condition+"</strong> for <strong>"+stim.label+"</strong>?";
	//var contextsentence = "How typical is this for "+stim.basiclevel+"?";
	//var objimagehtml = '<img src="images/'+stim.basiclevel+'/'+stim.item+'.jpg" style="height:190px;">';
	var objimagehtml = '<img src="images/'+this.size+'_'+this.color+'_'+stim.item+'.jpg" style="height:190px;">';

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
          "itemtype": this.stim.itemtype,
          "condition": this.stim.condition,
          //"labeltype": this.stim.labeltype,                    
          "rt" : Date.now() - _s.trial_start,
	      "response" : exp.sliderPost
        });
    }
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

	var items_target = _.shuffle([
	{
"item": "avocado",
"label": "an avocado",
"itemtype": "target",
"size": ["big", "small"],
"color": ["green", "black"],
"condition": ["size", "color"]
},
{
"item": "balloon",
"label": "a balloon",
"itemtype": "target",
"size": ["big", "small"],
"color": ["pink", "yellow"],
"condition": ["size", "color"]
},
{
"item": "cap",
"label": "a cap",
"itemtype": "target",
"size": ["big", "small"],
"color": ["blue", "orange"],
"condition": ["size", "color"]
},
{
"item": "belt",
"label": "a belt",
"itemtype": "target",
"size": ["big", "small"],
"color": ["black", "brown"],
"condition": ["size", "color"]
},
{
"item": "bike",
"label": "a bike",
"itemtype": "target",
"size": ["big", "small"],
"color": ["purple", "red"],
"condition": ["size", "color"]
},
{
"item": "billiardball",
"label": "a billiard ball",
"itemtype": "target",
"size": ["big", "small"],
"color": ["orange", "purple"],
"condition": ["size", "color"]
},
{
"item": "binder",
"label": "a binder",
"itemtype": "target",
"size": ["big", "small"],
"color": ["blue", "green"],
"condition": ["size", "color"]
},
{
"item": "book",
"label": "a book",
"itemtype": "target",
"size": ["big", "small"],
"color": ["black", "blue"],
"condition": ["size", "color"]
},
{
"item": "bracelet",
"label": "a bracelet",
"itemtype": "target",
"size": ["big", "small"],
"color": ["green", "purple"],
"condition": ["size", "color"]
},
{
"item": "bucket",
"label": "a bucket",
"itemtype": "target",
"size": ["big", "small"],
"color": ["pink", "red"],
"condition": ["size", "color"]
},
{
"item": "butterfly",
"label": "a butterfly",
"itemtype": "target",
"size": ["big", "small"],
"color": ["blue", "purple"],
"condition": ["size", "color"]
},
{
"item": "candle",
"label": "a candle",
"itemtype": "target",
"size": ["big", "small"],
"color": ["blue", "red"],
"condition": ["size", "color"]
},
{
"item": "chair",
"label": "a chair",
"itemtype": "target",
"size": ["big", "small"],
"color": ["green", "red"],
"condition": ["size", "color"]
},
{
"item": "coathanger",
"label": "a coat hanger",
"itemtype": "target",
"size": ["big", "small"],
"color": ["orange", "purple"],
"condition": ["size", "color"]
},
{
"item": "comb",
"label": "a comb",
"itemtype": "target",
"size": ["big", "small"],
"color": ["black", "blue"],
"condition": ["size", "color"]
},
{
"item": "cushion",
"label": "a cushion",
"itemtype": "target",
"size": ["big", "small"],
"color": ["blue", "orange"],
"condition": ["size", "color"]
},
{
"item": "guitar",
"label": "a guitar",
"itemtype": "target",
"size": ["big", "small"],
"color": ["blue", "green"],
"condition": ["size", "color"]
},
{
"item": "flower",
"label": "a flower",
"itemtype": "target",
"size": ["big", "small"],
"color": ["purple", "red"],
"condition": ["size", "color"]
},
{
"item": "framee",
"label": "a frame",
"itemtype": "target",
"size": ["big", "small"],
"color": ["green", "pink"],
"condition": ["size", "color"]
},
{
"item": "golfball",
"label": "a golf ball",
"itemtype": "target",
"size": ["big", "small"],
"color": ["blue", "pink"],
"condition": ["size", "color"]
},
{
"item": "hairdryer",
"label": "a hair dryer",
"itemtype": "target",
"size": ["big", "small"],
"color": ["pink", "purple"],
"condition": ["size", "color"]
},
{
"item": "jacket",
"label": "a jacket",
"itemtype": "target",
"size": ["big", "small"],
"color": ["brown", "green"],
"condition": ["size", "color"]
},
{
"item": "napkin",
"label": "a napkin",
"itemtype": "target",
"size": ["big", "small"],
"color": ["orange", "yellow"],
"condition": ["size", "color"]
},
{
"item": "ornament",
"label": "an ornament",
"itemtype": "target",
"size": ["big", "small"],
"color": ["blue", "purple"],
"condition": ["size", "color"]
},
{
"item": "pepper",
"label": "a pepper",
"itemtype": "target",
"size": ["big", "small"],
"color": ["green", "red"],
"condition": ["size", "color"]
},
{
"item": "phone",
"label": "a phone",
"itemtype": "target",
"size": ["big", "small"],
"color": ["pink", "white"],
"condition": ["size", "color"]
},
{
"item": "rock",
"label": "a rock",
"itemtype": "target",
"size": ["big", "small"],
"color": ["green", "purple"],
"condition": ["size", "color"]
},
{
"item": "rug",
"label": "a rug",
"itemtype": "target",
"size": ["big", "small"],
"color": ["blue", "purple"],
"condition": ["size", "color"]
},
{
"item": "shoe",
"label": "a shoe",
"itemtype": "target",
"size": ["big", "small"],
"color": ["white", "yellow"],
"condition": ["size", "color"]
},
{
"item": "stapler",
"label": "a stapler",
"itemtype": "target",
"size": ["big", "small"],
"color": ["purple", "red"],
"condition": ["size", "color"]
},
"item": "tack",
"label": "a tack",
"itemtype": "target",
"size": ["big", "small"],
"color": ["blue", "red"],
"condition": ["size", "color"]
},
{
"item": "teacup",
"label": "a teacup",
"itemtype": "target",
"size": ["big", "small"],
"color": ["pink", "white"],
"condition": ["size", "color"]
},
{
"item": "toothbrush",
"label": "a toothbrush",
"itemtype": "target",
"size": ["big", "small"],
"color": ["blue", "red"],
"condition": ["size", "color"]
},
{
"item": "turtle",
"label": "a turtle",
"itemtype": "target",
"size": ["big", "small"],
"color": ["black", "brown"],
"condition": ["size", "color"]
},
{
"item": "weddingcake",
"label": "a wedding cake",
"itemtype": "target",
"size": ["big", "small"],
"color": ["pink", "white"],
"condition": ["size", "color"]
},
{
"item": "yarn",
"label": "yarn",
"itemtype": "target",
"size": ["big", "small"],
"color": ["purple", "red"],
"condition": ["size", "color"]
}]).slice(0,28)		

  function makeTargetStim(i) {
    //get item
    var item = items_target[i];
    var item_id = item.item;
    var label = item.label;
    var itemtype = item.itemtype;
    var condition = item.condition;
    //var labeltype = item.labeltype;
      
      return {
	  "item": item_id,
	  "label": label,
	  "itemtype": itemtype,
    "condition": condition
	  //"labeltype": labeltype
    }
  }   
  
  exp.all_stims = [];
  for (var i=0; i<items_target.length; i++) {
    exp.all_stims.push(makeTargetStim(i));
  }
  
  exp.all_stims = _.shuffle(exp.all_stims);

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
