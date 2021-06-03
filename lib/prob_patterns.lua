-- Version  : 1.0.0
-- Author   : Kevin Lindley
-- Date     : 2021-04-26
-- Filename : prob_patterns.lua


function probpattern_change(x)
  local newpattern
  local patvalue = 0
  newpattern = table.shallow_copy(prob_pattern_values[x])
  for index=1,64 do
    cells[index][5] = prob_pattern_values[params:get("probpattern")][index]
  end
end


prob_pattern_names = {}
prob_pattern_values = {}


function add_prob_pattern(name,values)
  table.insert(prob_pattern_names,name) 
  table.insert(prob_pattern_values,values)
end

function build_prob_patterns()
  add_prob_pattern("All 100%",         build_rows_table({100,100,100,100,100,100,100,100}))  --1
  add_prob_pattern("All 95%",          build_rows_table({95,95,95,95,95,95,95,95}))          --2
  add_prob_pattern("All 75%",          build_rows_table({75,75,75,75,75,75,75,75}))          --3
  add_prob_pattern("All 50%",          build_rows_table({50,50,50,50,50,50,50,50}))          --4
  add_prob_pattern("All 25%",          build_rows_table({25,25,25,25,25,25,25,25}))          --5
  add_prob_pattern("Rows 100%-05%",    build_rows_table({100,85,75,60,50,35,20,5}))          --6
  add_prob_pattern("Rows 5%-100%",     build_rows_table({5,20,35,50,60,75,85,100}))          --7
  add_prob_pattern("Cols 100%-05%",    build_cols_table({100,85,75,60,50,35,20,5}))          --8
  add_prob_pattern("Cols 5%-100%",     build_cols_table({5,20,35,50,60,75,85,100}))          --9
  add_prob_pattern("25% inc by 0.5%",  build_inc_table(25,0.5))                              --10
  add_prob_pattern("25% inc by 1.2%",  build_inc_table(25,1.2))                              --11
  add_prob_pattern("01% inc by 1.5%",  build_inc_table(1,1.5))                               --12
  add_prob_pattern("100 dec by 0.5%",  build_inc_table(100,-0.5))                            --13
  add_prob_pattern("100 dec by 1.0%",  build_inc_table(100,-1.0))                            --14
  add_prob_pattern("100 dec by 1.25%", build_inc_table(100,-1.25))                           --15
  add_prob_pattern("Random(25,75)",    build_rnd_table(25,75))                               --16
  add_prob_pattern("Random(0,100)",    build_rnd_table(0,100))                               --17
  add_prob_pattern("Random(75,100)",   build_rnd_table(75,100))                              --18
  add_prob_pattern("Random(95,100)",   build_rnd_table(95,100))                              --19
  add_prob_pattern("Random(0,25)",     build_rnd_table(0,25))                                --20
  add_prob_pattern("RandWalk 1",       build_rndwalk_table(50,0,100,2))                      --21
  add_prob_pattern("RandWalk 2",       build_rndwalk_table(50,0,100,5))                      --22
  add_prob_pattern("RandWalk 3",       build_rndwalk_table(50,0,100,20))                     --23
  add_prob_pattern("RandWalk 4",       build_rndwalk_table(50,25,75,25))                     --24
  add_prob_pattern("Subtle",           build_cols_table({100,95,90,85,100,95,90,85}))        --25
end

function display_prob_pattern(pindex)
  print("Name ["..prob_pattern_names[pindex].."] ID:["..pindex.."]")
  print("  1  2  3  4  5  6  7  8")
  for row=1,8 do
    rowstring = ""
    for col=1,8 do
      index = ((row-1)*8) +col
      rowstring = rowstring .. tostring(prob_pattern_values[pindex][index]).." "
    end
    print(row.." ".. rowstring)
  end
end
