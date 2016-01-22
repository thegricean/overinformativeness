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
     var prob = Math.exp(erp.score([], v));
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

var getAllPossibleLabels = function(object, tax) {
  var relevantLabels = _.keys(_.omit(tax, function(value, key, tax) {
    return !_.has(value, object);
  }));
  return relevantLabels;
};

var locParse = function(filename) {
  return babyparse.parse(fs.readFileSync(filename, 'utf8'),
			 {header: true,
			  skipEmptyLines : true}).data;
};

var getFrequencyData = function() {
  var frequencyData = locParse("../../experiments/4_numdistractors_basiclevel_newitems"
			       + "/results/data/frequencyChart.csv");
  return frequencyData;
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
  return standardizeVal(frequencyData, relevantRow, selector);
};

var getRelativeLength = function(label) {
  var frequencyData = getFrequencyData();
  var relevantRow = _.filter(frequencyData, function(row) {return row.noun == label;})[0];
  var selector = function(row) {return row.noun.length;};
  return standardizeVal(frequencyData, relevantRow, selector);
};

var getTypicalityTax = function() {
  return tax.tax;
};

module.exports = {
  getTypicalityTax : getTypicalityTax,
  getRelativeLength : getRelativeLength,  
  getRelativeLogFrequency : getRelativeLogFrequency,
  writeERP : writeERP,
  writeCSV : writeCSV,
  getAllPossibleLabels : getAllPossibleLabels
};
