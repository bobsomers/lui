Class = require "thermyte.class"
Widget = require "thermyte.widget"

Button = Class("Button", Widget)

function Button:init(values)
  Widget.init(self, values)
end

return Button
