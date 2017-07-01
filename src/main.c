#include <stdio.h>
#include <stdlib.h>

#include <epoxy/gl.h>
#include <GLFW/glfw3.h>
#include "nanovg.h"
#define NANOVG_GL3_IMPLEMENTATION
#include "nanovg_gl.h"

void errorCallback(int error, const char* description) {
  fprintf(stderr, "GLFW Error [%d] %s\n", error, description);
}

void simpleDraw(NVGcontext* vg) {
  nvgBeginPath(vg);
  nvgRect(vg, 100, 100, 120, 30);
  nvgFillColor(vg, nvgRGBA(255, 192, 0, 255));
  nvgFill(vg);
}

int main(void) {
  glfwSetErrorCallback(errorCallback);

  if (!glfwInit()) {
    return EXIT_FAILURE;
  }

  glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
  glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 2);
  glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
  glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
  glfwWindowHint(GLFW_OPENGL_DEBUG_CONTEXT, 1);

  GLFWwindow* window = glfwCreateWindow(960, 540, "Thermyte", NULL, NULL);
  if (!window) {
    glfwTerminate();
    return EXIT_FAILURE;
  }

  glfwMakeContextCurrent(window);

  NVGcontext* vg = nvgCreateGL3(NVG_ANTIALIAS | NVG_STENCIL_STROKES | NVG_DEBUG);
  if (!vg) {
    fprintf(stderr, "%s", "Failed to create NanoVG context!\n");
    return EXIT_FAILURE;
  }

  while (!glfwWindowShouldClose(window)) {
    int win_width = 0;
    int win_height = 0;
    int fb_width = 0;
    int fb_height = 0;
    float px_ratio = 0.0f;

    glfwGetWindowSize(window, &win_width, &win_height);
    glfwGetFramebufferSize(window, &fb_width, &fb_height);
    px_ratio =  (float)fb_width / (float)win_width;

    glViewport(0, 0, fb_width, fb_height);
    glClearColor(0.3f, 0.3f, 0.32f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);

    nvgBeginFrame(vg, win_width, win_height, px_ratio);
    simpleDraw(vg);
    nvgEndFrame(vg);

    glfwSwapBuffers(window);
    glfwPollEvents();
  }

  nvgDeleteGL3(vg);
  glfwDestroyWindow(window);
  glfwTerminate();
  return EXIT_SUCCESS;
}
