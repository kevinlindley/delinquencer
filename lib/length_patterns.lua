-- Version  : 2.2.0
-- Author   : Kevin Lindley
-- Date     : 2021-05-07
-- Filename : length_patterns.lua

length_value_names = {}

function build_length_value_names()
  for index=1,64 do
    mvalue = index/4.00
    table.insert(length_value_names,mvalue)
  end
end

function length_preset_change(x)
  for index=1,64 do
    local nvalue = tonumber(length_value_names[params:get("lengthpreset")])
    cells[index][3] = nvalue
  end
end


function lenpattern_change(x)
  for index=1,64 do
    cells[index][3] = length_pattern_values[x][index]
  end
end


function randomlengthval(lowval,highval)
  local randomlengthval = 0
  local randomindex = math.random(lowval,highval)
  randomlengthval = tonumber(length_value_names[randomindex])
  return randomlengthval
end


function build_rnd_len_table(startval,endval,seedval)
  math.randomseed(seedval)
  newtable = {}
  for index=1,64 do
     local newvalue = math.random(startval,endval)
     table.insert(newtable,tonumber(length_value_names[newvalue]))
  end
  return newtable
end


length_pattern_names = {}
length_pattern_values = {}


function add_length_pattern(name,values)
  table.insert(length_pattern_names,name) 
  table.insert(length_pattern_values,values)
end


function build_length_patterns()
  build_length_value_names()
  add_length_pattern("Rows 25-100%", build_rows_table({0.25,0.50,0.75,1.00,0.25,0.50,0.75,1.00}))   --1
  add_length_pattern("Rows 50-125%", build_rows_table({0.50,0.75,1.00,1.25,0.50,0.75,1.00,1.25}))   --2
  add_length_pattern("Rows 75-150%", build_rows_table({0.75,1.00,1.25,1.50,0.75,1.00,1.25,1.50}))   --3
  add_length_pattern("Rows 100-25%", build_rows_table({1.00,0.75,0.50,0.25,1.00,0.75,0.50,0.25}))   --4
  add_length_pattern("Rows 125-50%", build_rows_table({1.25,1.00,0.75,0.50,1.25,1.00,0.75,0.50}))   --5
  add_length_pattern("Rows 150-75%", build_rows_table({1.50,1.25,1.00,0.75,1.50,1.25,1.00,0.75}))   --6
  add_length_pattern("Cols 25-100%", build_cols_table({0.25,0.50,0.75,1.00,0.25,0.50,0.75,1.00}))   --7
  add_length_pattern("Cols 50-125%", build_cols_table({0.50,0.75,1.00,1.25,0.50,0.75,1.00,1.25}))   --8
  add_length_pattern("Cols 75-150%", build_cols_table({0.75,1.00,1.25,1.50,0.75,1.00,1.25,1.50}))   --9
  add_length_pattern("Cols 100-25%", build_cols_table({1.00,0.75,0.50,0.25,1.00,0.75,0.50,0.25}))   --10
  add_length_pattern("Cols 125-50%", build_cols_table({1.25,1.00,0.75,0.50,1.25,1.00,0.75,0.50}))   --11 
  add_length_pattern("Cols 150-75%", build_cols_table({1.50,1.25,1.00,0.75,1.50,1.25,1.00,0.75}))   --12
  add_length_pattern("Random 25-50%",  build_rnd_len_table(1,2,1))     --13
  add_length_pattern("Random 25-75%",  build_rnd_len_table(1,3,5))     --14
  add_length_pattern("Random 25-100%", build_rnd_len_table(1,4,11))    --15
  add_length_pattern("Random 50-100%", build_rnd_len_table(2,4,17))    --16
  add_length_pattern("Random 75-125%", build_rnd_len_table(3,5,23))    --17
  add_length_pattern("Random 25-200%", build_rnd_len_table(1,8,31))    --18
  add_length_pattern("Random 100-250%", build_rnd_len_table(4,10,51))  --19
end


function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end


function display_length_pattern(pindex)
  print("Name ["..length_pattern_names[pindex].."] ID:["..pindex.."]")
  print("  1    2    3    4    5    6    7    8")
  for row=1,8 do
    rowstring = ""
    for col=1,8 do
      index = ((row-1)*8) +col
      local len_value_string = tostring(length_pattern_values[pindex][index])
      if string.len(len_value_string) < 4 then
        rowstring = rowstring .. len_value_string.."0 "
      else
        rowstring = rowstring .. len_value_string.." "
      end
    end
    print(row.." ".. rowstring)
  end
end


