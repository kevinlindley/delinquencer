-- Version  : 1.0.0
-- Author   : Kevin Lindley
-- Date     : 2021-05-11
-- Filename : patches.lua


patch_preset_names = {}
patch_preset_values = {}


function patch_change(x)
  print("Change Patch to :"..x)
  params:set("clock_tempo",   patch_preset_values[x][1])
  params:set("step_div",      patch_preset_values[x][2])
  params:set("seqpattern",    patch_preset_values[x][3])
  params:set("scale_mode",    patch_preset_values[x][4])
  params:set("semitone_trans",patch_preset_values[x][5])
  params:set("notepattern",   patch_preset_values[x][6])
  params:set("lengthpreset",  patch_preset_values[x][7])
  params:set("activepattern", patch_preset_values[x][8])
  params:set("activepatBG",   patch_preset_values[x][9])
  params:set("activepatFG",   patch_preset_values[x][10])
  params:set("activepatrnd",  patch_preset_values[x][11])
  params:set("modpresets",    patch_preset_values[x][19])
  mod_preset_change(params:get("modpresets"))
  params:set("modxpattern",   patch_preset_values[x][12])
  params:set("modxfreq",      patch_preset_values[x][13])
  params:set("modypattern",   patch_preset_values[x][14])
  params:set("modyfreq",      patch_preset_values[x][15])
  
  params:set("velpattern",    patch_preset_values[x][16])
  params:set("lenpattern",    patch_preset_values[x][17])
  params:set("probpattern",   patch_preset_values[x][18])
  build_scale()
  build_modgrid()
  activepattern_change(params:get("activepattern"))
  synth_sounds_change(patch_preset_values[x][20])
end

function add_patch_preset(name,values)
  table.insert(patch_preset_names,name) 
  table.insert(patch_preset_values,values)
end

function build_patch_presets()
  --                                         1    2    3    4    5    6    7    8    9    10   11   12   13   14   15   16   17   18   19   20
  --                                        CLK  STP  SEQ  SCA  SEM  NOT  LEN  ACT  ABG  AFG  RND  XMD  XFR  YMD  YFR  VEL  LEP  PRP  MDP  SND
  --------------------------------------------------------------------------------------------------------------------------------------------
  add_patch_preset("Init",               {  120, 2,   1,   1,   0,   2,   1,   1,   3,   1,   0,   1,   64,   1,  64,  2,   1,   1,   1,   2})
  add_patch_preset("Latch of the Day",   {  140, 2,   1,   1,  -6,  57,   1,  13,   4,   1,   0,   8,   64,   8,  64, 24,  19,  25,   1,   3})  
  add_patch_preset("Is Tawsinaay Ok",    {  120, 1,   3,   2, -12,  56,   2,  13,   4,   4,   0,   8,  991,   8, 701,  2,   9,   2,   3,   5})  
  add_patch_preset("Descent",            {   60, 1,   9,   5, -18,  57,   4,  13,   4,   4,   0,   8,  463,   8, 997,  2,   9,   2,   3,   7})
end



function display_patch(pindex)
  print("Name ["..patch_preset_names[pindex].."] ID:["..pindex.."]")
  print("------------------------------")
  print("clock_tempo    ["..patch_preset_values[pindex][1].."]")
  print("step_div       ["..patch_preset_values[pindex][2].."]")
  print("seqpattern     ["..patch_preset_values[pindex][3].."]")
  print("scale_mode     ["..patch_preset_values[pindex][4].."]")
  print("semitone_trans ["..patch_preset_values[pindex][5].."]")
  print("notepattern    ["..patch_preset_values[pindex][6].."]")
  print("lengthpreset   ["..patch_preset_values[pindex][7].."]")
  print("activepattern  ["..patch_preset_values[pindex][8].."]")
  print("activepatBG    ["..patch_preset_values[pindex][9].."]")
  print("activepatFG    ["..patch_preset_values[pindex][10].."]")
  print("activepatrnd   ["..patch_preset_values[pindex][11].."]")
  print("modxpattern    ["..patch_preset_values[pindex][12].."]")
  print("modxfreq       ["..patch_preset_values[pindex][13].."]")
  print("modypattern    ["..patch_preset_values[pindex][14].."]")
  print("modyfreq       ["..patch_preset_values[pindex][15].."]")
  print("velpattern     ["..patch_preset_values[pindex][16].."]")
  print("lenpattern     ["..patch_preset_values[pindex][17].."]")
  print("probpattern    ["..patch_preset_values[pindex][18].."]")
  print("modpresets     ["..patch_preset_values[pindex][19].."]")
  print("SynthSnd       ["..patch_preset_values[pindex][20].."]")
  print(" ")
  print(" ")
end

function load_demo_patch()
  patch_change(3)
end

function load_init_patch()
  patch_change(1)
end