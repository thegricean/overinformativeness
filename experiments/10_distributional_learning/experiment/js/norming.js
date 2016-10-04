// Returns a random integer between min (included) and max (excluded)
// Using Math.round() will give you a non-uniform distribution!
function getRandomInt(min, max) {
  return Math.floor(Math.random() * (max - min)) + min;
}

function startsWith(str, substrings) {
    for (var i = 0; i != substrings.length; i++) {
       var substring = substrings[i];
       if (str.indexOf(substring) == 0) {
         return 1;
       }
    }
    return -1; 
}

function make_slides(f) {
  var   slides = {};

  slides.i0 = slide({
     name : "i0",
     start: function() {
      exp.startT = Date.now();
     }
  });

  slides.intro = slide({
    name : "intro",
    button : function() {
      exp.go();
    }
  });

  slides.exposure = slide({
    name: "exposure",
    present : exp.all_expos,
    present_handle : function(stim) {
      console.log('made it into exposure');
      
      // title that always tells participant which type of food they should look for
      var tofind = "Please, collect all <strong><span id='thing_to_find'>{{}}</span>s</strong>!";
      $("#tofind").html(tofind);

      // array where all food items are saved in (to keep track of what we already have)
      var food = [];

      // get all food items and count number of appearances of one kind of food
      for (var i=0; i<exp.all_expos.length; i++) {
        var objimagehtml = '<img src="pictures/'+exp.all_expos[i].item+'_'+exp.all_expos[i].color+'.png" style="height:50px;">';
        var count=0;
        for (var l=0; l<food.length; l++) {
          if (food[l] == exp.all_expos[i].item) {
            count++;
          }
        }

        // 'transfer' picture to html file with id consisting of type of food and how many of those are already transfered
        $("#"+exp.all_expos[i].item+(count+1)).html(objimagehtml);

        // add new food item to list of food items
        food.push(exp.all_expos[i].item);
      }

      // the object that is the current stimulus, isn't in exp.all_expos; this is why it needs to be added separately
      var objimagehtml = '<img src="pictures/'+stim.label+'_'+stim.color+'.png" style="height:50px;">';
      $("#"+stim.label+9).html(objimagehtml);

      //
      // DRAGGING AND DROPPING
      //

      var initial_position_x;
      var initial_position_y;

      // target elements with the "draggable" class
      interact('.draggable').draggable({
          // enable inertial throwing
          inertia: true,
          // keep the element within the area of it's parent
          restrict: {
            restriction: "parent",
            endOnly: true,
            elementRect: { top: 0, left: 0, bottom: 1, right: 1 }
          },
          // enable autoScroll
          autoScroll: true,

          snap: true,

          // call this function on every dragmove event
          onmove: dragMoveListener,
          // call this function on every dragend event
          onend: function (event) {

            var textEl = event.target.querySelector('p');

            textEl && (textEl.textContent =
              'moved a distance of '
              + (Math.sqrt(event.dx * event.dx +
                           event.dy * event.dy)|0) + 'px');
          }
        });

      // 
      function dragMoveListener (event) {
        console.log("A");
        old_spot_x = event.dx;
        old_spot_y = event.dy;
        var target = event.target,
          // keep the dragged position in the data-x/data-y attributes
          x = (parseFloat(target.getAttribute('data-x')) || 0) + event.dx,
          y = (parseFloat(target.getAttribute('data-y')) || 0) + event.dy;

        // translate the element
        target.style.webkitTransform =
        target.style.transform =
          'translate(' + x + 'px, ' + y + 'px)';

        // update the position attributes
        target.setAttribute('data-x', x);
        target.setAttribute('data-y', y);

      }

      // this is used later in the resizing and gesture demos
      window.dragMoveListener = dragMoveListener;

      /* The dragging code for '.draggable' from the demo above
       * applies to this demo as well so it doesn't have to be repeated. */

      // to randomly choose the accepted type of food 
      var target_order = _.shuffle([0,1,2,3,4,5]);
      var acceptance = ['#apple1, #apple2, #apple3, #apple4, #apple5, #apple6, #apple7, #apple8, #apple9', 
                        '#banana1, #banana2, #banana3, #banana4, #banana5, #banana6, #banana7, #banana8, #banana9', 
                        '#carrot1, #carrot2, #carrot3, #carrot4, #carrot5, #carrot6, #carrot7, #carrot8, #carrot9', 
                        '#cucumber1, #cucumber2, #cucumber3, #cucumber4, #cucumber5, #cucumber6, #cucumber7, #cucumber8, #cucumber9', 
                        '#onion1, #onion2, #onion3, #onion4, #onion5, #onion6, #onion7, #onion8, #onion9', 
                        '#strawberry1, #strawberry2, #strawberry3, #strawberry4, #strawberry5, #strawberry6, #strawberry7, #strawberry8, #strawberry9'];
      var object_name = ['apple', 'banana', 'carrot', 'cucumber', 'onion', 'strawberry']

      // enable draggables to be dropped into this
      function init_dropzone(target_count) {
        // keeps track of how many item from one food type have already been put into the basket
        target_total = 0;
        // change the food type in the title according to accepted food type
        $('#thing_to_find').html(object_name[target_order[target_count]]);
        // change the basket (new label);
        var updated_basket = '<img src="pictures/basket_'+object_name[target_order[target_count]]+'.png" style="height:80px;">';
        // var updated_basket = '<img src="pictures/basket.png" style="height:80px;">';
        $('#basket').html(updated_basket);

        // try out
        function resetCoords(evt) {
          evt.relatedTarget.style.left = "0px";
          evt.relatedTarget.style.top = "0px";
          evt.interaction.x = 0;
          evt.interaction.y = 0;
        }
        // end of try out

        interact('.dropzone').dropzone({
          // only accept elements matching this CSS selecto
          accept: acceptance[target_order[target_count]],
          
          // Require a 20% element overlap for a drop to be possible
          overlap: 0.2,

          // listen for drop related events:

          ondropactivate: function (event) {
            // console.log("1");
            // add active dropzone feedback
            event.target.classList.add('drop-active');
          },
          ondragenter: function (event) {
            // console.log("2");
            var draggableElement = event.relatedTarget,
                dropzoneElement = event.target;
            // console.log(acceptance[target_order[target_count]])
            // feedback the possibility of a drop
            dropzoneElement.classList.add('drop-target');
            draggableElement.classList.add('can-drop');
            // draggableElement.textContent = 'Put into basket';
          },
          ondragleave: function (event) {
            // console.log("3");
            // remove the drop feedback style
            event.target.classList.remove('drop-target');
            event.relatedTarget.classList.remove('can-drop');
            // event.relatedTarget.textContent = 'Not in basket yet';
          },
          ondrop: function (event) {
            // console.log("4");
            event.relatedTarget.textContent = 'Dropped';

            // update the position attributes
            initial_position_x = event.relatedTarget.getAttribute('data-x');
            initial_position_y = event.relatedTarget.getAttribute('data-y');
            console.log(initial_position_x);
            console.log(initial_position_y);

            event.relatedTarget.remove();
            // new item of a food type was received
            target_total++;
            // if at least 9 items of one food type have been dropped
            if (target_total >= 9) {
              // and if this wasn't the last food type
              if (target_count < 5) {
                // restart this process and remember that one more type of food is already sorted
                init_dropzone(target_count+1);
              // if all items are sorted, switch to next slide
              } else { exp.go() }
            }
          },
          ondropdeactivate: function (event) {
            // console.log("5");

            // remove active dropzone feedback
            event.target.classList.remove('drop-active');
            event.target.classList.remove('drop-target');

          }
        });
      }
      // call function (necessary for recursive structure as 'accept' has to be updated)
      init_dropzone(0);
    },
  });

  slides.production = slide({
    name: "production",
    present: exp.prod_stims,
    start : function() {
      $(".err").hide();
    },
    present_handle: function(stim) {
      console.log('made it into production');
      
      /*// title that always tells participant which type of food they have to name
      var todescribe = "<strong>Which food item belongs in the <span id='thing_to_describe'>current</span> drawer?</strong> <br /> Type your answer in the field below and click 'Submit'.";
      $("#todescribe").html(todescribe);*/

      // food1 and color1 is target
      var food1html = '<img src="pictures/target_'+stim.food1+'_'+stim.color1+'.png" style="height:90px;">';
      var food2html = '<img src="pictures/'+stim.food2+'_'+stim.color2+'.png" style="height:90px;">';
      var food3html = '<img src="pictures/'+stim.food3+'_'+stim.color3+'.png" style="height:90px;">';
      shuffled_images = _.shuffle([food1html, food2html, food3html]);
      // console.log(stim.food1, stim.color1);
      $("#food1").html(shuffled_images[0]);
      $("#food2").html(shuffled_images[1]);
      $("#food3").html(shuffled_images[2]);

    },
    button : function() {
      if ($("#utterance").val().length < 3) {
        $(".err").show();
      } else {
        utterance = $("#utterance").val();
        console.log(utterance);
        _stream.apply(this);
        // stim.utterance = $("#utterance").val();
      }
    },
  });



  slides.objecttrial = slide({
    name : "objecttrial",
    present : exp.all_stims,
    start : function() {
	    $(".err").hide();
    },
    present_handle : function(stim) {
    	this.trial_start = Date.now();
      console.log('made it into a new trial');
    	this.init_sliders();
      exp.sliderPost = {};
  	  this.stim = stim;

    	// How typical is this color for this object?
      var contextsentence = "How typical is this for <strong>"+stim.label+"</strong>?";
    	var objimagehtml = '<img src="pictures/'+stim.item+'_'+stim.color+'.png" style="height:190px;">';

    	$("#contextsentence").html(contextsentence);
    	$("#objectimage").html(objimagehtml);
    	  console.log(this);
	  },
	  button : function() {
	    if (exp.sliderPost > -1 && exp.sliderPost < 16) {
        $(".err").hide();
        // this.log_responses();
        _stream.apply(this); //use exp.go() if and only if there is no "present" data.
      } else {
        $(".err").show();
      }
    },
    init_sliders : function() {
      utils.make_slider("#single_slider", function(event, ui) {
        exp.sliderPost = ui.value;
      });
    },
    /*log_responses : function() {
        exp.data_trials.push({
          "label" : this.stim.label,
          "slide_number_in_experiment" : exp.phase,
          "item": this.stim.item,
          "rt" : Date.now() - _s.trial_start,
	      "response" : exp.sliderPost,
	      "color": this.stim.color,
	      "size": this.stim.size,
        "condition": this.stim.condition
        });
    }*/
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
      "item": "apple",
      "label": "apple",
      "color": ["red", "yellow", "blue", "green"]
    },
    {
      "item": "avocado",
      "label": "avocado",
      "color": ["red", "black", "green"]
    },
    {
      "item": "banana",
      "label": "banana",
      "color": ["blue", "brown", "yellow"]
    },
    {
      "item": "carrot",
      "label": "carrot",
      "color": ["orange", "pink", "purple"]
    },
    {
      "item": "orange",
      "label": "orange",
      "color": ["orange", "purple", "yellow"]
    },
    {
      "item": "pepper",
      "label": "pepper",
      "color": ["green", "orange", "red"]
    },
    {
      "item": "tomato",
      "label": "tomato",
      "color": ["green", "pink", "red"]
    }
  ]).slice(0,36);



  function makeExpo(i) {
    //get item
    var item = items[i];
    var item_id = item.item;
    var color = _.shuffle(item.color)[0];
    label = item.label;
    return {
      "item": item_id,
      "label": label,
      "color": color,  
    }
  }

  exp.all_expos = [];
  for (var k=0; k<9; k++) {
    for (var i=0; i<6; i++) {
      exp.all_expos.push(makeExpo(i));
    }
  }



  function makeStim(i) {
    //get item
    var item = items[i];
    var item_id = item.item;
    var color = _.shuffle(item.color)[0];
    var label = "bla";
    var article = "";

    if (startsWith(item.label, ["a","e","i","o","u"]) == 1) {
    	article = "an";
    } else {
    	article = "a";
		}    	

		label = article+" "+item.label; 
      

      return {
	  "item": item_id,
	  "label": label,
	  "color": color,
    }
  }
  exp.all_stims = [];
  for (var i=0; i<items.length; i++) {
    exp.all_stims.push(makeStim(i));
  }

  function makeProdStim(food_item, context_condition) {
    //get item
    var prod_item = [items[food_item]];
    // make sure that every item is there in two colors for two times
    // creating two items in typical and two in atypical color
    if (context_condition%2 == 0) {
      var color1 = (prod_item[0].color)[0];
    } else {
      var color1 = (prod_item[0].color)[1];
    }
    
    // need to have one (a)typical item in overinformative and one in only informative context
    if (context_condition==0 || context_condition==1) {
      prod_item.push(items[food_item]);
      // console.log("informative trial");
      if (context_condition==0) {
        var color2 = (prod_item[1].color)[1];
      }
      else {
        var color2 = (prod_item[1].color)[0];
      }
    } else {
      // console.log("overinformative trial");
      // random_food can be anything except for food_item
      random_food = getRandomInt(0,6);
      while (random_food == food_item) {
        random_food = getRandomInt(0,6);
      }
      prod_item.push(items[random_food]);
      var color2 = _.shuffle(prod_item[1].color)[0];
    }

    random_food = getRandomInt(0,6);
    while (random_food == food_item) {
      random_food = getRandomInt(0,6);
    }
    prod_item.push(items[random_food]);
    var color3 = _.shuffle(prod_item[2].color)[0];

    // console.log(prod_item);

    return {
    "food1": prod_item[0].item,
    "food2": prod_item[1].item,
    "food3": prod_item[2].item,
    "color1": color1,
    "color2": color2,
    "color3": color3
    }
  }

  exp.prod_stims = [];
  for (var food_item=0; food_item<6; food_item++) {
    for (var context_condition=0; context_condition<4; context_condition++) {
      exp.prod_stims.push(makeProdStim(food_item, context_condition));
    }
  }
  exp.prod_stims = _.shuffle(exp.prod_stims);



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
  exp.structure=["i0", "intro", "exposure", "production", "objecttrial", 'subj_info', 'thanks'];
  
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

  $("#agree_button").click(function() {
    exp.go();
  });

  exp.go(); //show first slide
}
