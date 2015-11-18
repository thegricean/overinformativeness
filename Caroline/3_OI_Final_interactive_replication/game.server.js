/*  Copyright (c) 2012 Sven "FuzzYspo0N" Bergström, 2013 Robert XD Hawkins
    
    written by : http://underscorediscovery.com
    written for : http://buildnewgames.com/real-time-multiplayer/
    
    modified for collective behavior experiments on Amazon Mechanical Turk

    MIT Licensed.
*/
    var
        use_db      = false,
        game_server = module.exports = { games : {}, game_count:0, assignment:0},
        fs          = require('fs');
        clientobjectList = [];
        // totalScore = 0;
	    
    if (use_db) {
	    database    = require(__dirname + "/database"),
	    connection  = database.getConnection();
    }

global.window = global.document = global;
require('./game.core.js');
utils = require('./utils.js');

// This is the function where the server parses and acts on messages
// sent from 'clients' aka the browsers of people playing the
// game. For example, if someone clicks on the map, they send a packet
// to the server (check the client_on_click function in game.client.js)
// with the coordinates of the click, which this function reads and
// applies.
game_server.server_onMessage = function(client,message) {
  console.log("received message: " + message)
  //Cut the message up into sub components
  var message_parts = message.split('.');
  console.log("received messageparts: " + message_parts);
  //The first is always the type of message
  var message_type = message_parts[0];
  
  //Extract important variables
  var gc = client.game.gamecore;
  var id = gc.instance.id.slice(0,6);
  var all = gc.get_active_players();
  var target = gc.get_player(client.userid);
  var others = gc.get_others(client.userid);
  function printObject(o) {
  var out = '';
  for (var p in o) {
    out += p + ': ' + o[p] + '\n';
  }
  console.log("others: " + out);
}
printObject(others[0]); // this outputs [0]: id [1]: player
//console.log("others id" + others[0].id);
  //alert(JSON.stringify(others, null, 4));
  //console.dir("others " + others);

  switch(message_type) {
    
  case 'clickedObj' :
    writeData(client, "clickedObj", message_parts);
    //var otherPlayer = gc.get_others(client.userid);
    // alert("others: " + others[0]);
    //if (client.role == listener)
    //var other = gc.get_others(client.userid);
    others[0].player.instance.send("s.highlightObjSpeaker." + message_parts[1]);
    target.instance.send("s.highlightObjListener." + message_parts[1]);
    //_.map(, function(p) {p})
    //otherPlayer.send("s.highlightObj." + message_parts[1]) // others.instance.send?, others might be an array
    setTimeout(function() {
      _.map(all, function(p){
        p.player.instance.emit( 'newRoundUpdate', {user: client.userid} );
      });
      gc.newRound() //$('#chatbox').val() != '')  
    }, 3000);
    
    break; 
  
  case 'playerTyping' :
    console.log("player is typing?", message_parts[1]);
    _.map(others, function(p) {
      p.player.instance.emit( 'playerTyping',
			      {typing: message_parts[1]});
    });
    break;
  
  case 'chatMessage' :
    if(client.game.player_count == 2 && !gc.paused) 
    writeData(client, "message", message_parts)
    // Update others
    var msg = message_parts[1].replace(/~~~/g,'.');
    _.map(all, function(p){
      p.player.instance.emit( 'chatMessage', {user: client.userid, msg: msg});});
    break;

  case 'h' : // Receive message when browser focus shifts
    target.visible = message_parts[1];
    break;
  }
};

var writeData = function(client, type, message_parts) {
  var gc = client.game.gamecore;
  var roundNum = gc.state.roundNum + 1;
  var id = gc.instance.id.slice(0,6);
  switch(type) {
    case "clickedObj" :
      var clickedObjName = message_parts[1];
      var clickedObjTargetStatus = message_parts[2];
      var clickedObjSpeakerLocs = message_parts[3];
      var clickedObjListenerLocs = message_parts[4];
      var clickedObjCondition = message_parts[5];
      var alternative1Name = message_parts[6]; 
      var alternative1TargetStatus = message_parts[7];
      var alternative1SpeakerLocs = message_parts[8];
      var alternative1ListenerLocs = message_parts[9];
      var alternative2Name = message_parts[10]; 
      var alternative2TargetStatus = message_parts[11];
      var alternative2SpeakerLocs = message_parts[12];
      var alternative2ListenerLocs = message_parts[13];
      var line = (id + ',' + Date.now() + ',' + roundNum + ',' + clickedObjCondition + "," + clickedObjName + "," + 
        clickedObjTargetStatus + "," + clickedObjSpeakerLocs + "," + clickedObjListenerLocs + "," + 
        alternative1Name + "," + alternative1TargetStatus + "," + 
        alternative1SpeakerLocs + "," + alternative1ListenerLocs + "," + alternative2Name + 
        "," + alternative2TargetStatus + "," + alternative2SpeakerLocs + "," + alternative2ListenerLocs + '\n');
      console.log("clickedObj: " + line);
      gc.clickObjStream.write(line, function (err) {if(err) throw err;});
      break;

    // case "nonClickedObj" :
    //   var nonClickedObjName = message_parts[1];
    //   var nonCickedObjTargetStatus = message_parts[2];
    //   var nonClickedObjSpeakerLocs = message_parts[3];
    //   var nonClickedObjListenerLocs = message_parts[4];
    //   var nonClickedObjCondition = message_parts[5];
    //   var line = (id + ',' + Date.now() + ',' + roundNum + ',' + nonClickedObjName + "," + 
    //     nonClickedObjTargetStatus + "," + nonClickedObjSpeakerLocs + "," + nonClickedObjListenerLocs + "," + nonClickedObjCondition + '\n');
    //   console.log("nonClickedObj: " + line);
    //   gc.nonClickObjStream.write(line, function (err) {if(err) throw err;});
    //   break;

    case "message" :
      var msg = message_parts[1].replace('~~~','.')
      var line = (id + ',' + Date.now() + ',' + roundNum + ',' + client.role + ',"' + msg + '"\n')
      console.log("message:" + line);
      gc.messageStream.write(line, function (err) {if(err) throw err;});
      break;
  }
}

// /* 
//    The following functions should not need to be modified for most purposes
// */

// This is the important function that pairs people up into 'rooms'
// all independent of one another.
game_server.findGame = function(player) {
  this.log('looking for a game. We have : ' + this.game_count);
  //if there are any games created, add this player to it!
  if(this.game_count) {
    var joined_a_game = false;
    for (var gameid in this.games) {
      if(!this.games.hasOwnProperty(gameid)) continue;
      var game = this.games[gameid];
      var gamecore = game.gamecore;
      if(game.player_count < gamecore.players_threshold) { 
        joined_a_game = true;
        
        // player instances are array of actual client handles
        game.player_instances.push({id: player.userid, 
				    player: player});
        game.player_count++;
        
        // players are array of player objects
        game.gamecore.players.push({id: player.userid, 
				    player: new game_player(gamecore,player)});

         // Establish write streams
        var d = new Date();
        var start_time = d.getFullYear() + '-' + d.getMonth() + 1 + '-' + d.getDate() + '-' + d.getHours() + '-' + d.getMinutes() + '-' + d.getSeconds() + '-' + d.getMilliseconds()
        var name = start_time + '_' + game.id;
               
        var message_f = "data/message/" + name + ".csv"
        fs.writeFile(message_f, "gameid,time,roundNum,sender,contents\n", function (err) {if(err) throw err;})
        game.gamecore.messageStream = fs.createWriteStream(message_f, {'flags' : 'a'});

        var clickObj_f = "data/clickObj/" + name + ".csv"
        fs.writeFile(clickObj_f, "gameid, time, roundNum, condition, nameClickedObj, targetStatusClickedObj, spLocsClickedObj, lisLocsClickedObj, alt1Name, alt1TargetStatus, alt1SpLocs, alt1LisLocs, alt2Name, alt2TargetStatus, alt2SpLocs, alt2LisLocs \n", function (err) {if(err) throw err;})
        game.gamecore.clickObjStream = fs.createWriteStream(clickObj_f, {'flags' : 'a'});

        // var nonClickObj_f = "data/nonClickObj/" + name + ".csv"
        // fs.writeFile(nonClickObj_f, "gameid,time,roundNum,nameNonClickedObj,targetStatusNonClickedObj,speakerLocsNonClickedObj,listenerLocsNonClickedObj\n", function (err) {if(err) throw err;})
        // game.gamecore.nonClickObjStream = fs.createWriteStream(nonClickObj_f, {'flags' : 'a'});

        // Attach game to player so server can look at it later
        player.game = game;
        player.role = 'listener';

        // notify new player that they're joining game
        player.send('s.join.' + gamecore.players.length + '.' + player.role);

        // notify existing players that someone new is joining
        _.map(gamecore.get_others(player.userid), 
              function(p){
		p.player.instance.send( 's.add_player.' + player.userid);});
	  gamecore.newRound();
        gamecore.server_send_update();
        gamecore.player_count = game.player_count;
      }
    }
    if(!joined_a_game) { // if we didn't join a game, we must create one
      this.createGame(player);
    }
  }
  else { 
    //no games? create one!
    this.createGame(player);
  }
}; 

// Will run when first player connects
game_server.createGame = function(player) {
    var players_threshold = 2

    var d = new Date();
    var start_time = d.getFullYear() + '-' + d.getMonth() + 1 + '-' + d.getDate() + '-' + d.getHours() + '-' + d.getMinutes() + '-' + d.getSeconds() + '-' + d.getMilliseconds()
    var gameID = utils.UUID();

    var name = start_time + '_' + gameID;
    
    //Create a new game instance
    var game = {
	       //generate a new id for the game
        id : gameID,           
	       //store list of players in the game
        player_instances: [{id: player.userid, player: player}],
	       //for simple checking of state
        player_count: 1             
    };
    
    //Create a new game core instance (defined in game.core.js)
    game.gamecore = new game_core(game);

    // Tell the game about its own id
    game.gamecore.game_id = gameID;
    game.gamecore.players_threshold = players_threshold
    game.gamecore.player_count = 1
    
    // assign role
    player.game = game;
    player.role = 'speaker';
    player.send('s.join.' + game.gamecore.players.length + '.' + player.role)
    this.log('player ' + player.userid + ' created a game with id ' + player.game.id);

    // add to game collection
    this.games[ game.id ] = game;
    this.game_count++;
    
    game.gamecore.server_send_update()
    return game;
}; 

// we are requesting to kill a game in progress.
// This gets called if someone disconnects
game_server.endGame = function(gameid, userid) {
    var thegame = this.games [ gameid ];
    if(thegame) {
        _.map(thegame.gamecore.get_others(userid), function(p) {
            p.player.instance.send('s.end');})
        delete this.games[gameid];
        this.game_count--;
        this.log('game removed. there are now ' + this.game_count + ' games' );
    } else {
        this.log('that game was not found!');
    }   
}; 

//A simple wrapper for logging so we can toggle it,
//and augment it for clarity.
game_server.log = function() {
    console.log.apply(this,arguments);
};

