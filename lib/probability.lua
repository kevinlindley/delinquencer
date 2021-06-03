-- Version  : 1.0.0
-- Author   : Kevin Lindley
-- Date     : 2021-04-29
-- Filename : probability.lua

function build_default_probgrid()
  for index=1,64 do
    probgrid[index] = 1
  end
end


function prob_result(p_index)
  local mresult = 0
  local actual_prob = math.random(1,100)
  local cell_prob = cells[p_index][5]
  if (actual_prob <= cell_prob) then mresult = 1 end
  return mresult
end


function build_probgrid()
  build_default_probgrid()
  for mindex=1,64 do
    local result = prob_result(mindex)
    probgrid[mindex] = result
  end
end


function print_cellprobgrid()
  for row=1,8 do
    rowstring = ""
    for col=1,8 do
      index = ((row-1)*8) +col
      rowstring = rowstring .. tostring(cells[index][5])
    end
    print(rowstring)
  end
end