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
preload(["images/apple_blue.png","images/apple_green.png","images/apple_red.png","images/apple_yellow.png","images/avocado_black.png","images/avocado_green.png","images/avocado_red.png","images/banana_blue.png","images/banana_brown.png","images/banana_yellow.png","images/carrot_orange.png","images/carrot_pink.png","images/carrot_purple.png","images/carrot_brown.png","images/cup_black.png","images/cup_blue.png","images/cup_brown.png","images/cup_green.png","images/cup_orange.png","images/cup_pink.png","images/cup_purple.png","images/cup_red.png","images/cup_yellow.png","images/pear_green.png","images/pear_orange.png","images/pear_yellow.png","images/pepper_green.png","images/pepper_orange.png","images/pepper_red.png","images/pepper_black.png","images/strawberry_blue.png","images/strawberry_red.png","images/tomato_green.png","images/tomato_pink.png","images/tomato_red.png","images/tomato_yellow.png","images/pepper_black.png","images/carrot_brown.png"],
 {after: function() { console.log("everything's loaded now") }});


function startsWith(str, substrings) {
    for (var i = 0; i != substrings.length; i++) {
       var substring = substrings[i];
       if (str.indexOf(substring) == 0) {
         return 1;
       }
    }
    return -1; 
}

function getArticleItem(item_id) {

  var article = "";

  if (startsWith(item_id, ["a","e","i","o","u"]) == 1) {
    article = "an ";
  } else {
    article = "a ";
  }
  return article;
}

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
    // stim.item = _.shuffle(stim.item);
	  console.log(this.stim);
    var article = getArticleItem(stim.item);
   //  console.log(stim.item);
   //  console.log(stim.label);
	var contextsentence = "How typical is this object for "+article+"<strong>"+stim.item+"</strong>?";
	//var contextsentence = "How typical is this for "+stim.basiclevel+"?";
	//var objimagehtml = '<img src="images/'+stim.basiclevel+'/'+stim.item+'.jpg" style="height:190px;">';
	var objimagehtml = '<img src="images/'+stim.label+'.png" style="height:190px;">';

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
          "slide_number_in_experiment" : exp.phase,
          "utterance": this.stim.item,
          "object": this.stim.label,
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

  var items_target = _.shuffle([

{
"label": "banana_blue",
"item": ["carrot"]
},
{
"label": "banana_blue",
"item": ["apple"]
},
{
"label": "banana_blue",
"item": ["fruit"]
},
{
"label": "banana_blue",
"item": ["tomato"]
},
{
"label": "banana_yellow",
"item": ["apple"]
},
{
"label": "banana_brown",
"item": ["apple"]
},
{
"label": "banana_brown",
"item": ["pepper"]
},
{
"label": "banana_brown",
"item": ["vegetable"]
},
{
"label": "carrot_pink",
"item": ["apple"]
},
{
"label": "tomato_pink",
"item": ["avocado"]
},
{
"label": "tomato_pink",
"item": ["carrot"]
},
{
"label": "avocado_red",
"item": ["apple"]
},
{
"label": "banana_yellow",
"item": ["pear"]
},
{
"label": "tomato_green",
"item": ["pear"]
},
{
"label": "pear_green",
"item": ["avocado"]
},
{
"label": "pear_green",
"item": ["fruit"]
},
{
"label": "pear_yellow",
"item": ["vegetable"]
},
{
"label": "pear_orange",
"item": ["apple"]
},
{
"label": "pear_yellow",
"item": ["apple"]
},
{
"label": "pear_yellow",
"item": ["banana"]
},
{
"label": "pepper_orange",
"item": ["apple"]
},
{
"label": "pepper_orange",
"item": ["carrot"]
},
{
"label": "pepper_red",
"item": ["carrot"]
},
{
"label": "pepper_orange",
"item": ["vegetable"]
},
{
"label": "apple_green",
"item": ["vegetable"]
},
{
"label": "avocado_green",
"item": ["pear"]
},
{
"label": "banana_brown",
"item": ["tomato"]
},
{
"label": "carrot_pink",
"item": ["pepper"]
},
{
"label": "pear_orange",
"item": ["pepper"]
},
{
"label": "pepper_orange",
"item": ["avocado"]
},
{
"label": "pepper_orange",
"item": ["fruit"]
},
{
"label": "pepper_red",
"item": ["vegetable"]
},
{
"label": "apple_blue",
"item": ["pepper"]
},
{
"label": "apple_blue",
"item": ["avocado"]
},
{
"label": "apple_green",
"item": ["banana"]
},
{
"label": "apple_green",
"item": ["pear"]
},
{
"label": "apple_green",
"item": ["tomato"]
},
{
"label": "apple_red",
"item": ["tomato"]
},
{
"label": "avocado_black",
"item": ["fruit"]
},
{
"label": "avocado_green",
"item": ["tomato"]
},
{
"label": "banana_yellow",
"item": ["pepper"]
},
{
"label": "carrot_orange",
"item": ["pear"]
},
{
"label": "carrot_orange",
"item": ["vegetable"]
},
{
"label": "carrot_orange",
"item": ["pepper"]
},
{
"label": "carrot_brown",
"item": ["apple"]
},
{
"label": "carrot_brown",
"item": ["banana"]
},
{
"label": "carrot_brown",
"item": ["carrot"]
},
{
"label": "carrot_brown",
"item": ["avocado"]
},
{
"label": "carrot_brown",
"item": ["pear"]
},
{
"label": "carrot_brown",
"item": ["pepper"]
},
{
"label": "carrot_brown",
"item": ["fruit"]
},
{
"label": "carrot_brown",
"item": ["vegetable"]
},
{
"label": "carrot_brown",
"item": ["tomato"]
},
{
"label": "pepper_black",
"item": ["apple"]
},
{
"label": "pepper_black",
"item": ["banana"]
},
{
"label": "pepper_black",
"item": ["carrot"]
},
{
"label": "pepper_black",
"item": ["avocado"]
},
{
"label": "pepper_black",
"item": ["pear"]
},
{
"label": "pepper_black",
"item": ["pepper"]
},
{
"label": "pepper_black",
"item": ["fruit"]
},
{
"label": "pepper_black",
"item": ["vegetable"]
},
{
"label": "pepper_black",
"item": ["tomato"]
},
{
"label": "carrot_pink",
"item": ["tomato"]
},
{
"label": "pear_green",
"item": ["apple"]
},
{
"label": "pear_orange",
"item": ["avocado"]
},
{
"label": "pear_orange",
"item": ["vegetable"]
},
{
"label": "pepper_red",
"item": ["pear"]
},
{
"label": "avocado_red",
"item": ["pear"]
},
{
"label": "tomato_red",
"item": ["vegetable"]
},
{
"label": "tomato_green",
"item": ["banana"]
},
{
"label": "tomato_red",
"item": ["fruit"]
},
{
"label": "tomato_red",
"item": ["pear"]
},
{
"label": "tomato_pink",
"item": ["banana"]
},
{
"label": "tomato_pink",
"item": ["pepper"]
},
{
"label": "tomato_green",
"item": ["apple"]
},
{
"label": "apple_blue",
"item": ["banana"]
},
{
"label": "apple_blue",
"item": ["fruit"]
},
{
"label": "apple_red",
"item": ["banana"]
},
{
"label": "apple_red",
"item": ["avocado"]
},
{
"label": "apple_red",
"item": ["fruit"]
},
{
"label": "avocado_black",
"item": ["apple"]
},
{
"label": "avocado_black",
"item": ["banana"]
},
{
"label": "avocado_green",
"item": ["banana"]
},
{
"label": "avocado_green",
"item": ["carrot"]
},
{
"label": "avocado_black",
"item": ["vegetable"]
},
{
  "label": "avocado_black",
  "item": ["pear"]
},
{
  "label": "avocado_green",
  "item": ["pepper"]
},
{
  "label": "avocado_green",
  "item": ["vegetable"]
},
{
  "label": "avocado_red",
  "item": ["banana"]
},
{
  "label": "avocado_red",
  "item": ["pepper"]
}
]);


  function makeTargetStim(i) {
    //get item
    var item = items_target[i];
    var item_id = item.item[0];
    var object_label = item.label;
      
      return {
	  "item": item_id,
    "label": object_label
    }
  }

  exp.all_stims = [];
  for (var i=0; i<items_target.length; i++) {
    exp.all_stims.push(makeTargetStim(i));
  }

  exp.all_stims = _.shuffle(exp.all_stims);
  console.log(exp.all_stims);

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
