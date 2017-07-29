[cc,mc,l,expr,funcs] = textread('stats.csv',"%f, %f, %f, %f, %s");

functions = unique(funcs);

funcIds = zeros(size(funcs,1),1);
functionIds = 1 : size(functions,1);
for fId = functionIds
  funcIdxs = strmatch(functions{fId}, funcs);
  funcIds(funcIdxs,1) = fId;
endfor

groups = funcIds == functionIds;

ccT = cc' * groups;
exprT = expr' * groups;

counts = sum(groups,1);

avgs = ccT ./ counts;

lowerBounds = [0,0.5:19.5];
upperBounds = [0.5:20.5];


aggregations = (avgs' < upperBounds) .* (avgs' >= lowerBounds);

aggregatedFunctions = sum(aggregations,1);

aggregatedCounts = sum(counts' .* aggregations ,1);

aggregatedExpressions = (sum(exprT' .* aggregations, 1) ./ sum(sum(exprT))) .* 100;

countPerFunction = aggregatedCounts ./ aggregatedFunctions;

cpfN = countPerFunction ./ aggregatedExpressions;

ranges = [0:20];

plot(ranges,countPerFunction,"-.r",ranges,aggregatedExpressions,"-.k",ranges,cpfN,"-.m");

% plot(0:19,countPerFunction, 0:19, aggregatedFunctions, 0:19, countPerFunction' .* (0:19)');

% plot(1:20,aggregatedCounts',1:20,aggregatedCounts' .* (0:19)',1:20,aggregatedFunctions);