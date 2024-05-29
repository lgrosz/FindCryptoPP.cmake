#[[
based on https://github.com/riebl/vanetza/blob/aed571d6297258a2a499b9cb4eedb8254d977360/cmake/FindCryptoPP.cmake

Input:
CryptoPP_ROOT_DIR (optional) - specify where CryptoPP was installed
    (e.g. /usr/local or $CMAKE_SOURCE_DIR/3rdparty/usr/local)
    Directory must contain subdirectories include and lib
Output:
CryptoPP::CryptoPP   - target (release build)
CryptoPP_INCLUDE_DIR - includes directory containing subdirectory cryptopp/
CryptoPP_LIBRARY     - CryptoPP library file (libcryptopp.a)
CryptoPP_VERSION     - The version of the library
CryptoPP_VERSION_MAJOR - The major version of the library
CryptoPP_VERSION_MINOR - The minor version of the library
CryptoPP_VERSION_PATCH - The patch version (revision) of the library
CryptoPP_VERSION_STRING - The version of the library (for compatability, use CryptoPP_VERSION instead)
]]

if (CryptoPP_ROOT_DIR)
    # find using CryptoPP_ROOT_DIR ONLY
    find_path(CryptoPP_INCLUDE_DIR
        NAMES cryptopp/config.h
        DOC "CryptoPP include directory"
        NO_DEFAULT_PATH
        PATHS ${CryptoPP_ROOT_DIR}/include
        )
    find_library(CryptoPP_LIBRARY
        NAMES cryptopp
        DOC "CryptoPP library"
        NO_DEFAULT_PATH
        PATHS ${CryptoPP_ROOT_DIR}/lib
        )
    message("PACZPAN with root given: ${CryptoPP_INCLUDE_DIR} ${CryptoPP_LIBRARY}")
else()
    find_path(CryptoPP_INCLUDE_DIR
        NAMES cryptopp/config.h
        DOC "CryptoPP include directory"
        )
    find_library(CryptoPP_LIBRARY
        NAMES cryptopp
        DOC "CryptoPP library"
        NO_PACKAGE_ROOT_PATH
        PATHS "/usr/lib/x86_64-linux-gnu/"
        )
    message("PACZPAN without root given: ${CryptoPP_INCLUDE_DIR} ${CryptoPP_LIBRARY}")
endif(CryptoPP_ROOT_DIR)

if(CryptoPP_INCLUDE_DIR)
    file(STRINGS ${CryptoPP_INCLUDE_DIR}/cryptopp/config.h _config_version REGEX "CRYPTOPP_VERSION")
    string(REGEX MATCH "([0-9]+)([0-9]+)([0-9]+)" _match_version ${_config_version})
    set(CryptoPP_VERSION_MAJOR ${CMAKE_MATCH_1})
    set(CryptoPP_VERSION_MINOR ${CMAKE_MATCH_2})
    set(CryptoPP_VERSION_PATCH ${CMAKE_MATCH_3})
    set(CryptoPP_VERSION "${CryptoPP_VERSION_MAJOR}.${CryptoPP_VERSION_MINOR}.${CryptoPP_VERSION_PATCH}")
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(CryptoPP
    REQUIRED_VARS CryptoPP_INCLUDE_DIR CryptoPP_LIBRARY
    FOUND_VAR CryptoPP_FOUND
    VERSION_VAR CryptoPP_VERSION)

if(CryptoPP_FOUND AND NOT TARGET CryptoPP::CryptoPP)
    add_library(CryptoPP::CryptoPP UNKNOWN IMPORTED)
    set_target_properties(CryptoPP::CryptoPP PROPERTIES
        IMPORTED_LOCATION "${CryptoPP_LIBRARY}"
        INTERFACE_INCLUDE_DIRECTORIES "${CryptoPP_INCLUDE_DIR}")
endif()

mark_as_advanced(CryptoPP_INCLUDE_DIR CryptoPP_LIBRARY)
set(CryptoPP_INCLUDE_DIRS ${CryptoPP_INCLUDE_DIR})
set(CryptoPP_LIBRARIES ${CryptoPP_LIBRARY})
set(CryptoPP_VERSION_STRING ${CryptoPP_VERSION})

