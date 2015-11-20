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
  this.numRounds = 72;

  // How many mistakes have the pair made on the current trial?
  this.attemptNum = 0;

  // This will be populated with the tangram set
  this.objects = [];
  
  if(this.server) {
    // If we're initializing the server game copy, pre-create the list of trials
    // we'll use, make a player object, and tell the player who they are
    this.trialList = this.makeTrialList();
    this.data = {
      id : this.instance.id.slice(0,6), trials : [],
      catch_trials : [], system : {}, 
      //totalScore : {},
      subject_information : {
        gameID: this.instance.id.slice(0,6)
      }
    }

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
  // test:
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

// Randomly sets tangram locations for each round
game_core.prototype.makeTrialList = function () {
  var local_this = this;
  //Make a list of targets and fillers so we can delete objects which have already been used
  //List of target objects for colorSize experiment:
  var criticalObjsList = _.shuffle(_.filter(objectList, function(x){return x.type == "critical_trial"}));
  //List of target objects for SubSuper experiment:
  var criticalObjsListSubSuper = _.shuffle(_.filter(objectList, function(x){return (x.type == "subSuperTrial" && x.status == "target")}));
  //List of distrClass1 objects for SubSuper experiment:
  var distrClass1ListSubSuper = _.shuffle(_.filter(objectList, function(x){return (x.type == "subSuperTrial" && x.status == "distrClass1")}));
  //List of distrClass2 objects for SubSuper experiment:
  var distrClass2ListSubSuper = _.shuffle(_.filter(objectList, function(x){return (x.type == "subSuperTrial" && x.status == "distrClass2")}));
  //List of distrClass3 objects for SubSuper experiment:
  var distrClass3ListSubSuper = _.shuffle(_.clone(distrClass2ListSubSuper));
  //Make conditions:
  var conditionList = _.shuffle(["distr12", "distr12", "distr12", "distr12", "distr12", 
    "distr12", "distr12", "distr12", "distr12", 
    "distr22", "distr22", "distr22", "distr22", "distr22", 
    "distr22", "distr22", "distr22", "distr22", 
    "distr23", "distr23", "distr23", "distr23", "distr23", 
    "distr23", "distr23", "distr23", "distr23", 
    "distr33", "distr33", "distr33", "distr33", "distr33", 
    "distr33", "distr33", "distr33", "distr33", 
    "colorOnly", "colorOnly", "colorOnly", "colorOnly", "colorOnly", "colorOnly", 
    "colorOnly", "colorOnly", "colorOnly", "colorOnly", "colorOnly", "colorOnly", 
    "sizeOnly", "sizeOnly", "sizeOnly", "sizeOnly", "sizeOnly", "sizeOnly", 
    "sizeOnly", "sizeOnly", "sizeOnly", "sizeOnly", "sizeOnly", "sizeOnly", 
    "colorAndSize", "colorAndSize", "colorAndSize", "colorAndSize", "colorAndSize", "colorAndSize", 
    "colorAndSize", "colorAndSize", "colorAndSize", "colorAndSize", "colorAndSize", "colorAndSize" 
   ])
  var trialList =_.map(conditionList, function(condition) { //creating a list?
    // SubSuper Experiment trials:
    if (condition == "distr12" || condition == "distr22" || condition == "distr23" || condition == "distr33"){
      // target list that we can modify s.t. every target is used exactly once
      criticalObjsListSubSuper = _.clone(criticalObjsListSubSuper);
      distrClass1ListSubSuper = _.clone(distrClass1ListSubSuper);
      distrClass2ListSubSuper = _.clone(distrClass2ListSubSuper);
      distrClass3ListSubSuper = _.clone(distrClass3ListSubSuper);
      if (condition == "distr12"){
        console.log("condition is distr12")
        // Specify the 3 objects:
        var targetDistr12 = _.sample(criticalObjsListSubSuper);
        // Remove target from target list s.t. every target is only used once
        criticalObjsListSubSuper = _.without(criticalObjsListSubSuper, targetDistr12);
        // Specify distr1:
        var distr1Distr12 = _.sample(_.filter(distrClass1ListSubSuper, function(x){ return x.domain == targetDistr12.domain; }));
        // Remove distr1 from distrClass1 list s.t. every distr in Class1 is only used once
        distrClass1ListSubSuper = _.without(distrClass1ListSubSuper, distr1Distr12);
        // Specify distr2:
        var distr2Distr12 = _.sample(_.filter(distrClass2ListSubSuper, function(x){ return x.domain == targetDistr12.domain; }));
        // Remove distr2 from distrClass2 list s.t. every distr in Class2 is only used once
        distrClass2ListSubSuper = _.without(distrClass2ListSubSuper, distr2Distr12);
        // Specify locations of 3 objects
        targetDistr12.targetStatus = "target";
        distr1Distr12.targetStatus = "distractor";
        distr2Distr12.targetStatus = "distractor";
        // Specify full name of object:
        targetDistr12.fullName = targetDistr12.name ;
        distr1Distr12.fullName = distr1Distr12.name;
        distr2Distr12.fullName = distr2Distr12.name;
        // Attach condition attribute to objects
        targetDistr12.condition = condition;
        distr1Distr12.condition = condition;
        distr2Distr12.condition = condition;
        var objectList = [targetDistr12, distr1Distr12, distr2Distr12];
        //console.log("filler objectlist [0].speakerCoords " + objectList[0].speakerCoords);
        var speakerLocs = _.shuffle([[1,1], [2,1], [3,1]]);
        var listenerLocs = _.shuffle([[1,1], [2,1], [3,1]]);
      } else if (condition == "distr22"){
        console.log("condition is distr22")
        // Specify the 3 objects:
        var targetDistr22 = _.sample(criticalObjsListSubSuper);
        // Remove target from target list s.t. every target is only used once
        criticalObjsListSubSuper = _.without(criticalObjsListSubSuper, targetDistr22);
        // Specify distr1:
        var distr1Distr22 = _.sample(_.filter(distrClass2ListSubSuper, function(x){ return x.domain == targetDistr22.domain; }));
        // Remove distr1 from distrClass2 list s.t. every distr in Class2 is only used once
        distrClass2ListSubSuper = _.without(distrClass2ListSubSuper, distr1Distr22);
        // Specify distr2:
        var distr2Distr22 = _.sample(_.filter(distrClass2ListSubSuper, function(x){ return x.domain == targetDistr22.domain; }));
        // Remove distr2 from distrClass2 list s.t. every distr in Class2 is only used once
        distrClass2ListSubSuper = _.without(distrClass2ListSubSuper, distr2Distr22);
        // Specify locations of 3 objects
        targetDistr22.targetStatus = "target";
        distr1Distr22.targetStatus = "distractor";
        distr2Distr22.targetStatus = "distractor";
        // Specify full name of object:
        targetDistr22.fullName = targetDistr22.name ;
        distr1Distr22.fullName = distr1Distr22.name;
        distr2Distr22.fullName = distr2Distr22.name;
        // Attach condition attribute to objects
        targetDistr22.condition = condition;
        distr1Distr22.condition = condition;
        distr2Distr22.condition = condition;
        var objectList = [targetDistr22, distr1Distr22, distr2Distr22];
        //console.log("filler objectlist [0].speakerCoords " + objectList[0].speakerCoords);
        var speakerLocs = _.shuffle([[1,1], [2,1], [3,1]]);
        var listenerLocs = _.shuffle([[1,1], [2,1], [3,1]]);
      } else if (condition == "distr23"){
        console.log("condition is distr23")
        // Specify the 3 objects:
        var targetDistr23 = _.sample(criticalObjsListSubSuper);
        // Remove target from target list s.t. every target is only used once
        criticalObjsListSubSuper = _.without(criticalObjsListSubSuper, targetDistr23);
        // Specify distr1:
        var distr1Distr23 = _.sample(_.filter(distrClass2ListSubSuper, function(x){ return x.domain == targetDistr23.domain; }));
        // Remove distr1 from distrClass2 list s.t. every distr in Class2 is only used once
        distrClass2ListSubSuper = _.without(distrClass2ListSubSuper, distr1Distr23);
        // Specify distr2:
        var distr2Distr23 = _.sample(distrClass3ListSubSuper);
        while (distr2Distr23.name == distr1Distr23.name){distr2Distr23 = _.sample(distrClass3ListSubSuper)};
        // Specify locations of 3 objects
        targetDistr23.targetStatus = "target";
        distr1Distr23.targetStatus = "distractor";
        distr2Distr23.targetStatus = "distractor";
        // Specify full name of object:
        targetDistr23.fullName = targetDistr23.name ;
        distr1Distr23.fullName = distr1Distr23.name;
        distr2Distr23.fullName = distr2Distr23.name;
        // Attach condition attribute to objects
        targetDistr23.condition = condition;
        distr1Distr23.condition = condition;
        distr2Distr23.condition = condition;
        var objectList = [targetDistr23, distr1Distr23, distr2Distr23];
        //console.log("filler objectlist [0].speakerCoords " + objectList[0].speakerCoords);
        var speakerLocs = _.shuffle([[1,1], [2,1], [3,1]]);
        var listenerLocs = _.shuffle([[1,1], [2,1], [3,1]]);
      } else {  //if (condition == "distr33")
        console.log("condition is distr33")
        // Specify the 3 objects:
        var targetDistr33 = _.sample(criticalObjsListSubSuper);
        // Remove target from target list s.t. every target is only used once
        criticalObjsListSubSuper = _.without(criticalObjsListSubSuper, targetDistr33);
        // Specify distr1:
        var distr1Distr33 = _.sample(distrClass3ListSubSuper);
        // Specify distr2:
        var distr2Distr33 = _.sample(distrClass3ListSubSuper);
        while (distr2Distr33.name == distr1Distr33.name){distr2Distr33 = _.sample(distrClass3ListSubSuper)};
        // Specify locations of 3 objects
        targetDistr33.targetStatus = "target";
        distr1Distr33.targetStatus = "distractor";
        distr2Distr33.targetStatus = "distractor";
        // Specify full name of object:
        targetDistr33.fullName = targetDistr33.name ;
        distr1Distr33.fullName = distr1Distr33.name;
        distr2Distr33.fullName = distr2Distr33.name;
        // Attach condition attribute to objects
        targetDistr33.condition = condition;
        distr1Distr33.condition = condition;
        distr2Distr33.condition = condition;
        var objectList = [targetDistr33, distr1Distr33, distr2Distr33];
        //console.log("filler objectlist [0].speakerCoords " + objectList[0].speakerCoords);
        var speakerLocs = _.shuffle([[1,1], [2,1], [3,1]]);
        var listenerLocs = _.shuffle([[1,1], [2,1], [3,1]]);
      }
    }
    // ColorSize experiment trials:
    else {
      criticalObjsList = _.clone(criticalObjsList);
      // Set the type of the critical object before setting the kind of critical condition, in order to accomodate all objects
      // for this we need a list of all target objects:
      // Now we can start with the critical conditions
      if (condition == "colorOnly"){
        console.log("condition is colorOnly");
        var targetCriticalObj = _.sample(criticalObjsList);
        console.log("targetCriticalObj: ", targetCriticalObj)
        criticalObjsList = _.without(criticalObjsList, targetCriticalObj); // modify criticalObjsList s.t. target item which was already used gets deleted
        // console.log("after", criticalObjsList)
        //Initialize distractors, which are the same object as the target object in critical trials:
        var distr1 = _.clone(targetCriticalObj);
        var distr2 = _.clone(targetCriticalObj);
        // Properties of target:
        var colorCriticalObj = _.sample(targetCriticalObj.color);
        var sizeCriticalObj = _.sample(targetCriticalObj.size);
        // Properties of distractor 1:
        var colorDistr1 = _.without(targetCriticalObj.color, colorCriticalObj);
        var sizeDistr1 = sizeCriticalObj;
        // Properties of distractor 2:
        var colorDistr2 = colorDistr1;
        var sizeDistr2 = _.without(targetCriticalObj.size, sizeCriticalObj);
        // Target status
        targetCriticalObj.targetStatus = "target";
        distr1.targetStatus = "distractor";
        distr2.targetStatus = "distractor";
        // Specify full name of object:
        targetCriticalObj.fullName = sizeCriticalObj +  "_" + colorCriticalObj +  "_" +  targetCriticalObj.name ;
        distr1.fullName = sizeDistr1 +  "_" + colorDistr1 +  "_" +  distr1.name ;
        distr2.fullName = sizeDistr2 +  "_" + colorDistr2 +  "_" +  distr2.name ;
        // Attach condition attribute to objects
        targetCriticalObj.condition = condition;
        distr1.condition = condition;
        distr2.condition = condition;
        // Specify url of stimuli
        targetCriticalObj.url = "stimuli/" + targetCriticalObj.fullName + ".jpg";
        distr1.url = "stimuli/" + distr1.fullName + ".jpg";
        distr2.url = "stimuli/" + distr2.fullName + ".jpg";
        // Specify locations of 3 objects:
        var objectList = [targetCriticalObj, distr1, distr2];
        //console.log("critical objectlist [0].speakerCoords: " + objectList[0].speakerCoords);
        var speakerLocs = _.shuffle([[1,1], [2,1], [3,1]]);
        var listenerLocs = _.shuffle([[1,1], [2,1], [3,1]]);
      }
      else if (condition == "sizeOnly"){
        console.log("condition is sizeOnly");
        var targetCriticalObj = _.sample(criticalObjsList);
        // console.log("before", criticalObjsList)
        criticalObjsList = _.without(criticalObjsList, targetCriticalObj); // modify criticalObjsList s.t. target item which was already used gets deleted
        // console.log("after", criticalObjsList)
        //Initialize distractors, which are the same object as the target object in critical trials:
        var distr1 = _.clone(targetCriticalObj);
        var distr2 = _.clone(targetCriticalObj);
        // Properties of target:
        var colorCriticalObj = _.sample(targetCriticalObj.color);
        var sizeCriticalObj = _.sample(targetCriticalObj.size);
        // Properties of distractor 1:
        var colorDistr1 = colorCriticalObj;
        var sizeDistr1 = _.without(targetCriticalObj.size, sizeCriticalObj);
        // Properties of distractor 2:
        var colorDistr2 = _.without(targetCriticalObj.color, colorCriticalObj);
        var sizeDistr2 = sizeDistr1;
        // Target status
        targetCriticalObj.targetStatus = "target";
        distr1.targetStatus = "distractor";
        distr2.targetStatus = "distractor";
        //Specify full name of object:
        targetCriticalObj.fullName = sizeCriticalObj +  "_" + colorCriticalObj +  "_" +  targetCriticalObj.name ;
        distr1.fullName = sizeDistr1 +  "_" + colorDistr1 +  "_" +  distr1.name ;
        distr2.fullName = sizeDistr2 +  "_" + colorDistr2 +  "_" +  distr2.name ;
        // Attach condition attribute to objects
        targetCriticalObj.condition = condition;
        distr1.condition = condition;
        distr2.condition = condition;
        // Specify url of stimuli
        targetCriticalObj.url = "stimuli/" + targetCriticalObj.fullName + ".jpg";
        distr1.url = "stimuli/" + distr1.fullName + ".jpg";
        distr2.url = "stimuli/" + distr2.fullName + ".jpg";
        // Specify locations of 3 objects:
        var objectList = [targetCriticalObj, distr1, distr2];
        var speakerLocs = _.shuffle([[1,1], [2,1], [3,1]]);
        var listenerLocs = _.shuffle([[1,1], [2,1], [3,1]]);
      }
      else { // condition == "colorAndSize"  
        console.log("condition is colorOAndSize");
        var targetCriticalObj = _.sample(criticalObjsList);
        // console.log("before", criticalObjsList)
        criticalObjsList = _.without(criticalObjsList, targetCriticalObj); // modify criticalObjsList s.t. target item which was already used gets deleted
        // console.log("after", criticalObjsList)
        //Initialize distractors, which are the same object as the target object in critical trials:
        var distr1 = _.clone(targetCriticalObj);
        var distr2 = _.clone(targetCriticalObj);
        // Properties of target:
        var colorCriticalObj = _.sample(targetCriticalObj.color);
        var sizeCriticalObj = _.sample(targetCriticalObj.size);
        // Properties of distractor 1:
        var colorDistr1 = _.without(targetCriticalObj.color, colorCriticalObj);
        var sizeDistr1 = _.without(targetCriticalObj.size, sizeCriticalObj);
        // Properties of distractor 2:
        var colorDistr2 = colorDistr1;
        var sizeDistr2 = sizeDistr1;
        // Target status
        targetCriticalObj.targetStatus = "target";
        distr1.targetStatus = "distractor";
        distr2.targetStatus = "distractor";
        //Specify full name of object:
        targetCriticalObj.fullName = sizeCriticalObj +  "_" + colorCriticalObj +  "_" +  targetCriticalObj.name ;
        distr1.fullName = sizeDistr1 +  "_" + colorDistr1 +  "_" +  distr1.name ;
        distr2.fullName = sizeDistr2 +  "_" + colorDistr2 +  "_" +  distr2.name ;
        // Attach condition attribute to objects
        targetCriticalObj.condition = condition;
        distr1.condition = condition;
        distr2.condition = condition;
        // Specify url of stimuli
        targetCriticalObj.url = "stimuli/" + targetCriticalObj.fullName + ".jpg";
        distr1.url = "stimuli/" + distr1.fullName + ".jpg";
        distr2.url = "stimuli/" + distr2.fullName + ".jpg";
        // Specify locations of 3 objects:
        var objectList = [targetCriticalObj, distr1, distr2];
        var speakerLocs = _.shuffle([[1,1], [2,1], [3,1]]);
        var listenerLocs = _.shuffle([[1,1], [2,1], [3,1]]);
      }
    }
    return _.map(_.zip(objectList, speakerLocs, listenerLocs), function(tuple) {
       //console.log(tuple);
        var object = _.clone(tuple[0]);  
        var speakerGridCell = local_this.getPixelFromCell(tuple[1][0], tuple[1][1]); 
        //console.log("obj.width robert :" + object.width);
        var listenerGridCell = local_this.getPixelFromCell(tuple[2][0], tuple[2][1]);
        object.speakerCoords = {
          gridX : tuple[1][0],
          gridY : tuple[1][1],
          trueX : speakerGridCell.centerX - object.width/2,
          trueY : speakerGridCell.centerY - object.height/2,
          gridPixelX: speakerGridCell.centerX - 150,
          gridPixelY: speakerGridCell.centerY - 150
        };
        //console.log("obj.speakercoords.trueX robert :" + object.speakerCoords.trueX);
        object.listenerCoords = {
          gridX : tuple[2][0],
          gridY : tuple[2][1],
          trueX : listenerGridCell.centerX - object.width/2,
          trueY : listenerGridCell.centerY - object.height/2,
          gridPixelX: listenerGridCell.centerX - 150,
          gridPixelY: listenerGridCell.centerY - 150
        };
        return object;
    });
  });
  //console.log(JSON.stringify(trialList));
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

console.log(this.object);

