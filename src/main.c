#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <unistd.h>

#include "gl.h"

#include "nanovg.h"
#define NANOVG_GL3_IMPLEMENTATION
#include "nanovg_gl.h"

#include "demo_scene.h"
#include "script_app.h"

typedef struct Thermyte {
  ScriptApp* app;
  GLFWwindow* window;
} Thermyte;

static Thermyte thermyte;

void errorCallback(int error, const char* description) {
  fprintf(stderr, "GLFW Error [%d] %s\n", error, description);
}

void cursorPosCallback(GLFWwindow* window, double x, double y) {
  scriptAppMouseMoved(thermyte.app, x, y);
}

void mouseButtonCallback(GLFWwindow* window, int button, int action, int mods) {
  double x = 0.0;
  double y = 0.0;
  glfwGetCursorPos(thermyte.window, &x, &y);

  if (action == GLFW_PRESS) {
    scriptAppMousePressed(thermyte.app, x, y, button);
  } else if (action == GLFW_RELEASE) {
    scriptAppMouseReleased(thermyte.app, x, y, button);
  } else {
    fprintf(stderr, "%s\n", "Unexpected action in mouse button callback!");
    exit(EXIT_FAILURE);
  }
}

int main(int argc, char* argv[]) {
  if (argc > 1) {
    if (strcmp("-h", argv[1]) == 0 || strcmp("--help", argv[1]) == 0) {
      printf("Usage: %s [app directory]\n", argv[0]);
      return EXIT_SUCCESS;
    }

    if (chdir(argv[1])) {
      perror("Failed to set app directory");
      return EXIT_FAILURE;
    }
  }

  glfwSetErrorCallback(errorCallback);

  if (!glfwInit()) {
    return EXIT_FAILURE;
  }

  glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
  glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
  glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
  glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
  glfwWindowHint(GLFW_OPENGL_DEBUG_CONTEXT, 1);

  GLFWwindow* window = glfwCreateWindow(960, 540, "Thermyte", NULL, NULL);
  if (!window) {
    glfwTerminate();
    return EXIT_FAILURE;
  }
  thermyte.window = window;

  glfwSetCursorPosCallback(window, cursorPosCallback);
  glfwSetMouseButtonCallback(window, mouseButtonCallback);

  glfwMakeContextCurrent(window);

  NVGcontext* vg = nvgCreateGL3(NVG_ANTIALIAS | NVG_STENCIL_STROKES | NVG_DEBUG);
  if (!vg) {
    fprintf(stderr, "%s", "Failed to create NanoVG context!\n");
    return EXIT_FAILURE;
  }

  ScriptApp* app = scriptAppNew("main.lua", vg);
  if (!app) {
    return EXIT_FAILURE;
  }
  thermyte.app = app;

  DemoScene* scene = demoSceneNew();

  scriptAppInit(app);

  while (!glfwWindowShouldClose(window)) {
    int win_width = 0;
    int win_height = 0;
    int fb_width = 0;
    int fb_height = 0;
    glfwGetWindowSize(window, &win_width, &win_height);
    glfwGetFramebufferSize(window, &fb_width, &fb_height);

    float px_ratio = (float)fb_width / (float)win_width;
    float aspect_ratio = (float)win_width / (float)win_height;

    scriptAppUpdate(app, glfwGetTime());

    glViewport(0, 0, fb_width, fb_height);
    glClearColor(0.3f, 0.3f, 0.32f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);

    // TODO: What to do about this? We probably want control to do this from
    // Lua, but want to support workflows where all of this drawing is done in
    // native code. Maybe allow the user to specify "load" and "draw" functions
    // from a DLL that we will attempt to load if they want to implement
    // everything in native code?
    demoSceneDraw(scene, aspect_ratio);

    nvgBeginFrame(vg, win_width, win_height, px_ratio);
    scriptAppDraw(app);
    nvgEndFrame(vg);

    glfwSwapBuffers(window);
    glfwPollEvents();
  }

  demoSceneDelete(scene);
  scriptAppDelete(app);

  nvgDeleteGL3(vg);
  glfwDestroyWindow(window);
  glfwTerminate();
  return EXIT_SUCCESS;
}
