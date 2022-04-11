#include <inttypes.h>
#include <signal.h>
#include <unistd.h>

#include <iostream>

#include "fem_app.h"

int main() {
  // Init gl window
  glfwInit();
  glfwWindowHint(GLFW_CLIENT_API, GLFW_NO_API);
  GLFWwindow* window = glfwCreateWindow(512, 512, "Taichi show", NULL, NULL);
  if (window == NULL) {
    std::cout << "Failed to create GLFW window" << std::endl;
    glfwTerminate();
    return -1;
  }

  FemApp app;
  app.run_init(/*width=*/512, /*height=*/512, "../../", window);

  while (!glfwWindowShouldClose(window)) {
    app.run_render_loop();

    glfwSwapBuffers(window);
    glfwPollEvents();
  }

  app.cleanup();

  return 0;
}
