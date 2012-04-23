guilib = {}

guilib.bar = love.graphics.newImage("guilib/bar.png")

function guilib.draw()
  love.graphics.draw(guilib.bar,0,0,0,love.graphics.getWidth()-200,1)
  love.graphics.print("Cash: "..gamelib.cash.."/"..gamelib.cash_max,32,0)
  love.graphics.print("Research level: "..gamelib.research_level,256,0)
  --love.graphics.print("enemy_Cash: "..gamelib.enemy_cash.."/"..gamelib.enemy_cash_max,0,16)
  for i = 1,5 do
    if i == gamelib.unitselect then
      love.graphics.setColor(255,255,255,255)
    else
      love.graphics.setColor(255,255,255,127)
    end
    love.graphics.rectangle("fill",32*(i),32,32,32)
    love.graphics.setColor(0,0,0,255)
    love.graphics.print(i,32*i,32)
    love.graphics.setColor(255,255,255,255)
  end
  love.graphics.setColor(255,255,255,255)
  love.graphics.print(gamelib.unit_name[gamelib.unitselect].." [$"..gamelib.unit_cost[gamelib.unitselect].."]",32,64)
  love.graphics.draw(units.img,32,32)
end

return guilib
