--   =========================
--   D E L I N Q U E N C E R
--   =========================
--   A binary sequencer app
--   -------------------------
--   Author  : Kevin Lindley
--
--   Turn {Enc2}  for more .....
--
-- ---------------------------------
--        Menu 1 - Sequencer
------------------------------------
-- Enc1 - Change BPM
-- Enc2 - Menu Item Selection
-- Enc3 - Menu Item Value
-- Key1 - System Menu
-- Key1*- Reset if Held
-- Key2 - Next Menu
-- Key3 - Stop/Start
--
-- -----------Settings ------------
-- BPM       - Beats per Minute
-- Division  - Divs per Beat
-- Loop      - Looping Type
-- Scale     - Quantised Scale
-- Transpose - Transposition
-- Preset    - Patches
--
-- ------------------------------------
--     Menu 2 - Note Entry
------------------------------------
-- Enc1 - Sequencer Cell Position Selection
-- Enc2 - Menu Item Selection
-- Enc3 - Menu Item Value
-- Key1 - System Menu
-- Key2 - Next Menu
-- Key3 - Toggle Current Cell
--
-- -----------Settings ------------
-- Note      :  Cell Note Pitch
-- Velocity : Cell Note Velocity
-- Length : Cell Note Length
-- Cell State : On/Off/Rst/Skp
-- Probability: 0-100%
-- Len Notes  : Set all Note Lengths
--
-- --------------------------------
--       Menu 3 - PatternMaker
-- --------------------------------
-- Enc1 - Change BPM
-- Enc2 - Menu Item Selection
-- Enc3 - Menu Item Value
-- Key1 - System Menu
-- Key2 - Next Menu
-- Key3 - Stop/Start
--
-- -----------Settings ------------
-- Pattern  - Mod Pattern
-- Neutron  - On/Off/Rst/Skp/Ctl
-- Proton   - On/Off/Rst/Skp/Ctl
-- Mutation - 0-100%
-- --------------------------------
--      Menu 4 - Delinquencer
-- --------------------------------
-- Enc1 - Select Modifier
-- Enc2 - Menu Item Selection
-- Enc3 - Menu Item Value
-- Key1 - System Menu
-- Key2 - Next Menu
-- Key3 - Stop/Start
--
-- -----------Settings ------------
-- X-Pat  - Column Pattern
-- X-Loop - Column Change Freq
-- Y-Pat  - Row Pattern
-- Y-Loop - Row Change Freq
-- State  - Modifier Setting
-- Preset - Presets to try
--
-- --------------------------------
-- Version : 2.1.0
-- Date    : 2021-06-03
-- --------------------------------
--
-- Thanks to the following people
-- for Bug Fix Reports :-)
--   xmacex
--
-- Press {K3} to start ....

engine.name = 'PolySaw'

-- params:print()

MusicUtil = require "musicutil"
tabutil = require "tabutil"

-- Cell Notes MIDI No    - 1
-- Cell Note Velocity    - 2
-- Cell Note Length      - 3
-- Cell Note Status      - 4  
-- Cell Note Probability - 5


cells = {}
modgrid = {}
probgrid = {}
midicounter = 0

cellstatus = {"On","Rest","Skip","Ctl"}
modifierstatus_names = {"Off","On"}
clock_sources = {"internal","midi","link","crow"}
cellintensity = {15,3,1,8}
splashid = 0
note_names = {"C","C#","D","D#","E","F","F#","G","G#","A","A#","B"}
DATA_DIR=paths.code.."delinquencer/"
PROJECT_FOLDER=DATA_DIR.."projects_data/"
PROJECT_LIST=DATA_DIR.."projects/"
prevent_saveload=false

local active_pattern_sequence = {}
local active_mod_sequence     = {}
local midi_notes_in_scale     = {}
local editcell = 1

local midi_out_device  = 1
local midi_out_channel = 1
local active_notes = {}
local sequencestep = 1
local hstep = 1
local sequencer_running = false
local control_index = 1
local m_quant_scale = {}

local edit_sequencer = true   -- Are we editing the sequencer or the modifier

local menu_controls = {}
menu_option_index = {1,1,1,1}
menu_names       = {"Sequencer","Note Entry","PatternMaker","Delinquencer" }
menu_controls[1] = {"BPM","Division","Loop","Scale","Transpose","Preset"}
menu_controls[2] = {"Note","Velocity","Length","Cell State","Probability","Len Notes"}
menu_controls[3] = {"Pattern","Neutron","Proton","Mutation"}
menu_controls[4] = {"X Pat","X Loop","Y Pat","Y Loop","State","Preset"}

local menu_page  = 1

local id = 0 --  ID for clock

include('lib/seq_patterns')
include('lib/mod_patterns')
include('lib/active_patterns')
include('lib/note_patterns')
include('lib/probability')
include('lib/length_patterns')
include('lib/vel_patterns')
include('lib/prob_patterns')
include('lib/synth_sounds')
include('lib/patches')


function reset_sequencer()
  pstep = 1
  hstep = 1
  ticks = 1
  sequencestep = active_pattern_sequence[pstep]
end


function key(n,z)
  redraw()
  screen.update()
  if (z == 1) then
    if ((n == 1) and (menu_page ==1)) then
      reset_sequencer()
      redraw()
      screen.update()
    end
    if ((n == 1) and (menu_page ==2)) then
      load_init_patch()  
      build_modgrid()
      reset_sequencer()
      redraw()
      screen.update()
    end
    
    if (n ==2) then
      nextmenu(1)
    end
    if (n == 3) then
      if (menu_page == 2) then
          local newvalue = cells[params:get("editcell")][4] +1
          if (newvalue > 4) then newvalue = 1 end
          cells[params:get("editcell")][4] = newvalue
          menu_option_index[2]=4
      end
      if ((menu_page == 1) or (menu_page == 3)) then
        if (sequencer_running == true) then
          stop_sequencer()
        else
          start_sequencer()
        end
      end
      if (menu_page == 4) then
        if (mod_control[params:get"editmod"] == 1) then
          mod_control[params:get"editmod"] = 0
        else
          mod_control[params:get"editmod"] = 1
        end
        menu_option_index[4]=5
        build_modgrid()
      end
    end
  end
end


function seq_pattern_change(x)
 active_pattern_sequence = table.shallow_copy(seq_pattern_data[params:get("seqpattern")])
end

function mod_xpattern_change(x)
   update_col_modifier()
end

function mod_ypattern_change(x)
  update_row_modifier()
end

function new_midi_device(x)
  all_notes_off()
  midi.connect(x)
  print("New MIDI Device ["..x.."]")
end

function new_midi_channel(x)
  all_notes_off()
  print ("New MIDI Channel ["..x.."]")
end


function midi_panic()
  kill_all_notes_off()
  print ("MIDI Panic - All Notes Off")
  stop_sequencer()
  print ("Sequencer Stopped")
end


function new_output(x)
  all_notes_off()
end

function cleanup ()
  all_notes_off()
end

function kill_midi_note(deadnote)
  --print("Note Off:"..deadnote.." on channel:"..params:get("midi_out_channel"))
  midi_out_device:note_off(deadnote,nil,params:get("midi_out_channel"))
end

function remove_expired_notes(midicounter)
  local i=1
  while i <= #active_notes do
    if (active_notes[i][2] < midicounter+1) then
      kill_midi_note(active_notes[i][1])
      table.remove(active_notes, i)
    else
        i = i + 1
    end
  end
end

function print_all_notes()
  local i=1
  while i <= #active_notes do
    print(i.." 1:["..active_notes[i][1].. "] 2["..active_notes[i][2].."]")
    i = i + 1
  end
end

function kill_all_notes_off()
  for nindex=0,127 do
    midi_out_device:note_off(nindex,nil,params:get("midi_out_channel"))
  end
  print("Here")
end

function all_notes_off()
  -- For all the notes currently active send a midi note off message
  for _, a_note in pairs(active_notes) do
    midi_out_device:note_off(a_note[1],nil,params:get("midi_out_channel"))
  end
  -- Clear the list
  active_notes = {}
end

local output_options = {"audio", "midi", "audio + midi"}

local scale_names = {}

function build_scale()
   midi_notes_in_scale = MusicUtil.generate_scale_of_length(0, params:get("scale_mode"), 127)
   m_quant_scale = gen_midi_quant_scale(midi_notes_in_scale)
end

-- Debug Function to display the contents of a table as a single string
function print_a_table(input_table)
  local nstring = ""
  for _, a_note in pairs(input_table) do
    nstring = nstring .. a_note
  end
  print(nstring)
end


function setup_parameters()
  params:add_separator("")
  params:add_separator("D e l i n q u e n c e r")
  params:add_group("Notes",8)
  params:add_separator("All Note Settings") 
    params:add_option("lengthpreset",   "Lengths", length_value_names,1)
    params:set_action("lengthpreset", function(x)  length_preset_change(x)  end)
    params:add_option("probpattern",   "Probabilities", prob_pattern_names,1)
    params:set_action("probpattern", function(x)  probpattern_change(x)  end)
    params:add_option("velpattern",   "Velocities", vel_pattern_names,1)
    params:set_action("velpattern", function(x)  velpattern_change(x)  end)
    params:add_separator("Note Presets") 
    params:add_option("lenpattern",   "Length Pat", length_pattern_names,1)
    params:set_action("lenpattern", function(x)  lenpattern_change(x)  end)
    params:add_separator("Toggles")  
    params:add_option("probreset", "Probability Reset", modifierstatus_names,1)

  params:add_group("Sequencer",7)
    params:add_number("editcell","Selected Cell",1,64,1)
   -- params:set_action("editcell", function(x) editcell(x) end)
    division_names = {"1/1","1/2","1/3","1/4","1/5","1/6","1/7","1/8","1/9","1/10","1/11","1/12","1/13","1/14","1/15","1/16"}
    params:add_option("step_div",   "Divisions", division_names,1)
    params:add_option("seqpattern","Loop Direction",seq_pattern_names,1)
    params:set_action("seqpattern", function(x) seq_pattern_change(x)  end)
    params:add_option("scale_mode",   "Scale Quantizer",scale_short_names,1)
    params:set_action("scale_mode", function(x) build_scale()  end)
    params:add_number("semitone_trans","Transpose (semitones)",-12*5,12*5,0)
    params:add_separator("Sequencer Presets") 
    params:add_option("notepattern",   "Preset", note_pattern_names,1)
    params:set_action("notepattern", function(x)  notepattern_change(x)  end)
  
  params:add_group("Delinquencer",7)
    params:add_number("editmod","Selected Modulator",1,16,1)
    params:add_option("modxpattern","X Modulation Pattern",mod_pattern_names,1)
    params:set_action("modxpattern", function(x)  mod_xpattern_change(x)  end)
    params:add_option("modypattern","Y Modulation Pattern",mod_pattern_names,1)
    params:set_action("modypattern", function(x)  mod_ypattern_change(x)  end)
    params:add_number("modxfreq","X Modulation Frequency",2,1024,64)
    params:add_number("modyfreq","Y Modulation Frequency",2,1024,64)
  params:add_separator("Delinquencer Presets") 
    params:add_option("modpresets","Preset", mod_preset_names,2)
    params:set_action("modpresets", function(x)  mod_preset_change(x)  end)
  
  params:add_group("PatternMaker",4)  
    params:add_option("activepattern","Pattern", active_pattern_names,1)
      params:set_action("activepattern", function(x)  activepattern_change(x)  end)
    params:add_option("activepatBG","Neutron Status", cellstatus,2)  -- Off
    params:add_option("activepatFG","Proton Status", cellstatus,1)  -- On
      percentage_control = controlspec.new(0,100,'lin',1,0,'%',1,false)
    params:add_number("activepatrnd","Mutation",0,100,0)

  params:add_group("Sound",19)
    Amplitude_control = controlspec.new(0.0,1.0,'lin',0.01,1.0,'',0.01)
    Gain_control = controlspec.new(0.0,4.0,'lin',0.01,2.0,'',0.01)
    ADSRT_control = controlspec.new(0.0,4.0,'lin',0.01,2.0,'',0.01)
    CURVE_control = controlspec.new(-8.0,8.0,'lin',0.1,4.0,'',0.10)
  params:add_separator("Amplifier")   
    params:add{type="control",id="amp",name="Amplitude [0-1]",controlspec=Amplitude_control,action=function(x) engine.amp(x) end}
  params:add_separator("Amplifier ASR Envelope")  
    params:add{type="control",id="vattack",   name="Amp Attack [0-4]", controlspec=ADSRT_control, action=function(x) engine.vattackt(x) end}     
    params:add{type="control",id="vsustain",  name="Amp Sustain [0-1]", controlspec=Amplitude_control, action=function(x) engine.vsustaint(x) end} 
    params:add{type="control",id="vrelease",  name="Amp Release [0-4]", controlspec=ADSRT_control, action=function(x) engine.vrelease(x) end} 
    params:add_separator("Filter") 
    params:add{type="control",id="fcutoff",   name="Filter Cutoff (Hz)", controlspec=controlspec.FREQ, action=function(x) engine.fcutoff(x) end}
    params:add{type="control",id="fgain",     name="Filter Gain [0-4]", controlspec=Gain_control, action=function(x) engine.fgain(x) end} 
  params:add_separator("Filter ADSRR Envelope") 
    params:add{type="control",id="fattack",   name="Filter Attack [0-4]", controlspec=ADSRT_control, action=function(x) engine.fattackt(x) end} 
    params:add{type="control",id="fdecay",    name="Filter Decay [0-4]", controlspec=ADSRT_control, action=function(x) engine.fdecayt(x) end} 
    params:add{type="control",id="fsustain",  name="Filter Sustain [0-1]", controlspec=Amplitude_control, action=function(x) engine.fsustaint(x) end} 
    params:add{type="control",id="frelease",  name="Filter Release [0-4]", controlspec=ADSRT_control, action=function(x) engine.frelease(x) end} 
    params:add{type="control",id="pecrelease",name="Filter P Release [0-4]", controlspec=ADSRT_control, action=function(x) engine.pecrelease(x) end}
  params:add_separator("Stereo Panning")  
    params:add{type="control",id="pan",name="Pan L/R", controlspec=controlspec.PAN, action=function(x) engine.pan(x) end}  params:add_separator("Synth Sound Presets")
    params:add_option("synthpreset", "Preset", synth_preset_names,1)
    params:set_action("synthpreset", function(x) synth_sounds_change(x)  end)

  params:add_group("Output",7)
  params:add_separator("Output Settings") 
    params:add_option("output", "Output", output_options, 3)
    params:set_action("output", function(x) new_output(x) end)
    params:add_separator("MIDI Settings") 
    params:add_number("midi_out_device","Midi out device",1,4,2)
    params:set_action("midi_out_device", function(x) new_midi_device(x) end)
    params:add_number("midi_out_channel","Midi out channel",1,16,1)
    params:set_action("midi_out_channel", function(x) new_midi_channel(x) end)
    params:add_separator("MIDI Panic") 
    params:add_trigger("midi_panic","All midi notes off")
    params:set_action("midi_panic", function(x) midi_panic() end)

 params:add_group("Patches",1)
    params:add_option("patchpreset", "Patch", patch_preset_names,1)
    params:set_action("patchpreset", function(x) patch_change(x)  end)

  params:add_group("Projects",5)
  params:add_separator("Save") 
    params:add_text('save_name',"Project Name","new")
    params:add_binary("save current","Save project as {name}",'momentary')
    params:set_action("save current", function(y) dosaveproject(val) end)
  params:add_separator("Load") 
    params:add_file("load_name","Load  project",PROJECT_LIST)
    params:set_action("load_name", function(y) doloadproject(y) end)    

end


function dosaveproject(val)
  if prevent_saveload then 
    do return end 
  end
	local x=params:get("save_name")
  if ((x=="") or (val==0)) then 
    do return end end
    project_save(x)
end


function doloadproject(y)
  if prevent_saveload then do return end end
  local project_folder_name=y
 -- params:set("load_name",project_folder_name)
  if #project_folder_name<=#PROJECT_LIST then 
    do return end 
  end
  local folder = project_folder_name:gsub(PROJECT_LIST,"")
  local project_data_folder_name = PROJECT_FOLDER..folder
  project_load(project_data_folder_name)
end


function project_load(project_data_folder_name)
  prevent_saveload = true
  LOAD_PATH = project_data_folder_name.."/"
  local CELLS_FILENAME   = LOAD_PATH.."cells.txt"
  local MODGRID_FILENAME = LOAD_PATH.."modgrid.txt"
  local PARMS_FILENAME   = LOAD_PATH.."parameters.pset"
  cells = tab.load(CELLS_FILENAME)
  modgrid = tab.load(MODGRID_FILENAME)
  params:read(PARMS_FILENAME)
  prevent_saveload=false
end


function project_save(project_name)
  prevent_saveload = true
  -- create if doesn't exist
  SAVE_DIR = PROJECT_FOLDER..project_name.."/"
  local CELLS_FILENAME   = SAVE_DIR.."cells.txt"
  local MODGRID_FILENAME = SAVE_DIR.."modgrid.txt"
  local PARMS_FILENAME   = SAVE_DIR.."parameters.pset"
  os.execute("mkdir -p "..SAVE_DIR)
  os.execute("echo "..project_name.." > "..PROJECT_LIST.."/"..project_name)
  -- save tables
  tab.save(cells,CELLS_FILENAME)
  -- save modgrid
  tab.save(modgrid,MODGRID_FILENAME)
  -- save the parameter set
  params:write(PARMS_FILENAME)
  prevent_saveload = false
end


function build_scales()
    for i = 1, #MusicUtil.SCALES do
    table.insert(scale_names, string.lower(MusicUtil.SCALES[i].name))
    end
end


-- Build the Save Folders if we dont already have them
function build_save_folders()
  if (util.file_exists(DATA_DIR)       == false) then os.execute("mkdir -p "..DATA_DIR) end
  if (util.file_exists(PROJECT_FOLDER) == false) then os.execute("mkdir -p "..PROJECT_FOLDER) end
  if (util.file_exists(PROJECT_LIST)   == false) then os.execute("mkdir -p "..PROJECT_LIST) end
end


function init()
  midicounter = 0
  params:set("clock_source",1) -- Internal
  clock.set_source("internal")
  math.randomseed(os.time())
  build_save_folders()
  build_active_patterns()
  build_synth_presets()
  build_note_patterns()
  build_length_patterns()
  build_mod_presets()
  build_vel_patterns()
  build_prob_patterns()
  build_patch_presets()
  active_pattern_sequence = seq_pattern_data[1]
  screen.aa(0)
  build_scales()
  setup_parameters()
  midi_out_device = midi.connect(params:get("midi_out_device"))
  kill_all_notes_off()
  build_scale()
  build_cells()
  build_default_modgrid()
  build_default_probgrid()
  build_midi_notes()
  load_default_synth_sound()
  load_demo_patch()
  audio_sound_init()
  splashid = clock.run(display_splash_screen)
end


function display_splash_screen()
  drawsplash = true
  local SPLASH_SCREEN_DISPLAY_TIME_SECS = 2 
  clock.sleep(SPLASH_SCREEN_DISPLAY_TIME_SECS)
  drawsplash = false
  menu_page = 1
  clock.cancel(splashid)
  start_sequencer()
  redraw()
end


function start_sequencer()
  if (sequencer_running == false) then
    sequencer_running = true
    id = clock.run(sequencer_pulse)
  end
end


function stop_sequencer()
  if (sequencer_running == true) then
    sequencer_running = false
    clock.cancel(id)
    all_notes_off()
  end
end


function clock.transport.start()
  start_sequencer()
end


function clock.transport.stop()
  stop_sequencer()
end


function quantized_scale_note(in_note)
  local q_note
  q_note = m_quant_scale[in_note]
  return q_note
end


function gen_midi_quant_scale(m_midi_notes_in_scale)
  quant_scale = {}
  local scale_index = 0
  local scale_note = 0
  local old_note = 0
  local indexed_note = 0
  for index = 0, 127 do
    scale_note = m_midi_notes_in_scale[scale_index+1]  -- Add one because Lua tables start at 1 not 0
    if (scale_note > index) then
       quant_scale[index] = old_note
    else
      old_note = scale_note
      quant_scale[index] = old_note
      scale_index = util.clamp(scale_index + 1,0,#m_midi_notes_in_scale-1)
    end
  end
  return quant_scale
end


--cellstatus = {"On","Off","Skip","Ctl"}
function dont_skip_position(location)
  result = false
  if (cells[location][4] == 1) then result = true end   -- On
  if (cells[location][4] == 2) then result = true end  -- Off
  if (cells[location][4] == 3) then result = false  end   -- Skip
  if (cells[location][4] == 4) then                      -- Ctl
  -- we need to check the modgrid to find out what to do  
    if (modgrid[location] == 1) then  -- On
      result = true
    else                              -- Off
      result = false
    end
    if (probgrid[location] ~= 1) then -- Off
      result = false
    end
  end
  return result
end


function can_play_note(location)
  -- Assume we can't play the note - This covers case of cells[sequencestep][4] == 3
  result = false
  -- Sequencer setting is set to always play.
  if (cells[location][4] == 1) then  result = true end
  if (cells[location][4] == 4) then  
  -- we need to check the modgrid to find out what to do  
    if (modgrid[location] == 1) then
      result = true
    else
      result = false
    end
  end
  if (probgrid[location] ~= 1) then -- Off
    result = false
  end
  return result
end


function sequencer_pulse()
  reset_sequencer()
  while true do -- forever
    clock.sync(1/(params:get("step_div")*4))
    remove_expired_notes(midicounter)
    if (ticks == 1) then
      m_dontexit = true
      while (m_dontexit)
      do
        sequencestep = active_pattern_sequence[pstep]
        if dont_skip_position(sequencestep) then 
          playnote(sequencestep,midicounter)
          midicounter = midicounter + 1
          m_dontexit = false
        end
        if (hstep%params:get("modyfreq")) == 0 then update_row_modifier() end
        if (hstep%params:get("modxfreq")) == 0 then update_col_modifier() end 
        hstep = hstep + 1
        if (hstep > 1024) then hstep = 1 end
        pstep = pstep + 1
        if (pstep >  64) then 
          pstep = 1
          if (params:get("probreset") == 1) then    -- Yes 
            build_probgrid()
          end
        end
        if (alldead() == true) then m_dontexit = false end
      end
      redraw()
    end
    ticks = ticks + 1
    if ticks > 4 then ticks = 1 end
  end
end


function playnote(sequencestep,midicounter)
  local note_number   = quantized_scale_note(transposed_note(cells[sequencestep][1]))
  local note_velocity = cells[sequencestep][2]
  local note_length   = cells[sequencestep][3]
  local note_play     = cells[sequencestep][4]
  if (can_play_note(sequencestep)) then
  -- MIDI Out ---------------------------------------------------------  
    if (params:get("output") > 1) then
      midi_out_device:note_on(note_number,note_velocity,params:get("midi_out_channel"))
    --  print("note_length: "..note_length)
      table.insert(active_notes,{note_number,midicounter+note_length*4})
     -- print("midi out: N:[".. note_number .."] V:["..note_velocity.."] L:[" .. note_length*4 .. "] C:["..params:get("midi_out_channel").."]")
    end 
  -- Audio Out ---------------------------------------------------------
    if ((params:get("output") == 1) or (params:get("output") == 3)) then
      local freq = MusicUtil.note_num_to_freq(note_number)
      engine.amp(note_velocity/127)
      local releasetime = params:get("pecrelease")
      releasetime = releasetime * (note_length)
      engine.pecrelease(releasetime)
      engine.freq(freq);
      --print("Release Time: "..releasetime)
    end
  end
end


function transposed_note(p_midinote)
  local midinote = tonumber(p_midinote)
  local m_value = util.clamp(midinote+params:get("semitone_trans"),0,127)
  return m_value
end  


function alldead()
  result = true
  for index=1,64 do
    if (cells[index][4] == 1) then result = false end   -- On
    if (cells[index][4] == 2) then result = false end   -- Rest
  --   if (cells[index][4] == 3) then result = false end   -- Skip  - We dont check
    if (cells[index][4] == 4) then                      -- Ctl 
       if (modgrid[index] == 1) then result = false end  --   but set to On
     end
  end
  return result 
end


function nextmenu(d) 
  nmenu_page = menu_page + d
  if (nmenu_page > #menu_controls) then nmenu_page = 1 end
  if (nmenu_page < 1) then nmenu_page = #menu_controls end  
  menu_page = nmenu_page
  redraw()
  not_processed = false
  edit_sequencer = true
  if (menu_page == 3) then edit_sequencer = false end
end

-- Standard Encoder function
-- menu_page used to switch between modes of the buttons
function enc(n,d)
  not_processed = true
  if (n == 1) then 
    if (menu_page == 1) then params:set("clock_tempo",params:get("clock_tempo")+d) end
    if (menu_page == 2) then params:set("editcell",params:get("editcell")+d) end
    if (menu_page == 4) then params:set("editmod",params:get("editmod")+d) end
  end
  if (n == 2) then 
    menu_option_index[menu_page] = util.clamp(menu_option_index[menu_page]+d,1,#menu_controls[menu_page])
  end
  if (n == 3) then

      
    ---[Menu 1]-------------------------------
    if (menu_page == 1) then
      if  (menu_option_index[menu_page] == 1) then
        params:set("clock_tempo",params:get("clock_tempo")+d)
      end
      if  (menu_option_index[menu_page] == 2) then
        params:set("step_div",params:get("step_div")+d)
      end
      if  (menu_option_index[menu_page] == 3) then
        params:set("seqpattern",params:get("seqpattern")+d)
      end
      if  (menu_option_index[menu_page] == 4) then
        params:set("scale_mode",params:get("scale_mode")+d)  --- HELP
        build_scale()
      end
      if  (menu_option_index[menu_page] == 5) then
        params:set("semitone_trans",params:get("semitone_trans")+d)
      end
      if  (menu_option_index[menu_page] == 6) then
        params:set("notepattern",util.clamp(params:get("notepattern")+d,1,#note_pattern_names))
      end
    end
    
        ---[Menu 2]-------------------------------
    if (menu_page == 2) then
      if  (menu_option_index[menu_page] == 1) then   -- Note Pitch
        cells[params:get("editcell")][1] = util.clamp(cells[params:get("editcell")][1] +d,0,127)
      end
      if  (menu_option_index[menu_page] == 2) then   -- Note Velocity
        cells[params:get("editcell")][2] = util.clamp(cells[params:get("editcell")][2] +d,0,127)
      end
      if  (menu_option_index[menu_page] == 3) then   -- Note Length
        cells[params:get("editcell")][3] = util.clamp(cells[params:get("editcell")][3] +d/4,0.25,#length_value_names/4)
      end
      if  (menu_option_index[menu_page] == 4) then  -- Note Status
        cells[params:get("editcell")][4] = util.clamp(cells[params:get("editcell")][4] +d,1,4)
      end
      if  (menu_option_index[menu_page] == 5) then  -- Note Probablility
        cells[params:get("editcell")][5] = util.clamp(cells[params:get("editcell")][5] +d,0,100)
        build_probgrid()
      end
      if  (menu_option_index[menu_page] == 6) then  -- All Notes Length
        local newvalue = params:get("lengthpreset") +d
        params:set("lengthpreset",util.clamp(newvalue,1,#length_value_names))
      end
    end
    
    ----[Menu 3]-------------------------------
    if (menu_page == 3) then
      if (menu_option_index[menu_page] == 1) then
        params:set("activepattern",params:get("activepattern")+d)
      end
      if (menu_option_index[menu_page] == 2) then
        params:set("activepatBG",params:get("activepatBG")+d)
        activepattern_change(params:get("activepattern"))   -- force and update
      end
      if (menu_option_index[menu_page] == 3) then
        params:set("activepatFG",params:get("activepatFG")+d)
        activepattern_change(params:get("activepattern"))   -- force and update
      end
      if (menu_option_index[menu_page] == 4) then
        params:set("activepatrnd",params:get("activepatrnd")+d)
        activepattern_change(params:get("activepattern"))   -- force and update
      end
    end
      
    ----[Menu 4]-------------------------------
    if (menu_page == 4) then
      if  (menu_option_index[menu_page] == 1) then
        params:set("modxpattern",params:get("modxpattern")+d)
      end
      if  (menu_option_index[menu_page] == 2) then
        params:set("modxfreq",params:get("modxfreq")+d)
      end
      if  (menu_option_index[menu_page] == 3) then
        params:set("modypattern",params:get("modypattern")+d)
      end
      if  (menu_option_index[menu_page] == 4) then
        params:set("modyfreq",params:get("modyfreq")+d)
      end
      if  (menu_option_index[menu_page] == 5) then
        if (mod_control[params:get"editmod"] == 1) then
          mod_control[params:get"editmod"] = 0
        else
          mod_control[params:get"editmod"] = 1
        end
        build_modgrid()
      end
      if  (menu_option_index[menu_page] == 6) then
        params:set("modpresets",params:get("modpresets")+d)
      end
    end
  end
  redraw()
end


function build_midi_notes()
  octave = -2
  notename = 1
  midi_notes = {}
  for index = 0, 127 do
      if octave < 0 then 
        midi_notes[index+1] = "-" .. note_names[notename]..tostring(0-octave)  -- Add one because Lua tables start at 1 not 0
      else
        midi_notes[index+1] = note_names[notename]..tostring(octave)           -- Add one because Lua tables start at 1 not 0
      end
    notename = notename + 1
    if (notename > 12) then
      notename = 1
      octave = octave + 1
    end
  end
end


--  cellstatus = {"On","Off","Skip","Ctl"}
function build_cells()
  local state = 1
  local notelength = 1
  local probability = 100
  for index=1,64 do
    cells[index] = {index+28,127,notelength,state,probability}
  end
end


--   cellstatus = {"On","Off","Skip","Ctl"}
--   cellintensity = {15,1,0,8}
function draw_cells()
  y = 1
  x = 1
  for index=1,64 do
    -- Get the Base Intensity
    intensity = cellintensity[cells[index][4]]
    local chance_value = cells[index][5]
    -- Check to see if we need to modify it based on the modifier
    if (cells[index][4] == 4) then
      if (modgrid[index]== 1) then
        intensity = 13 --cellintensity[1] --Playing Cell
      else
        intensity = 2 --cellintensity[4]  --- Non Playing Cell
      end
    end
    if (probgrid[index] == 0) then intensity = 4 end
    draw_a_cell(x,y,intensity,6,chance_value)
    x = x + 1
    if (x > 8) then
      x = 1
      y = y + 1
    end
  end
end  


function draw_cell(index,value,size,chance_value)
  y = math.floor((index-1) / 8)
  x = (index - y*8)
 draw_a_cell(x,y+1,value,size,chance_value)
end


function draw_menu()
  screen.level(2)
  screen.rect(66,1,62,1)
  screen.rect(66,3,62,1)
  screen.rect(66,4,62,1)
  screen.stroke()
  screen.level(15)
  screen.move(65,5)
  screen.text(menu_names[menu_page])
  screen.level(2)
  for index=1,#menu_controls[menu_page] do
    screen.level(3)
    screen.move(65,7+5+((index-1)*7))
   if (menu_option_index[menu_page] == index) then screen.level(15) end 
    screen.text(menu_controls[menu_page][index])
    screen.level(3)
  end
  draw_footer()
  draw_dots()
end


function draw_dots()
  
  function highlight_dots(dot,x,y)
    screen.level(2)
    if (menu_page == dot) then screen.level(15) end
    screen.pixel(x,y)
    screen.fill()
  end
  highlight_dots(1,58,58) 
  highlight_dots(2,60,58)
  highlight_dots(3,58,60)
  highlight_dots(4,60,60)
end


function draw_footer()
  screen.level(8)
  screen.move(65,54)
  if ((menu_page==1) or (menu_page==3)) then  -- Sequencer
    if (sequencer_running == true) then
      screen.text("K3 Pause")
    else
      screen.text("K3 Start")
    end
  end
  if (menu_page==2) then --Note Entry
    screen.text("K3 Toggle Cell")
  end
  if (menu_page==4) then
    screen.text("K3 Toggle Mod")
  end
end


function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end


function draw_slash_screen()
  screen.clear()
  screen.blend_mode(0)
  screen.display_png(DATA_DIR.."assets/splash.png", 0, 0)
end


function transpose_string()
  local transpose_value = params:get("semitone_trans")
  local octaves = math.floor(math.abs(transpose_value)/12)
  local semis = math.floor(math.abs(transpose_value) - (octaves*12))
  local m_string = ""
  if (transpose_value < 0) then
    m_string = m_string.."-"
  end
  m_string = m_string .. octaves..":"..semis
  return m_string
end


function highlight_selected(index)
  if (menu_option_index[menu_page] == index) then screen.level(15) else screen.level(3) end
end


function display_value(index,valuestring)
  screen.move(128,5+index*7)
  highlight_selected(index)
  screen.text_right(valuestring)
end

function draw_seq_values(actualcell)
  screen.level(3)
  if (menu_page == 0) then 
    draw_slash_screen() 
  else
    draw_menu()
  end
  if (menu_page == 1) then
    display_value(1,params:get("clock_tempo"))
    display_value(2,"1/"..params:get("step_div"))
    display_value(3,seq_pattern_names[params:get("seqpattern")])
    display_value(4,scale_short_names[params:get("scale_mode")])
    display_value(5,transpose_string())
    display_value(6,note_pattern_names[params:get("notepattern")])
  end
  if (menu_page == 2) then
    display_value(1,midi_notes[cells[params:get("editcell")][1]+1])  -- Add one because lua tables start at 1 not 0 
    display_value(2,cells[params:get("editcell")][2])
    display_value(3,draw_note_length())
    display_value(4,cellstatus[cells[params:get("editcell")][4]])
    display_value(5,cells[params:get("editcell")][5])
    display_value(6,length_value_names[params:get("lengthpreset")])
  end
  if (menu_page == 3) then
    display_value(1,active_pattern_names[params:get("activepattern")])
    display_value(2,cellstatus[params:get("activepatBG")])
    display_value(3,cellstatus[params:get("activepatFG")])
    display_value(4,params:get("activepatrnd"))
  end
  if (menu_page == 4) then
    display_value(1,mod_pattern_names[params:get("modxpattern")])
    display_value(2,params:get("modxfreq"))
    display_value(3,mod_pattern_names[params:get("modypattern")])
    display_value(4,params:get("modyfreq"))
    display_value(5,modifierstatus_names[tonumber(mod_control[params:get("editmod")]+1)])  -- Add one because lua tables start at 1 not 0 
    display_value(6,mod_preset_names[params:get("modpresets")])
  end
end


function draw_note_length()
  local cell_note_value = cells[params:get("editcell")][3]
  local note_length_string = length_value_names[cell_note_value*4]
  return note_length_string
end

-- Cell Notes MIDI No    - 1
-- Cell Note Velocity    - 2
-- Cell Note Length      - 3
-- Cell Note Status      - 4  
-- Cell Note Probability - 5

function draw_current_note(psequencestep)
  local tnote = quantized_scale_note(transposed_note(cells[psequencestep][1]))
  if (can_play_note(psequencestep) == true) then
    screen.level(10)
  else
    screen.level(1)
  end
  screen.move(65,63)
    screen.level(15)
    screen.text(midi_notes[tnote+1])  -- Add one because Lua tables start at 1 not 0
    screen.move(82,63)
    screen.level(4)
    screen.text(cells[sequencestep][2])  -- Velocity
    screen.move(114,63)
    screen.text_right(cells[sequencestep][3])  -- Length
    screen.level(15)
    screen.move(128,63)
    screen.text_right (tnote)   -- Midi Note
end


function redraw()
  if (drawsplash == true) then
    draw_slash_screen()
  else
    screen.clear()
    screen.blend_mode(0)
    if (sequencer_running == true) then
      draw_current_note(sequencestep)
    else
      screen.level(15)
      screen.move(65,63)
      screen.text("Paused")
    end
    screen.level(15)
    draw_cells()
    draw_mod_controls()
    draw_cell(sequencestep,15,2)
    draw_cell(params:get("editcell"),15,4)
    draw_seq_values(sequencestep)
  end
  screen.update()
end  


function draw_mod_controls()
    for index=1,8 do
      draw_a_h_mod_control(index,mod_control[index])
      draw_a_v_mod_control(9-index,mod_control[index+8])
    end
end


function draw_a_h_mod_control(x,value)
  dx = ((x-1) * 7) + 1
  dy = 59
  if (params:get("editmod") == x) then
    screen.level(14)
    screen.move(dx-1,dy+4)
    screen.line(dx+5,dy+4)  
    screen.stroke()
  end
  screen.level(9) 
 if (value == 0) then screen.level(1) end
  screen.rect(dx,dy,5,2)
  screen.stroke()
end


function draw_a_v_mod_control(x,value)
  dy = ((x-1) * 7) + 1
  dx = 59
  if (params:get("editmod") == (17 - x)) then
    screen.level(14)
    screen.move(dx+4,dy-1)
    screen.line(dx+4,dy+5)  
    screen.stroke()
  end
  screen.level(9)
  if (value == 0) then screen.level(1) end
  screen.rect(dx,dy,2,5)
  screen.stroke()
end


function draw_a_v_mod_control2(x,value)
  if (params:get("editmod") == (17 - x)) then
    screen.level(15)
  else
    screen.level(7)
  end
  dx = 59 
  dy = ((x-1) * 7) + 1
  screen.rect(dx,dy,2,5)
  screen.stroke()
  if (value == "0") then 
    screen.level(1) 
  else
    screen.level(7) 
  end
  screen.move(dx+1,dy)
  screen.line(dx+1,dy+4)  
  screen.stroke()
end


function draw_a_cell(x,y,value,size,chance)
  screen.level(value)
  dx = ((x-1) * 7) +1
  dy = ((y-1) * 7) +1
  if (size == 6) then
    screen.rect(dx,dy,5,5)
    screen.stroke()
    if (chance < 100) then
      screen.level(0)
      screen.pixel(dx-1,dy-1)
      screen.pixel(dx-1,dy+4)
      screen.pixel(dx+4,dy-1)
      screen.pixel(dx+4,dy+4)
      screen.fill()
      screen.stroke()
    end
  end
  if (size == 4) then
    screen.rect(dx+1,dy+1,3,3)
  end
  if (size == 2) then
    screen.rect(dx+2,dy+2,1,1)
  end
  screen.stroke()
  if ((value==2) or (value == 13)) then 
    screen.level(0)
    screen.move(dx+1,dy)
    screen.line(dx+3,dy)
    screen.move(dx+1,dy+5)
    screen.line(dx+3,dy+5)
    screen.move(dx,dy+1)
    screen.line(dx,dy+3)
    screen.move(dx+5,dy+1)
    screen.line(dx+5,dy+3)
    screen.stroke()
  end
end

function audio_sound_init()
	audio.level_cut(1.0)
	audio.level_adc_cut(1)
	audio.level_eng_cut(1)
end