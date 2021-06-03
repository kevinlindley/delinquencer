-- Version  : 1.0.0
-- Author   : Kevin Lindley
-- Date     : 2021-04-26
-- Filename : vel_patterns.lua


function velpattern_change(x)
  local newpattern
  local patvalue = 0
  newpattern = table.shallow_copy(vel_pattern_values[x])
  for index=1,64 do
    cells[index][2] = vel_pattern_values[params:get("velpattern")][index]
  end
end


vel_pattern_names = {}
vel_pattern_values = {}


function add_vel_pattern(name,values)
  table.insert(vel_pattern_names,name) 
  table.insert(vel_pattern_values,values)
end

function build_vel_patterns()
  add_vel_pattern("All 127",            build_rows_table({127,127,127,127,127,127,127,127}))
  add_vel_pattern("All 96",             build_rows_table({96,96,96,96,96,96,96,96}))
  add_vel_pattern("All 64",             build_rows_table({64,64,64,64,64,64,64,64}))
  add_vel_pattern("All 32",             build_rows_table({32,32,32,32,32,32,32,32}))
  add_vel_pattern("Rows 125-20",         build_rows_table({125,110,95,80,65,50,35,20}))
  add_vel_pattern("Rows 20-125",         build_rows_table({20,35,50,65,80,95,110,125}))
  add_vel_pattern("Cols 125-20",         build_cols_table({125,110,95,80,65,50,35,20}))
  add_vel_pattern("Cols 20-125",         build_cols_table({20,35,50,65,80,95,110,125}))
  add_vel_pattern("Inc 32 by 0.5",       build_inc_table(32,0.5))
  add_vel_pattern("Inc 32 by 1",         build_inc_table(32,1.0))
  add_vel_pattern("Inc 32 by 1.5",       build_inc_table(32,1.5))
  add_vel_pattern("Dec 127 by 0.5",      build_inc_table(127,-0.5))
  add_vel_pattern("Dec 127 by 1",        build_inc_table(127,-1.0))
  add_vel_pattern("Dec 127 by 1.5",      build_inc_table(127,-1.5))
  add_vel_pattern("Rnd (32,96)",         build_rnd_table(32,96))
  add_vel_pattern("Rnd (64,96)",         build_rnd_table(64,96))
  add_vel_pattern("Rnd (32,127)",        build_rnd_table(32,127))
  add_vel_pattern("Rnd (1,127)",         build_rnd_table(1,127))
  add_vel_pattern("Rnd (80,127)",        build_rnd_table(80,127))
  add_vel_pattern("RndWalk 64:32:127:2", build_rndwalk_table(64,32,127,2))
  add_vel_pattern("RndWalk 64:32:127:4", build_rndwalk_table(64,32,127,4))
  add_vel_pattern("RndWalk 64:48:80:2",  build_rndwalk_table(64,48,80,2))
  add_vel_pattern("RndWalk 64:48:80:8",  build_rndwalk_table(64,48,80,8))
  add_vel_pattern("RndWalk 100:80:127:4",build_rndwalk_table(100,80,127,4))
end


function display_vel_pattern(pindex)
  print("Name ["..vel_pattern_names[pindex].."] ID:["..pindex.."]")
  print("  1  2  3  4  5  6  7  8")
  for row=1,8 do
    rowstring = ""
    for col=1,8 do
      index = ((row-1)*8) +col
      rowstring = rowstring .. tostring(vel_pattern_values[pindex][index]).." "
    end
    print(row.." ".. rowstring)
  end
end
