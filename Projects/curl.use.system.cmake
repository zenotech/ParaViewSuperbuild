find_package(CURL REQUIRED)

add_extra_cmake_args(
  -DCURL_INCLUDE_DIR:PATH=${CURL_INCLUDE_DIRS}
  -DCURL_LIBRARY:FILEPATH=${CURL_LIBRARIES}
)
