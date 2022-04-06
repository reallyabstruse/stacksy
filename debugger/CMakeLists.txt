cmake_minimum_required (VERSION 3.0)
project (stacksydebugger)

add_compile_options(-std=c++2a)

include_directories(libelfin-fbreg linenoise include)
add_executable(debugger debugger.cpp debuggerview.cpp debuginfo.cpp ncursesHelpers.cpp)

set_target_properties(debugger
                      PROPERTIES COMPILE_FLAGS "-g -O0")



add_custom_target(
   libelfin-fbreg
   COMMAND make
   WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}/libelfin-fbreg
)

target_link_libraries(debugger
                      ${PROJECT_SOURCE_DIR}/libelfin-fbreg/dwarf/libdwarf++.so
                      ${PROJECT_SOURCE_DIR}/libelfin-fbreg/elf/libelf++.so
					  panel
					  ncurses)
add_dependencies(debugger libelfin-fbreg)