buttonlib = {}
buttonlib.graphics = {}
function buttonlib.load()
  local theme = "dmg01"
  buttonlib.img_inactive = love.graphics.newImage("buttonlib/"..theme.."/inactive.png")
  buttonlib.img_active = love.graphics.newImage("buttonlib/"..theme.."/active.png")
  buttonlib.img_depress = love.graphics.newImage("buttonlib/"..theme.."/depress.png")
  buttonlib.img_disabled = love.graphics.newImage("buttonlib/"..theme.."/disabled.png")
  buttonlib.font = love.graphics.newFont("buttonlib/DejaVuSansCondensed.ttf",16)
  buttonlib.q_left = love.graphics.newQuad(0,0,16,32,33,32)
  buttonlib.q_center = love.graphics.newQuad(16,0,1,32,33,32)
  buttonlib.q_right = love.graphics.newQuad(17,0,16,32,33,32)
  buttonlib.active = false
  buttonlib.data = {}
end

function buttonlib.drawb(b,x,y)
  b.x = x
  b.y = y
  local text_width = buttonlib.font:getWidth(b.text)
  local text_height = buttonlib.font:getHeight(b.text)
  local img = buttonlib.img_inactive
  if b.active then
    img = buttonlib.img_active
  end
  if b.depress then
    img = buttonlib.img_depress
  end
  if b.disabled then
    img = buttonlib.img_disabled
  end
  love.graphics.drawq(img,buttonlib.q_left   ,x              ,y)
  love.graphics.drawq(img,buttonlib.q_center ,x+16           ,y,0,text_width,1)
  love.graphics.drawq(img,buttonlib.q_right  ,x+16+text_width,y)
  local orig_r,orig_g,orig_b,orig_a = love.graphics.getColor()
  if b.disabled then
    love.graphics.setColor(255,255,255,127)
  else
    love.graphics.setColor(255,255,255,255)
  end
  local old_font = love.graphics.getFont()
  love.graphics.setFont(buttonlib.font)
  love.graphics.print(b.text,x+16,y-text_height/2+16)
  love.graphics.setFont(old_font)
  love.graphics.setColor(orig_r,orig_g,orig_b,orig_a)
end

function buttonlib.newButton(text,cb)
  local b = {
    x=0,
    y=0,
    text=text,
    cb=cb,
    disabled=false
  }
  local width = buttonlib.font:getWidth(text) + 32
  b.getWidth = function() return width end
  b.getHeight = function() return 32 end
  return b
end


function buttonlib.update(butarray)
  for _,v in pairs(butarray) do
    if buttonlib.mouseIntersect(v) then
      v.active = true
    else
      v.active = false
    end
  end
end

function buttonlib.mousepressed(b,butarray)
  if b == "l" then
    for _,v in pairs(butarray) do
      if buttonlib.mouseIntersect(v) then
        v.depress = true
      else
        v.depress = false
      end
    end
  end
end

function buttonlib.mousereleased(b,butarray)
  if b == "l" then
    for _,v in pairs(butarray) do
      v.depress = false
      if buttonlib.mouseIntersect(v) then
        if not v.disabled then
          if buttonlib.pressed then
            buttonlib.pressed(v.cb)
          else
            print("function buttonlib.pressed(cb) not defined")
          end
        end
      end
    end
  end
end

-- Mouse intersect
function buttonlib.mouseIntersect(button)
  local x,y = love.mouse.getX(), love.mouse.getY()
  if button.x <= x and x <= button.x + button.getWidth() and button.y <= y and y <= button.y + button.getHeight() then
    return true
  end
end

return buttonlib
