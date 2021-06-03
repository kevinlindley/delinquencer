-- Version  : 2.0.0
-- Author   : Kevin Lindley
-- Date     : 2021-04-29
-- Filename : modifiers.lua

mod_pattern_names = {"Static","Shift-L","Shift-R","Flip","Inc","Dec","RndBit","RndAll"}
mod_preset_values = {}
mod_preset_names = {}
mod_preset_modxpattern = {}
mod_preset_modypattern = {}
mod_preset_modxfreq = {}
mod_preset_modyfreq = {}

mod_control = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

function build_mod_presets()
  --                                                                              Col    Row    Col      Row
  --                             C  C  C  C  C  C  C  C  R  R  R  R  R  R  R  R   Pat    Pat    Frq      Frq
  add_modifier_preset("All-On" ,{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},  1,     1,     64,     64)
  add_modifier_preset("All-Off",{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},  1,     1,     64,     64)
  add_modifier_preset("Checks", {1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0},  1,     1,     32,     16)
  add_modifier_preset("Half",   {1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0},  2,     2,     16,     16) 
  add_modifier_preset("Flip",   {1, 1, 0, 0, 1, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 1},  4,     4,     64,     16)
  add_modifier_preset("Count",  {1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0},  5,     6,     16,     16) 
  add_modifier_preset("Rand",   {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},  7,     7,     64,     32)
  add_modifier_preset("Chaos",  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},  8,     8,      8,      8)
  add_modifier_preset("Long",   {1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1},  7,     4,    256,     32)
  add_modifier_preset("WTF!",   {1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1},  8,     8,      2,      2)    --! Test Case to Break the code !
  add_modifier_preset("Prime",  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},  7,     7,     13,     23)
end

function add_modifier_preset(name,values,modxpattern,modypattern,modxfreq,modyfreq)
  table.insert(mod_preset_names,name) 
  table.insert(mod_preset_values,values)
  table.insert(mod_preset_modxpattern,modxpattern) 
  table.insert(mod_preset_modypattern,modypattern) 
  table.insert(mod_preset_modxfreq,modxfreq)
  table.insert(mod_preset_modyfreq,modyfreq)
end

function mod_preset_change(x) 
  mod_control = table.shallow_copy(mod_preset_values[x])
  params:set("modxpattern",mod_preset_modxpattern[x])
  params:set("modypattern",mod_preset_modypattern[x])
  params:set("modxfreq",   mod_preset_modxfreq[x])
  params:set("modyfreq",   mod_preset_modyfreq[x])
  build_modgrid()
end

function update_col_modifier()
  -- {"Static","Shift-L","Shift-R","Flip","Inc","Dec","RndBit","RndAll"}
  local setting = params:get("modxpattern")
  -- (setting == 1) is Static
  if (setting == 2) then mod_seq_col_shift_left()  end
  if (setting == 3) then mod_seq_col_shift_right() end
  if (setting == 4) then mod_seq_col_flip()        end
  if (setting == 5) then mod_seq_col_inc(1)        end
  if (setting == 6) then mod_seq_col_inc(-1)       end
  if (setting == 7) then mod_seq_col_bitrand()     end
  if (setting == 8) then mod_seq_col_rnd()         end
  build_modgrid()
end

function update_row_modifier()
  -- {"Static","Shift-L","Shift-R","Flip","Inc","Dec","RndBit","RndAll"}
  local setting = params:get("modypattern")
  -- (setting == 1) is Static
  if (setting == 2) then mod_seq_row_shift_left()  end
  if (setting == 3) then mod_seq_row_shift_right() end
  if (setting == 4) then mod_seq_row_flip()        end
  if (setting == 5) then mod_seq_row_inc(1)        end
  if (setting == 6) then mod_seq_row_inc(-1)       end
  if (setting == 7) then mod_seq_row_bitrand()     end
  if (setting == 8) then mod_seq_row_rnd()         end
  build_modgrid()
end


function mod_seq_col_justone()
  result = false
  local count = 0
  for index=1,8 do
    if (mod_control[index] == 1) then
      count = count + 1
    end
  end
  if (count == 1) then result = true end
  return result
end


function mod_seq_row_justone()
  result = false
  local count = 0
  for index=9,16 do
    if (mod_control[index] == 1) then
      count = count + 1
    end
  end
  if (count == 1) then result = true end
  return result
end


function mod_seq_col_bitrand()
  tweakbit = math.random(1,8) 
  if (mod_control[tweakbit] == 0) then
    mod_control[tweakbit] = 1
  else
    if (mod_seq_row_justone() == false) then 
      mod_control[tweakbit] = 0
    else
      mod_control[tweakbit] = 1
    end
  end
end


function mod_seq_row_bitrand()
  tweakbit = math.random(9,16) 
  if (mod_control[tweakbit] == 0) then
    mod_control[tweakbit] = 1
  else
    if (mod_seq_col_justone() == false) then 
      mod_control[tweakbit] = 0
    else
      mod_control[tweakbit] = 1
    end
  end
end


function numberToBinStr(x)
	ret=""
	while x~=1 and x~=0 do
		ret=tostring(x%2)..ret
		x=math.modf(x/2)
	end
	ret=tostring(x)..ret
	ret = "0000000" .. ret
	length = string.len(ret)
	return string.sub(ret,length-7,length)
end


function mod_seq_row_rnd()
  total = math.random(1,255) 
  mvalue = ""
  newstring = ""
  newstring = numberToBinStr(math.floor(tonumber(total)))
  for index=16,9,-1 do
    mvalue = string.sub(newstring,index-8,index-8)
    mod_control[index] = tonumber(mvalue)
  end
end


function mod_seq_col_rnd()
  total = math.random(1,255) 
  mvalue = ""
  newstring = ""
  newstring = numberToBinStr(math.floor(tonumber(total)))
  for index=8,1,-1 do
    mvalue = string.sub(newstring,index,index)
    mod_control[index] = tonumber(mvalue)
  end
end  


function mod_seq_row_inc(incvalue)
  total = 0 
  mvalue = ""
  newstring = ""
  for index=16,9,-1 do
    if (mod_control[index] == 1) then
      total = total + math.pow(2,15-(index-1))
    end
  end 
  total = total + incvalue
  if (total > 255) then total = 0 end
  if (total < 0) then total = 255 end
  newstring = numberToBinStr(math.floor(tonumber(total)))
  for index=16,9,-1 do
    mvalue = string.sub(newstring,index-8,index-8)
    mod_control[index] = tonumber(mvalue)
  end
end


function mod_seq_col_inc(incvalue)
  total = 0 
  mvalue = ""
  newstring = ""
  for index=8,1,-1 do
    if (mod_control[index] == 1) then
      total = total + math.pow(2,7-(index-1))
    end
  end 
  total = total + incvalue
  if (total > 255) then total = 0 end
  if (total < 0) then total = 255 end
  newstring = numberToBinStr(math.floor(tonumber(total)))
  for index=8,1,-1 do
    mvalue = string.sub(newstring,index,index)
    mod_control[index] = tonumber(mvalue)
  end
end  


function mod_seq_col_flip()
  for index=1,8 do
    if (mod_control[index] == 1) then
      mod_control[index] = 0
    else
      mod_control[index] = 1
    end
  end 
end


function mod_seq_row_flip()
  for index=9,16 do
    if (mod_control[index] == 1) then
      mod_control[index] = 0
    else
      mod_control[index] = 1
    end
  end 
end


function mod_seq_col_shift_left()
  temp = mod_control[1]
  for index=1,7 do
    mod_control[index]=mod_control[index+1]
  end 
  mod_control[8] = temp
end


function mod_seq_col_shift_right()
  temp = mod_control[8]
  for index=8,2,-1 do
    mod_control[index]=mod_control[index-1]
  end 
  mod_control[1] = temp
end


function mod_seq_row_shift_left()
  temp = mod_control[9]
  for index=9,15 do
    mod_control[index]=mod_control[index+1]
  end 
  mod_control[16] = temp
end


function mod_seq_row_shift_right()
  temp = mod_control[16]
  for index=16,10,-1 do
    mod_control[index]=mod_control[index-1]
  end 
  mod_control[9] = temp
end


function build_default_modgrid()
  for index=1,64 do
    modgrid[index] = 1
  end
end


function build_modgrid()
  build_default_modgrid()
  for mindex=1,8 do
    if (mod_control[mindex]==0) then
      set_modgrid_col(mindex,0)
    end
  end
  for mindex=9,16 do
    if (mod_control[mindex]==0) then
      set_modgrid_row(17-mindex,0)
    end
  end
end


function set_modgrid_row(rowindex,value)
  for col=1,8 do
    index = ((rowindex-1)*8) +col
    modgrid[index] = value
  end
end


function set_modgrid_col(colindex,value)
  for row=1,8 do
    index = ((row-1)*8) + colindex
    modgrid[index] = value
  end
end


-- Used only for Debugging
function print_modgrid()
  for row=1,8 do
    rowstring = ""
    for col=1,8 do
      index = ((row-1)*8) +col
      rowstring = rowstring .. tostring(modgrid[index])
    end
    print(rowstring)
  end
end

