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
	var contextsentence = "How typical is this <strong>"+stim.labeltype+"</strong> for <strong>"+stim.label+"</strong>?";
	//var contextsentence = "How typical is this for "+stim.basiclevel+"?";
	//var objimagehtml = '<img src="images/'+stim.basiclevel+'/'+stim.item+'.jpg" style="height:190px;">';
	var objimagehtml = '<img src="images/'+stim.size+'_'+stim.color+'_'+stim.item+'.jpg" style="height:190px;">';

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
          "labeltype": this.stim.labeltype,                    
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
"size": "big",
"color": "black",
"labeltype": "size"
},
{
"item": "avocado",
"label": "an avocado",
"itemtype": "target",
"size": "small",
"color": "black",
"labeltype": "size"
},
{
"item": "avocado",
"label": "an avocado",
"itemtype": "target",
"size": "big",
"color": "green",
"labeltype": "color"
},
{
"item": "avocado",
"label": "an avocado",
"itemtype": "target",
"size": "small",
"color": "green",
"labeltype": "color"
},
  {
"item": "balloon",
"label": "a balloon",
"itemtype": "target",
"size": "big",
"color": "pink",
"labeltype": "size"
},
{
"item": "balloon",
"label": "a balloon",
"itemtype": "target",
"size": "small",
"color": "pink",
"labeltype": "size"
},
{
"item": "balloon",
"label": "a balloon",
"itemtype": "target",
"size": "big",
"color": "yellow",
"labeltype": "color"
},
{
"item": "balloon",
"label": "a balloon",
"itemtype": "target",
"size": "small",
"color": "yellow",
"labeltype": "color"
},
  {
"item": "cap",
"label": "a cap",
"itemtype": "target",
"size": "big",
"color": "blue",
"labeltype": "size"
},
{
"item": "cap",
"label": "a cap",
"itemtype": "target",
"size": "small",
"color": "blue",
"labeltype": "size"
},
{
"item": "cap",
"label": "a cap",
"itemtype": "target",
"size": "big",
"color": "orange",
"labeltype": "color"
},
{
"item": "cap",
"label": "a cap",
"itemtype": "target",
"size": "small",
"color": "orange",
"labeltype": "color"
},
  {
"item": "belt",
"label": "a belt",
"itemtype": "target",
"size": "big",
"color": "black",
"labeltype": "size"
},
{
"item": "belt",
"label": "a belt",
"itemtype": "target",
"size": "small",
"color": "black",
"labeltype": "size"
},
{
"item": "belt",
"label": "a belt",
"itemtype": "target",
"size": "big",
"color": "brown",
"labeltype": "color"
},
{
"item": "belt",
"label": "a belt",
"itemtype": "target",
"size": "small",
"color": "brown",
"labeltype": "color"
},
  {
"item": "bike",
"label": "a bike",
"itemtype": "target",
"size": "big",
"color": "red",
"labeltype": "size"
},
{
"item": "bike",
"label": "a bike",
"itemtype": "target",
"size": "small",
"color": "red",
"labeltype": "size"
},
{
"item": "bike",
"label": "a bike",
"itemtype": "target",
"size": "big",
"color": "purple",
"labeltype": "color"
},
{
"item": "bike",
"label": "a bike",
"itemtype": "target",
"size": "small",
"color": "purple",
"labeltype": "color"
},
  {
"item": "billiardball",
"label": "a billiard ball",
"itemtype": "target",
"size": "big",
"color": "orange",
"labeltype": "size"
},
{
"item": "billiardball",
"label": "a billiard ball",
"itemtype": "target",
"size": "small",
"color": "orange",
"labeltype": "size"
},
{
"item": "billiardball",
"label": "a billiard ball",
"itemtype": "target",
"size": "big",
"color": "purple",
"labeltype": "color"
},
{
"item": "billiardball",
"label": "a billiard ball",
"itemtype": "target",
"size": "small",
"color": "purple",
"labeltype": "color"
},
  {
"item": "binder",
"label": "a binder",
"itemtype": "target",
"size": "big",
"color": "blue",
"labeltype": "size"
},
{
"item": "binder",
"label": "a binder",
"itemtype": "target",
"size": "small",
"color": "blue",
"labeltype": "size"
},
{
"item": "binder",
"label": "a binder",
"itemtype": "target",
"size": "big",
"color": "green",
"labeltype": "color"
},
{
"item": "binder",
"label": "a binder",
"itemtype": "target",
"size": "small",
"color": "green",
"labeltype": "color"
},
  {
"item": "book",
"label": "a book",
"itemtype": "target",
"size": "big",
"color": "black",
"labeltype": "size"
},
{
"item": "book",
"label": "a book",
"itemtype": "target",
"size": "small",
"color": "black",
"labeltype": "size"
},
{
"item": "book",
"label": "a book",
"itemtype": "target",
"size": "big",
"color": "blue",
"labeltype": "color"
},
{
"item": "book",
"label": "a book",
"itemtype": "target",
"size": "small",
"color": "blue",
"labeltype": "color"
},
  {
"item": "bracelet",
"label": "a bracelet",
"itemtype": "target",
"size": "big",
"color": "green",
"labeltype": "size"
},
{
"item": "bracelet",
"label": "a bracelet",
"itemtype": "target",
"size": "small",
"color": "green",
"labeltype": "size"
},
{
"item": "bracelet",
"label": "a bracelet",
"itemtype": "target",
"size": "big",
"color": "purple",
"labeltype": "color"
},
{
"item": "bracelet",
"label": "a bracelet",
"itemtype": "target",
"size": "small",
"color": "purple",
"labeltype": "color"
},
  {
"item": "bucket",
"label": "a bucket",
"itemtype": "target",
"size": "big",
"color": "pink",
"labeltype": "size"
},
{
"item": "bucket",
"label": "a bucket",
"itemtype": "target",
"size": "small",
"color": "pink",
"labeltype": "size"
},
{
"item": "bucket",
"label": "a bucket",
"itemtype": "target",
"size": "big",
"color": "red",
"labeltype": "color"
},
{
"item": "bucket",
"label": "a bucket",
"itemtype": "target",
"size": "small",
"color": "red",
"labeltype": "color"
},
  {
"item": "butterfly",
"label": "a butterfly",
"itemtype": "target",
"size": "big",
"color": "blue",
"labeltype": "size"
},
{
"item": "butterfly",
"label": "a butterfly",
"itemtype": "target",
"size": "small",
"color": "blue",
"labeltype": "size"
},
{
"item": "butterfly",
"label": "a butterfly",
"itemtype": "target",
"size": "big",
"color": "purple",
"labeltype": "color"
},
{
"item": "butterfly",
"label": "a butterfly",
"itemtype": "target",
"size": "small",
"color": "purple",
"labeltype": "color"
},
  {
"item": "candle",
"label": "a candle",
"itemtype": "target",
"size": "big",
"color": "blue",
"labeltype": "size"
},
{
"item": "candle",
"label": "a candle",
"itemtype": "target",
"size": "small",
"color": "blue",
"labeltype": "size"
},
{
"item": "candle",
"label": "a candle",
"itemtype": "target",
"size": "big",
"color": "red",
"labeltype": "color"
},
{
"item": "candle",
"label": "a candle",
"itemtype": "target",
"size": "small",
"color": "red",
"labeltype": "color"
},
  {
"item": "chair",
"label": "a chair",
"itemtype": "target",
"size": "big",
"color": "green",
"labeltype": "size"
},
{
"item": "chair",
"label": "a chair",
"itemtype": "target",
"size": "small",
"color": "green",
"labeltype": "size"
},
{
"item": "chair",
"label": "a chair",
"itemtype": "target",
"size": "big",
"color": "red",
"labeltype": "color"
},
{
"item": "chair",
"label": "a chair",
"itemtype": "target",
"size": "small",
"color": "red",
"labeltype": "color"
},
  {
"item": "coathanger",
"label": "a coat hanger",
"itemtype": "target",
"size": "big",
"color": "orange",
"labeltype": "size"
},
{
"item": "coathanger",
"label": "a coat hanger",
"itemtype": "target",
"size": "small",
"color": "orange",
"labeltype": "size"
},
{
"item": "coathanger",
"label": "a coat hanger",
"itemtype": "target",
"size": "big",
"color": "purple",
"labeltype": "color"
},
{
"item": "coathanger",
"label": "a coat hanger",
"itemtype": "target",
"size": "small",
"color": "purple",
"labeltype": "color"
},
  {
"item": "comb",
"label": "a comb",
"itemtype": "target",
"size": "big",
"color": "black",
"labeltype": "size"
},
{
"item": "comb",
"label": "a comb",
"itemtype": "target",
"size": "small",
"color": "black",
"labeltype": "size"
},
{
"item": "comb",
"label": "a comb",
"itemtype": "target",
"size": "big",
"color": "blue",
"labeltype": "color"
},
{
"item": "comb",
"label": "a comb",
"itemtype": "target",
"size": "small",
"color": "blue",
"labeltype": "color"
},
  {
"item": "cushion",
"label": "a cushion",
"itemtype": "target",
"size": "big",
"color": "blue",
"labeltype": "size"
},
{
"item": "cushion",
"label": "a cushion",
"itemtype": "target",
"size": "small",
"color": "blue",
"labeltype": "size"
},
{
"item": "cushion",
"label": "a cushion",
"itemtype": "target",
"size": "big",
"color": "orange",
"labeltype": "color"
},
{
"item": "cushion",
"label": "a cushion",
"itemtype": "target",
"size": "small",
"color": "orange",
"labeltype": "color"
},
  {
"item": "guitar",
"label": "a guitar",
"itemtype": "target",
"size": "big",
"color": "blue",
"labeltype": "size"
},
{
"item": "guitar",
"label": "a guitar",
"itemtype": "target",
"size": "small",
"color": "blue",
"labeltype": "size"
},
{
"item": "guitar",
"label": "a guitar",
"itemtype": "target",
"size": "big",
"color": "green",
"labeltype": "color"
},
{
"item": "guitar",
"label": "a guitar",
"itemtype": "target",
"size": "small",
"color": "green",
"labeltype": "color"
},
  {
"item": "flower",
"label": "a flower",
"itemtype": "target",
"size": "big",
"color": "purple",
"labeltype": "size"
},
{
"item": "flower",
"label": "a flower",
"itemtype": "target",
"size": "small",
"color": "purple",
"labeltype": "size"
},
{
"item": "flower",
"label": "a flower",
"itemtype": "target",
"size": "big",
"color": "red",
"labeltype": "color"
},
{
"item": "flower",
"label": "a flower",
"itemtype": "target",
"size": "small",
"color": "red",
"labeltype": "color"
},
  {
"item": "framee",
"label": "a frame",
"itemtype": "target",
"size": "big",
"color": "green",
"labeltype": "size"
},
{
"item": "framee",
"label": "a frame",
"itemtype": "target",
"size": "small",
"color": "green",
"labeltype": "size"
},
{
"item": "framee",
"label": "a frame",
"itemtype": "target",
"size": "big",
"color": "pink",
"labeltype": "color"
},
{
"item": "framee",
"label": "a frame",
"itemtype": "target",
"size": "small",
"color": "pink",
"labeltype": "color"
},
  {
"item": "golfball",
"label": "a golf ball",
"itemtype": "target",
"size": "big",
"color": "blue",
"labeltype": "size"
},
{
"item": "golfball",
"label": "a golf ball",
"itemtype": "target",
"size": "small",
"color": "blue",
"labeltype": "size"
},
{
"item": "golfball",
"label": "a golf ball",
"itemtype": "target",
"size": "big",
"color": "pink",
"labeltype": "color"
},
{
"item": "golfball",
"label": "a golf ball",
"itemtype": "target",
"size": "small",
"color": "pink",
"labeltype": "color"
},
  {
"item": "hairdryer",
"label": "a hair dryer",
"itemtype": "target",
"size": "big",
"color": "pink",
"labeltype": "size"
},
{
"item": "hairdryer",
"label": "a hair dryer",
"itemtype": "target",
"size": "small",
"color": "pink",
"labeltype": "size"
},
{
"item": "hairdryer",
"label": "a hair dryer",
"itemtype": "target",
"size": "big",
"color": "purple",
"labeltype": "color"
},
{
"item": "hairdryer",
"label": "a hair dryer",
"itemtype": "target",
"size": "small",
"color": "purple",
"labeltype": "color"
},
  {
"item": "jacket",
"label": "a jacket",
"itemtype": "target",
"size": "big",
"color": "green",
"labeltype": "size"
},
{
"item": "jacket",
"label": "a jacket",
"itemtype": "target",
"size": "small",
"color": "green",
"labeltype": "size"
},
{
"item": "jacket",
"label": "a jacket",
"itemtype": "target",
"size": "big",
"color": "brown",
"labeltype": "color"
},
{
"item": "jacket",
"label": "a jacket",
"itemtype": "target",
"size": "small",
"color": "brown",
"labeltype": "color"
},
  {
"item": "napkin",
"label": "a napkin",
"itemtype": "target",
"size": "big",
"color": "orange",
"labeltype": "size"
},
{
"item": "napkin",
"label": "a napkin",
"itemtype": "target",
"size": "small",
"color": "orange",
"labeltype": "size"
},
{
"item": "napkin",
"label": "a napkin",
"itemtype": "target",
"size": "big",
"color": "yellow",
"labeltype": "color"
},
{
"item": "napkin",
"label": "a napkin",
"itemtype": "target",
"size": "small",
"color": "yellow",
"labeltype": "color"
},
  {
"item": "ornament",
"label": "an ornament",
"itemtype": "target",
"size": "big",
"color": "blue",
"labeltype": "size"
},
{
"item": "ornament",
"label": "an ornament",
"itemtype": "target",
"size": "small",
"color": "blue",
"labeltype": "size"
},
{
"item": "ornament",
"label": "an ornament",
"itemtype": "target",
"size": "big",
"color": "purple",
"labeltype": "color"
},
{
"item": "ornament",
"label": "an ornament",
"itemtype": "target",
"size": "small",
"color": "purple",
"labeltype": "color"
},
  {
"item": "pepper",
"label": "a pepper",
"itemtype": "target",
"size": "big",
"color": "green",
"labeltype": "size"
},
{
"item": "pepper",
"label": "a pepper",
"itemtype": "target",
"size": "small",
"color": "green",
"labeltype": "size"
},
{
"item": "pepper",
"label": "a pepper",
"itemtype": "target",
"size": "big",
"color": "red",
"labeltype": "color"
},
{
"item": "pepper",
"label": "a pepper",
"itemtype": "target",
"size": "small",
"color": "red",
"labeltype": "color"
},
  {
"item": "phone",
"label": "a phone",
"itemtype": "target",
"size": "big",
"color": "pink",
"labeltype": "size"
},
{
"item": "phone",
"label": "a phone",
"itemtype": "target",
"size": "small",
"color": "pink",
"labeltype": "size"
},
{
"item": "phone",
"label": "a phone",
"itemtype": "target",
"size": "big",
"color": "white",
"labeltype": "color"
},
{
"item": "phone",
"label": "a phone",
"itemtype": "target",
"size": "small",
"color": "white",
"labeltype": "color"
},
  {
"item": "rock",
"label": "a rock",
"itemtype": "target",
"size": "big",
"color": "purple",
"labeltype": "size"
},
{
"item": "rock",
"label": "a rock",
"itemtype": "target",
"size": "small",
"color": "purple",
"labeltype": "size"
},
{
"item": "rock",
"label": "a rock",
"itemtype": "target",
"size": "big",
"color": "green",
"labeltype": "color"
},
{
"item": "rock",
"label": "a rock",
"itemtype": "target",
"size": "small",
"color": "green",
"labeltype": "color"
},
  {
"item": "rug",
"label": "a rug",
"itemtype": "target",
"size": "big",
"color": "purple",
"labeltype": "size"
},
{
"item": "rug",
"label": "a rug",
"itemtype": "target",
"size": "small",
"color": "purple",
"labeltype": "size"
},
{
"item": "rug",
"label": "a rug",
"itemtype": "target",
"size": "big",
"color": "blue",
"labeltype": "color"
},
{
"item": "rug",
"label": "a rug",
"itemtype": "target",
"size": "small",
"color": "blue",
"labeltype": "color"
},
  {
"item": "shoe",
"label": "a shoe",
"itemtype": "target",
"size": "big",
"color": "yellow",
"labeltype": "size"
},
{
"item": "shoe",
"label": "a shoe",
"itemtype": "target",
"size": "small",
"color": "yellow",
"labeltype": "size"
},
{
"item": "shoe",
"label": "a shoe",
"itemtype": "target",
"size": "big",
"color": "white",
"labeltype": "color"
},
{
"item": "shoe",
"label": "a shoe",
"itemtype": "target",
"size": "small",
"color": "white",
"labeltype": "color"
},
  {
"item": "stapler",
"label": "a stapler",
"itemtype": "target",
"size": "big",
"color": "red",
"labeltype": "size"
},
{
"item": "stapler",
"label": "a stapler",
"itemtype": "target",
"size": "small",
"color": "red",
"labeltype": "size"
},
{
"item": "stapler",
"label": "a stapler",
"itemtype": "target",
"size": "big",
"color": "purple",
"labeltype": "color"
},
{
"item": "stapler",
"label": "a stapler",
"itemtype": "target",
"size": "small",
"color": "purple",
"labeltype": "color"
},
  {
"item": "tack",
"label": "a tack",
"itemtype": "target",
"size": "big",
"color": "blue",
"labeltype": "size"
},
{
"item": "tack",
"label": "a tack",
"itemtype": "target",
"size": "small",
"color": "blue",
"labeltype": "size"
},
{
"item": "tack",
"label": "a tack",
"itemtype": "target",
"size": "big",
"color": "red",
"labeltype": "color"
},
{
"item": "tack",
"label": "a tack",
"itemtype": "target",
"size": "small",
"color": "red",
"labeltype": "color"
},
  {
"item": "belt",
"label": "a belt",
"itemtype": "target",
"size": "big",
"color": "black",
"labeltype": "size"
},
{
"item": "belt",
"label": "a belt",
"itemtype": "target",
"size": "small",
"color": "black",
"labeltype": "size"
},
{
"item": "belt",
"label": "a belt",
"itemtype": "target",
"size": "big",
"color": "brown",
"labeltype": "color"
},
{
"item": "belt",
"label": "a belt",
"itemtype": "target",
"size": "small",
"color": "brown",
"labeltype": "color"
},
  {
"item": "belt",
"label": "a belt",
"itemtype": "target",
"size": "big",
"color": "black",
"labeltype": "size"
},
{
"item": "belt",
"label": "a belt",
"itemtype": "target",
"size": "small",
"color": "black",
"labeltype": "size"
},
{
"item": "belt",
"label": "a belt",
"itemtype": "target",
"size": "big",
"color": "brown",
"labeltype": "color"
},
{
"item": "belt",
"label": "a belt",
"itemtype": "target",
"size": "small",
"color": "brown",
"labeltype": "color"
},
  {
"item": "belt",
"label": "a belt",
"itemtype": "target",
"size": "big",
"color": "black",
"labeltype": "size"
},
{
"item": "belt",
"label": "a belt",
"itemtype": "target",
"size": "small",
"color": "black",
"labeltype": "size"
},
{
"item": "belt",
"label": "a belt",
"itemtype": "target",
"size": "big",
"color": "brown",
"labeltype": "color"
},
{
"item": "belt",
"label": "a belt",
"itemtype": "target",
"size": "small",
"color": "brown",
"labeltype": "color"
},
  {
"item": "belt",
"label": "a belt",
"itemtype": "target",
"size": "big",
"color": "black",
"labeltype": "size"
},
{
"item": "belt",
"label": "a belt",
"itemtype": "target",
"size": "small",
"color": "black",
"labeltype": "size"
},
{
"item": "belt",
"label": "a belt",
"itemtype": "target",
"size": "big",
"color": "brown",
"labeltype": "color"
},
{
"item": "belt",
"label": "a belt",
"itemtype": "target",
"size": "small",
"color": "brown",
"labeltype": "color"
},
  {
"item": "belt",
"label": "a belt",
"itemtype": "target",
"size": "big",
"color": "black",
"labeltype": "size"
},
{
"item": "belt",
"label": "a belt",
"itemtype": "target",
"size": "small",
"color": "black",
"labeltype": "size"
},
{
"item": "belt",
"label": "a belt",
"itemtype": "target",
"size": "big",
"color": "brown",
"labeltype": "color"
},
{
"item": "belt",
"label": "a belt",
"itemtype": "target",
"size": "small",
"color": "brown",
"labeltype": "color"
},


{
"item": "wardrobe",
"label": "furniture",
"itemtype": "dist_samesuper",
"labeltype": "super"
}]).slice(0,28)		

  function makeTargetStim(i) {
    //get item
    var item = items_target[i];
    var item_id = item.item;
    var label = item.label;
    var itemtype = item.itemtype;
    var labeltype = item.labeltype;
      
      return {
	  "item": item_id,
	  "label": label,
	  "itemtype": itemtype,
	  "labeltype": labeltype
    }
  }
  
  function makeDistSStim(i) {
    //get item
    var item = items_dists[i];
    var item_id = item.item;
    var label = item.label;
    var itemtype = item.itemtype;
    var labeltype = item.labeltype;
      
      return {
	  "item": item_id,
	  "label": label,
	  "itemtype": itemtype,
	  "labeltype": labeltype
    }
  }
  
  function makeDistSSStim(i) {
    //get item
    var item = items_distss[i];
    var item_id = item.item;
    var label = item.label;
    var itemtype = item.itemtype;
    var labeltype = item.labeltype;
      
      return {
	  "item": item_id,
	  "label": label,
	  "itemtype": itemtype,
	  "labeltype": labeltype
    }
  }    
  
  exp.all_stims = [];
  for (var i=0; i<items_target.length; i++) {
    exp.all_stims.push(makeTargetStim(i));
  }
  for (var i=0; i<items_dists.length; i++) {
    exp.all_stims.push(makeDistSStim(i));
  }
  for (var i=0; i<items_distss.length; i++) {
    exp.all_stims.push(makeDistSSStim(i));
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
