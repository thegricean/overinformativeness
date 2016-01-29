var _ = require('underscore');
var babyparse = require('babyparse');
var fs = require('fs');

var labelToObjName = function(label) {
  var lowerCased = label.toLowerCase();
  var noWhiteSpace = lowerCased.replace(/[^A-Z0-9]+/ig, "");
  return noWhiteSpace == "mms" ? "mnms" : noWhiteSpace;
};

var typicality = function () {
  var filename = ("../../experiments/5_norming_object_typicality_phrasing1"
		  + "/results/data/itemtypicalities.csv");
  var parseResult = babyparse.parse(fs.readFileSync(filename, 'utf8'),
				    {header: true, skipEmptyLines : true});
  this.data = parseResult.data;
};

typicality.prototype.clean = function() {
  this.data = _.map(this.data, function(row) {
    var newRow = _.clone(row);
    var wordsInLabel = row.label.split(' ');
    newRow.label = (_.contains(['a', 'an'], wordsInLabel[0]) ?
		    wordsInLabel.slice(1).join(' ') :
		    wordsInLabel.join(' '));
    return newRow;
  });
};

typicality.prototype.getLabels = function() {
  return _.unique(_.pluck(this.data, 'label'));
};

typicality.prototype.getTypicality = function(label, obj) {
  return Number(_.filter(this.data, function(row) {
    return row.item === obj & row.label === label;
  })[0]["meanresponse"]);
};

typicality.prototype.getPossibleReferents = function(label) {
  return _.pluck(_.filter(this.data, function(row) {
    return row.label === label;
  }), 'item');
};

typicality.prototype.makeTree = function() {
  this.tree = {};
  var that = this;
  _.each(this.labels, function(label) {
    var cleanedLabel = labelToObjName(label);
    that.tree[cleanedLabel] = {};
    _.each(that.getPossibleReferents(label), function(object) {
      that.tree[cleanedLabel][object] = that.getTypicality(label, object);
    });
  });
};

var t = new typicality();
t.clean();
t.labels = t.getLabels();
t.makeTree();
module.exports = {
  tax : t.tree
};
