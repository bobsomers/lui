Class = require "lui.class"
VG = require "lui.nanovg"

Widget = Class("Widget")

function Widget:init(values)
  if not Widget.font then
    Widget.font = VG.nvgCreateFont(VG.context(), "debug", "assets/DejaVuSansMono.ttf")
  end

  values = values or {}
  self.x = values.x or 0
  self.y = values.y or 0
  self.width = values.width or 100
  self.height = values.height or 100
end

function Widget:update(t)
  --self.width = ((math.sin(t) + 1) * 150) + 10
end

function Widget:draw()
  -- This is the default debug draw for widgets which have not implemented a
  -- drawing function (or are intentionally drawing themselves in debug mode).
  local ctx = VG.context()
  VG.nvgBeginPath(ctx)

  -- Stroke the dimensions of the widget.
  VG.nvgRect(ctx, self.x, self.y, self.width, self.height)
  VG.nvgStrokeColor(ctx, VG.nvgRGBA(255, 0, 0, 255))
  VG.nvgStroke(ctx)

  -- Set up text rendering.
  VG.nvgFontFaceId(ctx, Widget.font)
  VG.nvgFontSize(ctx, 10)
  VG.nvgFillColor(ctx, VG.nvgRGBA(255, 255, 255, 255))

  local textpad = 1
  local l = self.x + textpad
  local r = self.x + self.width - textpad
  local t = self.y + textpad
  local b = self.y + self.height - textpad

  -- Draw the widget location in the top left corner.
  VG.nvgTextAlign(ctx, "NVG_ALIGN_LEFT_TOP")
  VG.nvgText(ctx, l, t, string.format("%d,%d", self.x, self.y), nil)

  -- Draw the widget type in the bottom left corner.
  VG.nvgTextAlign(ctx, "NVG_ALIGN_LEFT_BOTTOM")
  VG.nvgText(ctx, l, b, self.class_name, nil)

  -- Draw the widget size in the top right corner.
  VG.nvgTextAlign(ctx, "NVG_ALIGN_RIGHT_TOP")
  VG.nvgText(ctx, r, t, string.format("%dx%d", self.width, self.height), nil)

  -- Draw the widget extents in the bottom right corner.
  VG.nvgTextAlign(ctx, "NVG_ALIGN_RIGHT_BOTTOM")
  VG.nvgText(ctx, r, b, string.format("%d,%d", self.x + self.width, self.y + self.height), nil)
end

return Widget
