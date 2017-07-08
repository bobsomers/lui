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

ScriptApp* scriptAppNew(const char* filename, void* nano_vg) {
  lua_State* l = luaL_newstate();
  if (!l) {
    fprintf(stderr, "%s\n", "Failed to create LuaJIT interpreter!");
    return NULL;
  }

  luaL_openlibs(l);

  lua_newtable(l);
  lua_pushlightuserdata(l, nano_vg);
  lua_setfield(l, -2, "_nano_vg");
  lua_setglobal(l, "thermyte");

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
  lua_getglobal(l, "thermyte");
  lua_getfield(l, -1, "init");
  if (lua_isfunction(l, -1)) {
    if (lua_pcall(l, 0, 0, 0)) {
      luaL_error(l, "Script error: %s\n", lua_tostring(l, -1));
    }
  }
  lua_pop(l, 1);
}

void scriptAppUpdate(ScriptApp* app, double t) {
  lua_State* l = app->lua;
  lua_getglobal(l, "thermyte");
  lua_getfield(l, -1, "update");
  if (lua_isfunction(l, -1)) {
    lua_pushnumber(l, t);
    if (lua_pcall(l, 1, 0, 0)) {
      luaL_error(l, "Script error: %s\n", lua_tostring(l, -1));
    }
  }
  lua_pop(l, 1);
}

void scriptAppDraw(ScriptApp* app) {
  lua_State* l = app->lua;
  lua_getglobal(l, "thermyte");
  lua_getfield(l, -1, "draw");
  if (lua_isfunction(l, -1)) {
    if (lua_pcall(l, 0, 0, 0)) {
      luaL_error(l, "Script error: %s\n", lua_tostring(l, -1));
    }
  }
  lua_pop(l, 1);
}

void scriptAppMouseMoved(ScriptApp* app, double x, double y) {
  lua_State* l = app->lua;
  lua_getglobal(l, "thermyte");
  lua_getfield(l, -1, "mouseMoved");
  if (lua_isfunction(l, -1)) {
    lua_pushnumber(l, x);
    lua_pushnumber(l, y);
    if (lua_pcall(l, 2, 0, 0)) {
      luaL_error(l, "Script error: %s\n", lua_tostring(l, -1));
    }
  }
  lua_pop(l, 1);
}

void scriptAppMousePressed(ScriptApp* app, double x, double y, int button) {
  lua_State* l = app->lua;
  lua_getglobal(l, "thermyte");
  lua_getfield(l, -1, "mousePressed");
  if (lua_isfunction(l, -1)) {
    lua_pushnumber(l, x);
    lua_pushnumber(l, y);
    lua_pushnumber(l, button);
    if (lua_pcall(l, 3, 0, 0)) {
      luaL_error(l, "Script error: %s\n", lua_tostring(l, -1));
    }
  }
  lua_pop(l, 1);
}

void scriptAppMouseReleased(ScriptApp* app, double x, double y, int button) {
  lua_State* l = app->lua;
  lua_getglobal(l, "thermyte");
  lua_getfield(l, -1, "mouseReleased");
  if (lua_isfunction(l, -1)) {
    lua_pushnumber(l, x);
    lua_pushnumber(l, y);
    lua_pushnumber(l, button);
    if (lua_pcall(l, 3, 0, 0)) {
      luaL_error(l, "Script error: %s\n", lua_tostring(l, -1));
    }
  }
  lua_pop(l, 1);
}
