local ffi = require "ffi"

local nanovg = {}

function nanovg.context()
  return thermyte._nano_vg
end

ffi.cdef [[
  /*
   * ================= TYPES ==================================================
   */
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

  /*
   * ================= COLOR UTILS ============================================
   */
  NVGcolor nvgRGB(unsigned char r, unsigned char g, unsigned char b);
  NVGcolor nvgRGBf(float r, float g, float b);
  NVGcolor nvgRGBA(unsigned char r, unsigned char g, unsigned char b, unsigned char a);
  NVGcolor nvgRGBAf(float r, float g, float b, float a);

  NVGcolor nvgLerpRGBA(NVGcolor c0, NVGcolor c1, float u);
  NVGcolor nvgTransRGBA(NVGcolor c0, unsigned char a);
  NVGcolor nvgTransRGBAf(NVGcolor c0, float a);
  NVGcolor nvgHSL(float h, float s, float l);
  NVGcolor nvgHSLA(float h, float s, float l, unsigned char a);

  /*
   * ================= STATE HANDLING =========================================
   */
  void nvgSave(NVGcontext* ctx);
  void nvgRestore(NVGcontext* ctx);
  void nvgReset(NVGcontext* ctx);

  /*
   * ================= RENDER STYLES ==========================================
   */
  void nvgStrokeColor(NVGcontext* ctx, NVGcolor color);
  void nvgFillColor(NVGcontext* ctx, NVGcolor color);

  /*
   * ================= PATHS ==================================================
   */
  void nvgBeginPath(NVGcontext* ctx);
  void nvgRect(NVGcontext* ctx, float x, float y, float w, float h);
  void nvgFill(NVGcontext* ctx);
  void nvgStroke(NVGcontext* ctx);

  /*
   * ================= TEXT ===================================================
   */
  int nvgCreateFont(NVGcontext* ctx, const char* name, const char* filename);
  void nvgFontFaceId(NVGcontext* ctx, int font);
  void nvgFontSize(NVGcontext* ctx, float size);
  void nvgTextAlign(NVGcontext* ctx, NVGalign align);
  float nvgText(NVGcontext* ctx, float x, float y, const char* string, const char* end);
]]

return setmetatable(nanovg, {__index = ffi.C})
