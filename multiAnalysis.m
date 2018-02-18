function [de, chCC, co] = multiAnalysis(breadth)
  co = zeros(1, breadth + 1);
  chCC = zeros(1, breadth + 1);
  aggCC = zeros(1, breadth + 1);
  aggF = zeros(1, breadth + 1);
  de = zeros(1, breadth + 1);
  gr = zeros(1, breadth + 1);
  mass = zeros(1, breadth + 1);
 #{
#} 
  [code, ranges, changesPerCC, aggregatedChanges, aggregatedFunctions] = analysis('history/restbase/',breadth);
  
  co = co .+ code;
  chCC = chCC .+ changesPerCC;
  aggCC = aggCC .+ aggregatedChanges;
  aggF = aggF .+ aggregatedFunctions;

  [code, ranges, changesPerCC, aggregatedChanges, aggregatedFunctions] = analysis('history/prettier/',breadth);
  
  co = co .+ code;
  chCC = chCC .+ changesPerCC;
  aggCC = aggCC .+ aggregatedChanges;
  aggF = aggF .+ aggregatedFunctions;
 
  [code, ranges, changesPerCC, aggregatedChanges, aggregatedFunctions] = analysis('history/lighthouse/',breadth);
  
  co = co .+ code;
  chCC = chCC .+ changesPerCC;
  aggCC = aggCC .+ aggregatedChanges;
  aggF = aggF .+ aggregatedFunctions; 

  [code, ranges, changesPerCC, aggregatedChanges, aggregatedFunctions] = analysis('history/keystone/',breadth);
  
  co = co .+ code;
  chCC = chCC .+ changesPerCC;
  aggCC = aggCC .+ aggregatedChanges;
  aggF = aggF .+ aggregatedFunctions;
 
  [code, ranges, changesPerCC, aggregatedChanges, aggregatedFunctions] = analysis('history/Ghost/',breadth);
  
  co = co .+ code;
  chCC = chCC .+ changesPerCC;
  aggCC = aggCC .+ aggregatedChanges; 
  aggF = aggF .+ aggregatedFunctions;
  
 #{
 #}

  ranges = [0:1:breadth];

  deR = ranges(find(co > 0));
  grR = ranges(find(aggF > 0));
  coR = ranges(find(co > 0));
  massR = ranges(find(co > 0));
  
  de = chCC ./ co;
  gr = aggCC ./ aggF;
  mass = gr ./ co;
  
  cof = co ./ aggF;
  cof(find(aggF == 0)) = [];
  de(find(co == 0)) = [];
  gr(find(aggF == 0)) = [];
  co(find(co == 0)) = [];
  mass(find(co == 0)) = [];

  plot(
 #   ranges, chCC / max(chCC), "-*b",
 #   coR, de, "-*g"#,
#    grR, gr ./ max(gr), "-*r",
#    coR, cof ./ max(cof), "-*k"#,
    coR, (gr ./ max(gr)) .- (cof ./ max(cof)), "-*b"#,
 #   ranges, aggCC / max(aggCC), "-*m" 
#   massR, mass ./ max(mass), "-*m"
  );
  #title("Gravity and Function Size");
  title("High change density vs low change density");
  xlabel("Cognitive Complexity");
  #ylabel("# of Changes");
#  legend("Function Gravity", "Avg. Function Size");
endfunction