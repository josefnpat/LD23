require("maplib/maplib")
require("guilib/guilib")
require("gamelib/gamelib")
require("barlib/barlib")

love.mouse.setVisible( false )
math.randomseed( os.time() )

function love.draw()
  maplib.draw()
  gamelib.draw()
  guilib.draw()
  love.graphics.print("fps:"..love.timer.getFPS( ),0,100)
end

function love.update(dt)
  maplib.update(dt)
  gamelib.update(dt)
end

function love.mousepressed(x,y,button)
  gamelib.mousepressed(x,y,button)
  maplib.mousepressed(x,y,button)
end

map = math.random(1,5)
function love.keypressed(key,uni)
  gamelib.keyboardpressed(key,uni)
  if key == " " then
    map = ( map + 1 ) % 7 + 1
    maplib.loadmap(map)
  end
end

units = {}
units.img = love.graphics.newImage("maplib/units.png")
units.img:setFilter("nearest","nearest")
units.quad = {}
units.quad[1] = love.graphics.newQuad(0,0,32,32,units.img:getWidth(),units.img:getHeight())
units.quad[2] = love.graphics.newQuad(32,0,32,32,units.img:getWidth(),units.img:getHeight())
units.quad[3] = love.graphics.newQuad(64,0,32,32,units.img:getWidth(),units.img:getHeight())
units.quad[4] = love.graphics.newQuad(96,0,32,32,units.img:getWidth(),units.img:getHeight())
units.quad[5] = love.graphics.newQuad(128,0,32,32,units.img:getWidth(),units.img:getHeight())

function love.load(arg)
  maplib.loadmap(map)
end
