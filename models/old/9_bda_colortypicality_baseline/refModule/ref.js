var _ = require('underscore');
var fs = require('fs');
var babyparse = require('babyparse');
// var tax = require('./typicalityTax');

function testPrint() {
  console.log("this is working");
};

function readCSV(filename){
  return babyparse.parse(fs.readFileSync(filename, 'utf8')).data;
};

function writeCSV(jsonCSV, filename){
  fs.writeFileSync(filename, babyparse.unparse(jsonCSV) + '\n');
}

function appendCSV(jsonCSV, filename){
  fs.appendFileSync(filename, babyparse.unparse(jsonCSV) + '\n');
}

var writeERP = function(erp, labels, filename, fixed) {
  var data = _.filter(erp.support().map(
   function(v) {
     var prob = Math.exp(erp.score(v));
     if (prob > 0.0){
      if(v.slice(-1) === ".")
        out = butLast(v);
      else if (v.slice(-1) === "?")
        out = butLast(v).split("Is")[1].toLowerCase();
      else 
        out = v
      return labels.concat([out, String(prob.toFixed(fixed))]);

    } else {
      return [];
    }
  }
  ), function(v) {return v.length > 0;});
  appendCSV(data, filename);
};

var supportWriter = function(s, p, handle) {
  var sLst = _.pairs(s);
  var l = sLst.length;

  for (var i = 0; i < l; i++) {
    fs.writeSync(handle, sLst[i].join(',')+','+p+'\n');
  }
};

// Note this is highly specific to a single type of erp
var bayesianErpWriter = function(erp, filePrefix) {
  var predictiveFile = fs.openSync(filePrefix + "Predictives.csv", 'w');
  fs.writeSync(predictiveFile, ["condition", "TargetColor","TargetType","Dist1Color","Dist1Type","Dist2Color","Dist2Type",
				"value", "prob", "MCMCprob"] + '\n');

  var paramFile = fs.openSync(filePrefix + "Params.csv", 'w');
  fs.writeSync(paramFile, ["parameter", "value", "MCMCprob"] + '\n');

  var supp = erp.support();
  supp.forEach(function(s) {
    supportWriter(s.predictive, Math.exp(erp.score(s)), predictiveFile);
    supportWriter(s.params, Math.exp(erp.score(s)), paramFile);
  });
  fs.closeSync(predictiveFile);
  fs.closeSync(paramFile);
  console.log('writing complete.');
};

var getSubset = function(data, options) {
  var condition = options.condition;
      t_color = options.t_color;
      t_type = options.t_type;
      d1_color = options.d1_color;
      d1_type = options.d1_type;
      d2_color = options.d2_color;
      d2_type = options.d2_type;      
  var cond = function(row) {
    return (row[0] === condition &&
		 row[1] === t_color &&
		 row[2] === t_type &&
     row[3] === d1_color &&
     row[4] === d1_type &&
     row[5] === d2_color &&
     row[6] === d2_type);
  };
  return _.filter(data, cond);
};

var getTypSubset = function(data, obj_features) {
  var cond = function(row) {
    return row[0] === obj_features;
  };
  return _.filter(data, cond);
};

var locParse = function(filename) {
  return babyparse.parse(fs.readFileSync(filename, 'utf8'),
       {header: true,
        skipEmptyLines : true}).data;
};


module.exports = {
  getSubset : getSubset,
  bayesianErpWriter : bayesianErpWriter,
  writeERP : writeERP,
  writeCSV : writeCSV,
  readCSV : readCSV,
  locParse : locParse,
  getTypSubset : getTypSubset
};
