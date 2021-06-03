-- Version  : 1.0.0
-- Author   : Kevin Lindley
-- Date     : 2021-05-01
-- Filename : synth_sounds.lua


synth_preset_names = {}
synth_preset_values = {}


function synth_sounds_change(x)
  params:set("amp",       synth_preset_values[x][1])
  params:set("pan",       synth_preset_values[x][2])
  params:set("fcutoff",   synth_preset_values[x][3])
  params:set("fgain",     synth_preset_values[x][4])
  params:set("fattack",   synth_preset_values[x][5])
  params:set("fdecay",    synth_preset_values[x][6])
  params:set("fsustain",  synth_preset_values[x][7])
  params:set("frelease",  synth_preset_values[x][8])
  params:set("pecrelease",synth_preset_values[x][9])
  params:set("vattack",   synth_preset_values[x][10])
  params:set("vsustain",  synth_preset_values[x][11])
  params:set("vrelease",  synth_preset_values[x][12])
end

function add_synth_preset(name,values)
  table.insert(synth_preset_names,name) 
  table.insert(synth_preset_values,values)
end


function build_synth_presets()
  --                             amp     pan    fcutoff  fgain  fattack  fdecay  fsustain  frelease  pecrelease  vattack  vsustain  vrelease
  add_synth_preset("Init",    {  0.75,   0.0,   10000,   3.0,   0.05,    0.05,   0.5,      0.15,     0.30,       0.15,    0.5,      0.20     })
  add_synth_preset("Ivy",     {  0.75,   0.0,    6000,   2.5,   0.00,    0.00,   0.4,      2.85,     1.00,       0.00,    0.2,      4.00     })
  add_synth_preset("Bravo",   {  1.00,   0.0,   20000,   0.0,   0.00,    0.00,   0.1,      0.00,     1.40,       0.00,    0.0,      0.45     })
  add_synth_preset("OTR",     {  1.00,   0.0,    6000,   3.56,  0.00,    0.00,   0.04,     0.16,     0.32,       0.00,    0.3,      0.45     })
  add_synth_preset("Bass",    {  1.00,   0.0,    1480,   3.00,  0.04,    0.04,   1.00,     2.00,     2.00,       0.00,    1.0,      0.00     })
  add_synth_preset("Droplet", {  1.00,   0.0,    3097,   3.56,  0.04,    0.52,   0.02,     1.68,     0.80,       0.40,    0.0,      0.40     })
  add_synth_preset("Bass 2",  {  1.00,   0.0,    3000,   3.6,   0.2,     0.2,    1.00,     4.00,     4.00,       0.00,    0.67,     4.00     })
end


function reset_reverb()
  params:set("reverb",2)             -- On
  params:set("rev_eng_input",0)      -- 0dB
  params:set("rev_cut_input",0)      -- 0dB
  params:set("rev_monitor_input",0)  -- 0dB
  params:set("rev_tape_input",0)     -- 0dB
  params:set("rev_return_level",3)   -- 3dB
  params:set("rev_monitor_input",0)  -- 0dB
  params:set("rev_pre_delay",70)     -- 70ms
  params:set("rev_lf_fc",250)        -- 250 Hz
  params:set("rev_low_time",2)       -- 2 Seconds
  params:set("rev_mid_time",2)       -- 2 Seconds
  params:set("rev_hf_damping",6000)  -- 6,000 Hz
end

function reset_compressor()
  params:set("compressor",1)         --     1,2   Off
  params:set("comp_mix",1.0)         --     0      1       0  
  params:set("comp_ratio",4.0)       --     1     20       0
  params:set("comp_threshold",-18)   --  -100     10   db  0
  params:set("comp_attack",5)        --     1   1000   ms  0  
  params:set("comp_release",50)      --     1   1000   ms  0
  params:set("comp_pre_gain",0)      --   -20     60   db  0
  params:set("comp_post_gain",10)    --   -20     60   db  0
end

function load_default_synth_sound()
  synth_sounds_change(3)
  reset_reverb()
  reset_compressor()
  -- params:print()
  -- params:list()
end