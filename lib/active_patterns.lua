-- Version  : 2.0.0
-- Author   : Kevin Lindley
-- Date     : 2021-04-29
-- Filename : active_patterns.lua

active_pattern_values = {}
active_pattern_names = {}

function add_active_pattern(name,values)
  table.insert(active_pattern_names,name) 
  table.insert(active_pattern_values,values)
end

function build_active_patterns()
        -- Index                 1234567890123456789012345678901234567890123456789012345678901234
  add_active_pattern("8 Bit",   build01table(8))
  add_active_pattern("16 Bit",  build01table(16))
  add_active_pattern("24 Bit",  build01table(24))
  add_active_pattern("32 Bit",  build01table(32))
  add_active_pattern("40 Bit",  build01table(40))
  add_active_pattern("48 Bit",  build01table(48))
  add_active_pattern("56 Bit",  build01table(56))
  add_active_pattern("64 Bit",  build01table(64))
  add_active_pattern("1 Col ",  "1000000010000000100000001000000010000000100000001000000010000000")
  add_active_pattern("2 Col ",  "1100000011000000110000001100000011000000110000001100000011000000")
  add_active_pattern("3 Col ",  "1110000011100000111000001110000011100000111000001110000011100000")
  add_active_pattern("4 Col ",  "1111000011110000111100001111000011110000111100001111000011110000")
  add_active_pattern("5 Col ",  "1111100011111000111110001111100011111000111110001111100011111000")
  add_active_pattern("6 Col ",  "1111110011111100111111001111110011111100111111001111110011111100")
  add_active_pattern("7 Col ",  "1111111011111110111111101111111011111110111111101111111011111110")
  add_active_pattern("Stripe",  "1010101010101010101010101010101010101010101010101010101010101010")
  add_active_pattern("Lines",   "1111111100000000111111110000000011111111000000001111111100000000")
  add_active_pattern("Cheq",    "1010101001010101101010100101010110101010010101011010101001010101") 
  add_active_pattern("Cube",    "1100110011001100001100110011001111001100110011000011001100110011")
  add_active_pattern("Cube4",   "1111000011110000111100001111000000001111000011110000111100001111")
  add_active_pattern("Invader", "0001100000111100011111100101101011111111001001000101101010100101")
  add_active_pattern("Face",    "0011110001000010010000101010010110000001010110100100001000111100")
  add_active_pattern("TB1",     "1111111100000000000000000000000000000000000000000000000011111111")
  add_active_pattern("TB2",     "1111111111111111000000000000000000000000000000000000000011111111")
  add_active_pattern("TB3",     "1111111111111111000000000000000000000000000000001111111111111111")
  add_active_pattern("TB4",     "1111111111111111111111110000000000000000000000001111111111111111")  
  add_active_pattern("TB5",     "1111111111111111111111110000000000000000111111111111111111111111")  
  for index=1,64 do
    add_active_pattern("Seq"..index,build01table(index))
  end
end

function build01table(numberofones)
  local newpattern = ""
  for index=1,64 do
    if (index <=numberofones) then
      newpattern = newpattern.."1"
    else
      newpattern = newpattern.."0"
    end
  end
  return newpattern
end


function activepattern_change(x)
  local newpattern = ""
  local patvalue = 0
  newpattern = active_pattern_values[x]
  for index=1,64 do
    if (make_value_random() == true) then
     patvalue = math.random(0,1) 
    else
      patvalue = tonumber(newpattern:sub(index,index))
    end
    if (patvalue == 1) then
      cells[index][4] = params:get("activepatFG")
    else
      cells[index][4] = params:get("activepatBG")
    end
  end
end


function make_value_random()
  randomvalue = math.random(0,100)
  if (randomvalue < params:get("activepatrnd")) then
    return true
  else
  return false
  end
end