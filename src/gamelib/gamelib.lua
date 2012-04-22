gamelib = {}

gamelib.cash = 100
gamelib.units = {}
function gamelib.draw()
  for y = 1,100 do
    for x = 1,200 do
      if gamelib.units[y] and gamelib.units[y][x] then
        if gamelib.units[y][x].owner then
          love.graphics.setColor(127,255,127)
        else
          love.graphics.setColor(255,127,127)
        end
        local xout,youy = maplib.drawunit(units.img,units.quad[gamelib.units[y][x].type],x,y)
        barlib.draw(xout,youy, gamelib.units[y][x].hp * maplib.scale / gamelib.units[y][x].hp_max * 8 -1 , 8 * maplib.scale-1 )
      end
    end
  end
  love.graphics.setColor(255,255,255)
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
    if gamelib.cash < gamelib.unit_cost[gamelib.unitselect] then
      valid = false
    end
    
    local valid_range = false
    if gamelib.unitselect == 5 then
      valid_range = true
    else
      for x,v in pairs(gamelib.units) do
        for y,unit in pairs(v) do
          if unit.owner and unit.type == 5 and gamelib.dist(x,y,maplib.cursor_y,maplib.cursor_x) <= 10 then
            valid_range = true
          end
        end
      end
    end
    
    if valid_range and valid and maplib.map[maplib.cursor_x][maplib.cursor_y][3]<=64 then
      local unit = {}
      unit.hp = gamelib.unit_hp[gamelib.unitselect]
      unit.hp_max = gamelib.unit_hp[gamelib.unitselect]
      unit.owner = true
      unit.type = gamelib.unitselect
      gamelib.units[maplib.cursor_y][maplib.cursor_x] = unit
      gamelib.cash = gamelib.cash - gamelib.unit_cost[gamelib.unitselect] 
    end
  end
end

function gamelib.dist(x1,y1,x2,y2)
  return math.sqrt((x1-x2)^2+(y1-y2)^2)
end

gamelib.tick_dt = 0
gamelib.cash_max = 100
function gamelib.update(dt)
  gamelib.tick_dt = gamelib.tick_dt + dt
  if gamelib.tick_dt > 0.12 then
    gamelib.tick_dt =  gamelib.tick_dt - 0.1
    count = {}
    count[1],count[2],count[3],count[4],count[5] = 0,0,0,0,0
    for x,v in pairs(gamelib.units) do
      for y,unit in pairs(v) do
        count[unit.type] = count[unit.type] + 1
      end
    end

    gamelib.cash_max = 100 + 1000 * count[1]
    gamelib.cash = gamelib.cash + 1 * count[2]
    if gamelib.cash > gamelib.cash_max then
      gamelib.cash = gamelib.cash_max
    end
  end
end

gamelib.unitselect = 1
gamelib.unit_name = {}
gamelib.unit_name[1] = "Resource Storage"
gamelib.unit_name[2] = "Resource Factory"
gamelib.unit_name[3] = "Research Facility"
gamelib.unit_name[4] = "Attack Tower"
gamelib.unit_name[5] = "Territory Flag"

gamelib.unit_cost = {}
gamelib.unit_cost[1] = 10
gamelib.unit_cost[2] = 20
gamelib.unit_cost[3] = 30
gamelib.unit_cost[4] = 40
gamelib.unit_cost[5] = 50

gamelib.unit_hp = {}
gamelib.unit_hp[1] = 10
gamelib.unit_hp[2] = 20
gamelib.unit_hp[3] = 30
gamelib.unit_hp[4] = 40
gamelib.unit_hp[5] = 50


function gamelib.keyboardpressed(key,uni)
  if key == "1" then
    gamelib.unitselect = 1
  elseif key == "2" then
    gamelib.unitselect = 2
  elseif key == "3" then
    gamelib.unitselect = 3
  elseif key == "4" then
    gamelib.unitselect = 4
  elseif key == "5" then
    gamelib.unitselect = 5
  end
end

return gamelib
