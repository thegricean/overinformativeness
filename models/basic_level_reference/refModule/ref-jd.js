var _ = require('underscore');
var fs = require('fs');
var babyparse = require('babyparse');
var tax = require('./typicalityTax');

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
  fs.writeSync(predictiveFile, ["condition", "target", "alt1", "alt2",
				"value", "prob", "MCMCprob"] + '\n');

  var paramFile = fs.openSync(filePrefix + "Params.csv", 'w');
  fs.writeSync(paramFile, ["parameter", "value", "MCMCprob"] + '\n');

  var supp = erp.support([]);
  supp.forEach(function(s) {
    supportWriter(s.predictive, Math.exp(erp.score(s)), predictiveFile);
    supportWriter(s.params, Math.exp(erp.score(s)), paramFile);
  });
  fs.closeSync(predictiveFile);
  fs.closeSync(paramFile);
  console.log('writing complete.');
};

var getAllPossibleLabels = function(object, tax) {
  var relevantLabels = _.keys(_.omit(tax, function(value, key, tax) {
    return !_.has(value, object);
  }));
  return relevantLabels;
};

var getSubset = function(data, options) {
  var target = options.target,
      alt1 = options.alt1,
      alt2 = options.alt2;
  var cond = function(row) {
    var cond1 = (row[2] === target &&
		 row[3] === alt1 &&
		 row[4] === alt2);
    var cond2 = (row[2] === target &&
		 row[3] === alt2 &&
		 row[4] === alt1);
    return cond1 || cond2;
  };
  return _.filter(data, cond);
};

var locParse = function(filename) {
  return babyparse.parse(fs.readFileSync(filename, 'utf8'),
			 {header: true,
			  skipEmptyLines : true}).data;
};

var getFrequencyData = function() {
  var frequencyData = locParse("../../experiments/4_numdistractors_basiclevel_newitems"
			       + "/results/data/frequencyChart_uniformLabels.csv");
  return frequencyData;
};

//var getLengthData = function() {
//  var lengthData = locParse("../../experiments/4_numdistractors_basiclevel_newitems"
//			    + "/results/data/lengthChart_uniformLabels.csv");
//  return lengthData;
//};

var getLengthData = function() {
  var lengthData = locParse("../../experiments/7_overinf_basiclevel_biggersample"
          + "/results/data/lengthChart_uniformLabels.csv");
  return lengthData;
};

var standardizeVal = function(frequencyData, row, attributeSelector) {
  var maxObj = _.max(frequencyData, attributeSelector);
  var minObj = _.min(frequencyData, attributeSelector);
  var val = attributeSelector(row);
  var maxVal = attributeSelector(maxObj);
  var minVal = attributeSelector(minObj);
  return (val - minVal)/(maxVal - minVal);
};

var getRelativeLogFrequency = function(label) {
  var frequencyData = getFrequencyData();
  var relevantRow = _.filter(frequencyData, function(row) {return row.noun == label;})[0];
  var selector = function(row) {return Math.log(row.relFreq);};
  //console.log("label, relevantRow, selector: ", label, relevantRow, selector)
  // console.log("standardizeVal(frequencyData, relevantRow, selector): ", label, standardizeVal(frequencyData, relevantRow, selector))
  return standardizeVal(frequencyData, relevantRow, selector);
};

var getRelativeLength = function(label) {
  var lengthData = getLengthData();
  var relevantRow = _.filter(lengthData, function(row) {return row.noun == label;})[0];
  var selector = function(row) {return Number(row.average_length);};
  //console.log("standardizeVal(lengthData, relevantRow, selector): ", label, standardizeVal(lengthData, relevantRow, selector))
  return standardizeVal(lengthData, relevantRow, selector);
};

var getTypicalityTax = function() {
  return tax.tax;
};

module.exports = {
  getTypicalityTax : getTypicalityTax,
  getRelativeLength : getRelativeLength,  
  getRelativeLogFrequency : getRelativeLogFrequency,
  getSubset : getSubset,
  bayesianErpWriter : bayesianErpWriter,
  writeERP : writeERP,
  writeCSV : writeCSV,
  readCSV : readCSV,  
  getAllPossibleLabels : getAllPossibleLabels
};
