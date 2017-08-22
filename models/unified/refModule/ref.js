var _ = require('underscore');
var fs = require('fs');
var babyparse = require('babyparse');

var getLexicon = function(lexiconChoice) {
  var f = (lexiconChoice === 'realValued' ? './json/realValuedMeanings.json' :
	   lexiconChoice === 'truthConditional' ? './json/truthConditionalMeanings.json' :
	   console.error('lexicon choice unknown with value: ' + lexiconChoice));
  return require(f);
};

var powerset = function (set) {
  if (set.length == 0)
    return [[]];
  else {
    var rest = powerset(set.slice(1));
    return rest.map(
      function(element) {
        return [set[0]].concat(element);
      }).concat(rest);
  }
};

var getNominalUtterances = function(object, tax) {
  return _.keys(_.omit(tax, function(value, key, tax) {
    return !_.has(value, object);
  }));
};

var getTypicalityUtterances = function(context) {
  return _.uniq(_.flatten(map(function(itemArr) {
    return [itemArr[0], itemArr[1], itemArr.join('_')];
  }, context)));
};

var getColorSizeUtterances = function(context) {
  return _.uniq(_.flatten(map(function(itemArr) {
    var type = itemArr[2];
    return map(function(v) {return [v, type].join('_');}, powerset(itemArr.slice(2)));
  }, context)));
};

var colors = ["yellow", "orange", "red", "pink", "green",
              "purple", "white", "blue", "brown", "black"];

var sizes = ["big", "small"];

var types = ["fan", "tv", "desk", "couch", "desk", "chair", "couch"];

var makeArr = function(n, v) {
  return repeat(n, function(foo) {return v});
};

var makeColorSizeLists = function(wordsOrObjects) {
  var colorList = wordsOrObjects === 'words' ? colors.concat('') : colors;
  var sizeList = wordsOrObjects === 'words' ? sizes.concat('') : sizes;
  var typeList = wordsOrObjects === 'words' ? ['thing'] : types;

  return _.flattenDepth(map(function(size) {
    return map(function(color) {
      return map(function(type) {
        return [size, color, type]
      }, typeList);
    }, colorList);
  }, sizeList), 2);
};

var colorSizeWordMeanings = function(params) {
  return extend(
    _.zipObject(colors, makeArr(colors.length, params.colorTyp)),
    _.zipObject(sizes, makeArr(sizes.length, params.sizeTyp)),
    _.zipObject(types, makeArr(types.length, params.typeTyp))
  );
};

var constructLexicon = function(params, modelType) {
  var allUtts = makeColorSizeLists('words');
  var allObjs = makeColorSizeLists('objects');
  var wordMeaning = colorSizeWordMeanings(params);
  return _.zipObject(allUtts, map(function(utt) {
    return _.zipObject(allObjs, map(function(obj) {
      var meanings = map(function(tuple) {
        var uttWord = tuple[0], objProp = tuple[1];
        return (uttWord === '' ? 1 :
                uttWord === objProp ? wordMeaning[uttWord] :
                (1 - wordMeaning[uttWord]));
      }, _.zip(utt, obj));
      return _.reduce(meanings, _.multiply);
    }, allObjs));
  }, allUtts));
}

function readCSV(filename){
  return babyparse.parse(fs.readFileSync(filename, 'utf8'),
			 {header:true}).data;
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
    supportWriter(s.predictive, erp.score(s), predictiveFile);
    supportWriter(s.params, erp.score(s), paramFile);
  });
  fs.closeSync(predictiveFile);
  fs.closeSync(paramFile);
  console.log('writing complete.');
};

var getSubset = function(data, properties) {
  var matchProps = _.matches(properties);
  return _.filter(data, matchProps);
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

var getFrequencyData = function() {
  var frequencyData = require("./json/frequencies.json");
  return frequencyData;
};

var getLengthData = function() {
  var lengthData = require("./json/lengths.json");
  return lengthData;
};

var standardizeVal = function(data, val) {
  var maxVal = _.max(_.values(data));
  var minVal = _.min(_.values(data));
  return (val - minVal)/(maxVal - minVal);
};

var getRelativeLogFrequency = function(label) {
  var frequencyData = getFrequencyData();
  return 1-standardizeVal(frequencyData, frequencyData[label]);
};

var getRelativeLength = function(label) {
  var lengthData = getLengthData();
  return standardizeVal(lengthData, lengthData[label]);
};

module.exports = {
  getNominalUtterances, getColorSizeUtterances, getTypicalityUtterances,
  powerset, getSubset, getLexicon,
  bayesianErpWriter, writeERP, writeCSV,
  readCSV, locParse, getRelativeLength,
  getRelativeLogFrequency, getTypSubset
};
