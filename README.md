Project Versioning with CMake and Git
=====================================

This example project demonstratates how to use CMake and Git to generate a
version string header file in a robust way. In particular, it:

  - Produces a meaningful version string that is also a valid git revision
    specifier and always monotonically increasing. These version strings look
    like like:

    - `v1.0.1`

      - A clean working copy at tag `v1.0.1`

    - `v1.0.1-13-g1234abc`

      - A clean working copy at git revision `1234abc` which is 13 commits
        ahead of the most recent tag `v1.0.1`

    - `v1.0.1-13-g1234abc-dirty`

      - The same as above, but for a dirty working copy (with uncommited
        changes to tracked files)

  - Regenerates foobar_version.h whenever the version changes - even if the
    source files themselves did not changes (e.g after creating a new tag).

  - Does NOT regenerate or touch foobar_version.h if the version has not
    changed.

  - Warns if the version cannot be determined from Git tags and proceeds using
    a default version of "v0.0.0-unknown".
