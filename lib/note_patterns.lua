-- Version  : 1.0.0
-- Author   : Kevin Lindley
-- Date     : 2021-04-26
-- Filename : note_pattersn.lua


note_pattern_names = {}
note_pattern_values = {}


function add_note_pattern(name,values)
  table.insert(note_pattern_names,name) 
  table.insert(note_pattern_values,values)
end


function catt(t1,t2)
  newtable = {}
  for index=1,#t1 do
    table.insert(newtable,t1[index])
  end
  for index=1,#t2 do
    table.insert(newtable,t2[index])
  end
  return newtable
end


function transpose_table(t1,semitones)
  newtable = {}
  for index=1,#t1 do
    table.insert(newtable,t1[index]+semitones)
  end
  return newtable
end


function build_note_patterns()
  add_note_pattern("Rows", build_rows_table({48,50,52,53,55,57,59,60}))
  add_note_pattern("Cols", build_cols_table({62,64,66,67,69,71,73,74}))
  for nrange=24,35,2 do
    add_note_pattern("U"..note_names[(nrange%12)+1].."1",  build_inc_table(nrange,1))
  end
  for nrange=95,84,-2 do
    add_note_pattern("D"..note_names[(nrange%12)+1].."6",  build_dec_table(nrange,1))
  end
  for index=1,9 do
    add_note_pattern("Tau-"..index, build_seq_01(index*3))
  end
  for index=1,9 do
    add_note_pattern("Rho-"..index, build_seq_02(index*4))
  end
  for index=1,9 do
    add_note_pattern("Phi-"..index, build_seq_03(index*5))
  end
  for index=1,9 do
    add_note_pattern("Eta-"..index, build_seq_04(index*7))
  end
  add_note_pattern("RndW1", build_rndwalk_table(64,32,127,2))
  add_note_pattern("RndW2", build_rndwalk_table(64,32,127,4))
  add_note_pattern("RndW3", build_rndwalk_table(64,48,80,2))
  add_note_pattern("RndW4", build_rndwalk_table(64,48,80,8))
  add_note_pattern("OTR",   build_cols_table({52,55,57,55,62,60,62,64}))
  add_note_pattern("Silica1", silica(fill_table({67,74,77,81},16),12,7,5,-12))
  add_note_pattern("Silica2", silica({69,74,77,81,77,74,69,67},5,12,7,-12))
end


function display_note_pattern(pindex)
  print("Name ["..note_pattern_names[pindex].."] ID:["..pindex.."]")
  print("  1  2  3  4  5  6  7  8")
  for row=1,8 do
    rowstring = ""
    for col=1,8 do
      index = ((row-1)*8) +col
      rowstring = rowstring .. tostring(note_pattern_values[pindex][index]).." "
    end
    print(row.." ".. rowstring)
  end
end


function silica(allowed_scale,t1,t2,t3)
  notetable = {}
  local P1 = allowed_scale
  local P5 = transpose_table(allowed_scale,t1)
  local P7 = transpose_table(allowed_scale,t2)
  local P12 = transpose_table(allowed_scale,t3)
  local notetable = catt(catt(catt(catt(catt(catt(catt(P1,P5),P12),P1),P7),P1),P5),P12)
  return notetable
end

function fill_table(allowed_scale,size)
  notetable = {}
  scale_index = 0
  for loop = 1,size do
    scale_index = scale_index + 1
    if scale_index > #allowed_scale then scale_index=1 end
    extracted_note = allowed_scale[scale_index]
    table.insert(notetable,extracted_note)
  end
  return notetable
end

function build_fire()
  allowed_scale = {48,50,52,53,55,57,59,60}
  local N1 = seedednotes_builder(allowed_scale,1,4)
  local N2 = transpose_table(N1,12)
  local result = catt(N1,N2)
  return result
end


function build_seq_01(seed)
  allowed_scale = {55,57,59,60,62,64,66,67}
  local P1 = seedednotes_builder(allowed_scale,100,4)
  local P2 = transpose_table(P1,12)
  local result = catt(P1,P2)
  return result
end


function build_seq_02(seed)
  allowed_scale = {62,64,66,67,69,71,73,74}
  local P1 = seedednotes_builder(allowed_scale,seed+3,1)
  local P2 = seedednotes_builder(allowed_scale,seed+7,1)
  local P3 = seedednotes_builder(allowed_scale,seed+11,1)
  local P4 = transpose_table(P1,4)
  local P5 = transpose_table(P2,7)
  local result = catt(P1,catt(P2,catt(P4,catt(P1,catt(P5,catt(P3,catt(P5,P4)))))))
  return result
end

function build_seq_03(seed)
  allowed_scale = {48,50,52,48,55,57,59,60}
  local P1 = seedednotes_builder(allowed_scale,seed+13,1)
  local P2 = seedednotes_builder(allowed_scale,seed+17,1)
  local P3 = seedednotes_builder(allowed_scale,seed+19,1)
  local P4 = transpose_table(P1,4)
  local P5 = transpose_table(P2,12)
  local result = catt(P1,catt(P2,catt(P1,catt(P4,catt(P5,catt(P3,catt(P4,P5)))))))
  return result
end

function build_seq_04(seed)
  allowed_scale1 = {48,50,52,48}
  allowed_scale2 = {55,57,59,60}
  allowed_scale3 = {62,64,66,67,69,71,73,74}
  local P1 = seedednotes_builder(allowed_scale1,seed+13,2)  --8
  local P2 = seedednotes_builder(allowed_scale2,seed+17,2)  --8
  local P3 = seedednotes_builder(allowed_scale3,seed+19,2)  --16
  local P4 = transpose_table(P2,4)  --8
  local P5 = transpose_table(P3,12) --16
  local result = catt(P4,catt(P1,catt(P3,catt(P5,catt(P2,catt(P3,P2))))))
  return result
end



-- Generate a string of Notes from a given seedvale (so it's repeatable) and allowed_scale
-- and ensures that the same not is never next to one of the same value.
-- Lengh is a multiple of allowed_scale and num_loops, so for 
-- allowed_scale with 5 notes and loops set to 4 would generate a table.
-- Logic: Ensures that 2 notes do are not allowed to be together.
function seedednotes_builder(allowed_scale,seedval,num_loops)
  notetable = {}
  noexit = true
  loopcount = 1
  offset = 1
  lastnote = ""
  while (noexit == true)
  do
    notetablecopy = table.shallow_copy(allowed_scale)
    newloop = rndseedednotes(notetablecopy,seedval+offset)
    -- Only add it if the next note is not the same as the last, if it is generate a new list
    if (newloop[1] ~= lastnote) then
      for entries = 1, #newloop do
        table.insert(notetable,newloop[entries])
      end
      lastnote = notetable[#notetable]
      loopcount = loopcount + 1
    end
    offset = offset + 1
    if (loopcount > num_loops) then noexit = false end
  end
  return notetable
end


-- Generate a Random Table of Notes from a given seedvale (so it's repeatable)
-- Logic: Ensures that 2 notes do are not allowed to be together.
function rndseedednotes(allowed_scale,seedval)
  local offset = 0
  local znoexit = true
  local lastnote = ""
  while (znoexit == true)
  do
    znoexit = false
    math.randomseed(seedval+offset)
    offset = offset + 1
    random_notes = {}
    local znotetable = table.shallow_copy(allowed_scale)
    for cindex = 1,#znotetable do
      local random_position = math.random(1,#znotetable)
      local extracted_note = table.remove(znotetable,random_position)
      if (extracted_note == lastnote) then znoexit = true end
      table.insert(random_notes,extracted_note)
      lastnote = extracted_note
    end
  end
  return random_notes
end


function buildrow(itemvalue)
  local newtable = {}
  for index=1,8 do table.insert(newtable,index) end
  return newtable
end

function build_cols_table(n)
  newtable = {}
  for row=1,8 do
    for col=1,8 do
      table.insert(newtable,n[col])
    end
  end
  return newtable
end


function build_rows_table(n)
  newtable = {}
  for row=1,8 do
    for col=1,8 do
      table.insert(newtable,n[row])
    end
  end
  return newtable
end


function build_inc_table(start,amount)
  newtable = {}
  for inc_index=0,63 do
     local newvalue = math.floor(start+inc_index*amount)
     table.insert(newtable,newvalue)
  end
  return newtable
end


function build_dec_table(start,amount)
  newtable = {}
  for dec_index=0,63,amount do
     local newvalue = math.floor(start+dec_index*amount)
     table.insert(newtable,newvalue)
  end
  return newtable
end


function build_rnd_table(startval,endval)
  newtable = {}
  for dec_index=0,63 do
     local newvalue = math.random(startval,endval)
     table.insert(newtable,newvalue)
  end
  return newtable
end

function build_rndwalk_table(startval,minval,maxval,varval)
  newtable = {}
  local noteval = startval
  for m_index=0,63 do
     local randval = math.random(-varval,varval)
     noteval = util.clamp(noteval+randval,minval,maxval)
     table.insert(newtable,noteval)
  end
  return newtable
end



function notepattern_change(x)
  local newpattern
  local patvalue = 0
  newpattern = note_pattern_values[x]
  for index=1,64 do
    cells[index][1] = note_pattern_values[params:get("notepattern")][index]
  end
end


function table.shallow_copy(t)
  local t2 = {}
  for k,v in pairs(t) do
    t2[k] = v
  end
  return t2
end