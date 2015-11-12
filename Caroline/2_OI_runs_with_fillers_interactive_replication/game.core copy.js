/*  Copyright (c) 2012 Sven "FuzzYspo0N" Bergström, 
                  2013 Robert XD Hawkins
    
    written by : http://underscorediscovery.com
    written for : http://buildnewgames.com/real-time-multiplayer/
    
    substantially modified for collective behavior experiments on the web
    MIT Licensed.
*/

/*
  The main game class. This gets created on both server and
  client. Server creates one for each game that is hosted, and each
  client creates one for itself to play the game. When you set a
  variable, remember that it's only set in that instance.
*/
var has_require = typeof require !== 'undefined'

if( typeof _ === 'undefined' ) {
    if( has_require ) {
        _ = require('underscore')
    }
    else throw new ('mymodule requires underscore, see http://underscorejs.org');
}

var game_core = function(game_instance){

  this.debug = false;

  // Store the instance passed in from game.server.js
  this.instance = game_instance;
  
  //Store a flag if we are the server instance
  this.server = this.instance !== undefined;
  
  //Dimensions of world in pixels and numberof cells to be divided into;
  this.numHorizontalCells = 3;
  this.numVerticalCells = 1;
  this.cellDimensions = {height : 300, width : 300}; // in pixels
  this.cellPadding = 50;
  this.world = {height : (this.cellDimensions.height * this.numVerticalCells
              + this.cellPadding),
              width : (this.cellDimensions.width * this.numHorizontalCells
              + this.cellPadding)}; 
  
  // Which round are we on (initialize at -1 so that first round is 0-indexed)
  this.roundNum = -1;
  // $('#roundnumber').append(this.roundNum + 2);

  // How many rounds do we want people to complete?
  this.numRounds = 108;

  // How many mistakes have the pair made on the current trial?
  this.attemptNum = 0;

  // This will be populated with the tangram set
  this.objects = [];
  
  if(this.server) {
    // If we're initializing the server game copy, pre-create the list of trials
    // we'll use, make a player object, and tell the player who they are
    this.trialList = this.makeTrialList();
    this.data = {id : this.instance.id.slice(0,6), trials : [],
     catch_trials : [], system : {}, 
     //totalScore : {},
     subject_information : 
        {gameID: this.instance.id.slice(0,6), 
        speakerBoards : this.nameAndBoxAll(this.trialList, 'speaker'),
        initiallistenerBoards : this.nameAndBoxAll(this.trialList, 'listener')}}

    this.players = [{
      id: this.instance.player_instances[0].id, 
      player: new game_player(this,this.instance.player_instances[0].player)
    }];
    this.server_send_update();
  } else {
    // If we're initializing a player's local game copy, create the player object
    this.players = [{
      id: null, 
      player: new game_player(this)
    }];
  }
};

var game_player = function( game_instance, player_instance) {
  //Store the instance, if any (only the server copy will have one)
  this.instance = player_instance;
  // Store the game instance, so players can access it
  this.game = game_instance;
  // The player will be assigned to speaker or listener
  this.role = '';
  // This will be displayed in big letters on a plain white screen
  this.message = '';
  // This will be set to the player's id, once it is known
  this.id = '';
}; 

// server side we set some classes to global types, so that
// we can use them in other files (specifically, game.server.js)
if('undefined' != typeof global) {
  //Comment out:
  //var objectList = _.shuffle(require('./stimuli/objectSet')); // import stimuli
  //Caroline adds fillerList and criticalObjList // Never mind! doesn't work, 
  //since we need to loop through all 108 objects at once :( INSTEAD:
  var objectList = require('./stimuli/objectSet'); // import stimuli
  //var criticalObjList = _.shuffle(require('./stimuli/objectSet')); // import critical stimuli
  //var fillerList = _.shuffle(require('./stimuli/objectSet')); // import fillers
  // Fun experiment:
  // a = _.sample(objectList);
  // console.log(_.filter(objectList, function(x){return x.type == "filler"}));
  //var a = [1,2,3];
  //a = _.without(a, 2);
  //console.log(a);
  module.exports = global.game_core = game_core;
  module.exports = global.game_player = game_player;
}

// HELPER FUNCTIONS

// Method to easily look up player 
game_core.prototype.get_player = function(id) {
    var result = _.find(this.players, function(e){ return e.id == id; });
    return result.player
};

// Method to get list of players that aren't the given id
game_core.prototype.get_others = function(id) {
  return _.without(_.map(_.filter(this.players, function(e){return e.id != id;}), 
       function(p){return p.player ? p : null;}), null);
};

// Returns all players
game_core.prototype.get_active_players = function() {
  return _.without(_.map(this.players, function(p){
    return p.player ? p : null;}), null);
};

// Advance to the next round
game_core.prototype.newRound = function() {
  if(this.roundNum == this.numRounds - 1) {
    // If you've reached the planned number of rounds, end the game
    var local_game = this;
    _.map(local_game.get_active_players(), function(p){
      p.player.instance.disconnect();});
  } else {
    // Otherwise, get the preset list of tangrams for the new round
    this.roundNum += 1;
    roundNow = this.roundNum + 1;
    console.log("now on round " + roundNow);
    this.objects = this.trialList[this.roundNum];
    //when there is a new round, we want the server to send an update to the client
    //with the new roundNum;
    this.server_send_update();
  }
};

//What does this do???

var cartesianProductOf = function(listOfLists) {
    return _.reduce(listOfLists, function(a, b) {
        return _.flatten(_.map(a, function(x) {
            return _.map(b, function(y) {
                return x.concat([y]);
            });
        }), true);
    }, [ [] ]);
};

// Returns random set of unique grid locations
game_core.prototype.randomizeLocations = function() {
  //var possibilities = cartesianProductOf([_.range(1, this.numHorizontalCells + 1), [1] ]);
  var possibilities = [[1, 1],[2, 1],[3, 1]];
   //         _.range(1, this.numVerticalCells + 1)]);
  // does possibilities mean that possibilities of locations for one object?
  // That would mean three: one object can be at the left, middle or right location
  //OR does possibilities mean the possibilities of how to arange the objects
  // then, a b c / a c b / b a c / b c a / c b a / c a b
  //console.log(possibilities); // since possibilities.length = 3, poss. must mean the possible 
                                //locations of a SINGLE object
  // Makes sure we select locations WITHOUT replacement
  function getRandomFromBucket() {
    //var randomIndex = Math.floor(Math.random()*possibilities.length);
    var randomIndex = _.sample([0,1,2]);  // Why not use this?!
    //console.log(randomIndex);
    //console.log(possibilities.splice(randomIndex, 1)[0]); 
    return possibilities.splice(randomIndex, 1)[0];
  }
  return _.map(_.range(this.numHorizontalCells * this.numVerticalCells), function(v) {
    return getRandomFromBucket();
  });

};

//returns names of tangrams from single round objectList
game_core.prototype.getNames = function(trialList) {
  return _.pluck(trialList, 'name');
}

//returns list of speaker [x,y] coords for each tangram (only for 1 round)
game_core.prototype.getGridLocs = function(trialList, role) {
  if (role == 'speaker') {
    var speakerCoords = _.pluck(trialList, 'speakerCoords');
    var gridX = _.pluck(speakerCoords, 'gridX');
    var gridY = _.pluck(speakerCoords, 'gridY');
    return _.zip(gridX, gridY);
}
  else {
    var listenerCoords = _.pluck(trialList, 'listenerCoords');
    var gridX = _.pluck(listenerCoords, 'gridX');
    var gridY = _.pluck(listenerCoords, 'gridY');
    return _.zip(gridX, gridY);
  }
};

// returns box location range(1,12) of tangram, given [x,y] loc pair
game_core.prototype.boxLoc = function(loc) {
  var box = 0;
  var x = loc[0];
  var y = loc[1];
  if (y == 1) { 
    box = x; 
    return box;
  }
  else {
    box = x + 6;
    return box;
  }
};

// returns list of boxes for each tangram (1 round only)
game_core.prototype.getBoxLocs = function(trialList, role) {
  var tangramGridLocs = this.getGridLocs(trialList, role);
  var self = this;
  return _.map(tangramGridLocs, function(pair) {
    return self.boxLoc(pair);
  });
};

//returns list of name and box for all tangrams (1 round only)
game_core.prototype.nameAndBox = function(trialList, role) {
    var boxLocs = this.getBoxLocs(trialList, role);
    var names = this.getNames(trialList);
    return _.zip(names, boxLocs);
};

// returns list of name and box for all tangrams in all rounds
game_core.prototype.nameAndBoxAll = function(totalTrialList, role) {
  var self = this;
  return _.map(totalTrialList, function(x) {
    return self.nameAndBox(x, role);
  });
};

// get a set of non matching speaker and listener locations
game_core.prototype.notMatchingLocs = function() {
  var local_this = this;
  console.log(local_this);
  var speakerLocs = local_this.randomizeLocations();
  //console.log(speakerLocs);
  var listenerLocs = local_this.randomizeLocations();
  //console.log(listenerLocs);
  if (this.arraysDifferent (speakerLocs, listenerLocs)==true) {
    return [speakerLocs, listenerLocs];

  }
  return this.notMatchingLocs();
};


//helper function to check if two arrays are completely different from each other
game_core.prototype.arraysDifferent = function(arr1, arr2) {
  for(var i = arr1.length; i--;) {
      if(_.isEqual(arr1[i], arr2[i])) {
          return false;
    };
  }
  return true;
};

game_core.prototype.direcBoxes = function(speakerLocs) {
 var self = this;
_.map(speakerLocs, function(x) {
  return this.boxLoc;
  })
};

// Randomly sets tangram locations for each round
game_core.prototype.makeTrialList = function () {
  var local_this = this;
  //console.log(local_this);
  //Make a list of targets and fillers so we can delete objects which have already been used
  var criticalObjsList = _.filter(objectList, function(x){return x.type == "critical_trial"});
  _.shuffle(criticalObjsList);
  var fillerList = _.filter(objectList, function(x){return x.type == "filler"});
  var trialList =_.map(_.range(this.numRounds), function(i) { //creating a list?
  var conditionList = ["filler", "filler", "filler", "filler", "filler", "filler", 
  "filler", "filler", "filler", "filler", "filler", "filler", 
  "filler", "filler", "filler", "filler", "filler", "filler", 
  "filler", "filler", "filler", "filler", "filler", "filler", 
  "filler", "filler", "filler", "filler", "filler", "filler", 
  "filler", "filler", "filler", "filler", "filler", "filler", 
  "filler", "filler", "filler", "filler", "filler", "filler", 
  "filler", "filler", "filler", "filler", "filler", "filler", 
  "filler", "filler", "filler", "filler", "filler", "filler", 
  "filler", "filler", "filler", "filler", "filler", "filler", 
  "filler", "filler", "filler", "filler", "filler", "filler", 
  "filler", "filler", "filler", "filler", "filler", "filler", 
  "colorOnly", "colorOnly", "colorOnly", "colorOnly", "colorOnly", "colorOnly", 
  "colorOnly", "colorOnly", "colorOnly", "colorOnly", "colorOnly", "colorOnly", 
  "sizeOnly", "sizeOnly", "sizeOnly", "sizeOnly", "sizeOnly", "sizeOnly", 
  "sizeOnly", "sizeOnly", "sizeOnly", "sizeOnly", "sizeOnly", "sizeOnly", 
  "colorAndSize", "colorAndSize", "colorAndSize", "colorAndSize", "colorAndSize", "colorAndSize", 
  "colorAndSize", "colorAndSize", "colorAndSize", "colorAndSize", "colorAndSize", "colorAndSize", 
  ]
  _.shuffle(conditionList);
  var condition = conditionList[i];
  if (condition == "filler"){
     _.shuffle(fillerList);
    // Specify the 3 objects:
    var targetFillerObj = _.sample(fillerList);
    //Specify distr1:
    var distr1 = _.sample(fillerList);
    //Check if disr = target (we want 3 unique objects in the filler conditions!!)
    while (distr1.name == targetFillerObj.name){distr1 = _.sample(fillerList)};
    // Specify distr2:
    var distr2 = _.sample(fillerList);
    //Check uniqueness
    while (distr2.name == targetFillerObj.name || distr2.name == distr1.name){distr2 = _.sample(fillerList)};
    // Specify locations of 3 objects:
    //var locs = this.notMatchingLocs();

    //var locs = local_this.notMatchingLocs();
    
    var possibleLocsPerObj = [[1,1], [2,1], [3,1]];
    var targetLocSpeaker = _.sample(possibleLocsPerObj);
    //console.log(targetLocSpeaker);
    var distr1LocSpeaker = _.sample(_.without(possibleLocsPerObj, targetLocSpeaker));
    //console.log(distr1LocSpeaker);
    var distr2LocSpeaker = _.sample(_.without(possibleLocsPerObj, targetLocSpeaker, distr2LocSpeaker));
    //console.log(distr2LocSpeaker);
    var targetLocListener = _.sample(possibleLocsPerObj);
    var distr1LocListener = _.sample(_.without(possibleLocsPerObj, targetLocListener));
    var distr2LocListener = _.sample(_.without(possibleLocsPerObj, targetLocListener, distr1LocListener));
  }
  // else if it's a target trial (colorOnly, sizeOnly, colorAndSize):
  else {
    // Set the type of the critical object before setting the condition, in order to accomodate all objects
    // for this we need a list of all target objects:
    var criticalObj = _.sample(criticalObjsList);
    criticalObjsList = _.without(criticalObjsList, criticalObj); // modify criticalObjsList s.t. target item which was already used gets deleted
    // Now we can start with the critical conditions
    if (condition == "colorOnly"){
      var colorCriticalObj = _.sample(criticalObj.color);
      var sizeCriticalObj = _.sample(criticalObj.size);
      // Convert the attributes color and size of critical object from a list to an array, in order to 
      // be able to use the _.without function
      var colorCriticalObjArray = _.toArray(criticalObj.color);
      var sizeCriticalObjArray = _.toArray(criticalObj.size);
      // Properties of distractor 1:
      var colorDistr1 = _.without(colorCriticalObjArray, colorCriticalObj);
      var sizeDistr1 = sizeCriticalObj;
      // Properties of distractor 2:
      var colorDistr2 = colorDistr1;
      var sizeDistr2 = _.without(sizeCriticalObjArray, sizeCriticalObj);
      // Specify locations of 3 objects:
      //var locs = this.notMatchingLocs();
      var locs = local_this.notMatchingLocs();
    }
    else if (condition == "sizeOnly"){
      // Properties of the critical object in colorOnly condition:
      var colorCriticalObj = _.sample(criticalObj.color);
      var sizeCriticalObj = _.sample(criticalObj.size);
      // Convert the attributes color and size of critical object from a list to an array, in order to 
      // be able to use the _.without function
      var colorCriticalObjArray = _.toArray(criticalObj.color);
      var sizeCriticalObjArray = _.toArray(criticalObj.size);
      // Properties of distractor 1:
      var colorDistr1 = colorCriticalObj;
      var sizeDistr1 = _.without(sizeCriticalObjArray, sizeCriticalObj);
      // Properties of distractor 2:
      var colorDistr2 = _.without(colorCriticalObjArray, colorCriticalObj);
      var sizeDistr2 = sizeDistr1;
      // Specify locations of 3 objects:
      //var locs = this.notMatchingLocs();
      var locs = local_this.notMatchingLocs();
    }
    else { // condition == "colorAndSize"  
      // Properties of the critical object in colorOnly condition:
      var colorCriticalObj = _.sample(criticalObj.color);
      var sizeCriticalObj = _.sample(criticalObj.size);
      // Convert the attributes color and size of critical object from a list to an array, in order to 
      // be able to use the _.without function
      var colorCriticalObjArray = _.toArray(criticalObj.color);
      var sizeCriticalObjArray = _.toArray(criticalObj.size);
      // Properties of distractor 1:
      var colorDistr1 = _.without(colorCriticalObjArray, colorCriticalObj);
      var sizeDistr1 = _.without(sizeCriticalObjArray, sizeCriticalObj);
      // Properties of distractor 2:
      var colorDistr2 = colorDistr1;
      var sizeDistr2 = sizeDistr1;
      // Specify locations of 3 objects:
      //var locs = this.notMatchingLocs();
      var locs = local_this.notMatchingLocs();

    }
  }
// Robert's Notes on how to do this:
// var criticalObj = objectList[i];
// var criticalObjLoc = _.sample([1,2,3]);
// var locs = this.notMatchingLocs();
// console.log(_.map())
//    var objs = // array containing three objects
    debugger;
    return _.map(_.zip(criticalObjsList, speakerLocs, listenerLocs, speakerBoxes, listenerBoxes), function(pair) {
     //console.log(pair);
      var tangram = pair[0]   // [[tangramA,[4,1]*speaker, [3,2]*listener], [tangramB, [3,2]...]]
      var speakerGridCell = local_this.getPixelFromCell(pair[1][0], pair[1][1]); 
      var listenerGridCell = local_this.getPixelFromCell(pair[2][0], pair[2][1]);
      tangram.speakerCoords = {
        gridX : pair[1][0],
        gridY : pair[1][1],
        trueX : speakerGridCell.centerX - tangram.width/2,
        trueY : speakerGridCell.centerY - tangram.height/2,
        box : pair[3]
      };
      tangram.listenerCoords = {
        gridX : pair[2][0],
        gridY : pair[2][1],
        trueX : listenerGridCell.centerX - tangram.width/2,
        trueY : listenerGridCell.centerY - tangram.height/2,
        box :pair[4]
      };
      return tangram;
    });
  });
  return(trialList);
}

//scores the number of incorrect tangram matches between listener and speaker
//returns the correct score out of total tangrams
game_core.prototype.game_score = function(game_objects) {
   var correct = 0;
   var incorrect = 0;
   for(var i = game_objects.length; i--; i>=0) {
      if(game_objects[i].listenerCoords.gridX == game_objects[i].speakerCoords.gridX) {
        if(game_objects[i].listenerCoords.gridY == game_objects[i].speakerCoords.gridY) {
          correct = correct + 1;
        }
      }
      incorrect = incorrect + 1;
  }
  return correct;
}

// maps a grid location to the exact pixel coordinates
// for x = 1,2,3,4; y = 1,2,3,4
game_core.prototype.getPixelFromCell = function (x, y) {
  return {
    centerX: (this.cellPadding/2 + this.cellDimensions.width * (x - 1)
        + this.cellDimensions.width / 2),
    centerY: (this.cellPadding/2 + this.cellDimensions.height * (y - 1)
        + this.cellDimensions.height / 2),
    upperLeftX : (this.cellDimensions.width * (x - 1) + this.cellPadding/2),
    upperLeftY : (this.cellDimensions.height * (y - 1) + this.cellPadding/2),
    width: this.cellDimensions.width,
    height: this.cellDimensions.height
  };
};

// maps a raw pixel coordinate to to the exact pixel coordinates
// for x = 1,2,3,4; y = 1,2,3,4
game_core.prototype.getCellFromPixel = function (mx, my) {
  var cellX = Math.floor((mx - this.cellPadding / 2) / this.cellDimensions.width) + 1;
  var cellY = Math.floor((my - this.cellPadding / 2) / this.cellDimensions.height) + 1;
  return [cellX, cellY];
};

game_core.prototype.getTangramFromCell = function (gridX, gridY) {
    for (i=0; i < this.objects.length; i++) {
      if (this.objects[i].gridX == gridX && this.objects[i].gridY == gridY) {
        var tangram = this.objects[i];
        var tangramIndex = i;
        // return tangram;
        return i;
        }
    }
    console.log("Did not find tangram from cell!")
  }

// readjusts trueX and trueY values based on the objLocation and width and height of image (objImage)
game_core.prototype.getTrueCoords = function (coord, objLocation, objImage) {
  var trueX = this.getPixelFromCell(objLocation.gridX, objLocation.gridY).centerX - objImage.width/2;
  var trueY = this.getPixelFromCell(objLocation.gridX, objLocation.gridY).centerY - objImage.height/2;
  if (coord == "xCoord") {
    return trueX;
  }
  if (coord == "yCoord") {
    return trueY;
  }
}

game_core.prototype.server_send_update = function(){
  //Make a snapshot of the current state, for updating the clients
  var local_game = this;
  
  // Add info about all players
  var player_packet = _.map(local_game.players, function(p){
    return {id: p.id,
            player: null};
  });

  var state = {
    gs : this.game_started,   // true when game's started
    pt : this.players_threshold,
    pc : this.player_count,
    dataObj  : this.data,
    roundNum : this.roundNum,
    objects: this.objects
  };

  _.extend(state, {players: player_packet});
  _.extend(state, {instructions: this.instructions});
  if(player_packet.length == 2) {
    _.extend(state, {objects: this.objects});
  }

  //Send the snapshot to the players
  this.state = state;
  _.map(local_game.get_active_players(), function(p){
    p.player.instance.emit( 'onserverupdate', state);});
};

// (4.22208334636).fixed(n) will return fixed point value to n places, default n = 3
// Number.prototype.fixed = function(n) { n = n || 3; return parseFloat(this.toFixed(n)); };

