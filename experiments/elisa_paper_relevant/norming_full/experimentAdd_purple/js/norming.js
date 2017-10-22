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
preload(["images/apple_blue.png","images/apple_green.png","images/apple_red.png","images/avocado_black.png","images/avocado_green.png","images/avocado_red.png","images/banana_blue.png","images/banana_brown.png","images/banana_yellow.png","images/carrot_brown.png","images/carrot_orange.png","images/carrot_purple.png","images/pear_green.png","images/pear_orange.png","images/pear_yellow.png","images/pepper_black.png","images/pepper_green.png","images/pepper_orange.png","images/pepper_red.png","images/tomato_green.png","images/tomato_purple.png","images/tomato_red.png"],
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
"label": "avocado_black",
"item": ["black avocado", "green avocado", "red avocado"]
},
{
"label": "avocado_green",
"item": ["black avocado", "green avocado", "red avocado"]
},
{
"label": "avocado_red",
"item": ["black avocado", "green avocado", "red avocado"]
},
{
"label": "apple_blue",
"item": ["blue apple", "red apple", "green apple"]
},
{
"label": "apple_red",
"item": ["blue apple", "red apple", "green apple"]
},
{
"label": "apple_green",
"item": ["blue apple", "red apple", "green apple"]
},
{
"label": "banana_blue",
"item": ["blue banana", "brown banana", " yellow banana"]
},
{
"label": "banana_brown",
"item": ["blue banana", "brown banana", " yellow banana"]
},
{
"label": "banana_yellow",
"item": ["blue banana", "brown banana", " yellow banana"]
},
{
"label": "carrot_orange",
"item": ["orange carrot", "purple carrot", "brown carrot"]
},
{
"label": "carrot_purple",
"item": ["orange carrot", "purple carrot", "brown carrot"]
},
{
"label": "carrot_brown",
"item": ["orange carrot", "purple carrot", "brown carrot"]
},
// {
// "label": "carrot_orange",
// "item": ["purple carrot"]
// },
// {
// "label": "carrot_purple",
// "item": ["purple carrot"]
// },
// {
// "label": "carrot_brown",
// "item": ["purple carrot"]
// },
{
"label": "pear_green",
"item": ["green pear", "orange pear", "yellow pear"]
},
{
"label": "pear_orange",
"item": ["green pear", "orange pear", "yellow pear"]
},
{
"label": "pear_yellow",
"item": ["green pear", "orange pear", "yellow pear"]
},
{
"label": "pepper_green",
"item": ["green pepper", "black pepper", "orange pepper", "red pepper"]
},
{
"label": "pepper_black",
"item": ["green pepper", "black pepper", "orange pepper", "red pepper"]
},
{
"label": "pepper_orange",
"item": ["green pepper", "black pepper", "orange pepper", "red pepper"]
},
{
"label": "pepper_red",
"item": ["green pepper", "black pepper", "orange pepper", "red pepper"]
},
{
"label": "tomato_green",
"item": ["green tomato", "purple tomato", "red tomato"]
},
// {
// "label": "tomato_green",
// "item": ["purple tomato"]
// },
{
"label": "tomato_purple",
"item": ["green tomato", "purple tomato", "red tomato"]
},
// {
// "label": "tomato_purple",
// "item": ["purple tomato"]
// },
{
"label": "tomato_red",
"item": ["green tomato", "purple tomato", "red tomato"]
}
// {
// "label": "tomato_red",
// "item": ["purple tomato"]
// }
]);



var items_target_2 = _.shuffle([
{
// object
"label": "apple_blue",
// utterance
"item": ["purple carrot"],
},
{
"label": "apple_blue",
"item": ["yellow pear"],
},
{
"label": "apple_green",
"item": ["black pepper"],
},
{
"label": "apple_red",
"item": ["brown carrot"],
},
{
"label": "avocado_black",
"item": ["black pepper"],
},
{
"label": "avocado_black",
"item": ["blue apple"],
},
{
"label": "avocado_black",
"item": ["red pepper"],
},
{
"label": "avocado_green",
"item": ["orange pear"],
},
{
"label": "avocado_red",
"item": ["brown carrot"],
},
{
"label": "banana_blue",
"item": ["green pear"],
},
{
"label": "banana_brown",
"item": ["green apple"],
},
{
"label": "banana_brown",
"item": ["green avocado"],
},
{
"label": "banana_brown",
"item": ["green pear"],
},
{
"label": "banana_yellow",
"item": ["red tomato"],
},
{
"label": "carrot_brown",
"item": ["black pepper"],
},
{
"label": "carrot_brown",
"item": ["red pepper"],
},
{
"label": "carrot_orange",
"item": ["black pepper"],
},
{
"label": "carrot_purple",
"item": ["green avocado"],
},
{
"label": "pear_green",
"item": ["orange carrot"],
},
{
"label": "pear_orange",
"item": ["black pepper"],
},
{
"label": "pear_orange",
"item": ["green tomato"],
},
{
"label": "pear_yellow",
"item": ["blue banana"],
},
{
"label": "pear_yellow",
"item": ["red tomato"],
},
{
"label": "pepper_green",
"item": ["blue apple"],
},
{
"label": "pepper_green",
"item": ["green apple"],
},
{
"label": "pepper_orange",
"item": ["brown banana"],
},
{
"label": "pepper_red",
"item": ["green apple"],
},
{
"label": "tomato_green",
"item": ["yellow banana"],
},
{
"label": "tomato_green",
"item": ["yellow pear"],
},
{
"label": "tomato_purple",
"item": ["brown carrot"],
},
{
"label": "tomato_red",
"item": ["brown banana"],
},
{
"label": "apple_blue",
"item": ["red tomato"],
},
{
"label": "apple_red",
"item": ["red tomato"],
},
{
"label": "avocado_black",
"item": ["orange pear"],
},
{
"label": "avocado_green",
"item": ["green pepper"],
},
{
"label": "avocado_green",
"item": ["red tomato"],
},
{
"label": "avocado_red",
"item": ["blue banana"],
},
{
"label": "avocado_red",
"item": ["green apple"],
},
{
"label": "avocado_red",
"item": ["purple carrot"],
},
{
"label": "avocado_red",
"item": ["red apple"],
},
{
"label": "avocado_red",
"item": ["red pepper"],
},
{
"label": "banana_blue",
"item": ["black pepper"],
},
{
"label": "banana_blue",
"item": ["green tomato"],
},
{
"label": "banana_brown",
"item": ["black avocado"],
},
{
"label": "banana_brown",
"item": ["green tomato"],
},
{
"label": "banana_brown",
"item": ["purple carrot"],
},
{
"label": "banana_yellow",
"item": ["green pear"],
},
{
"label": "banana_yellow",
"item": ["green pepper"],
},
{
"label": "banana_yellow",
"item": ["orange pepper"],
},
{
"label": "carrot_brown",
"item": ["red tomato"],
},
{
"label": "carrot_brown",
"item": ["yellow pear"],
},
{
"label": "carrot_orange",
"item": ["blue apple"],
},
{
"label": "pear_green",
"item": ["red avocado"],
},
{
"label": "pear_orange",
"item": ["orange carrot"],
},
{
"label": "pear_orange",
"item": ["purple tomato"],
},
{
"label": "pear_yellow",
"item": ["orange carrot"],
},
{
"label": "pepper_black",
"item": ["red apple"],
},
{
"label": "pepper_green",
"item": ["green pear"],
},
{
"label": "pepper_orange",
"item": ["purple carrot"],
},
{
"label": "pepper_orange",
"item": ["yellow pear"],
},
{
"label": "pepper_red",
"item": ["blue apple"],
},
{
"label": "tomato_green",
"item": ["black pepper"],
},
{
"label": "tomato_purple",
"item": ["orange carrot"],
},
{
"label": "tomato_purple",
"item": ["yellow banana"],
},
{
"label": "tomato_red",
"item": ["black pepper"],
},
{
"label": "tomato_red",
"item": ["orange pear"],
},
{
"label": "apple_blue",
"item": ["green avocado"],
},
{
"label": "apple_blue",
"item": ["red avocado"],
},
{
"label": "apple_green",
"item": ["orange carrot"],
},
{
"label": "apple_green",
"item": ["orange pepper"],
},
{
"label": "apple_green",
"item": ["purple tomato"],
},
{
"label": "apple_green",
"item": ["red tomato"],
},
{
"label": "apple_red",
"item": ["green pepper"],
},
{
"label": "apple_red",
"item": ["orange pepper"],
},
{
"label": "apple_red",
"item": ["red pepper"],
},
{
"label": "avocado_black",
"item": ["orange carrot"],
},
{
"label": "avocado_black",
"item": ["red apple"],
},
{
"label": "avocado_green",
"item": ["green tomato"],
},
{
"label": "avocado_green",
"item": ["yellow pear"],
},
{
"label": "avocado_red",
"item": ["purple tomato"],
},
{
"label": "avocado_red",
"item": ["red tomato"],
},
{
"label": "banana_blue",
"item": ["red avocado"],
},
{
"label": "banana_blue",
"item": ["yellow pear"],
},
{
"label": "banana_brown",
"item": ["orange carrot"],
},
{
"label": "banana_yellow",
"item": ["green tomato"],
},
{
"label": "banana_yellow",
"item": ["orange pear"],
},
{
"label": "banana_yellow",
"item": ["yellow pear"],
},
{
"label": "carrot_orange",
"item": ["black avocado"],
},
{
"label": "carrot_orange",
"item": ["orange pear"],
},
{
"label": "carrot_purple",
"item": ["red avocado"],
},
{
"label": "pear_green",
"item": ["brown carrot"],
},
{
"label": "pear_orange",
"item": ["brown carrot"],
},
{
"label": "pear_orange",
"item": ["purple carrot"],
},
{
"label": "pear_orange",
"item": ["red apple"],
},
{
"label": "pear_yellow",
"item": ["black avocado"],
},
{
"label": "pear_yellow",
"item": ["brown carrot"],
},
{
"label": "pear_yellow",
"item": ["green avocado"],
},
{
"label": "pear_yellow",
"item": ["yellow banana"],
},
{
"label": "pepper_black",
"item": ["black avocado"],
},
{
"label": "pepper_black",
"item": ["orange pear"],
},
{
"label": "pepper_green",
"item": ["brown banana"],
},
{
"label": "pepper_orange",
"item": ["black avocado"],
},
{
"label": "pepper_orange",
"item": ["green tomato"],
},
{
"label": "pepper_orange",
"item": ["red apple"],
},
{
"label": "pepper_red",
"item": ["red tomato"],
},
{
"label": "tomato_green",
"item": ["brown carrot"],
},
{
"label": "tomato_green",
"item": ["green pepper"],
},
{
"label": "tomato_purple",
"item": ["black avocado"],
},
{
"label": "tomato_purple",
"item": ["blue banana"],
},
{
"label": "tomato_purple",
"item": ["orange pepper"],
},
{
"label": "apple_blue",
"item": ["orange pepper"],
},
{
"label": "apple_red",
"item": ["red avocado"],
},
{
"label": "avocado_black",
"item": ["purple tomato"],
},
{
"label": "avocado_green",
"item": ["red pepper"],
},
{
"label": "banana_brown",
"item": ["brown carrot"],
},
{
"label": "banana_brown",
"item": ["green pepper"],
},
{
"label": "banana_brown",
"item": ["red avocado"],
},
{
"label": "banana_yellow",
"item": ["brown carrot"],
},
{
"label": "banana_yellow",
"item": ["green avocado"],
},
{
"label": "carrot_brown",
"item": ["green pepper"],
},
{
"label": "carrot_brown",
"item": ["green tomato"],
},
{
"label": "carrot_brown",
"item": ["red apple"],
},
{
"label": "carrot_orange",
"item": ["brown banana"],
},
{
"label": "carrot_orange",
"item": ["green apple"],
},
{
"label": "carrot_orange",
"item": ["green pear"],
},
{
"label": "pear_green",
"item": ["black pepper"],
},
{
"label": "pear_orange",
"item": ["green pepper"],
},
{
"label": "pear_yellow",
"item": ["blue apple"],
},
{
"label": "pear_yellow",
"item": ["green pepper"],
},
{
"label": "pepper_black",
"item": ["green pear"],
},
{
"label": "pepper_black",
"item": ["yellow pear"],
},
{
"label": "pepper_green",
"item": ["orange pear"],
},
{
"label": "pepper_green",
"item": ["yellow pear"],
},
{
"label": "pepper_orange",
"item": ["brown carrot"],
},
{
"label": "pepper_orange",
"item": ["orange carrot"],
},
{
"label": "pepper_red",
"item": ["brown carrot"],
},
{
"label": "tomato_green",
"item": ["black avocado"],
},
{
"label": "tomato_green",
"item": ["blue banana"],
},
{
"label": "tomato_green",
"item": ["purple carrot"],
},
{
"label": "tomato_purple",
"item": ["green apple"],
},
{
"label": "tomato_red",
"item": ["black avocado"],
},
{
"label": "tomato_red",
"item": ["blue apple"],
},
{
"label": "tomato_red",
"item": ["green apple"],
},
{
"label": "tomato_red",
"item": ["green avocado"],
},
{
"label": "banana_blue",
"item": ["purple tomato"],
},
{
"label": "carrot_brown",
"item": ["purple tomato"],
},
{
"label": "pear_yellow",
"item": ["purple carrot"],
},
{
"label": "pepper_black",
"item": ["purple carrot"],
},
{
"label": "pepper_orange",
"item": ["purple tomato"],
},
{
"label": "avocado_green",
"item": ["purple tomato"],
},
{
"label": "banana_brown",
"item": ["purple tomato"],
},
{
"label": "banana_yellow",
"item": ["purple carrot"],
},
{
"label": "avocado_black",
"item": ["purple carrot"],
},
{
"label": "pear_green",
"item": ["purple carrot"],
},
{
"label": "pepper_black",
"item": ["purple tomato"],
},
{
"label": "tomato_purple",
"item": ["purple carrot"],
},
{
"label": "carrot_orange",
"item": ["purple tomato"],
},
{
"label": "pear_green",
"item": ["purple tomato"],
},
{
"label": "pear_yellow",
"item": ["purple tomato"],
},
{
"label": "pepper_red",
"item": ["purple tomato"],
},
{
"label": "avocado_green",
"item": ["purple carrot"],
},
{
"label": "pepper_red",
"item": ["purple carrot"],
},
{
"label": "banana_yellow",
"item": ["purple tomato"],
},
{
"label": "apple_green",
"item": ["purple carrot"],
},
{
"label": "pepper_green",
"item": ["purple tomato"],
},
{
"label": "pepper_green",
"item": ["purple carrot"],
},
{
"label": "apple_red",
"item": ["purple tomato"],
},
{
"label": "tomato_red",
"item": ["purple carrot"],
},
{
"label": "apple_red",
"item": ["purple carrot"],
},
{
"label": "banana_blue",
"item": ["purple carrot"],
},
{
"label": "carrot_purple",
"item": ["purple tomato"],
},
{
"label": "apple_blue",
"item": ["purple tomato"],
},
{
"label": "carrot_brown",
"item": ["purple carrot"],
},
{
"label": "carrot_orange",
"item": ["purple carrot"],
},
{
"label": "carrot_purple",
"item": ["purple carrot"],
},
{
"label": "tomato_green",
"item": ["purple tomato"],
},
{
"label": "tomato_purple",
"item": ["purple tomato"],
},
{
"label": "tomato_red",
"item": ["purple tomato"],
},
  ]);
	


  function makeTargetStim(i,j) {
    //get item
    var item = items_target[i];
    var item_id = item.item[j];
    var object_label = item.label;
      
      return {
	  "item": item_id,
    "label": object_label
    }
  }
  
  function makeTargetStim2(l,k) {
    //get item
    var item = items_target_2[l];
    var item_id = item.item[k];
    var object_label = item.label;
      
      return {
    "item": item_id,
    "label": object_label
    }
  }

  exp.all_stims = [];

for (var i=0; i<items_target.length; i++) {
    items_target[i].item = _.shuffle(items_target[i].item);
    for (var j=0; j<items_target[i].item.length; j++) {
      exp.all_stims.push(makeTargetStim(i,j));
    }
  }

  for (var l=0; l<40; l++) {
    items_target_2[l].item = _.shuffle(items_target_2[l].item);
    for (var k=0; k<items_target_2[l].item.length; k++) {
      exp.all_stims.push(makeTargetStim2(l,k));
    }
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
