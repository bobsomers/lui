Class = require "lui.class"
Button = require "lui.button"

ToggleButton = Class("ToggleButton", Button)

function ToggleButton:init(values)
  Button.init(self, values)
end

return ToggleButton
