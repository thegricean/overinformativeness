var _ = require('underscore');
var assert = require('assert');
var fs = require('fs');

var babyparse = require('babyparse');

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

var getFrequencyData = function() {
  var locParse = function(filename) {
    return babyparse.parse(fs.readFileSync(filename, 'utf8'),
			   {header: true}).data;
  };
  var frequencyData = locParse("../../experiments/4_numdistractors_basiclevel_newitems/"
			       + "results/data/frequencyChart.csv");
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

var buildTax = function(knowledge, labels, responses) {
  // Add knowledge about labels to taxonomy
  var tax = {};

  for (var labelId = 0; labelId < labels.length; labelId++) {
    var probObj = {};
    var label = labels[labelId];
    var labelMatches = _.filter(knowledge, function(obj) {return obj.label == label;});
    _.forEach(labelMatches, function(obj) {
      probObj = _.extend(probObj, _.object([obj.response], [obj.prop]));
    });
    tax = _.extend(tax, _.object([label],[probObj]));
  }
  
  // Add knowledge about responses to taxonomy
  for (var responseId = 0; responseId < responses.length; responseId++) {
    var response = responses[responseId];
    tax = _.extend(tax, _.object([response], [_.object([response], [1])]));
  }

  return tax;
};

var buildKnowledge = function(type, domain) {
  // use appropriate knowledge
  var unifKnowledge = require("./saliencyKnowledgeUniform.json");
  var empKnowledge = require("./saliencyKnowledgeEmpirical.json");
  var filterFunc = function(obj) {
    return obj.type === type && obj.domain === domain;
  };
  var relevantUnifKnowledge = _.filter(unifKnowledge, filterFunc);
  var relevantEmpKnowledge = _.filter(empKnowledge, filterFunc);
  var relevantResponses = _.unique(_.pluck(relevantEmpKnowledge, 'response'));
  var relevantLabels =  _.unique(_.pluck(relevantEmpKnowledge, 'label'));
  var unifTax = buildTax(relevantUnifKnowledge, relevantLabels, relevantResponses);
  var empTax = buildTax(relevantEmpKnowledge, relevantLabels, relevantResponses);

  return {
    unifTaxonomy : unifTax,
    objectSpace : relevantResponses,
    labelSpace : relevantLabels
  };
};

module.exports = {
  buildKnowledge : buildKnowledge,
  getRelativeLength : getRelativeLength,  
  getRelativeLogFrequency : getRelativeLogFrequency,
  writeERP : writeERP,
  writeCSV : writeCSV,
  getAllPossibleLabels : getAllPossibleLabels
};
