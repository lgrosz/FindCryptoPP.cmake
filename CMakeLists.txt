# Sample project that uses CryptoPP

project(cryptopp_user)
add_executable(${PROJECT_NAME} "main.cpp")

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake") # needed to find the FindModule
set (CryptoPP_ROOT_DIR /pro/cmake_tests/inst/usr/local/) # only needed if CryptoPP is installed in non-standard directory
find_package(CryptoPP 5 REQUIRED)
target_link_libraries(${PROJECT_NAME} PRIVATE CryptoPP::CryptoPP)
