require("maplib/maplib")

function love.draw()
  maplib.draw()
  love.graphics.print("fps:"..love.timer.getFPS( ),0,0)
end

function love.update(dt)
  maplib.update(dt)
end

function love.mousepressed(x,y,button)
  maplib.mousepressed(x,y,button)
end

map = 1
function love.keypressed(button,uni)
  if button == " " then
    map = ( map + 1 ) % 7 + 1
    maplib.loadmap(map)
  end
end

function love.load(arg)
  maplib.loadmap(map)
end
