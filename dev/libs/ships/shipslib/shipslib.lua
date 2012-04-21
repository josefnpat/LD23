shipslib = {}

-------------------------------------
-- shipslib.load
-------------------------------------
function shipslib.load()
  math.randomseed(os.time())
  
  shipslib.img_ships = love.graphics.newImage("shipslib/ships.gif")
  shipslib.img_ships:setFilter("nearest","nearest")
  shipslib.img_effects = love.graphics.newImage("shipslib/effects.gif")
  shipslib.img_effects:setFilter("nearest","nearest")
  
  shipslib.imgdata_effects = love.image.newImageData("shipslib/effects.gif")
  
  shipslib.ships = {}
  
  local temp
  for i=1,4 do
    --print("Building ship "..((i-1)*3+1).."/12");
    table.insert(shipslib.ships,build_ship(0,4*2^i,4*2^i))
    --print("Building ship "..((i-1)*3+2).."/12");
    table.insert(shipslib.ships,build_ship(4*2^i,0,4*2^i))
    --print("Building ship "..((i-1)*3+3).."/12");
    table.insert(shipslib.ships,build_ship(4*2^i,4*2^i,4*2^i))
  end
  --print("Done")
  shipslib.scale = 1
  shipslib.trail_dt = 0
  shipslib.trail_perc = 0
end

function build_ship(x,y,size)
  local trail_length = size/2
  local temp
  temp = {}
  temp.size = size
  temp.quad = love.graphics.newQuad(x,y,size,size,128,128)
  local tempimg
  
  --engine
  local blue = {r=0,g=0,b=255}
  temp.effect_engine = find_color(shipslib.imgdata_effects,x,y,size,size,blue)
  temp.effect_engine_sprite = {}
  
  for i = 1,trail_length do
    tempimg = love.image.newImageData(size,size+trail_length)
    for eexi,eexv in pairs(temp.effect_engine) do
      for eeyi,_ in pairs(eexv) do
        for j = 1,i do
          tempimg:setPixel(eexi-x,eeyi-y+j,
            math.sin(j/i)*127,
            math.sin(j/i)*127,
            255,
            255-500/size*j)
          tempimg:setPixel(eexi-x,eeyi-y+j,
            math.sin(j/i)*127,
            math.sin(j/i)*127,
            255,
            255-500/size*j)
        end
      end
    end
    temp.effect_engine_sprite[i] = love.graphics.newImage(tempimg)
    temp.effect_engine_sprite[i]:setFilter("nearest","nearest")
  end
  
  --weapon
  local red = {r=255,g=0,b=0}
  temp.effect_weapons = find_color(shipslib.imgdata_effects,x,y,size,size,red)
  temp.effect_weapons_sprite = {}
  
  tempimg = love.image.newImageData(size,size+trail_length)
  for eexi,eexv in pairs(temp.effect_weapons) do
    for eeyi,_ in pairs(eexv) do
      for j = 1,size/4 do
        tempimg:setPixel(eexi-x,eeyi-y+j,
          255,
          0,
          0,
          255-512/size*j)
      end
    end
  end
  temp.effect_weapons_sprite[1] = love.graphics.newImage(tempimg)
  temp.effect_weapons_sprite[1]:setFilter("nearest","nearest")
  
  --damage
  local green = {r=0,g=255,b=0}
  temp.effect_damages = find_color(shipslib.imgdata_effects,x,y,size,size,green)
  temp.effect_damages_sprite = {}
  
  local whiteness
  
  for i = 1,16 do
    tempimg = love.image.newImageData(size*2,size+trail_length)
    for eexi,eexv in pairs(temp.effect_damages) do
      for eeyi,_ in pairs(eexv) do
        for j = 1,size/4 do
          whiteness = math.random(1,255)
          tempimg:setPixel(eexi-x+math.random(-1,1)+size/2,eeyi-y+j,
            255,
            whiteness/2,
            0,
            255-512/size*j)
        end
      end
    end
    temp.effect_damages_sprite[i] = love.graphics.newImage(tempimg)
    temp.effect_damages_sprite[i]:setFilter("nearest","nearest")
  end
  
  return temp
end

function find_color(img,ix,iy,iw,ih,color)
  local r, g, b, a
  local results = {}
  for x = ix,ix+iw-1 do
    for y = iy,iy+ih-1 do
      r,g,b,a = img:getPixel(x,y)
      if color.r == r and color.g == g and color.b == b then
        if not results[x] then
          results[x] = {}
        end
        results[x][y] = true
      end
    end
  end
  return results
end



function shipslib.draw(ent)
  -- ENGINE TRAIL
  local engine_index = math.floor(ent.speed/ent.speed_max*(ent.type.size/2-1))+1
  love.graphics.draw(ent.type.effect_engine_sprite[engine_index],
    ent.x,ent.y,ent.r,shipslib.scale,shipslib.scale,ent.type.size/2,ent.type.size/2)
  -- SHIP
  love.graphics.drawq(shipslib.img_ships,ent.type.quad,ent.x,ent.y,ent.r,shipslib.scale,shipslib.scale,ent.type.size/2,ent.type.size/2)
  -- DAMAGE
  love.graphics.setColor(255,255,255,255*(ent.hp_max-ent.hp)/ent.hp_max)
  local damage_index = math.floor(shipslib.trail_perc/100*16)+1
  love.graphics.draw(ent.type.effect_damages_sprite[damage_index],
    ent.x,ent.y,ent.r,shipslib.scale,shipslib.scale,ent.type.size,ent.type.size/2)
  love.graphics.setColor(255,255,255,255)
  
  -- WEAPON PREVIEW DEBUG
  --love.graphics.draw(ent.type.effect_weapons_sprite[1],
  --  ent.x,ent.y - shipslib.trail_perc*10 ,ent.r,shipslib.scale,shipslib.scale,ent.type.size/2,ent.type.size/2)
  -- EFFECTS PREVIEW DEBUG
  --love.graphics.drawq(shipslib.img_effects,ent.type.quad,ent.x,ent.y,ent.r,shipslib.scale,shipslib.scale,ent.type.size/2,ent.type.size/2)
  -- PROXIMITY DEBUG
  --love.graphics.circle("line", ent.x, ent.y, ent.type.size*shipslib.scale/2,32 )--DEBUG
end

-------------------------------------
-- shipslib.update
-------------------------------------
function shipslib.update (dt)
  shipslib.trail_dt = shipslib.trail_dt + dt
  if shipslib.trail_dt >= 0.01 then
    shipslib.trail_perc = shipslib.trail_perc + 1
    if shipslib.trail_perc >= 100 then
      shipslib.trail_perc = 0
    end
  end
end

return shipslib
