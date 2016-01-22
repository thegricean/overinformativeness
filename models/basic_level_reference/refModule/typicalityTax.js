var _ = require('underscore');
var babyparse = require('babyparse');
var fs = require('fs');

function typicality () {
  var filename = ("../../../experiments/5_norming_object_typicality_phrasing1"
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
    that.tree[label] = {};
    _.each(that.getPossibleReferents(label), function(object) {
      that.tree[label][object] = that.getTypicality(label, object);
    });
  });
};

var typicality = new typicality();
typicality.clean();
typicality.labels = typicality.getLabels();
typicality.makeTree();
module.exports = typicality.tree;
