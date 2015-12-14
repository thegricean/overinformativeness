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

var getRelevantLabels = function(object, tax) {
  var relevantLabels = _.keys(_.omit(tax, function(value, key, tax) {
    return !_.has(value, object);
  }));
  return relevantLabels;
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
  getRelevantLabels : getRelevantLabels
};
