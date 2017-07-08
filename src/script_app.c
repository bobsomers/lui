#include "script_app.h"

#include <stdio.h>
#include <stdlib.h>

#include <luajit-2.0/lua.h>
#include <luajit-2.0/lauxlib.h>
#include <luajit-2.0/lualib.h>
#include <luajit-2.0/luajit.h>

struct ScriptApp {
  lua_State* lua;
};

ScriptApp* scriptAppNew(const char* filename) {
  lua_State* l = luaL_newstate();
  if (!l) {
    fprintf(stderr, "%s\n", "Failed to create LuaJIT interpreter!");
    return NULL;
  }

  luaL_openlibs(l);
  if (luaL_dofile(l, filename)) {
    fprintf(stderr, "Script error: %s\n", lua_tostring(l, -1));
    return NULL;
  }

  ScriptApp* app = malloc(sizeof(ScriptApp));
  app->lua = l;
  return app;
}

void scriptAppDelete(ScriptApp* app) {
  free(app);
}

void scriptAppInit(ScriptApp* app) {
  lua_State* l = app->lua;
  lua_getglobal(l, "init");
  if (lua_pcall(l, 0, 0, 0)) {
    luaL_error(l, lua_tostring(l, -1));
  }
}

void scriptAppUpdate(ScriptApp* app, double t) {
  lua_State* l = app->lua;
  lua_getglobal(l, "update");
  lua_pushnumber(l, t);
  if (lua_pcall(l, 1, 0, 0)) {
    luaL_error(l, lua_tostring(l, -1));
  }
}

void scriptAppDraw(ScriptApp* app, void* vg) {
  lua_State* l = app->lua;
  lua_getglobal(l, "draw");
  lua_pushlightuserdata(l, vg);
  if (lua_pcall(l, 1, 0, 0)) {
    luaL_error(l, lua_tostring(l, -1));
  }
}
