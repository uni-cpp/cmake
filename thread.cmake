set( CMAKE_THREAD_PREFER_PTHREAD TRUE )
set( THREADS_PREFER_PTHREAD_FLAG TRUE )

if( NOT ${CMAKE_SYSTEM_NAME} MATCHES "Darwin" )
    find_package( Threads REQUIRED )
    message( STATUS "Thread library - ${CMAKE_THREAD_LIBS_INIT}" )
endif( )
