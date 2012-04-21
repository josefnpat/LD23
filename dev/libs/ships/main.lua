shipslib = require("shipslib/shipslib")

function love.load (arg)
  shipslib.load()
  love.keypressed()
end

temp_dt = 0
mod_r = 0
mod_speed = 0
mod_hp = 0
function love.update (dt)
  temp_dt = temp_dt + dt
  if temp_dt > 0.1 then
  
    mod_r = mod_r + 1/180
    mod_speed = mod_speed + 1
    mod_hp = mod_hp + 1
    
  end
  shipslib.update(dt)
end

function love.draw ()
  local temp_r,temp_speed,temp_hp
  for i,v in ipairs(ships) do
    temp_r,temp_speed,temp_hp = v.r,v.speed,v.hp
    
    v.r = v.r + mod_r
    v.speed = (v.speed + mod_speed)%101
    v.hp = (v.hp + mod_hp)%101
    
    shipslib.draw(v)
    
    v.r,v.speed,v.hp = temp_r,temp_speed,temp_hp
  end
end

function love.keypressed (key,unicode)
  ships = {}
  local temp
  local x = 8
  local y = 6
  
  for i = 1, x do
    for j = 1,y do
      temp = {}
      temp.type = shipslib.ships[math.random(1,12)]
      temp.x = love.graphics.getWidth()*i/(x+1)
      temp.y = love.graphics.getHeight()*j/(y+1)
      temp.r = math.random(1,360)*180/math.pi
      temp.speed = math.random(0,100)
      temp.speed_max = 100
      temp.hp = math.random(0,100)
      temp.hp_max = 100
      
      table.insert(ships,temp)
    end
  end
  shipslib.scale = 2
end

function love.mousepressed(x,y,button)
  if button == "wd" then
    shipslib.scale = shipslib.scale - 0.1
  elseif button == "wu" then
    shipslib.scale = shipslib.scale + 0.1
  end
end
