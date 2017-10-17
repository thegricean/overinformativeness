var fs = require('fs');
var _ = require('lodash');
var refModule = require('../refModule');

var data = refModule.readCSV("bda_data_typicality.csv"); // loads data with 46 "other utterance" cases excluded
console.log(data);
//console.log("Loading data complete...",+data.length+" data points");

var conditions = refModule.readCSV("./unique_conditions_typicality.csv"); 

var contexts = _.map(conditions, function(c) {
  return _.extend(c, {context: [
    {color: c.t_color, item: c.t_item},
    {color: c.d1_color, item: c.d1_item},
    {color: c.d2_color, item: c.d2_color}
  ]});
});

console.log(contexts);
console.log("Constructing contexts complete...");
fs.writeFileSync('./bda_data_typicality.json',
		 JSON.stringify(data, null, 2));
