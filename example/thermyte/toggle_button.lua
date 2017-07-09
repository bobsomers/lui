Class = require "thermyte.class"
Button = require "thermyte.button"

ToggleButton = Class("ToggleButton", Button)

function ToggleButton:init(values)
  Button.init(self, values)
end

return ToggleButton
