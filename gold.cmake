if( CMAKE_USE_GOLD )
    find_program( GOLD ld.gold )
    if( NOT GOLD )
        message( FATAL_ERROR "GOLD linker requested but not found" )
    endif( )

    set( GOLD_LINKER_FLAGS "-fuse-ld=gold -Wl,--fatal-warnings" )
    message( STATUS "GOLD linker is enabled" )

    if( ENABLE_MULTITHREADING_LINKAGE )
        set( MULTITHREADING_LINKAGE_FLAGS "-Wl,--threads" )
        message( STATUS "GOLD linker's multithreading is enabled" )
    endif( )

    set( CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${GOLD_LINKER_FLAGS} ${THREADS_LINKER_FLAGS}" )
    set( CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} ${GOLD_LINKER_FLAGS} ${THREADS_LINKER_FLAGS}" )
    set( CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} ${GOLD_LINKER_FLAGS} ${THREADS_LINKER_FLAGS}" )
endif( )
