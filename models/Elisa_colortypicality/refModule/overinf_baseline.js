var uniformDraw = function (xs) {
  return xs[randomInteger(xs.length)];
};

var mean = function(thunk){
  return expectation(Enumerate(thunk), function(v){return v;});
};

var negate = function(predicate){
  return function(x){
    return !predicate(x);
  };
};

var identity = function(x){
  return x;
};

var condition = function(x){
 factor(x ? 0 : -Infinity);
};

var foreach = function(lst, fn) {
  var foreach_ = function(i) {
    if (i < lst.length) {
      fn(lst[i]);
      foreach_(i + 1);
    }
  };
  foreach_(0);
};

var getUtterancesOneFeature = function(context) {
  var utts = [];
  // map takes array context and with each element in context does what is in function
  map(function(c) {
    // utterance with adjective and noun
    utts.push(c[0]+"_"+c[1]);
    // utterance only with noun
    utts.push(c[1]);
    // utterance only with adjective
    utts.push(c[0]);
  },context);
  // returns list of strings with all possible utterances
  return _.unique(utts);
};

 var getTailoredTypicalityUnlogged = function(utt, object) {
    // console.log(utt);
    // console.log(object);
    // var f = Number.NEGATIVE_INFINITY;
    var e = 0;
    var tailoredtypicalities = {
      "apple" : {
        blue_apple : e,
        green_apple : e,
        red_apple : e
      },
      "avocado" : {
        black_avocado : e,
        green_avocado : e,
        red_avocado : e
      },
      "banana" : {
        blue_banana : e,
        brown_banana : e,
        yellow_banana : e
      },
      "carrot" : {
        brown_carrot : e,
        orange_carrot : e,
        pink_carrot : e
      },
      "pear" : {
        green_pear : e,
        orange_pear : e,
        yellow_pear : e
      },
      "pepper" : {
        black_pepper : e,
        orange_pepper : e,
        red_pepper : e,
        green_pepper : e
      },
      "tomato" : {
        green_tomato : e,
        pink_tomato : e,
        red_tomato : e
      },
      "fruit" : {
        blue_apple : e,
        green_apple : e,
        red_apple : e,
        black_avocado : e,
        green_avocado : e,
        red_avocado : e,
        blue_banana : e,
        brown_banana : e,
        yellow_banana : e,
        green_pear : e,
        orange_pear : e,
        yellow_pear : e
      },
      "vegetable" : {
        brown_carrot : e,
        orange_carrot : e,
        pink_carrot : e
      },
      "yellow" : {
        yellow_banana : e,
        yellow_pear : e
      },
      "orange" : {
        orange_carrot : e,
        orange_pear : e,
        orange_pepper : e
      },           
      "red" : {
        red_apple : e,
        red_avocado : e,
        red_pepper : e,
        red_tomato : e
      },    
      "pink" : {
        pink_carrot : e,
        pink_tomato : e
      },   
      "green" : {
        green_apple : e,
        green_avocado : e,
        green_pear : e,
        green_pepper : e,
        green_tomato : e
      },    
      "blue" : {
        blue_apple : e,
        blue_banana : e
      },    
      "brown" : {
        brown_banana : e,
        brown_carrot : e
      },    
      "black" : {
        black_avocado : e,
        black_pepper : e
      },
      "black_avocado" : {
        black_avocado : e
      },
      "black_pepper" : {
        black_pepper : e
      },
      "blue_apple" : {
        blue_apple : e
      },
      "blue_banana" : {
        blue_banana : e
      },
      "brown_banana" : {
        brown_banana : e
      },
      "green_apple" : {
        green_apple : e
      },
      "green_avocado" : {
        green_avocado : e
      },
      "green_pear" : {
        green_pear : e
      },
      "green_pepper" : {
        green_pepper : e
      },
      "orange_carrot" : {
        orange_carrot : e
      },
      "orange_pear" : {
        orange_pear : e
      },
      "orange_pepper" : {
        orange_pepper : e
      },
      "pink_carrot" : {
        pink_carrot : e
      },
      "pink_tomato" : {
        pink_tomato : e
      },
      "red_apple" : {
        red_apple : e
      },
      "red_avocado" : {
        red_avocado : e
      },
      "red_pepper" : {
        red_pepper : e
      },
      "red_tomato" : {
        red_tomato : e
      },
      "yellow_banana" : {
        yellow_banana : e
      },
      "yellow_pear" : {
        yellow_pear : e
      },
      "brown_carrot" : {
        brown_carrot : e
      },
      "green_tomato" : {
        green_tomato : e            
      },

    };

      var typicality = tailoredtypicalities[utt][object.join("_")];
      if (typeof typicality != 'undefined') {
        // console.log(typicality);
        return typicality;
      } else {
        // console.log("reassigned");
        return Number.NEGATIVE_INFINITY;
    }
    
  };
  
var OverinformativeModel = function(params, context) {

    // console.log(context);
  /*var getNoise = function(utt) {
    var splited = utt.split("_");
    if (splited.length == 2) {
      return 0.1
    } else {
      return _.contains(["color","othercolor","yellow", "blue"], splited[0]) ? 0.5 : 0;
    }
  }*/

  var getUtteranceCost = function(utt) {
    var splited = utt.split("_");
    if (splited.length == 2) {
      // conditioning cost on typicality
      // return _.contains(["blue"], splited[0]) ? params.cost_type + 0.2 : params.cost_color + params.cost_type;
      return params.cost_color + params.cost_type;
    } else {
      return _.contains(["yellow","orange","red","pink","green","blue","brown","black"], splited[0]) ? params.cost_color + params.color_only_cost : params.cost_type;
    }
  };

  var uttFitness = function(utt, object) {
    var typfit = getTailoredTypicalityUnlogged(utt,object); 
    // console.log(typfit);
    return typfit; 
  };

  var literalListener = cache(function(utt){
    return Infer({method:'enumerate'},function(){
      var object = uniformDraw(context);
      // console.log(object);
      // console.log(utt);
      // that's awesome
      factor(uttFitness(utt,object)); 
      return object;
    });
  });

  // what does cache do?
  var speaker = cache(function(target) {
    // list all possible utterances in context
    var possibleutts = getUtterancesOneFeature(context);
    return Infer({method:'enumerate'},function(){
      var utt = uniformDraw(possibleutts);
      var literalListenerERP = literalListener(utt);
      var uttCost = getUtteranceCost(utt);
      // console.log(uttCost);
      // var noise = getNoise(utt);
      var score = params.alpha * literalListenerERP.score(target) - params.lengthWeight * uttCost;
      // console.log("score: ");
      // console.log(score);
      factor(score); 
      return utt;
    });
  });

  var runModel = function(speakerModel, target) { 
    var speakerERP = speakerModel(target);
    return Infer({method:'enumerate'},function(){
      var utt = sample(speakerERP);
      return utt;
    });
  };

  var runListener = function(listenerModel, utterance) { 
    var listenerERP = listenerModel(utterance);
    return Infer({method:'enumerate'},function(){
      var obj = sample(listenerERP);
      return obj;
    });
  };    

  return {
    runModel : runModel,
    speaker : speaker,
    listener: literalListener,
    runListener : runListener
  };
};
