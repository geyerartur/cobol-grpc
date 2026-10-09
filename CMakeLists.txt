cmake_minimum_required(VERSION 3.20)

project(cobol-grpc LANGUAGES NONE)

find_package(Git REQUIRED)
find_program(COBC_EXECUTABLE NAMES cobc REQUIRED)
get_filename_component(COBC_BIN_DIR "${COBC_EXECUTABLE}" DIRECTORY)

set(MODULE_NAME "cobol-grpc" CACHE STRING "Name of the generated COBOL module")
set(COBFLAGS "-free -Wall" CACHE STRING "Flags passed to cobc")
set(COPYBOOK_DIRS "copybooks" CACHE STRING "Semicolon-separated copybook directories")

separate_arguments(COBFLAGS_LIST NATIVE_COMMAND "${COBFLAGS}")

set(COPYBOOK_FLAGS)
set(COPYBOOKS)
foreach(copybook_dir IN LISTS COPYBOOK_DIRS)
    if(IS_ABSOLUTE "${copybook_dir}")
        set(resolved_copybook_dir "${copybook_dir}")
    else()
        set(resolved_copybook_dir "${CMAKE_SOURCE_DIR}/${copybook_dir}")
    endif()

    list(APPEND COPYBOOK_FLAGS "-I${resolved_copybook_dir}")
    file(GLOB dir_copybooks CONFIGURE_DEPENDS "${resolved_copybook_dir}/*.cpy")
    list(APPEND COPYBOOKS ${dir_copybooks})
endforeach()

file(GLOB COBOL_SOURCES CONFIGURE_DEPENDS
    "${CMAKE_SOURCE_DIR}/src/*.cob"
    "${CMAKE_SOURCE_DIR}/src/*.cbl"
)

if(NOT COBOL_SOURCES)
    message(FATAL_ERROR "No COBOL sources found in src/.")
endif()

set(MODULE_EXT "${CMAKE_SHARED_LIBRARY_SUFFIX}")
if(MODULE_EXT STREQUAL "")
    set(MODULE_EXT ".so")
endif()

set(MODULE_FILE "${CMAKE_BINARY_DIR}/${MODULE_NAME}${MODULE_EXT}")

add_custom_command(
    OUTPUT "${MODULE_FILE}"
    COMMAND "${COBC_EXECUTABLE}" -b ${COBFLAGS_LIST} ${COPYBOOK_FLAGS} -o "${MODULE_FILE}" ${COBOL_SOURCES}
    DEPENDS ${COBOL_SOURCES} ${COPYBOOKS}
    COMMENT "Building COBOL module ${MODULE_FILE}"
    VERBATIM
)

add_custom_target(cobol_module ALL DEPENDS "${MODULE_FILE}")

set(TEST_SOURCE "${CMAKE_SOURCE_DIR}/tests/smoke.cbl")
set(TEST_BIN "${CMAKE_BINARY_DIR}/smoke${CMAKE_EXECUTABLE_SUFFIX}")

add_custom_command(
    OUTPUT "${TEST_BIN}"
    COMMAND "${COBC_EXECUTABLE}" -x ${COBFLAGS_LIST} ${COPYBOOK_FLAGS} -o "${TEST_BIN}" "${TEST_SOURCE}"
    DEPENDS "${TEST_SOURCE}" ${COPYBOOKS}
    COMMENT "Building smoke test executable"
    VERBATIM
)

add_custom_target(smoke_bin DEPENDS "${TEST_BIN}")

add_custom_target(git_hooks
    COMMAND "${GIT_EXECUTABLE}" -C "${CMAKE_SOURCE_DIR}" config --local core.hooksPath .githooks
    COMMENT "Activating repository git hooks"
    VERBATIM
)

add_custom_target(info
    COMMAND "${COBC_EXECUTABLE}" --version
    COMMENT "Printing cobc version"
    VERBATIM
)

enable_testing()

add_test(
    NAME smoke
    COMMAND "${CMAKE_COMMAND}" -E env
        "COB_LIBRARY_PATH=${CMAKE_BINARY_DIR}"
        "PATH=${COBC_BIN_DIR};$ENV{PATH}"
        "${TEST_BIN}"
)

add_custom_target(check
    COMMAND "${CMAKE_CTEST_COMMAND}" --output-on-failure
    DEPENDS cobol_module smoke_bin
    COMMENT "Running smoke test"
    VERBATIM
)
