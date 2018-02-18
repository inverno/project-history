function [code, ranges, changesPerCC, aggregatedChanges, aggregatedFunctions] = analysis(project, aggSize)

  [cc,mc,l,expr,funcs] = textread(strcat(project,'stats.csv'),"%f, %f, %f, %f, %s");
  [cog,expre] = textread(strcat(project,'cognitive_distribution.csv'),"%f,%f");

  functions = unique(funcs);
  
  ccn = cc ./ expr;
  mcn = mc ./ expr;

  funcIds = zeros(size(funcs,1),1);
  functionIds = 1 : size(functions,1);
  for fId = functionIds
    funcIdxs = strmatch(functions{fId}, funcs);
    funcIds(funcIdxs,1) = fId;
  endfor

  groups = funcIds == functionIds; % m = changes n= functions

  functionCCs = cc' * groups; % cumulated CC of every function

  mcT = mc' * groups;

  exprT = expr' * groups;

  changes = sum(groups,1); % changes per Function

  avgs = functionCCs ./ changes; % avg CC of every function

  avgsMc = mcT ./ changes;

  lowerBounds = [0,0.5:1:(aggSize - 0.5)];
  upperBounds = [0.5:1:(aggSize + 0.5)];


  aggregations = (avgs' < upperBounds) .* (avgs' >= lowerBounds); % which function falls in which CC range

  aggregatedFunctions = sum(aggregations,1); % how many functions fall in which CC range

  aggregatedChanges = sum(changes' .* aggregations ,1); % how many function changes fall in which CC range

  aggregatedExpressions = (sum(exprT' .* aggregations, 1) ./ sum(expr));

  ranges = [0:1:aggSize];

  ccAggregations = (cc < upperBounds) .* (cc >= lowerBounds);
  changesPerCC = sum(ccAggregations,1);
  
  expPerCC = expre' * (cog == ranges);
  
  code = expPerCC

  safeChanges = changesPerCC .* (expPerCC > 0);
  
  code = code;

endfunction