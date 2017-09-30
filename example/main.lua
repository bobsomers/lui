Widget = require "lui.widget"
Button = require "lui.button"
ToggleButton = require "lui.toggle_button"

function lui.init()
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

function lui.update(t)
  w:update(t)
  b:update(t)
  tb:update(t)
end

function lui.draw()
  w:draw()
  b:draw()
  tb:draw()
end

--[[
function lui.mouseMoved(x, y)
  print("mouseMoved(" .. tostring(x) .. ", " .. tostring(y) .. ")")
end

function lui.mousePressed(x, y, button)
  print("mousePressed(" .. tostring(x) .. ", " .. tostring(y) .. ", " .. button .. ")")
end

function lui.mouseReleased(x, y, button)
  print("mouseReleased(" .. tostring(x) .. ", " .. tostring(y) .. ", " .. button .. ")")
end
]]
