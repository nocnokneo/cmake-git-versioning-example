get_filename_component(SRC_DIR ${SRC} DIRECTORY)

# Generate a git-describe-like version string from Mercurial repository tags
if(HG_EXECUTABLE AND NOT DEFINED VAL_VERSION)
  execute_process(
    COMMAND ${HG_EXECUTABLE} log --rev . --template
      "{latesttag}{sub\('\^-0-.*', '', '-{latesttagdistance}-m{node|short}'\)}"
    WORKING_DIRECTORY ${SRC_DIR}
    OUTPUT_VARIABLE HG_REVISION
    RESULT_VARIABLE HG_LOG_ERROR_CODE
    OUTPUT_STRIP_TRAILING_WHITESPACE
    )

  # Append "-dirty" if the working copy is not clean
  execute_process(
    COMMAND ${HG_EXECUTABLE} id --id
    WORKING_DIRECTORY ${SRC_DIR}
    OUTPUT_VARIABLE HG_ID
    RESULT_VARIABLE HG_ID_ERROR_CODE
    OUTPUT_STRIP_TRAILING_WHITESPACE
    )
  # The hg id ends with '+' if there are uncommitted local changes
  if(HG_ID MATCHES "\\+$")
    set(HG_REVISION "${HG_REVISION}-dirty")
  endif()

  if(NOT HG_LOG_ERROR_CODE AND NOT HG_ID_ERROR_CODE)
    set(FOOBAR_VERSION ${HG_REVISION})
  endif()
endif()

# Generate a git-describe version string from Git repository tags
if(GIT_EXECUTABLE AND NOT DEFINED FOOBAR_VERSION)
  execute_process(
    COMMAND ${GIT_EXECUTABLE} describe --tags --dirty --match "v*"
    WORKING_DIRECTORY ${SRC_DIR}
    OUTPUT_VARIABLE GIT_DESCRIBE_VERSION
    RESULT_VARIABLE GIT_DESCRIBE_ERROR_CODE
    OUTPUT_STRIP_TRAILING_WHITESPACE
    )
  if(NOT GIT_DESCRIBE_ERROR_CODE)
    set(FOOBAR_VERSION ${GIT_DESCRIBE_VERSION})
  endif()
endif()

# Final fallback: Just use a bogus version string that is semantically older
# than anything else and spit out a warning to the developer.
if(NOT DEFINED FOOBAR_VERSION)
  set(FOOBAR_VERSION v0.0.0-unknown)
  message(WARNING "Failed to determine FOOBAR_VERSION from repository tags. Using default version \"${FOOBAR_VERSION}\".")
endif()

configure_file(${SRC} ${DST} @ONLY)
