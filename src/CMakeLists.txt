cmake_minimum_required(VERSION 3.10)
project(llama_api VERSION 1.0)

# Define the source files for the library
set(LIBRARY_SOURCES
    llama_api.c
)

# Add the library target
# SHARED creates a shared library (.so on Linux, .dll on Windows)
# STATIC creates a static library (.a on Linux, .lib on Windows)
add_library(llama_api SHARED ${LIBRARY_SOURCES})

# Specify public include directories for consumers of the library
target_include_directories(llama_api PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:include>
)

# (Optional) Install rules for the library and its headers
install(TARGETS llama_api DESTINATION lib)
install(DIRECTORY include/ DESTINATION include)