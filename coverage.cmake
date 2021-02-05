find_program( GCOV gcov )

##########################################
# Basic checks
##########################################

if( CODE_COVERAGE AND GCOV)
    message( STATUS "Code coverage requested and will be used" )
    set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fprofile-arcs -ftest-coverage" )
#    set( CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -coverage -lgcov" )

    if( NOT CMAKE_BUILD_TYPE STREQUAL "Debug" )
        message( WARNING "Code coverage build type is not DEBUG, results will be misleading" )
    endif( )
elseif ( CODE_COVERAGE )
    message( FATAL_ERROR "Code coverage requested, but GCOV not found" )
else( )
    # message( STATUS "Code coverage is not requested." )
    return( )
endif( )

##########################################
# Coverage generators
##########################################

set( COVERAGE_OUTPUT_DIR_NAME "out" )

if( USE_LCOV)
    find_program( LCOV lcov )
    if( NOT LCOV )
        message( FATAL_ERROR "LCOV requested but not found" )
    endif( )

    find_program( GENHTML genhtml )
    if( NOT GENHTML )
        message( FATAL_ERROR "GENHTML requested but not found" )
    endif( )

    set( LCOV_OPTIONS "--capture --directory . --output-file coverage.info" )
    # --demangle-cpp required c++filt
    set( GENHTML_OPTIONS "coverage.info --output-directory ${COVERAGE_OUTPUT_DIR_NAME} --function-coverage --legend --demangle-cpp" )
    if( BRANCH_COVERAGE )
        set( GENHTML_OPTIONS "${GENHTML_OPTIONS} --branch-coverage" )
    endif( )

    message( STATUS "LCOV/GENHTML code coverage generator is enabled with BRANCH_COVERAGE=${BRANCH_COVERAGE}" )
endif( )

if( USE_GCOVR )
    find_program( GCOVR gcovr )
    if( NOT GCOVR )
        message( FATAL_ERROR "GCOVR requested but not found" )
    endif( )

    set( GCOVR_OPTIONS "--html --html-details --output ${COVERAGE_OUTPUT_DIR_NAME}/index.html" )

    message( STATUS "GCOVR code coverage generator is enabled" )
endif( )

##########################################
# Function for CMakeLists.txt
##########################################

set( RUN_POSTFIX "run" )
set( COVERAGE_POSTFIX "coverage" )

# TODO DEPENDED_TESTS should be ARGV
function( generate_coverage PROJECT_NAME DEPENDED_TESTS)
    set( ALL_DEPENDED_TESTS ${DEPENDED_TESTS}_${RUN_POSTFIX} )
    set( COVERAGE_TARGET_NAME ${PROJECT_NAME}_${COVERAGE_POSTFIX} )

    if( USE_LCOV )
        # set( LCOV_FILTER_OPTIONS "--include \"*${PROJECT_NAME}*\"" )
        set( LCOV_FULL_COMMAND "${LCOV} ${LCOV_OPTIONS} ${LCOV_FILTER_OPTIONS}" )
        separate_arguments( LCOV_FULL_COMMAND )
        set( GENHTML_FULL_COMMAND "${GENHTML} ${GENHTML_OPTIONS}" )
        separate_arguments( GENHTML_FULL_COMMAND )
        add_custom_target( ${COVERAGE_TARGET_NAME} ALL
                           COMMAND ${LCOV_FULL_COMMAND}
                           COMMAND ${GENHTML_FULL_COMMAND}
                           COMMENT "Generating coverage using LCOV for ${PROJECT_NAME}. Depended tests: ${DEPENDED_TESTS}"
                           DEPENDS ${ALL_DEPENDED_TESTS} )
    elseif( USE_GCOVR )
        # TODO add filters
        set( GCOVR_ADDITIONAL_OPTIONS "--root ${CMAKE_CURRENT_SOURCE_DIR} --object-directory ${CMAKE_CURRENT_BINARY_DIR}" )
        set( GCOVR_FULL_COMMAND "${GCOVR} ${GCOVR_OPTIONS}" ${GCOVR_ADDITIONAL_OPTIONS} )
        separate_arguments( GCOVR_FULL_COMMAND )
        add_custom_target( ${COVERAGE_TARGET_NAME} ALL
                           COMMAND ${CMAKE_COMMAND} -E make_directory ${COVERAGE_OUTPUT_DIR_NAME}
                           COMMAND ${GCOVR_FULL_COMMAND}
                           COMMENT "Generating coverage using GCOVR for ${PROJECT_NAME}. Depended tests: ${DEPENDED_TESTS}"
                           DEPENDS ${ALL_DEPENDED_TESTS} )
    else( )
        message( FATAL_ERROR "Coverage generator LCOV or GCOVR should be acivated" )
    endif( )
endfunction( )
