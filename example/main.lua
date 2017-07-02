local ffi = require("ffi")

ffi.cdef [[
  typedef struct NVGcolor {
    union {
      float rgba[4];
      struct {
        float r, g, b, a;
      };
    };
  } NVGcolor;

  typedef struct NVGcontext {} NVGcontext;

  void nvgBeginPath(NVGcontext* ctx);
  void nvgRect(NVGcontext* ctx, float x, float y, float w, float h);
  void nvgFillColor(NVGcontext* ctx, NVGcolor color);
  NVGcolor nvgRGBA(unsigned char r, unsigned char g, unsigned char b, unsigned char a);
  void nvgFill(NVGcontext* ctx);
]]

box_width = 0

function update(t)
  box_width = ((math.sin(t) + 1) * 150) + 10
end

function drawScene()
  -- TODO
end

function drawUI(vg)
  ffi.C.nvgBeginPath(vg)
  ffi.C.nvgRect(vg, 100, 100, box_width, 30)
  ffi.C.nvgFillColor(vg, ffi.C.nvgRGBA(255, 192, 0, 255))
  ffi.C.nvgFill(vg)
end

print "Main script loaded!"
