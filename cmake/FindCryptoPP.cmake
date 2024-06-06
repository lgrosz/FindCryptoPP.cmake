#[[
Output:
CryptoPP::CryptoPP   - target (release build)
CryptoPP_INCLUDE_DIR - includes directory containing subdirectory cryptopp/
CryptoPP_LIBRARY     - CryptoPP library file (libcryptopp.a)
CryptoPP_VERSION     - The version of the library
CryptoPP_VERSION_MAJOR - The major version of the library
CryptoPP_VERSION_MINOR - The minor version of the library
CryptoPP_VERSION_PATCH - The patch version (revision) of the library
CryptoPP_VERSION_VV  - Whether or not version VV has been found
CryptoPP_VERSION_STRING - The version of the library (for compatability, use CryptoPP_VERSION instead)
]]

find_path(CryptoPP_INCLUDE_DIR NAMES cryptopp/config.h DOC "CryptoPP include directory")
find_library(CryptoPP_LIBRARY NAMES cryptopp DOC "CryptoPP library")
find_file(CryptoPP_VERSION_HEADER NAMES cryptopp/config_ver.h)

# Determine version from headers
if(CryptoPP_INCLUDE_DIR)
    find_file(CryptoPP_VERSION_HEADER NAMES cryptopp/config_ver.h PATHS ${CryptoPP_INCLUDE_DIR} NO_DEFAULT_PATH)
    find_file(CryptoPP_CONFIG_HEADER NAMES cryptopp/config.h PATHS ${CryptoPP_INCLUDE_DIR} NO_DEFAULT_PATH)

    if (CryptoPP_VERSION_HEADER)
        # Since CryptoPP 8.3, version information is housed in config_ver.h
        file(READ ${CryptoPP_VERSION_HEADER} version_content)
        string(REGEX MATCHALL "#define[ \\t\\r\\n]+CRYPTOPP_MAJOR[ \\t\\r\\n]+([0-9]+)" _ "${version_content}")
        set(CryptoPP_VERSION_MAJOR ${CMAKE_MATCH_1})
        string(REGEX MATCHALL "#define[ \\t\\r\\n]+CRYPTOPP_MINOR[ \\t\\r\\n]+([0-9]+)" _ "${version_content}")
        set(CryptoPP_VERSION_MINOR ${CMAKE_MATCH_1})
        string(REGEX MATCHALL "#define[ \\t\\r\\n]+CRYPTOPP_REVISION[ \\t\\r\\n]+([0-9]+)" _ "${version_content}")
        set(CryptoPP_VERSION_PATCH ${CMAKE_MATCH_1})
    elseif(CryptoPP_CONFIG_HEADER)
        file(STRINGS ${CryptoPP_INCLUDE_DIR}/cryptopp/config.h _config_version REGEX "CRYPTOPP_VERSION")
        string(REGEX MATCH "([0-9]+)([0-9]+)([0-9]+)" _match_version ${_config_version})
        set(CryptoPP_VERSION_MAJOR ${CMAKE_MATCH_1})
        set(CryptoPP_VERSION_MINOR ${CMAKE_MATCH_2})
        set(CryptoPP_VERSION_PATCH ${CMAKE_MATCH_3})
    endif()

    # Clean-up variables
    unset(CryptoPP_VERSION_HEADER)
    unset(CryptoPP_CONFIG_HEADER)
endif()

set(CryptoPP_VERSION "${CryptoPP_VERSION_MAJOR}.${CryptoPP_VERSION_MINOR}.${CryptoPP_VERSION_PATCH}")
set(CryptoPP_VERSION_${CryptoPP_VERSION_MAJOR} TRUE)

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
