gamelib = {}

gamelib.cash = 100
gamelib.units = {}
function gamelib.draw()
  for y = 1,100 do
    for x = 1,200 do
      if gamelib.units[y] and gamelib.units[y][x] then
        local xout,youy = maplib.drawunit(units.img,units.quad[gamelib.units[y][x].type],x,y)
        barlib.draw(xout,youy, gamelib.units[y][x].hp * maplib.scale / gamelib.units[y][x].hp_max * 8 , 8 * maplib.scale )
      end
    end
  end
end

function gamelib.mousepressed(x,y,button)
  if button == "l" then
    local valid = true
    if gamelib.units[maplib.cursor_y] then
      if gamelib.units[maplib.cursor_y][maplib.cursor_x] then
        valid = false
      end
    else
      gamelib.units[maplib.cursor_y] = {}
    end
    if valid and maplib.map[maplib.cursor_x][maplib.cursor_y][3]<=64 then
      local unit = {}
      unit.hp = 100
      unit.hp_max = 100
      unit.owner = true
      unit.type = gamelib.unitselect
      gamelib.units[maplib.cursor_y][maplib.cursor_x] = unit
    end
  end
end

gamelib.unitselect = 1
gamelib.unit_name = {}
gamelib.unit_name[1] = "Resource Storage"
gamelib.unit_name[2] = "Resource Factory"
gamelib.unit_name[3] = "Research Facility"
gamelib.unit_name[4] = "Attack Tower"

gamelib.unit_cost = {}
gamelib.unit_cost[1] = 10
gamelib.unit_cost[2] = 20
gamelib.unit_cost[3] = 30
gamelib.unit_cost[4] = 40

function gamelib.keyboardpressed(key,uni)
  if key == "1" then
    gamelib.unitselect = 1
  elseif key == "2" then
    gamelib.unitselect = 2
  elseif key == "3" then
    gamelib.unitselect = 3
  elseif key == "4" then
    gamelib.unitselect = 4
  end
end

return gamelib
