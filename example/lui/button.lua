Class = require "lui.class"
Widget = require "lui.widget"

Button = Class("Button", Widget)

function Button:init(values)
  Widget.init(self, values)
end

return Button
