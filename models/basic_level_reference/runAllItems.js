// set this to right path
var items = refModule.readCSV("./bdaInput/basicLevelResultsExp7.csv");
var domains = globalInfo.domains;

// set params instead of sampling
var params = {
	alpha : sample(Uniform({a:0,b:20})),
	lengthWeight : sample(Uniform({a:0,b:5})),
	freqWeight : sample(Uniform({a:0,b:5}))//,
};

 map(function(item) {
    var domainInfo = globalInfo.info[domain]; // replace "domain" with "item[N]""
    var model = BasicLevelModel(domainInfo, params);
    var runModel = model.runModel;
    var speaker = model.speaker;
	var modelOutput = runModel(speaker, [item[1],item[2],[item[3]]], domainInfo); // make sure it's getting the right columns
	refModule.writeERP(modelOutput, item, "speakerOutput.csv",2);  // this should work...

},items);