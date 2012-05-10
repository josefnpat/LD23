require("maplib/maplib")
require("guilib/guilib")
require("gamelib/gamelib")
require("barlib/barlib")
menu = require("menu/menu")

love.mouse.setVisible( false )
math.randomseed( os.time() )
state = "menu"

kittendare = love.graphics.newImage("menu/kittendare-small.png")

function love.draw()
  if state == "menu" then
    menu:draw()
    if showcat then
      love.graphics.setColor(255,255,255,255)
      love.graphics.draw(notacat,32,32)
    end
    love.graphics.draw(kittendare,0,0)
  elseif state == "game" then
    maplib.draw()
    gamelib.draw()
    guilib.draw()
    if toggle_escape then
      love.graphics.setColor(0,0,0,127)
      love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight())
      love.graphics.setColor(255,255,255,255)
      love.graphics.printf("Are you sure you want to quit the game?",0,love.graphics.getHeight()/2,love.graphics.getWidth(),"center")
      love.graphics.printf("Press escape to quit and any other key to continue playing.",0,love.graphics.getHeight()/2+48,love.graphics.getWidth(),"center")
    end
    if toggle_winlose then
      love.graphics.setColor(0,0,0,127)
      love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight())
      love.graphics.setColor(255,255,255,255)
      if toggle_winlose == "victory" then
        love.graphics.printf("You are victorious!",0,love.graphics.getHeight()/2,love.graphics.getWidth(),"center")
        love.graphics.printf("=^.^=",0,love.graphics.getHeight()/2+48,love.graphics.getWidth(),"center")
      elseif toggle_winlose == "defeat" then
        love.graphics.printf("You have been defeated.",0,love.graphics.getHeight()/2,love.graphics.getWidth(),"center")
        love.graphics.printf("@( * O * )@",0,love.graphics.getHeight()/2+48,love.graphics.getWidth(),"center")
      end
    end
    love.graphics.print("fps:"..love.timer.getFPS( ),0,100)
  end
end

function love.update(dt)
  if state == "menu" then
    menu:update(dt)
  elseif state == "game" then
    maplib.update(dt)
    gamelib.update(dt)
  end
end

function love.mousepressed(x,y,button)
  if state == "game" then
    gamelib.mousepressed(x,y,button)
    maplib.mousepressed(x,y,button)
  end
end

map = math.random(1,5)
toggle_escape = false
function love.keypressed(key,uni)
  if state == "menu" then
    menu:keypressed(key)
  elseif state == "game" then
    if toggle_winlose then
      state = "menu"
      toggle_winlose = nil
    elseif key == "escape" then
      if toggle_escape then
        toggle_escape = false
        state = "menu"
      else
        toggle_escape = true        
      end
    elseif toggle_escape then
      toggle_escape = false
    end
    gamelib.keyboardpressed(key,uni)
    if key == "`" then --Not a cheat!
      gamelib.units = {}
    end
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
  menu:toggle()
  menu_view = {}
  menu_view[1] = {
    title="Pocket Strife",
    desc="Global Domination, one pixel at a time.",
    {t="New Game",cb="ng"},
    {t="Options",cb="op"},
    {t="Help",cb="help"},
    {t="Credits",cb="cr"},
    {t="Exit",cb="exit"}
  }
  menu_view[2] = {
    title="Options",
    desc="Set your options here.",
    {t="Fullscreen",cb="fs"},
    {t="Resolution ("..love.graphics.getWidth().."x"..love.graphics.getHeight()..")",cb="res"},
    {t="Return",cb="mm"}
  }
  menu_view[3] = {
    title="Quit",
    desc="Are you sure you want to quit?",
    {t="Confirm",cb="cexit"},
    {t="Return",cb="mm"}
  }
  local help_desc = "Welcome to Pocket Strife!\nIn this game, there are five types of buildings:\n"
  help_desc = help_desc .. ">" .. gamelib.unit_name[1] .. ": This building will increase your capacity!\n";
  help_desc = help_desc .. ">" .. gamelib.unit_name[2] .. ": This building increases your income! Don't leave home without it.\n";
  help_desc = help_desc .. ">" .. gamelib.unit_name[3] .. ": This building will increase the damage of your attack towers! Pew pew pew!\n";
  help_desc = help_desc .. ">" .. gamelib.unit_name[4] .. ": This building will attack your foes, and rob them of their health!\n";
  help_desc = help_desc .. ">" .. gamelib.unit_name[5] .. ": This building will allow you to build other buildings near it! Better build one of these first!\n";
  help_desc = help_desc .. "The goal is to destroy the enemy!";
  
  menu_view[4] = {
    title="Help",
    desc=help_desc,
    {t="Return",cb="mm"}
  }
  menu_view[6] = {
    title="KITTY!",
    desc="",
    {t="Return",cb="mm"}
  }
  menu_view[5] = {
    title="Credits",
    desc="This game was created for \nLudum Dare Challenge 23 by josefnpat.\nI was unable to participate for most of the weekend, but still wanted to make something.\nCheck out the github repo @ https://github.com/josefnpat/LD23\n\nhttp://www.ludumdare.com/",
    {t="Return",cb="mm"},
--    {t="Meow?",cb="cat"}
  }
  menu:load(menu_view)
  videomodes = love.graphics.getModes()
  currentmode = 1  
end

function menu:callback(cb)
  showcat = false
  if cb == "ng" then
    state = "game"
    map = math.random(1,5)
    gamelib.load()
    maplib.load()
  elseif cb == "op" then
    menu:setstate(2)
  elseif cb == "cr" then
    menu:setstate(5)
  elseif cb == "help" then
    menu:setstate(4)
  elseif cb == "cat" then
    menu:setstate(6)
    showcat = true
  elseif cb == "exit" then
    menu:setstate(3)
  elseif cb == "cexit" then
    love.event.quit()
  elseif cb == "fs" then
    love.graphics.toggleFullscreen( )
  elseif cb == "res" then
    love.graphics.setMode( videomodes[currentmode].width, videomodes[currentmode].height )
    menu_view[2][2].t = "Resolution ("..love.graphics.getWidth().."x"..love.graphics.getHeight()..")"
    currentmode = ((currentmode + 1)% #videomodes)+1
  elseif cb == "sound" then
    sound = not sound
    local temp_x = ""
    if sound then
      temp_s = "on"
    else
      temp_s = "off"
    end
    menu_view[2][3].t = "Sound ("..temp_s..")"
  elseif cb == "mm" then
    menu:setstate(1)
  else
    print("unknown command:"..cb)
  end
end

notacat = love.graphics.newImage("menu/assets/.nocatsinhere/notacat")
