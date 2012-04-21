maplib = {}

maplib.map = {}

math.randomseed( os.time() )

maplib.tiles = love.graphics.newImage("maplib/tilesheet.png")
maplib.tiles:setFilter("nearest","nearest")

maplib.quads = {}
maplib.quads[1] = love.graphics.newQuad(0,0,32,32,maplib.tiles:getWidth(),maplib.tiles:getHeight())

maplib.block_width, maplib.block_depth = 32,16
maplib.grid_x,maplib.grid_y = 0,0

maplib.scale = 1

function maplib.draw_unit()

end

function maplib.draw()
  local screenx,screeny = 1280-200,1024-200
  local offsetx,offsety = 100,100
  local xout,yout
  
  for x,v in pairs(maplib.map) do
    for y,color in pairs(v) do
      xout = (16 * (x-y) + maplib.grid_x*32) + offsetx
      yout = (8 * (y+x) + maplib.grid_y*16) + offsety
      
      xout = xout * maplib.scale
      yout = yout * maplib.scale
      
      if xout > -32*maplib.scale + offsetx and xout < screenx + offsetx and yout > -32*maplib.scale + offsety and yout < screeny-16*maplib.scale + offsety then
        love.graphics.setColor(color[1],color[2],color[3])
        love.graphics.drawq(maplib.tiles,maplib.quads[1],xout,yout,0,maplib.scale,maplib.scale)
  love.graphics.setColor(255,255,255)
          --love.graphics.print(x..","..y,xout+8*maplib.scale,yout+16*maplib.scale)
      end
    end
  end
  love.graphics.setColor(255,255,255)
  love.graphics.rectangle("line",offsetx,offsety,screenx,screeny)
  love.graphics.print("vx:"..(maplib.grid_x).." vy:"..(maplib.grid_y),0,16)
  
  
  local mx,my = love.mouse.getPosition()
  
  local rmx = math.floor((mx+((my)-mx/2))/32*maplib.scale+0.5)
  local rmy = math.floor((((my)-mx/2))/16*maplib.scale+0.5)
  love.graphics.print("rmx:"..(rmx).." rmy:"..(rmy),0,32)
end

function maplib.loadmap(mapid)
  local source = love.image.newImageData("maplib/world"..mapid..".gif")
  local w, h = source:getWidth(), source:getHeight()
  maplib.grid_size = w
  
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

function maplib.update(dt)
  local modx,mody = 0,0
  local speed = 9-maplib.scale
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
    maplib.scale = maplib.scale - 1
    if maplib.scale < 1 then
      maplib.scale = 1
    end
  elseif button == "wu" then
    maplib.scale = maplib.scale + 1
    if maplib.scale > 8 then
      maplib.scale = 8
    end
  end
end

return maplib
