buttonlib = require("buttonlib/buttonlib")

function love.load()
  buttonlib.load()
  buttons = {
    b1 = buttonlib.newButton("Submit","sub"),
    b2 = buttonlib.newButton("Cancel","can"),
    b3 = buttonlib.newButton("Format HD","dis")
  }
  buttons.b3.disabled = true
end

function love.draw()
  buttonlib.drawb(buttons.b1,100,100)
  buttonlib.drawb(buttons.b2,100+buttons.b1:getWidth()+2,100)
  buttonlib.drawb(buttons.b3,100+buttons.b1:getWidth()+buttons.b2:getWidth()+4,100)
end

function buttonlib.pressed(cb)
  print("Pressed cb:"..cb)
end

function love.update(dt)
  buttonlib.update(buttons)
end

function love.mousepressed(x,y,b)
  buttonlib.mousepressed(b,buttons)
end

function love.mousereleased(x,y,b)
  buttonlib.mousereleased(b,buttons)
end
