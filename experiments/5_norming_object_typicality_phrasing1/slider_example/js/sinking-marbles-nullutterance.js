function make_slides(f) {
  var   slides = {};

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

  slides.cause_effect_prior = slide({
    name : "cause_effect_prior",
    present : exp.all_stims,
    start : function() {
      $(".err").hide();
    },
    present_handle : function(stim) {
    	this.trial_start = Date.now();
      var N = stim.N;    	
      this.init_sliders(N);
      exp.sliderPost = {};
      $("#number_guess").html("?");
      this.stim = stim;
      console.log(stim.cause);
      if (stim.end_cause.length > 0) {
        var cause = stim.name + " " + stim.beginning_cause + " " + stim.N.toString() + " " + stim.object + " " + stim.end_cause + ".";
      } else {
        var cause = stim.name + " " + stim.beginning_cause + " " + stim.N.toString() + " " + stim.object + ".";
      }
      var effect_question = "How many " + stim.object + " " + stim.effect + "?";
      var utterance = '';
      if (this.stim.quantifier == "short_filler") {
      	this.stim.actual_utterance = '"' + this.stim.actual_utterance + '"';
      } else {
      	if (this.stim.quantifier == "long_filler") {
			this.stim.actual_utterance = '"' + this.stim.actual_utterance + '"';
      	} else {
      		this.stim.actual_utterance =  '"' + stim.quantifier + " of the " + stim.object +
                      //can comment out following line to make it less wordy
                      //(" that " + stim.name + " " + stim.beginning_cause + (stim.end_cause ? " " + stim.end_cause : "")).replace(/ a /g, " the ").replace(/ an /g, " the ") + 
                      " " + stim.effect + '."';
      	}
      }
      $(".other_name").html(stim.other_name);
      $("#none").html("0"  + " " + stim.object + " " + stim.effect);
      $(".N").html(N.toString() + " " + stim.object + " " + stim.effect);
      $("#lower_half").html("1 to " + Math.floor(N/2).toString() + " " + stim.object + " " + stim.effect);
      $("#upper_half").html(Math.ceil((N+1)/2).toString() + " to " + (N - 1).toString() + " " + stim.object + " " + stim.effect);
      $("#cause").html(cause);
      $("#effect_question").html(effect_question);
      $("#numObjects").html("<h3>"+N+"</h3>");
      $("#utterance").html(this.stim.actual_utterance);
      this.stim.actual_cause = cause;
      this.stim.actual_effect_question = effect_question;
//      this.stim.actual_utterance = utterance;      
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
    init_sliders : function(N) {
      utils.make_slider("#single_slider", function(event, ui) {
        exp.sliderPost = Math.round(ui.value*N);
        $("#number_guess").html(Math.round(ui.value*N));
      });
    },
    log_responses : function() {
        exp.data_trials.push({
          "trial_type" : "cause_effect_prior",
          "slide_number_in_experiment" : exp.phase,
          "object": this.stim.object,
          "object_level": this.stim.object_level,
          "cause": this.stim.cause,
          "num_objects": this.stim.N,
          "effect": this.stim.effect,
          "name": this.stim.name,
          "gender" : this.stim.gender,
          "other_gender" : this.stim.other_gender,
          "actual_cause": this.stim.actual_cause,
          "actual_effect_question": this.stim.actual_effect_question,
          "actual_utterance": this.stim.actual_utterance,          
          "quantifier" : this.stim.quantifier,
	      "response" : exp.sliderPost,
          "rt" : Date.now() - this.trial_start,
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

  var items = _.shuffle([
    {
      "object_low":"pencils",
      "object_mid":"crayons",
      "object_high":"ice cubes",
      "cause":"left __ in the hot sun",
      "effect":"melted",
      "extrautt":"It's a beautiful day."
    },
    {
      "object_low":"baseballs",
      "object_mid":"cakes",
      "object_high":"pieces of gum",
      "cause":"threw __ against a wall",
      "effect":"stuck to the wall",
      "extrautt":"What a strange thing to do."      
    },
    {
      "object_low":"rocks",
      "object_mid":"books",
      "object_high":"matches",
      "cause":"threw __ into a fire",
      "effect":"burnt",
      "extrautt":"I love watching fires."
    },
    {
      "object_low":"backpacks",
      "object_mid":"hats",
      "object_high":"napkins",
      "cause":"left __ on a table on a windy day",
      "effect":"blew away",
      "extrautt":"I just wish the weather was better."      
    },
    {
      "object_low":"cd-players",
      "object_mid":"computers",
      "object_high":"flashlights",
      "cause":"pressed the 'on' button on __",
      "effect":"lit up",
      "extrautt":"I wish we could just say 'on'."
    },
    {
      "object_low":"houses",
      "object_mid":"old cars",
      "object_high":"new cars",
      "cause":"left the lights on in __",
      "effect":"beeped",
      "extrautt":"That's not very good for the environment."      
    },
    {
      "object_low":"shoes",
      "object_mid":"shirts",
      "object_high":"books",
      "cause":"used __ as dog toys",
      "effect":"ripped",
      "extrautt":"Doesn't the dog have its own toys?"      
    },
    {
      "object_low":"logs",
      "object_mid":"boxes",
      "object_high":"sunglasses",
      "cause":"ran __ over with a car",
      "effect":"broke",
      "extrautt":"Why does Lucy always leave her stuff in the driveway?"      
    },
    {
      "object_low":"soda cans",
      "object_mid":"pinecones",
      "object_high":"banana peels",
      "cause":"put __ in a compost pile for a month",
      "effect":"decomposed",
      "extrautt":"What a great way to reduce trash."      
    },
    {
      "object_low":"candles",
      "object_mid":"fireworks",
      "object_high":"gas tanks",
      "cause":"lit __",
      "effect":"exploded",
      "extrautt":"Who came up with that idea?"      
    },
    {
      "object_low":"carrots",
      "object_mid":"oreos",
      "object_high":"sugar cubes",
      "cause":"put __ in a bucket of water",
      "effect":"dissolved",
      "extrautt":"There are people starving in the world."      
    },
    {
      "object_low":"beads",
      "object_mid":"sequins",
      "object_high":"stickers",
      "cause":"glued __ to a piece of paper",
      "effect":"stuck",
      "extrautt":"It looks like a zebra."      
    },
    {
      "object_low":"bicyclists",
      "object_mid":"bus drivers",
      "object_high":"taxi drivers",
      "cause":"cut off __",
      "effect":"honked",
      "extrautt":"That looks kind of dangerous."      
    },
    {
      "object_low":"lawyers",
      "object_mid":"comedians",
      "object_high":"kids",
      "cause":"told a joke to __",
      "effect":"laughed",
      "extrautt":"I guess once a jokester, always a jokester."      
    },
    {
      "object_low":"dogs",
      "object_mid":"butterflies",
      "object_high":"birds",
      "cause":"left seeds out for __",
      "effect":"ate the seeds",
      "extrautt":"I wish someone would leave seeds out for me."      
    },
    {
      "object_low":"phones",
      "object_mid":"bike lights",
      "object_high":"laptops",
      "cause":"left __ on (and unplugged) all day",
      "effect":"ran out of batteries",
      "extrautt":"That would be a pretty useful gadget."      
    },
    {
      "object_low":"birthday cards",
      "object_mid":"love notes",
      "object_high":"novels",
      "cause":"wrote __",
      "effect":"had the letter Z in them",
      "extrautt":"I just don't have the patience to write one of those."      
    },
    {
      "object_low":"notebooks",
      "object_mid":"pancakes",
      "object_high":"coins",
      "cause":"tossed __",
      "effect":"landed flat",
      "extrautt":"I love throwing stuff, too."      
    },
    {
      "object_low":"balloons",
      "object_mid":"cups",
      "object_high":"marbles",
      "cause":"threw __ into a pool",
      "effect":"sank",
      "extrautt":"It's just fun to throw stuff in the water."      
    },
    {
      "object_low":"strawberries",
      "object_mid":"bananas",
      "object_high":"clovers",
      "cause":"saw __",
      "effect":"were green",
      "extrautt":"I should start growing those myself."      
    },
    {
      "object_low":"white tablecloths",
      "object_mid":"white shirts",
      "object_high":"white carpets",
      "cause":"spilled red nail polish on __",
      "effect":"got stained",
      "extrautt":"Why always the red?"      
    },
    {
      "object_low":"shelves",
      "object_mid":"block towers",
      "object_high":"card towers",
      "cause":"punched __",
      "effect":"fell down",
      "extrautt":"Some people just love destruction."      
    },
    {
      "object_low":"phone screens",
      "object_mid":"diamonds",
      "object_high":"mirrors",
      "cause":"placed __ in the sun",
      "effect":"reflected the sunlight",
      "extrautt":"Why not just take them inside?"      
    },
    {
      "object_low":"poems",
      "object_mid":"songs",
      "object_high":"limericks",
      "cause":"wrote __",
      "effect":"rhymed",
      "extrautt":"It's so pretty."      
    },
    {
      "object_low":"bicycles",
      "object_mid":"motorcycles",
      "object_high":"cars",
      "cause":"pressed the brakes on __",
      "effect":"stopped",
      "extrautt":"So many parts need to work for us to not die." 
    },
    {
      "object_low":"toy cars",
      "object_mid":"shopping carts",
      "object_high":"wheelchairs",
      "cause":"pushed __",
      "effect":"rolled",
      "extrautt":"Pushing stuff is so much fun." 
    },
    {
      "object_low":"bottles of hand soap",
      "object_mid":"chocolate bars",
      "object_high":"berries",
      "cause":"put __ in the freezer",
      "effect":"froze",
      "extrautt":"That reminds me I need to visit my grandma."      
    },
    {
      "object_low":"webcams",
      "object_mid":"phones",
      "object_high":"cameras",
      "cause":"took a picture with __",
      "effect":"flashed",
      "extrautt":"Everyone with the selfie craze these days."      
    },
    {
      "object_low":"eggs",
      "object_mid":"balloons",
      "object_high":"bubbles",
      "cause":"poked __ with a pin",
      "effect":"popped",
      "extrautt":"That requires a lot of concentration."      
    },
    {
      "object_low":"CDs",
      "object_mid":"balls of tin foil",
      "object_high":"eggs",
      "cause":"heated up __ in a microwave",
      "effect":"exploded",
      "extrautt":"That's one way of spending your free time."      
    }
  ]);

  var names = _.shuffle([
    {
      "name":"James",
      "gender":"M"
    },
    {
      "name":"John",
      "gender":"M"
    },
    {
      "name":"Robert",
      "gender":"M"
    },
    {
      "name":"Michael",
      "gender":"M"
    },
    {
      "name":"William",
      "gender":"M"
    },
    {
      "name":"David",
      "gender":"M"
    },
    {
      "name":"Richard",
      "gender":"M"
    },
    {
      "name":"Joseph",
      "gender":"M"
    },
    {
      "name":"Charles",
      "gender":"M"
    },
    {
      "name":"Thomas",
      "gender":"M"
    },
    {
      "name":"Christopher",
      "gender":"M"
    },
    {
      "name":"Daniel",
      "gender":"M"
    },
    {
      "name":"Matthew",
      "gender":"M"
    },
    {
      "name":"Donald",
      "gender":"M"
    },
    {
      "name":"Anthony",
      "gender":"M"
    },
    {
      "name":"Paul",
      "gender":"M"
    },
    {
      "name":"Mark",
      "gender":"M"
    },
    {
      "name":"George",
      "gender":"M"
    },
    {
      "name":"Steven",
      "gender":"M"
    },
    {
      "name":"Kenneth",
      "gender":"M"
    },
    {
      "name":"Andrew",
      "gender":"M"
    },
    {
      "name":"Edward",
      "gender":"M"
    },
    {
      "name":"Joshua",
      "gender":"M"
    },
    {
      "name":"Brian",
      "gender":"M"
    },
    {
      "name":"Kevin",
      "gender":"M"
    },
    {
      "name":"Ronald",
      "gender":"M"
    },
    {
      "name":"Timothy",
      "gender":"M"
    },
    {
      "name":"Jason",
      "gender":"M"
    },
    {
      "name":"Jeffrey",
      "gender":"M"
    },
    {
      "name":"Gary",
      "gender":"M"
    },
    {
      "name":"Ryan",
      "gender":"M"
    },
    {
      "name":"Nicholas",
      "gender":"M"
    },
    {
      "name":"Eric",
      "gender":"M"
    },
    {
      "name":"Jacob",
      "gender":"M"
    },
    {
      "name":"Jonathan",
      "gender":"M"
    },
    {
      "name":"Larry",
      "gender":"M"
    },
    {
      "name":"Frank",
      "gender":"M"
    },
    {
      "name":"Scott",
      "gender":"M"
    },
    {
      "name":"Justin",
      "gender":"M"
    },
    {
      "name":"Brandon",
      "gender":"M"
    },
    {
      "name":"Raymond",
      "gender":"M"
    },
    {
      "name":"Gregory",
      "gender":"M"
    },
    {
      "name":"Samuel",
      "gender":"M"
    },
    {
      "name":"Benjamin",
      "gender":"M"
    },
    {
      "name":"Patrick",
      "gender":"M"
    },
    {
      "name":"Jack",
      "gender":"M"
    },
    {
      "name":"Dennis",
      "gender":"M"
    },
    {
      "name":"Jerry",
      "gender":"M"
    },
    {
      "name":"Alexander",
      "gender":"M"
    },
    {
      "name":"Tyler",
      "gender":"M"
    },
    {
      "name":"Mary",
      "gender":"F"
    },
    {
      "name":"Jennifer",
      "gender":"F"
    },
    {
      "name":"Elizabeth",
      "gender":"F"
    },
    {
      "name":"Linda",
      "gender":"F"
    },
    {
      "name":"Emily",
      "gender":"F"
    },
    {
      "name":"Susan",
      "gender":"F"
    },
    {
      "name":"Margaret",
      "gender":"F"
    },
    {
      "name":"Jessica",
      "gender":"F"
    },
    {
      "name":"Dorothy",
      "gender":"F"
    },
    {
      "name":"Sarah",
      "gender":"F"
    },
    {
      "name":"Karen",
      "gender":"F"
    },
    {
      "name":"Nancy",
      "gender":"F"
    },
    {
      "name":"Betty",
      "gender":"F"
    },
    {
      "name":"Lisa",
      "gender":"F"
    },
    {
      "name":"Sandra",
      "gender":"F"
    },
    {
      "name":"Helen",
      "gender":"F"
    },
    {
      "name":"Ashley",
      "gender":"F"
    },
    {
      "name":"Donna",
      "gender":"F"
    },
    {
      "name":"Kimberly",
      "gender":"F"
    },
    {
      "name":"Carol",
      "gender":"F"
    },
    {
      "name":"Michelle",
      "gender":"F"
    },
    {
      "name":"Emily",
      "gender":"F"
    },
    {
      "name":"Amanda",
      "gender":"F"
    },
    {
      "name":"Melissa",
      "gender":"F"
    },
    {
      "name":"Deborah",
      "gender":"F"
    },
    {
      "name":"Laura",
      "gender":"F"
    },
    {
      "name":"Stephanie",
      "gender":"F"
    },
    {
      "name":"Rebecca",
      "gender":"F"
    },
    {
      "name":"Sharon",
      "gender":"F"
    },
    {
      "name":"Cynthia",
      "gender":"F"
    },
    {
      "name":"Kathleen",
      "gender":"F"
    },
    {
      "name":"Ruth",
      "gender":"F"
    },
    {
      "name":"Anna",
      "gender":"F"
    },
    {
      "name":"Shirley",
      "gender":"F"
    },
    {
      "name":"Amy",
      "gender":"F"
    },
    {
      "name":"Angela",
      "gender":"F"
    },
    {
      "name":"Virginia",
      "gender":"F"
    },
    {
      "name":"Brenda",
      "gender":"F"
    },
    {
      "name":"Catherine",
      "gender":"F"
    },
    {
      "name":"Nicole",
      "gender":"F"
    },
    {
      "name":"Christina",
      "gender":"F"
    },
    {
      "name":"Janet",
      "gender":"F"
    },
    {
      "name":"Samantha",
      "gender":"F"
    },
    {
      "name":"Carolyn",
      "gender":"F"
    },
    {
      "name":"Rachel",
      "gender":"F"
    },
    {
      "name":"Heather",
      "gender":"F"
    },
    {
      "name":"Diane",
      "gender":"F"
    },
    {
      "name":"Joyce",
      "gender":"F"
    },
    {
      "name":"Julie",
      "gender":"F"
    },
    {
      "name":"Emma",
      "gender":"F"
    }
  ]);

  var quantifiers = _.shuffle([
    "None", "None", "None", "None", "None",
    "Some", "Some", "Some", "Some", "Some", "Some", "Some", "Some", "Some", "Some", // "some" twice as frequent
    "All", "All", "All", "All", "All",
    "short_filler", "short_filler", "short_filler", "short_filler", "short_filler",
    "long_filler", "long_filler", "long_filler", "long_filler", "long_filler"
  ]);
  var shortfillers = _.shuffle([
  	"Typical.",
  	"Nothing out of the ordinary.",
  	"As usual.",
  	"Pretty normal.",
  	"Nothing surprising there."
  ]);
  
  var shortfillercounter = 0;
  
  //var Ns = [4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
  var Ns = [15];

  function makeStim(i) {
    //get item
    var item = items[i];
    //get name
    var name_data = names[i];
    var name = name_data.name;
    var gender = name_data.gender;

    //make sure we have double as many names as trials!
    var other_name_data = names[names.length - i - 1];
    var other_name = other_name_data.name;
    var other_gender = other_name_data.gender;

    //get level
    var object_level = _.shuffle(["object_low", "object_mid", "object_high"])[0];
    //get pronouns
    var nom = gender == "M" ? "he" : "she";
    var acc = gender == "M" ? "him" : "her";
    var gen = gender == "M" ? "his" : "her";
    //get cause and effect elements
    var cause = item.cause;
    var effect = item.effect;
    var object = item[object_level];
    var cause_elements = cause.split("__");
    var beginning_cause = cause_elements[0];
    var end_cause = cause_elements.length > 1 ? cause_elements[1] : "";
    var actualutterance = "";
    if (quantifiers[i] == "short_filler") {
    	actualutterance = shortfillers[shortfillercounter];
    	shortfillercounter++;
    } else {
    	if (quantifiers[i] == "long_filler") {
    		actualutterance = item.extrautt;
    	}
    }
    return {
      "name": name,
      "quantifier": quantifiers[i],//_.shuffle(quantifiers)[0],
      "N": _.shuffle(Ns)[0],
      "name": name,
      "gender": gender,
      "other_name": other_name,
      "other_gender": other_gender,
      "object_level": object_level,
      "cause": cause,
      "effect": effect,
      "object": object,
      "beginning_cause": beginning_cause,
      "end_cause": end_cause,
      "actual_utterance": actualutterance
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
  exp.structure=["i0", "instructions", "cause_effect_prior", 'subj_info', 'thanks'];
  
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