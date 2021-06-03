-- Version  : 2.0.0
-- Author   : Kevin Lindley
-- Date     : 2021-04-29
-- Filename : seq_patterns.lua

function table_reverse(tab)
  local newtable = { }
  for index=1,64 do
    newtable[index] = tab[64-(index-1)]
  end
  return newtable
end


function table_rotate(tab)
  local newtable = { }
  local lookup = {8,16,24,32,40,48,56,64,
                  7,15,23,31,39,47,55,63,
                  6,14,22,30,38,46,54,62,
                  5,13,21,29,37,45,53,61, 
                  4,12,20,28,36,44,52,60,
                  3,11,19,27,35,43,51,59,
                  2,10,18,26,34,42,50,58,
                  1, 9,17,25,33,41,49,57 }
  for index=1,64 do
    newtable[index] = tab[lookup[index]]
  end
  return newtable
end


seq_pattern_names = {"Forward","Back","Rain","Dust",
                    "DownUp","DownUpR","Zipper","ZipperR",
                    "Snake","SnakeR","Frog","FrogR",
                    "Spiral","SpiralR","LR","LRB",
                    "Blocks","BlocksR","Goat","GoatR",
                    "Knight","KnightR"
}


seq_pattern_data = {}

--Forward
seq_pattern_data[1]  = { 1, 2, 3, 4, 5, 6, 7, 8,
                         9,10,11,12,13,14,15,16,
                        17,18,19,20,21,22,23,24,
                        25,26,27,28,29,30,31,32,
                        33,34,35,36,37,38,39,40,
                        41,42,43,44,45,46,47,48,
                        49,50,51,52,53,54,55,56,
                        57,58,59,60,61,62,63,64}

--Backwards
seq_pattern_data[2]  = table_reverse(seq_pattern_data[1])

--Rain
seq_pattern_data[3]  = table_rotate(seq_pattern_data[1])

--Dust
seq_pattern_data[4]  = table_reverse(table_rotate(seq_pattern_data[1]))

--DownUp
seq_pattern_data[5]  =  { 1, 9,17,25,33,41,49,57,
                        58,50,42,34,26,18,10, 2,
                         3,11,19,27,35,43,51,59,
                        60,52,44,36,28,20,12, 4,
                         5,13,21,29,37,45,53,61,
                        62,54,46,38,30,22,14, 6,
                         7,15,23,31,39,47,55,63,
                        64,56,48,40,32,24,16, 8 }

--DownUpR
seq_pattern_data[6]  = table_reverse(seq_pattern_data[5])

--Zipper
seq_pattern_data[7]  = table_rotate(seq_pattern_data[5])

--ZipperR
seq_pattern_data[8]  = table_reverse(table_rotate(seq_pattern_data[5]))                      

--Snake
seq_pattern_data[9]  = { 1, 2, 9,17,10, 3, 4,11,
                        18,25,33,26,19,12, 5, 6,
                        13,20,27,34,41,49,42,35,
                        28,21,14, 7, 8,15,22,29,
                        36,43,50,57,58,51,44,37,
                        30,23,16,24,31,38,45,52,
                        59,60,53,46,39,32,40,47,
                        54,61,62,55,48,56,63,64 }

--SnakeR
seq_pattern_data[10] = table_reverse(seq_pattern_data[9])

--Frog
seq_pattern_data[11] = table_rotate(seq_pattern_data[9])

--FrogR
seq_pattern_data[12] = table_reverse(table_rotate(seq_pattern_data[9]))

--Spiral
seq_pattern_data[13] = { 1, 2, 3, 4, 5, 6, 7, 8,
                        16,24,32,40,48,56,64,63,
                        62,61,60,59,58,57,49,41,
                        33,25,17, 9,10,11,12,13,
                        14,15,23,31,39,47,55,54,
                        53,52,51,50,42,34,26,18,
                        19,20,21,22,30,38,46,45,
                        44,43,28,29,37,45,44,36 }

--SpiralR
seq_pattern_data[14] = table_reverse(seq_pattern_data[13])

--LR
seq_pattern_data[15] = { 1, 2, 3, 4, 5, 6, 7, 8,
                        16,15,14,13,12,11,10,	9,
                        17,18,19,20,21,22,23,24,
                        32,31,30,29,28,27,26,25,
                        33,34,35,36,37,38,39,40,
                        48,47,46,45,44,43,42,41,
                        49,50,51,52,53,54,55,56,
                        64,63,62,61,60,59,58,57 }

--LRB
seq_pattern_data[16] = table_reverse(seq_pattern_data[15])

--Blocks
seq_pattern_data[17] = { 1,2 , 3,	4, 9,10,11,12,
                        17,18,19,20,25,26,27,28,
                         5, 6, 7, 8,13,14,15,16,
                        21,22,23,24,29,30,31,32,
                        33,34,35,36,41,42,43,44,
                        49,50,51,52,57,58,59,60,
                        37,38,39,40,45,46,47,48,
                        53,54,55,56,61,62,63,64 }

--BlocksR
seq_pattern_data[18] = table_reverse(seq_pattern_data[17])

--Goat
seq_pattern_data[19] = table_rotate(seq_pattern_data[18])

--GoatR
seq_pattern_data[20] = table_reverse(table_rotate(seq_pattern_data[18]))

seq_pattern_data[21] = {36,30,20,	5,11, 1,18,33,
                        50,60,54,64,47,32,15,21,
                         6,12, 2,17,34,49,59,53,
                        63,48,38,44,27,37,43,28,
                        45,35,29,19, 4,10,25,42,
                        57,51,61,55,40,23, 8,14,
                        24,39,56,62,52,58,41,26,
                         9, 3,13, 7,22,16,31,46 }
seq_pattern_data[22] = table_reverse(seq_pattern_data[21])

scale_short_names = {}

scale_short_names[ 1]="Major "
scale_short_names[ 2]="Natur.m"
scale_short_names[ 3]="Harmo.m"
scale_short_names[ 4]="Melodi.m"
scale_short_names[ 5]="Dorian "
scale_short_names[ 6]="Phrygia."
scale_short_names[ 7]="Lydian  "
scale_short_names[ 8]="Mixolyd."
scale_short_names[ 9]="Locrian "
scale_short_names[10]="WholeTo."
scale_short_names[11]="M Pent."
scale_short_names[12]="m Pent."
scale_short_names[13]="M Bebo."
scale_short_names[14]="Altered "
scale_short_names[15]="DorianB."
scale_short_names[16]="Mixoly.B."
scale_short_names[17]="Blues   "
scale_short_names[18]="DimWhHa"
scale_short_names[19]="DimHaWh"
scale_short_names[20]="M Neap."
scale_short_names[21]="M Hung."
scale_short_names[22]="M Harm."
scale_short_names[23]="m Hung."
scale_short_names[24]="m Lydia."
scale_short_names[25]="m Neap."
scale_short_names[26]="M Locri."
scale_short_names[27]="Lead.Wh."
scale_short_names[28]="6 ToneS."
scale_short_names[29]="Balinese"
scale_short_names[30]="Persian"
scale_short_names[31]="E Indian"
scale_short_names[32]="Oriental"
scale_short_names[33]="x2 Harm"
scale_short_names[34]="Enigmat."
scale_short_names[35]="Overto. "
scale_short_names[36]="8TSpani."
scale_short_names[37]="Promet.."
scale_short_names[38]="Gagaku."
scale_short_names[39]="In sen ."
scale_short_names[40]="Okinawa"
scale_short_names[41]="Chromat."
