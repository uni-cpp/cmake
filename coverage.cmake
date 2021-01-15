find_program( GCOV gcov )

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

#####################
# Coverage generators
#####################

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
    set( GENHTML_OPTIONS "coverage.info --output-directory out --function-coverage --legend --demangle-cpp" )
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

    # CMAKE_CURRENT_SOURCE_DIR probably will be more reliable
    set( GCOVR_OPTIONS "--root ${CMAKE_CURRENT_SOURCE_DIR} --html --html-details --output index.html --object-directory ${CMAKE_BINARY_DIR}" )

    message( STATUS "GCOVR code coverage generator is enabled" )
endif( )

function( generate_coverage PROJECT_NAME )
    if( USE_LCOV )
        set( LCOV_FILTER_OPTIONS "--include \"*${PROJECT_NAME}*\"" )
        # TODO exclude all tests and apps files
        set( LCOV_FULL_COMMAND "${LCOV} ${LCOV_OPTIONS} ${LCOV_FILTER_OPTIONS}" )
        separate_arguments( LCOV_FULL_COMMAND )
        set( GENHTML_FULL_COMMAND "${GENHTML} ${GENHTML_OPTIONS}" )
        separate_arguments( GENHTML_FULL_COMMAND )
        add_custom_target( ${PROJECT_NAME}_coverage ALL
                           COMMAND ${LCOV_FULL_COMMAND}
                           COMMAND ${GENHTML_FULL_COMMAND}
                           DEPENDS ${PROJECT_NAME}_run )
    elseif( USE_GCOVR )
        # TODO add filters
        set( GCOVR_FULL_COMMAND "${GCOVR} ${GCOVR_OPTIONS}" )
        separate_arguments( GCOVR_FULL_COMMAND )
        add_custom_target( ${PROJECT_NAME}_coverage ALL
                           COMMAND ${GCOVR_FULL_COMMAND}
                           DEPENDS ${PROJECT_NAME}_run )
    else( )
        message( FATAL_ERROR "Coverage generator LCOV or GCOVR should be acivated" )
    endif( )
endfunction( )
