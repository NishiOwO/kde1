cmake_minimum_required(VERSION 3.3.2)

project(kde1
        VERSION 1.1.2
        LANGUAGES C CXX)

if (CMAKE_SYSTEM_NAME MATCHES "NetBSD")
    set(CMAKE_C_FLAGS  "${CMAKE_C_FLAGS} -I/usr/X11R7/include -I/usr/pkg/include -I/usr/local/include -I/usr/kde1/include")
    set(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -I/usr/X11R7/include -I/usr/pkg/include -I/usr/local/include -I/usr/kde1/include")
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -L/usr/X11R7/lib -L/usr/pkg/lib -R/usr/X11R7/lib -R/usr/pkg/lib")
endif()

add_subdirectory(qt1)
add_subdirectory(kdelibs)
add_subdirectory(kdebase)
