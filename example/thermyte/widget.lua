local ffi = require "ffi"

ffi.cdef [[
  typedef struct NVGcolor {
    union {
      float rgba[4];
      struct {
        float r, g, b, a;
      };
    };
  } NVGcolor;

  typedef enum NVGalign {
    NVG_ALIGN_LEFT = 1<<0,
    NVG_ALIGN_CENTER = 1<<1,
    NVG_ALIGN_RIGHT = 1<<2,

    NVG_ALIGN_TOP = 1<<3,
    NVG_ALIGN_MIDDLE = 1<<4,
    NVG_ALIGN_BOTTOM = 1<<5,
    NVG_ALIGN_BASELINE = 1<<6,

    NVG_ALIGN_LEFT_TOP = NVG_ALIGN_LEFT | NVG_ALIGN_TOP,
    NVG_ALIGN_LEFT_MIDDLE = NVG_ALIGN_LEFT | NVG_ALIGN_MIDDLE,
    NVG_ALIGN_LEFT_BOTTOM = NVG_ALIGN_LEFT | NVG_ALIGN_BOTTOM,
    NVG_ALIGN_LEFT_BASELINE = NVG_ALIGN_LEFT | NVG_ALIGN_BASELINE,

    NVG_ALIGN_CENTER_TOP = NVG_ALIGN_CENTER | NVG_ALIGN_TOP,
    NVG_ALIGN_CENTER_MIDDLE = NVG_ALIGN_CENTER | NVG_ALIGN_MIDDLE,
    NVG_ALIGN_CENTER_BOTTOM = NVG_ALIGN_CENTER | NVG_ALIGN_BOTTOM,
    NVG_ALIGN_CENTER_BASELINE = NVG_ALIGN_CENTER | NVG_ALIGN_BASELINE,

    NVG_ALIGN_RIGHT_TOP = NVG_ALIGN_RIGHT | NVG_ALIGN_TOP,
    NVG_ALIGN_RIGHT_MIDDLE = NVG_ALIGN_RIGHT | NVG_ALIGN_MIDDLE,
    NVG_ALIGN_RIGHT_BOTTOM = NVG_ALIGN_RIGHT | NVG_ALIGN_BOTTOM,
    NVG_ALIGN_RIGHT_BASELINE = NVG_ALIGN_RIGHT | NVG_ALIGN_BASELINE,
  } NVGalign;

  typedef struct NVGcontext {} NVGcontext;

  NVGcolor nvgRGBA(unsigned char r, unsigned char g, unsigned char b, unsigned char a);

  void nvgBeginPath(NVGcontext* ctx);

  void nvgRect(NVGcontext* ctx, float x, float y, float w, float h);

  void nvgFillColor(NVGcontext* ctx, NVGcolor color);
  void nvgStrokeColor(NVGcontext* ctx, NVGcolor color);

  void nvgFill(NVGcontext* ctx);
  void nvgStroke(NVGcontext* ctx);

  int nvgCreateFont(NVGcontext* ctx, const char* name, const char* filename);
  void nvgFontFaceId(NVGcontext* ctx, int font);
  void nvgFontSize(NVGcontext* ctx, float size);
  void nvgTextAlign(NVGcontext* ctx, NVGalign align);
  float nvgText(NVGcontext* ctx, float x, float y, const char* string, const char* end);
]]

Class = require "thermyte.class"

Widget = Class("Widget")

function Widget:init(values)
  if not Widget.font then
    Widget.font = ffi.C.nvgCreateFont(thermyte._nano_vg,
                                      "debug",
                                      "assets/DejaVuSansMono.ttf")
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
  local vg = thermyte._nano_vg
  ffi.C.nvgBeginPath(vg)

  -- Stroke the dimensions of the widget.
  ffi.C.nvgRect(vg, self.x, self.y, self.width, self.height)
  ffi.C.nvgStrokeColor(vg, ffi.C.nvgRGBA(255, 0, 0, 255))
  ffi.C.nvgStroke(vg)

  -- Set up text rendering.
  ffi.C.nvgFontFaceId(vg, Widget.font)
  ffi.C.nvgFontSize(vg, 10)
  ffi.C.nvgFillColor(vg, ffi.C.nvgRGBA(255, 255, 255, 255))

  local textpad = 1
  local l = self.x + textpad
  local r = self.x + self.width - textpad
  local t = self.y + textpad
  local b = self.y + self.height - textpad

  -- Draw the widget location in the top left corner.
  ffi.C.nvgTextAlign(vg, "NVG_ALIGN_LEFT_TOP")
  ffi.C.nvgText(vg, l, t, string.format("%d,%d", self.x, self.y), nil)

  -- Draw the widget type in the bottom left corner.
  ffi.C.nvgTextAlign(vg, "NVG_ALIGN_LEFT_BOTTOM")
  ffi.C.nvgText(vg, l, b, self.class_name, nil)

  -- Draw the widget size in the top right corner.
  ffi.C.nvgTextAlign(vg, "NVG_ALIGN_RIGHT_TOP")
  ffi.C.nvgText(vg, r, t, string.format("%dx%d", self.width, self.height), nil)

  -- Draw the widget extents in the bottom right corner.
  ffi.C.nvgTextAlign(vg, "NVG_ALIGN_RIGHT_BOTTOM")
  ffi.C.nvgText(vg, r, b, string.format("%d,%d", self.x + self.width, self.y + self.height), nil)
end

return Widget
