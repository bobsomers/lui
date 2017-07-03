#include "demo_scene.h"

#include <stdio.h>
#include <stdlib.h>

#include "gl.h"

struct DemoScene {
  GLuint vao;
  GLuint vbo;
  GLuint vshader;
  GLuint fshader;
  GLuint program;
  GLuint time_uniform;
  GLuint proj_uniform;
};

static void printShaderInfoLog(GLuint id) {
  GLint info_log_length = 0;
  glGetShaderiv(id, GL_INFO_LOG_LENGTH, &info_log_length);
  if (info_log_length > 0) {
    char* log = malloc(info_log_length + 1);
    glGetShaderInfoLog(id, info_log_length, NULL, log);
    printf("Info Log: %s\n", log);
    free(log);
  }
}

static void printProgramInfoLog(GLuint id) {
  GLint info_log_length = 0;
  glGetShaderiv(id, GL_INFO_LOG_LENGTH, &info_log_length);
  if (info_log_length > 0) {
    char* log = malloc(info_log_length + 1);
    glGetProgramInfoLog(id, info_log_length, NULL, log);
    printf("Info Log: %s\n", log);
    free(log);
  }
}

DemoScene* demoSceneNew() {
  DemoScene* scene = malloc(sizeof(DemoScene));

  glGenVertexArrays(1, &scene->vao);
  glBindVertexArray(scene->vao);

  static const GLfloat vertex_buffer_data[] = {
    -0.5f, -0.5f, 0.0f,
    0.5f, -0.5f, 0.0f,
    0.0f, 0.5f, 0.0f,
  };

  glGenBuffers(1, &scene->vbo);
  glBindBuffer(GL_ARRAY_BUFFER, scene->vbo);
  glBufferData(GL_ARRAY_BUFFER, sizeof(vertex_buffer_data), vertex_buffer_data, GL_STATIC_DRAW);

  const char* vert_shader =
    "#version 330 core\n"
    "layout(location = 0) in vec3 vertexPosition_modelspace;\n"
    "uniform float time;\n"
    "uniform mat4 proj;\n"
    "void main() {\n"
    "  float theta = time;\n"
    "  mat4 rot = mat4(\n"
    "    vec4(cos(theta), sin(theta), 0, 0),\n"
    "    vec4(-sin(theta), cos(theta), 0, 0),\n"
    "    vec4(0, 0, 1, 0),\n"
    "    vec4(0, 0, 0, 1)\n"
    "  );\n"
    "  gl_Position = proj * rot * vec4(vertexPosition_modelspace, 1.0);\n"
    "}\n";

  const char* frag_shader =
    "#version 330 core\n"
    "out vec3 color;\n"
    "void main() {\n"
    "  color = vec3(1, 0, 0);\n"
    "}\n";

  GLint result = GL_FALSE;

  scene->vshader = glCreateShader(GL_VERTEX_SHADER);
  glShaderSource(scene->vshader, 1, &vert_shader, NULL);
  glCompileShader(scene->vshader);
  glGetShaderiv(scene->vshader, GL_COMPILE_STATUS, &result);
  printShaderInfoLog(scene->vshader);

  scene->fshader = glCreateShader(GL_FRAGMENT_SHADER);
  glShaderSource(scene->fshader, 1, &frag_shader, NULL);
  glCompileShader(scene->fshader);
  glGetShaderiv(scene->fshader, GL_COMPILE_STATUS, &result);
  printShaderInfoLog(scene->fshader);

  scene->program = glCreateProgram();
  glAttachShader(scene->program, scene->vshader);
  glAttachShader(scene->program, scene->fshader);
  glLinkProgram(scene->program);
  glGetProgramiv(scene->program, GL_LINK_STATUS, &result);
  printProgramInfoLog(scene->program);

  scene->time_uniform = glGetUniformLocation(scene->program, "time");
  scene->proj_uniform = glGetUniformLocation(scene->program, "proj");

  glDetachShader(scene->program, scene->vshader);
  glDetachShader(scene->program, scene->fshader);
  glDeleteShader(scene->vshader);
  glDeleteShader(scene->fshader);

  return scene;
}

void demoSceneDraw(DemoScene* scene, float aspect_ratio) {
  const GLfloat ortho[4][4] = {
    {1 / aspect_ratio, 0, 0, 0},
    {0, 1, 0, 0},
    {0, 0, -1, 0},
    {0, 0, 0, 1},
  };

  glBindVertexArray(scene->vao);
  glUseProgram(scene->program);
  glEnableVertexAttribArray(0);
  glBindBuffer(GL_ARRAY_BUFFER, scene->vbo);
  glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, NULL);
  glUniform1f(scene->time_uniform, glfwGetTime());
  glUniformMatrix4fv(scene->proj_uniform, 1, GL_FALSE, &ortho[0][0]);
  glDrawArrays(GL_TRIANGLES, 0, 3);
  glDisableVertexAttribArray(0);
}

void demoSceneDelete(DemoScene* scene) {
  glDeleteProgram(scene->program);
  glDeleteBuffers(1, &scene->vbo);
  glDeleteVertexArrays(1, &scene->vao);
  free(scene);
}
