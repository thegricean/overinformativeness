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
preload(["images/apple_blue.png","images/apple_green.png","images/apple_red.png","images/avocado_black.png","images/avocado_green.png","images/avocado_red.png","images/banana_blue.png","images/banana_brown.png","images/banana_yellow.png","images/carrot_orange.png","images/carrot_purple.png","images/carrot_brown.png","images/pear_green.png","images/pear_orange.png","images/pear_yellow.png","images/pepper_green.png","images/pepper_orange.png","images/pepper_red.png","images/pepper_black.png","images/tomato_green.png","images/tomato_purple.png","images/tomato_red.png","images/pepper_black.png","images/carrot_brown.png"],
 {after: function() { console.log("everything's loaded now") }});

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
	var contextsentence = "How typical is this color for the color <strong>"+stim.color+"</strong>?";
	//var contextsentence = "How typical is this for "+stim.basiclevel+"?";
	//var objimagehtml = '<img src="images/'+stim.basiclevel+'/'+stim.item+'.jpg" style="height:190px;">';
	var objimagehtml = '<img src="images/'+stim.item+'.png" style="height:190px;">';

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
          "color_utterance": this.stim.color,
          "item_color": this.stim.item,
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
"item": "apple_blue",
"color": ["blue"]
},
{
"item": "apple_green",
"color": ["green"]
},
{
"item": "apple_red",
"color": ["red"]
},
{
"item": "avocado_black",
"color": ["black"]
},
{
"item": "avocado_green",
"color": ["green"]
},
{
"item": "avocado_red",
"color": ["red"]
},
{
"item": "banana_blue",
"color": ["blue"]
},
{
"item": "banana_brown",
"color": ["brown"]
},
{
"item": "banana_yellow",
"color": ["yellow"]
},
{
"item": "carrot_brown",
"color": ["brown"]
},
{
"item": "carrot_orange",
"color": ["orange"]
},
{
"item": "carrot_purple",
"color": ["purple"]
},
{
"item": "pear_green",
"color": ["green"]
},
{
"item": "pear_orange",
"color": ["orange"]
},
{
"item": "pear_yellow",
"color": ["yellow"]
},
{
"item": "pepper_black",
"color": ["black"]
},
{
"item": "pepper_green",
"color": ["green"]
},
{
"item": "pepper_orange",
"color": ["orange"]
},
{
"item": "pepper_red",
"color": ["red"]
},
{
"item": "tomato_green",
"color": ["green"]
},
{
"item": "tomato_purple",
"color": ["purple"]
},
{
"item": "tomato_red",
"color": ["red"]
},
// non-fitting but have to
{
"item": "pepper_black",
"color": ["purple"]
},
{
"item": "carrot_brown",
"color": ["purple"]
},
{
"item": "avocado_red",
"color": ["purple"]
}
])


var items_target_2 = _.shuffle([
// "black"  "blue"   "brown"  "green"  "orange"  "purple" "red" "yellow"
{
"item": "avocado_black",
"color": ["purple"]
},
{
"item": "avocado_black",
"color": ["blue"]
},
{
"item": "avocado_black",
"color": ["red"]
},
{
"item": "avocado_black",
"color": ["brown"]
},
{
"item": "avocado_black",
"color": ["green"]
},
{
"item": "avocado_black",
"color": ["orange"]
},
{
"item": "avocado_black",
"color": ["yellow"]
},

{
"item": "avocado_green",
"color": ["brown"]
},
{
"item": "avocado_green",
"color": ["blue"]
},
{
"item": "avocado_green",
"color": ["black"]
},
{
"item": "avocado_green",
"color": ["orange"]
},
{
"item": "avocado_green",
"color": ["purple"]
},
{
"item": "avocado_green",
"color": ["red"]
},
{
"item": "avocado_green",
"color": ["yellow"]
},

{
"item": "avocado_red",
"color": ["brown"]
},
{
"item": "avocado_red",
"color": ["blue"]
},
{
"item": "avocado_red",
"color": ["black"]
},
{
"item": "avocado_red",
"color": ["orange"]
},
// {
// "item": "avocado_red",
// "color": ["purple"]
// },
{
"item": "avocado_red",
"color": ["green"]
},
{
"item": "avocado_red",
"color": ["yellow"]
},

{
"item": "apple_red",
"color": ["brown"]
},
{
"item": "apple_red",
"color": ["blue"]
},
{
"item": "apple_red",
"color": ["black"]
},
{
"item": "apple_red",
"color": ["orange"]
},
{
"item": "apple_red",
"color": ["purple"]
},
{
"item": "apple_red",
"color": ["green"]
},
{
"item": "apple_red",
"color": ["yellow"]
},

{
"item": "apple_blue",
"color": ["brown"]
},
{
"item": "apple_blue",
"color": ["red"]
},
{
"item": "apple_blue",
"color": ["black"]
},
{
"item": "apple_blue",
"color": ["orange"]
},
{
"item": "apple_blue",
"color": ["purple"]
},
{
"item": "apple_blue",
"color": ["green"]
},
{
"item": "apple_blue",
"color": ["yellow"]
},

{
"item": "apple_green",
"color": ["brown"]
},
{
"item": "apple_green",
"color": ["red"]
},
{
"item": "apple_green",
"color": ["black"]
},
{
"item": "apple_green",
"color": ["orange"]
},
{
"item": "apple_green",
"color": ["purple"]
},
{
"item": "apple_green",
"color": ["blue"]
},
{
"item": "apple_green",
"color": ["yellow"]
},

{
"item": "pear_green",
"color": ["brown"]
},
{
"item": "pear_green",
"color": ["red"]
},
{
"item": "pear_green",
"color": ["black"]
},
{
"item": "pear_green",
"color": ["orange"]
},
{
"item": "pear_green",
"color": ["purple"]
},
{
"item": "pear_green",
"color": ["blue"]
},
{
"item": "pear_green",
"color": ["yellow"]
},

{
"item": "pear_orange",
"color": ["brown"]
},
{
"item": "pear_orange",
"color": ["red"]
},
{
"item": "pear_orange",
"color": ["black"]
},
{
"item": "pear_orange",
"color": ["green"]
},
{
"item": "pear_orange",
"color": ["purple"]
},
{
"item": "pear_orange",
"color": ["blue"]
},
{
"item": "pear_orange",
"color": ["yellow"]
},

{
"item": "pear_yellow",
"color": ["brown"]
},
{
"item": "pear_yellow",
"color": ["red"]
},
{
"item": "pear_yellow",
"color": ["black"]
},
{
"item": "pear_yellow",
"color": ["green"]
},
{
"item": "pear_yellow",
"color": ["purple"]
},
{
"item": "pear_yellow",
"color": ["blue"]
},
{
"item": "pear_yellow",
"color": ["orange"]
},

{
"item": "banana_blue",
"color": ["brown"]
},
{
"item": "banana_blue",
"color": ["red"]
},
{
"item": "banana_blue",
"color": ["black"]
},
{
"item": "banana_blue",
"color": ["orange"]
},
{
"item": "banana_blue",
"color": ["purple"]
},
{
"item": "banana_blue",
"color": ["green"]
},
{
"item": "banana_blue",
"color": ["yellow"]
},

{
"item": "banana_yellow",
"color": ["brown"]
},
{
"item": "banana_yellow",
"color": ["red"]
},
{
"item": "banana_yellow",
"color": ["black"]
},
{
"item": "banana_yellow",
"color": ["orange"]
},
{
"item": "banana_yellow",
"color": ["purple"]
},
{
"item": "banana_yellow",
"color": ["green"]
},
{
"item": "banana_yellow",
"color": ["blue"]
},

{
"item": "banana_brown",
"color": ["yellow"]
},
{
"item": "banana_brown",
"color": ["red"]
},
{
"item": "banana_brown",
"color": ["black"]
},
{
"item": "banana_brown",
"color": ["orange"]
},
{
"item": "banana_brown",
"color": ["purple"]
},
{
"item": "banana_brown",
"color": ["green"]
},
{
"item": "banana_brown",
"color": ["blue"]
},

{
"item": "carrot_brown",
"color": ["green"]
},
{
"item": "carrot_brown",
"color": ["red"]
},
{
"item": "carrot_brown",
"color": ["black"]
},
{
"item": "carrot_brown",
"color": ["orange"]
},
// {
// "item": "carrot_brown",
// "color": ["purple"]
// },
{
"item": "carrot_brown",
"color": ["blue"]
},
{
"item": "carrot_brown",
"color": ["yellow"]
},

{
"item": "carrot_orange",
"color": ["green"]
},
{
"item": "carrot_orange",
"color": ["red"]
},
{
"item": "carrot_orange",
"color": ["black"]
},
{
"item": "carrot_orange",
"color": ["brown"]
},
{
"item": "carrot_orange",
"color": ["purple"]
},
{
"item": "carrot_orange",
"color": ["blue"]
},
{
"item": "carrot_orange",
"color": ["yellow"]
},

{
"item": "carrot_purple",
"color": ["green"]
},
{
"item": "carrot_purple",
"color": ["red"]
},
{
"item": "carrot_purple",
"color": ["black"]
},
{
"item": "carrot_purple",
"color": ["brown"]
},
{
"item": "carrot_purple",
"color": ["orange"]
},
{
"item": "carrot_purple",
"color": ["blue"]
},
{
"item": "carrot_purple",
"color": ["yellow"]
},

{
"item": "tomato_red",
"color": ["green"]
},
{
"item": "tomato_red",
"color": ["purple"]
},
{
"item": "tomato_red",
"color": ["black"]
},
{
"item": "tomato_red",
"color": ["brown"]
},
{
"item": "tomato_red",
"color": ["orange"]
},
{
"item": "tomato_red",
"color": ["blue"]
},
{
"item": "tomato_red",
"color": ["yellow"]
},

{
"item": "tomato_purple",
"color": ["green"]
},
{
"item": "tomato_purple",
"color": ["red"]
},
{
"item": "tomato_purple",
"color": ["black"]
},
{
"item": "tomato_purple",
"color": ["brown"]
},
{
"item": "tomato_purple",
"color": ["orange"]
},
{
"item": "tomato_purple",
"color": ["blue"]
},
{
"item": "tomato_purple",
"color": ["yellow"]
},

{
"item": "tomato_green",
"color": ["purple"]
},
{
"item": "tomato_green",
"color": ["red"]
},
{
"item": "tomato_green",
"color": ["black"]
},
{
"item": "tomato_green",
"color": ["brown"]
},
{
"item": "tomato_green",
"color": ["orange"]
},
{
"item": "tomato_green",
"color": ["blue"]
},
{
"item": "tomato_green",
"color": ["yellow"]
},

{
"item": "pepper_green",
"color": ["purple"]
},
{
"item": "pepper_green",
"color": ["red"]
},
{
"item": "pepper_green",
"color": ["black"]
},
{
"item": "pepper_green",
"color": ["brown"]
},
{
"item": "pepper_green",
"color": ["orange"]
},
{
"item": "pepper_green",
"color": ["blue"]
},
{
"item": "pepper_green",
"color": ["yellow"]
},

// {
// "item": "pepper_black",
// "color": ["purple"]
// },
{
"item": "pepper_black",
"color": ["red"]
},
{
"item": "pepper_black",
"color": ["green"]
},
{
"item": "pepper_black",
"color": ["brown"]
},
{
"item": "pepper_black",
"color": ["orange"]
},
{
"item": "pepper_black",
"color": ["blue"]
},
{
"item": "pepper_black",
"color": ["yellow"]
},

{
"item": "pepper_red",
"color": ["purple"]
},
{
"item": "pepper_red",
"color": ["black"]
},
{
"item": "pepper_red",
"color": ["green"]
},
{
"item": "pepper_red",
"color": ["brown"]
},
{
"item": "pepper_red",
"color": ["orange"]
},
{
"item": "pepper_red",
"color": ["blue"]
},
{
"item": "pepper_red",
"color": ["yellow"]
},

{
"item": "pepper_orange",
"color": ["purple"]
},
{
"item": "pepper_orange",
"color": ["black"]
},
{
"item": "pepper_orange",
"color": ["green"]
},
{
"item": "pepper_orange",
"color": ["brown"]
},
{
"item": "pepper_orange",
"color": ["red"]
},
{
"item": "pepper_orange",
"color": ["blue"]
},
{
"item": "pepper_orange",
"color": ["yellow"]
}
]);


  function makeTargetStim(i) {
    //get item
    var item = items_target[i];
    var item_id = item.item;
    var item_color = item.color[0];
      
      return {
	  "item": item_id,
    "color": item_color
    }
  }

  function makeTargetStim2(i) {
    //get item
    var item = items_target_2[i];
    var item_id = item.item;
    var item_color = item.color[0];
      
      return {
    "item": item_id,
    "color": item_color
    }
  }
  

  exp.all_stims = [];
  for (var i=0; i<items_target.length; i++) {
    exp.all_stims.push(makeTargetStim(i));
  }
  for (var k=0; k<65; k++) {
    exp.all_stims.push(makeTargetStim2(k));
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
