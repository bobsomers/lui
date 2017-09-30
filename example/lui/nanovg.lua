local ffi = require "ffi"

local nanovg = {}

function nanovg.context()
  return lui._nano_vg
end

ffi.cdef [[
  /*
   * ================= TYPES ==================================================
   */
  typedef struct NVGcontext {} NVGcontext;

  typedef struct NVGcolor {
    union {
      float rgba[4];
      struct {
        float r, g, b, a;
      };
    };
  } NVGcolor;

  typedef struct NVGpaint {
    float xform[6];
    float extent[2];
    float radius;
    float feather;
    NVGcolor innerColor;
    NVGcolor outerColor;
    int image;
  } NVGpaint;

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

  typedef enum NVGwinding {
    NVG_CCW = 1,
    NVG_CW = 2,
  } NVGwinding;

  typedef enum NVGsolidity {
    NVG_SOLID = 1,
    NVG_HOLE = 2,
  } NVGsolidity;

  typedef enum NVGlineCap {
    NVG_BUTT,
    NVG_ROUND,
    NVG_SQUARE,
    NVG_BEVEL,
    NVG_MITER,
  } NVGlineCap;

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
  void nvgStrokePaint(NVGcontext* ctx, NVGpaint paint);
  void nvgFillColor(NVGcontext* ctx, NVGcolor color);
  void nvgFillPaint(NVGcontext* ctx, NVGpaint paint);
  void nvgMiterLimit(NVGcontext* ctx, float limit);
  void nvgStrokeWidth(NVGcontext* ctx, float size);
  void nvgLineCap(NVGcontext* ctx, NVGlineCap cap);
  void nvgLineJoin(NVGcontext* ctx, NVGlineCap join);
  void nvgGlobalAlpha(NVGcontext* ctx, float alpha);

  /*
   * ================= PAINTS =================================================
   */
  NVGpaint nvgLinearGradient(NVGcontext* ctx, float sx, float sy, float ex,
                             float ey, NVGcolor icol, NVGcolor ocol);
  NVGpaint nvgBoxGradient(NVGcontext* ctx, float x, float y, float w, float h,
                          float r, float f, NVGcolor icol, NVGcolor ocol);
  NVGpaint nvgRadialGradient(NVGcontext* ctx, float cx, float cy, float inr,
                             float outr, NVGcolor icol, NVGcolor ocol);
  NVGpaint nvgImagePattern(NVGcontext* ctx, float ox, float oy, float ex,
                           float ey, float angle, int image, float alpha);

  /*
   * ================= SCISSORING =============================================
   */
  void nvgScissor(NVGcontext* ctx, float x, float y, float w, float h);
  void nvgIntersectScissor(NVGcontext* ctx, float x, float y, float w, float h);
  void nvgResetScissor(NVGcontext* ctx);

  /*
   * ================= PATHS ==================================================
   */
  void nvgBeginPath(NVGcontext* ctx);
  void nvgMoveTo(NVGcontext* ctx, float x, float y);
  void nvgLineTo(NVGcontext* ctx, float x, float y);
  void nvgBezierTo(NVGcontext* ctx, float c1x, float c1y, float c2x, float c2y,
                   float x, float y);
  void nvgQuadTo(NVGcontext* ctx, float cx, float cy, float x, float y);
  void nvgArcTo(NVGcontext* ctx, float x1, float y1, float x2, float y2, float radius);
  void nvgClosePath(NVGcontext* ctx);
  void nvgPathWinding(NVGcontext* ctx, int dir);
  void nvgArc(NVGcontext* ctx, float cx, float cy, float r, float a0, float a1, int dir);
  void nvgRect(NVGcontext* ctx, float x, float y, float w, float h);
  void nvgRoundedRect(NVGcontext* ctx, float x, float y, float w, float h, float r);
  void nvgRoundedRectVarying(NVGcontext* ctx, float x, float y, float w, float h,
                             float radTopLeft, float radTopRight,
                             float radBottomRight, float radBottomLeft);
  void nvgEllipse(NVGcontext* ctx, float cx, float cy, float rx, float ry);
  void nvgCircle(NVGcontext* ctx, float cx, float cy, float r);
  void nvgFill(NVGcontext* ctx);
  void nvgStroke(NVGcontext* ctx);

  /*
   * ================= TEXT ===================================================
   */
  int nvgCreateFont(NVGcontext* ctx, const char* name, const char* filename);
  void nvgFontFaceId(NVGcontext* ctx, int font);
  void nvgFontSize(NVGcontext* ctx, float size);
  void nvgFontBlur(NVGcontext* ctx, float blur);
  void nvgTextLetterSpacing(NVGcontext* ctx, float spacing);
  void nvgTextLineHeight(NVGcontext* ctx, float lineHeight);
  void nvgTextAlign(NVGcontext* ctx, NVGalign align);
  float nvgText(NVGcontext* ctx, float x, float y, const char* string, const char* end);
  void nvgTextBox(NVGcontext* ctx, float x, float y, float breakRowWidth, const char* string, const char* end);
]]

return setmetatable(nanovg, {__index = ffi.C})
