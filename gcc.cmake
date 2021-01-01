if( ENABLE_DIAGNOSTIC_COLORS )
    if( NOT CMAKE_CXX_COMPILER_ID STREQUAL "GNU" AND NOT CMAKE_CXX_COMPILER_ID MATCHES "Clang" )
        message( FATAL_ERROR "Diagnostic colors could be enabled only for Clang or Gcc" )
    endif( )

    message( STATUS "Diagnostic colors are enabled" )
    if( CMAKE_CXX_COMPILER_ID STREQUAL "GNU" )
        set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fdiagnostics-color=always" )
    else( )
        set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fcolor-diagnostics" )
    endif( )
endif( )
