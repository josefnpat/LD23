maplib = {}

maplib.map = {}

maplib.grid_size = 200

math.randomseed( os.time() )

for x = 1,maplib.grid_size do
  for y = 1,maplib.grid_size/2 do
    if not maplib.map[x] then
      maplib.map[x] = {}
    end
    maplib.map[x][y] = {math.random(127,255),math.random(127,255),math.random(127,255)}
  end
end

maplib.tiles = love.graphics.newImage("maplib/tilesheet.png")

maplib.quads = {}
maplib.quads[1] = love.graphics.newQuad(0,0,32,32,maplib.tiles:getWidth(),maplib.tiles:getHeight())

maplib.block_width, maplib.block_depth = 32,16
maplib.grid_x,maplib.grid_y = 0,0

function maplib.draw()
  for x,v in pairs(maplib.map) do
    for y,color in pairs(v) do
      love.graphics.setColor(color[1],color[2],color[3])
      love.graphics.drawq(maplib.tiles,maplib.quads[1],
        maplib.grid_x + ((y-x) * (maplib.block_width / 2)),
        maplib.grid_y + ((x+y) * (maplib.block_depth / 2)) - (maplib.block_depth * (maplib.grid_size / 2)))
       love.graphics.setColor(255,255,255)
    end
  end
end

function maplib.loadmap(mapid)
  if not mapid  then
    mapid = 1
  end
  local source = love.image.newImageData("maplib/world"..mapid..".gif")
  local w, h = source:getWidth(), source:getHeight()
  
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

maplib.loadmap(2)

function maplib.update(dt)
  local modx,mody = 0,0
  local speed = 250
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
  maplib.grid_x = maplib.grid_x + modx*dt
  maplib.grid_y = maplib.grid_y + mody*dt
end
return maplib
