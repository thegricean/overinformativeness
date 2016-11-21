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
    stim.color = _.shuffle(stim.color);
    console.log(stim.color[0]);
	var contextsentence = "How typical is this color for the color "+stim.color[0]+"?";
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
      console.log(this.stim.color[0]);
        exp.data_trials.push({
          "slide_number_in_experiment" : exp.phase,
          "color_utterance": this.stim.color[0],
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
"item": "apple_blue",
"color": ["blue"]
},
{
"item": "apple_red",
"color": ["red"]
},
{
"item": "apple_green",
"color": ["green"]
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
"item": "carrot_orange",
"color": ["orange"]
},
{
"item": "carrot_pink",
"color": ["pink"]
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
"item": "tomato_pink",
"color": ["pink"]
},
{
"item": "tomato_red",
"color": ["red"]
}, 


{
"item": "avocado_black",
"color": ["green", "red"]
},
{
"item": "avocado_green",
"color": ["black", "red"]
},
{
"item": "avocado_red",
"color": ["black", "green"]
},
{
"item": "apple_blue",
"color": ["black", "green"]
},
{
"item": "apple_red",
"color": ["black", "green"]
},
{
"item": "apple_green",
"color": ["black", "red"]
},
{
"item": "banana_blue",
"color": ["black", "green"]
},
{
"item": "banana_brown",
"color": ["black", "green"]
},
{
"item": "banana_yellow",
"color": ["black", "green"]
},
{
"item": "carrot_orange",
"color": ["black", "green"]
},
{
"item": "carrot_pink",
"color": ["black", "green"]
},
{
"item": "carrot_purple",
"color": ["black", "green"]
},
{
"item": "pear_green",
"color": ["black", "red"]
},
{
"item": "pear_orange",
"color": ["black", "green"]
},
{
"item": "pear_yellow",
"color": ["black", "green"]
},
{
"item": "pepper_green",
"color": ["black", "red"]
},
{
"item": "pepper_orange",
"color": ["black", "green"]
},
{
"item": "pepper_red",
"color": ["black", "green"]
},
{
"item": "tomato_green",
"color": ["black", "red"]
},
{
"item": "tomato_pink",
"color": ["black", "green"]
},
{
"item": "tomato_red",
"color": ["black", "green"]
},


{
"item": "avocado_black",
"color": ["brown", "yellow"]
},
{
"item": "avocado_green",
"color": ["brown", "yellow"]
},
{
"item": "avocado_red",
"color": ["brown", "yellow"]
},
{
"item": "apple_blue",
"color": ["red", "brown"]
},
{
"item": "apple_red",
"color": ["brown", "yellow"]
},
{
"item": "apple_green",
"color": ["brown", "yellow"]
},
{
"item": "banana_blue",
"color": ["red", "brown"]
},
{
"item": "banana_brown",
"color": ["red", "yellow"]
},
{
"item": "banana_yellow",
"color": ["red", "brown"]
},
{
"item": "carrot_orange",
"color": ["red", "brown"]
},
{
"item": "carrot_pink",
"color": ["red", "brown"]
},
{
"item": "carrot_purple",
"color": ["red", "brown"]
},
{
"item": "pear_green",
"color": ["brown", "yellow"]
},
{
"item": "pear_orange",
"color": ["red", "brown"]
},
{
"item": "pear_yellow",
"color": ["red", "brown"]
},
{
"item": "pepper_green",
"color": ["brown", "yellow"]
},
{
"item": "pepper_orange",
"color": ["red", "brown"]
},
{
"item": "pepper_red",
"color": ["brown", "yellow"]
},
{
"item": "tomato_green",
"color": ["brown", "yellow"]
},
{
"item": "tomato_pink",
"color": ["red", "brown"]
},
{
"item": "tomato_red",
"color": ["brown", "yellow"]
},



{
"item": "avocado_black",
"color": ["blue", "pink"]
},
{
"item": "avocado_green",
"color": ["blue", "pink"]
},
{
"item": "avocado_red",
"color": ["blue", "pink"]
},
{
"item": "apple_blue",
"color": ["yellow", "pink"]
},
{
"item": "apple_red",
"color": ["blue", "pink"]
},
{
"item": "apple_green",
"color": ["blue", "pink"]
},
{
"item": "banana_blue",
"color": ["yellow", "pink"]
},
{
"item": "banana_brown",
"color": ["blue", "pink"]
},
{
"item": "banana_yellow",
"color": ["blue", "pink"]
},
{
"item": "carrot_orange",
"color": ["yellow", "blue"]
},
{
"item": "carrot_pink",
"color": ["yellow", "blue"]
},
{
"item": "carrot_purple",
"color": ["yellow", "blue"]
},
{
"item": "pear_green",
"color": ["blue", "pink"]
},
{
"item": "pear_orange",
"color": ["yellow", "blue"]
},
{
"item": "pear_yellow",
"color": ["blue", "pink"]
},
{
"item": "pepper_green",
"color": ["blue", "pink"]
},
{
"item": "pepper_orange",
"color": ["yellow", "blue"]
},
{
"item": "pepper_red",
"color": ["blue", "pink"]
},
{
"item": "tomato_green",
"color": ["blue", "pink"]
},
{
"item": "tomato_pink",
"color": ["yellow", "blue"]
},
{
"item": "tomato_red",
"color": ["blue", "pink"]
},


{
"item": "avocado_black",
"color": ["purple", "orange"]
},
{
"item": "avocado_green",
"color": ["purple", "orange"]
},
{
"item": "avocado_red",
"color": ["purple", "orange"]
},
{
"item": "apple_blue",
"color": ["purple", "orange"]
},
{
"item": "apple_red",
"color": ["purple", "orange"]
},
{
"item": "apple_green",
"color": ["purple", "orange"]
},
{
"item": "banana_blue",
"color": ["purple", "orange"]
},
{
"item": "banana_brown",
"color": ["purple", "orange"]
},
{
"item": "banana_yellow",
"color": ["purple", "orange"]
},
{
"item": "carrot_orange",
"color": ["pink", "purple"]
},
{
"item": "carrot_pink",
"color": ["purple", "orange"]
},
{
"item": "carrot_purple",
"color": ["pink", "orange"]
},
{
"item": "pear_green",
"color": ["purple", "orange"]
},
{
"item": "pear_orange",
"color": ["pink", "purple"]
},
{
"item": "pear_yellow",
"color": ["purple", "orange"]
},
{
"item": "pepper_green",
"color": ["purple", "orange"]
},
{
"item": "pepper_orange",
"color": ["pink", "purple"]
},
{
"item": "pepper_red",
"color": ["purple", "orange"]
},
{
"item": "tomato_green",
"color": ["purple", "orange"]
},
{
"item": "tomato_pink",
"color": ["purple", "orange"]
},
{
"item": "tomato_red",
"color": ["purple", "orange"]
}

	]).slice(0,250)
	


  function makeTargetStim(i) {
    //get item
    var item = items_target[i];
    var item_id = item.item;
    var item_color = item.color;
      
      return {
	  "item": item_id,
    "color": item_color
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
