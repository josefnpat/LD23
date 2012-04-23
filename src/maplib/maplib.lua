maplib = {}

maplib.map = {}

math.randomseed( os.time() )

maplib.tiles = love.graphics.newImage("maplib/tilesheet.png")
maplib.tiles:setFilter("nearest","nearest")

maplib.quads = {}
maplib.quads[1] = love.graphics.newQuad(0,0,32,32,maplib.tiles:getWidth(),maplib.tiles:getHeight())

maplib.block_width, maplib.block_depth = 32,16

function maplib.load()
  maplib.grid_x,maplib.grid_y = 0,0

  maplib.scale = 1

  maplib.screenx,maplib.screeny = love.graphics.getWidth(),love.graphics.getHeight()
  maplib.offsetx,maplib.offsety = 0,0
end


maplib.curworld = 1
maplib.worlds = {}
for mapid = 1,8 do
  maplib.worlds[mapid] =  love.graphics.newImage("maplib/world"..mapid..".gif")
end


function maplib.drawunit(img,quad,x,y)
  xout = (16 * (x-y) + maplib.grid_x*32) + maplib.offsetx
  yout = (8 * (y+x) + maplib.grid_y*16) + maplib.offsety
  
  xout = xout * maplib.scale
  yout = yout * maplib.scale
  love.graphics.drawq(img,quad,xout,yout,0,maplib.scale,maplib.scale)
  love.graphics.setColor(255,0,0)
  love.graphics.point(love.graphics.getWidth()-200+x,y)
  love.graphics.setColor(255,255,255)
  
  return xout,yout
end


function maplib.draw()

  local xout,yout
  
  for x,v in pairs(maplib.map) do
    for y,color in pairs(v) do
      xout = (16 * (x-y) + maplib.grid_x*32) + maplib.offsetx
      yout = (8 * (y+x) + maplib.grid_y*16) + maplib.offsety
      
      xout = xout * maplib.scale
      yout = yout * maplib.scale
      
      --mouse
      local mx,my = love.mouse.getPosition()
      mx = mx - 48
      my = my - 48
      if mx < xout + 8*maplib.scale and mx > xout - 8*maplib.scale and my < yout + 4*maplib.scale and my > yout - 4*maplib.scale then
        maplib.cursor_x = x
        maplib.cursor_y = y
      end
      
      t_color = {}

      t_color[1] = color[1]
      t_color[2] = color[2]
      t_color[3] = color[3]
      --cursor
      local tile_alpha = 255
      if maplib.cursor_x == x and maplib.cursor_y == y then 
        if maplib.cursor_blink % 1 > 0.5 then
          tile_alpha = 127
        else
          tile_alpha = 192
        end
        -- invalid placement
        if color[3] > 64 then
          t_color[1] = 255
          t_color[2] = 0
          t_color[3] = 0
        else
          t_color[1] = 0
          t_color[2] = 255
          t_color[3] = 0
        end
      end
      
      if gamelib.unitselect== 5 and gamelib.dist(maplib.cursor_x,maplib.cursor_y,x,y) <= 10 then
        tile_alpha = tile_alpha / 2
      end
      
      
      if xout > maplib.screenx and yout > maplib.screeny then
        break
      end
      
      if xout > -32*maplib.scale + maplib.offsetx and xout < maplib.screenx + maplib.offsetx and yout > -32*maplib.scale + maplib.offsety and yout < maplib.screeny-16*maplib.scale + maplib.offsety then
        love.graphics.setColor(t_color[1],t_color[2],t_color[3],tile_alpha)
        love.graphics.drawq(maplib.tiles,maplib.quads[1],xout,yout,0,maplib.scale,maplib.scale)
  love.graphics.setColor(255,255,255)
          --love.graphics.print(x..","..y,xout+8*maplib.scale,yout+16*maplib.scale)
          --love.graphics.print(color[3],xout+8*maplib.scale,yout+16*maplib.scale)
      end
    end
  end
  love.graphics.setColor(255,255,255)
  love.graphics.rectangle("line",maplib.offsetx,maplib.offsety,maplib.screenx,maplib.screeny)--debug
  love.graphics.draw(maplib.worlds[maplib.curworld],love.graphics.getWidth()-200,0)
  love.graphics.setColor(255,0,0,127)
  love.graphics.circle("line",love.graphics.getWidth()-200+maplib.cursor_x,maplib.cursor_y,(9-maplib.scale))
  love.graphics.setColor(255,255,255)
end

function maplib.loadmap(mapid)
  local source = love.image.newImageData("maplib/world"..mapid..".gif")
  local w, h = source:getWidth(), source:getHeight()
  maplib.grid_size = w
  maplib.curworld = mapid
  for x = 1,w do
    for y = 1,h do
      if not maplib.map[x] then
        maplib.map[x] = {}
      end
      local r,g,b,a = source:getPixel( x-1, y-1 )
      maplib.map[x][y] = {r,g,b}
    end
  end
end

maplib.cursor_blink = 0
maplib.cursor_x = 1
maplib.cursor_y = 1

function maplib.update(dt)
  maplib.cursor_blink = maplib.cursor_blink + dt
  local modx,mody = 0,0
  local speed = 17-maplib.scale*2
  if love.keyboard.isDown("up") then
    mody = speed
  end
  if love.keyboard.isDown("down") then
    mody = -speed
  end
  if love.keyboard.isDown("left") then
    modx = speed
  end
  if love.keyboard.isDown("right") then
    modx = -speed
  end
  maplib.grid_x = maplib.grid_x + modx*dt*maplib.scale
  maplib.grid_y = maplib.grid_y + mody*dt*maplib.scale
end

function maplib.mousepressed(x,y,button)
  if button == "wd" then
    if maplib.scale - 1 >= 1 then
      maplib.scale = maplib.scale - 1
    end
  elseif button == "wu" then
    if maplib.scale + 1 <= 8 then
      maplib.scale = maplib.scale + 1
    end
  end
end

return maplib
