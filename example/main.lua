Widget = require "thermyte.widget"
Button = require "thermyte.button"
ToggleButton = require "thermyte.toggle_button"

function thermyte.init()
  w = Widget {
    x = 100, y = 100,
    width = 80, height = 20,
  }

  b = Button {
    x = 200, y = 100,
    width = 100, height = 50,
  }

  tb = ToggleButton {
    x = 100, y = 200,
    width = 50, height = 50,
  }
end

function thermyte.update(t)
  w:update(t)
  b:update(t)
  tb:update(t)
end

function thermyte.draw()
  w:draw()
  b:draw()
  tb:draw()
end

--[[
function thermyte.mouseMoved(x, y)
  print("mouseMoved(" .. tostring(x) .. ", " .. tostring(y) .. ")")
end

function thermyte.mousePressed(x, y, button)
  print("mousePressed(" .. tostring(x) .. ", " .. tostring(y) .. ", " .. button .. ")")
end

function thermyte.mouseReleased(x, y, button)
  print("mouseReleased(" .. tostring(x) .. ", " .. tostring(y) .. ", " .. button .. ")")
end
]]
