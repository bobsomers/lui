solution "lui"
  location "build"
  configurations { "Debug", "Release" }

  project "nanovg"
    language "C"
    kind "StaticLib"
    includedirs { "deps/nanovg/src" }
    files { "deps/nanovg/src/*.c" }
    targetdir "build"

    configuration "Debug"
      defines { "DEBUG" }
      flags {
        "Symbols",
        "ExtraWarnings",
      }

    configuration "Release"
      defines { "NDEBUG" }
      flags {
        "OptimizeSpeed",
        "ExtraWarnings",
      }

  project "yoga"
    language "C"
    kind "StaticLib"
    includedirs { "deps/yoga/src" }
    files { "deps/yoga/src/*.c" }
    targetdir "build"

    configuration "Debug"
      defines { "DEBUG" }
      flags {
        "Symbols",
        "ExtraWarnings",
      }

    configuration "Release"
      defines { "NDEBUG " }
      flags {
        "OptimizeSpeed",
        "ExtraWarnings",
      }

  project "lui"
    kind "ConsoleApp"
    language "C"
    includedirs {
      "src",
      "deps/nanovg/src",
      "deps/yoga/src",
    }
    files { "src/*.c" }
    targetdir "build"
    links {
      "m",
      "epoxy",
      "glfw",
      "nanovg",
      "yoga",
    }

    configuration "Debug"
      defines { "DEBUG" }
      flags {
        "Symbols",
        "ExtraWarnings",
      }

    configuration "Release"
      defines { "NDEBUG" }
      flags {
        "OptimizeSpeed",
        "Symbols",
        "ExtraWarnings",
      }

    configuration { "macosx" }
      linkoptions {
        "-framework OpenGL",
        "-framework Cocoa",
        "-framework IOKit",
        "-framework CoreVideo",
        "-framework Carbon",
        "-pagezero_size 10000",
        "-image_base 100000000",
      }
      links {
        "luajit",
      }

    configuration { "linux" }
      linkoptions {
        "-Wl,-export-dynamic -lluajit-5.1",
      }
