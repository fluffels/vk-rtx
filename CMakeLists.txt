cmake_minimum_required (VERSION 3.0)
set (CMAKE_CXX_STANDARD 17)

project (vk-rtx)

find_package(Vulkan REQUIRED)

set(GLSL_VALIDATOR "$ENV{VULKAN_SDK}/Bin/glslc.exe")
file(GLOB_RECURSE GLSL_FILES "shaders/*.comp" "shaders/*.vert" "shaders/*.frag" "shaders/*.mesh")
foreach(GLSL_FILE ${GLSL_FILES})
    set(SPIRV_FILE "${GLSL_FILE}.spv")
    add_custom_command(
        OUTPUT ${SPIRV_FILE}
        COMMAND ${GLSL_VALIDATOR} ${GLSL_FILE} -o ${SPIRV_FILE}
        DEPENDS ${GLSL_FILE}
    )
    list(APPEND SPIRV_FILES ${SPIRV_FILE})
endforeach(GLSL_FILE)
add_custom_target(Shaders ALL DEPENDS ${SPIRV_FILES})

include_directories(${CMAKE_HOME_DIRECTORY}/src)
include_directories(${CMAKE_HOME_DIRECTORY}/lib)
include_directories(${Vulkan_INCLUDE_DIRS})
add_executable (
    main
    WIN32
    Shaders
    lib/SPIRV-Reflect/spirv_reflect.c
    src/Main.cpp
)
target_link_libraries(
    main
    ${Vulkan_LIBRARIES}
    dinput8.lib
    dxguid.lib
)
