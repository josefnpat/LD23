gamelib = {}

function gamelib.load()
  gamelib.cash = 1000
  gamelib.enemy_cash = 1000
  gamelib.research_level = 0
  gamelib.enemy_research_level = 0
  gamelib.units = {}
  
  gamelib.tick_dt = 0
  gamelib.cash_max = 1000
  gamelib.enemy_cash_max = 1000

  gamelib.start = true  
end

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
        if gamelib.units[y][x].hp_max ~= gamelib.units[y][x].hp then
          barlib.draw(xout,youy, gamelib.units[y][x].hp * maplib.scale / gamelib.units[y][x].hp_max * 8 -1 , 8 * maplib.scale-1 )
        end
      end
    end
  end
  love.graphics.setColor(255,255,255)
end

function gamelib.mousepressed(x,y,button)
  if button == "l" then
    local valid
    valid = gamelib.build(maplib.cursor_x,maplib.cursor_y,true,gamelib.unitselect)
    if valid then
      gamelib.start = false
    end
  end
end

function gamelib.build(cx,cy,owner,select)
  local valid = true
  if gamelib.units[cy] then
    if gamelib.units[cy][cx] then
      valid = false
    end
  else
    gamelib.units[cy] = {}
  end
  if owner then
    if gamelib.cash < gamelib.unit_cost[select] then
      valid = false
    end
  else
    if gamelib.enemy_cash < gamelib.unit_cost[select] then
      valid = false
    end
  end
  
  local valid_range = false
  if select == 5 then
    valid_range = true
  else
    for x,v in pairs(gamelib.units) do
      for y,unit in pairs(v) do
        if owner then
          if unit.owner and unit.type == 5 and gamelib.dist(x,y,cy,cx) <= 10 then
            valid_range = true
          end
        else
          if not unit.owner and unit.type == 5 and gamelib.dist(x,y,cy,cx) <= 10 then
            valid_range = true
          end
        end
      end
    end
  end
  if valid_range and valid and maplib.map[cx][cy][3]<=64 then
    local unit = {}
    unit.hp = gamelib.unit_hp[select]
    unit.hp_max = gamelib.unit_hp[select]
    unit.owner = owner
    unit.type = select
    gamelib.units[cy][cx] = unit
    if owner then
      gamelib.cash = gamelib.cash - gamelib.unit_cost[select] 
    else
      gamelib.enemy_cash = gamelib.enemy_cash - gamelib.unit_cost[select] 
    end
    return true
  end
end

function gamelib.dist(x1,y1,x2,y2)
  return math.sqrt((x1-x2)^2+(y1-y2)^2)
end

catz = false
function gamelib.update(dt)

  gamelib.tick_dt = gamelib.tick_dt + dt
  if gamelib.tick_dt > 0.1 then
    gamelib.tick_dt =  gamelib.tick_dt - 0.1
    
    for x,v in pairs(gamelib.units) do
      for y,unit in pairs(v) do
        if unit.type == 4 then
          
          local done = false
          for cx,cv in pairs(gamelib.units) do
            if done then break end
            for cy,cunit in pairs(cv) do
              if done then break end
              if (cunit.owner and not unit.owner) or (not cunit.owner and unit.owner) then --if other entity
                if gamelib.dist(x,y,cx,cy) < 12 then
                  if unit.owner then
                    cunit.hp = cunit.hp - 1-1*gamelib.research_level/100
                  else
                    cunit.hp = cunit.hp - 1-1*gamelib.enemy_research_level/100
                  end
                  if cunit.hp < 0 then
                    gamelib.units[cx][cy] = nil
                  end
                  done = true
                end
              end
            end
          end
          
        end
      end
    end

    -- check game units
    count = {}
    count[1],count[2],count[3],count[4],count[5] = 0,0,0,0,0
    enemy_count = {}
    enemy_count[1],enemy_count[2],enemy_count[3],enemy_count[4],enemy_count[5] = 0,0,0,0,0
    for x,v in pairs(gamelib.units) do
      for y,unit in pairs(v) do
        if unit.owner then
          count[unit.type] = count[unit.type] + 1
        else
          enemy_count[unit.type] = enemy_count[unit.type] + 1
        end
      end
    end
    
    if count[1]+count[2]+count[3]+count[4]+count[5] <= 0 and not gamelib.start then
      toggle_winlose = "defeat"
    end
    
    if enemy_count[1]+enemy_count[2]+enemy_count[3]+enemy_count[4]+enemy_count[5] <= 0 and not gamelib.start then
      toggle_winlose = "victory"
      if not catz then
        catz = true
        local temp = {t="Meow?",cb="cat"}
        table.insert(menu_view[5],temp)
      end
    end
    
    -- enemy play
    
    local tobuild = 2
    if enemy_count[5] == 0 then
      tobuild = 5
    else
      if enemy_count[1]+enemy_count[2]+enemy_count[3]+enemy_count[4] > 25*enemy_count[5] then
        tobuild = 5
      else
        if gamelib.enemy_cash/gamelib.enemy_cash_max < 0.5 then
          tobuild = 2
        else
          if enemy_count[1] < 10*enemy_count[5] then
            tobuild = 1
          else
            if gamelib.enemy_cash > gamelib.unit_cost[3] then
              tobuild = 3
            else
              tobuild = 4
            end
          end
        end
      end
    end
    
    local timeout = 100
    local built = false
    while not built do
      built = gamelib.build(math.random(1,200),math.random(1,100),false,tobuild)
      timeout = timeout - 1
      if timeout <= 0 then
        break
      end
    end
    
--    print(tobuild,enemy_count[1],enemy_count[2],enemy_count[3],enemy_count[4],enemy_count[5])--ai debug

    gamelib.research_level = count[3]
    gamelib.enemy_research_level = enemy_count[3]

    gamelib.cash_max = 1000 + 100 * count[1]
    gamelib.cash = gamelib.cash + 1 * count[2]
    if gamelib.cash > gamelib.cash_max then
      gamelib.cash = gamelib.cash_max
    end
    
    gamelib.enemy_cash_max = 1000 + 10 * enemy_count[1]
    gamelib.enemy_cash = gamelib.enemy_cash + 1 * enemy_count[2]
    if gamelib.enemy_cash > gamelib.enemy_cash_max then
      gamelib.enemy_cash = gamelib.enemy_cash_max
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
gamelib.unit_cost[1] = 200
gamelib.unit_cost[2] = 50
gamelib.unit_cost[3] = 2000
gamelib.unit_cost[4] = 250
gamelib.unit_cost[5] = 500

gamelib.unit_hp = {}
gamelib.unit_hp[1] = 10
gamelib.unit_hp[2] = 20
gamelib.unit_hp[3] = 40
gamelib.unit_hp[4] = 10
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
