if( ADDRESS_SANITIZER )
    # https://clang.llvm.org/docs/AddressSanitizer.html
    message( STATUS "Enabled address sanitizer" )
    set( ASAN_FLAGS "-fsanitize=address -fsanitize-recover=address" )
    set( ASAN_ADDITIONAL_FLAGS "-fno-omit-frame-pointer -fno-optimize-sibling-calls" )
    set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${ASAN_FLAGS} ${ASAN_ADDITIONAL_FLAGS}" )
    set( CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${ASAN_FLAGS}" )
    set( CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} ${ASAN_FLAGS}" )
endif( )

if( UNDEFINED_SANITIZER )
    # https://developer.apple.com/documentation/code_diagnostics/undefined_behavior_sanitizer/enabling_the_undefined_behavior_sanitizer
    message( STATUS "Enabled undefined behavior sanitizer" )
    set( UBSAN_FLAGS "-fsanitize=undefined,float-cast-overflow -fsanitize-recover=undefined" )
    set( UBSAN_ADDITIONAL_FLAGS "-fno-omit-frame-pointer" )
    set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${UBSAN_FLAGS} ${UBSAN_ADDITIONAL_FLAGS}" )
    set( CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${UBSAN_FLAGS}" )
endif( )

if( THREAD_SANITIZER )
    # https://clang.llvm.org/docs/ThreadSanitizer.html
    message( STATUS "Enabled thread sanitizer" )
    set( TSAN_FLAGS "-fsanitize=thread" )
    set( TSAN_ADDITIONAL_FLAGS "-fno-omit-frame-pointer" )
    set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${TSAN_FLAGS} ${TSAN_ADDITIONAL_FLAGS}" )
    set( CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${TSAN_FLAGS}" )
endif( )

if( MEMORY_SANITIZER )
    # https://clang.llvm.org/docs/MemorySanitizer.html
    message( WARNING "Memory sanitizer will be added later. Skipped." )
    set( MSAN_ADDITIONAL_FLAGS "-fno-omit-frame-pointer -fno-optimize-sibling-calls" )
endif( )
