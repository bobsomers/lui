solution "Thermyte"
  configurations { "Debug", "Release" }

  project "thermyte"
    kind "ConsoleApp"
    language "C"
    files {
      "src/**.h",
      "src/**.c"
    }

    configuration "Debug"
      defines { "DEBUG" }
      flags { "Symbols" }

    configuration "Release"
      defines { "NDEBUG" }
      flags { "Optimize", "Symbols" }
