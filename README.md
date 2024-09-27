# bazel-cgo

## Steps to show that the code works

1. Run server go code:

```
go mod init bazel-cgo
go mod tidy
go run zmq_server.go
```

2. Run client Go code:

```
go run zmq_client.go
```

Observe that the server and client code work as expected.

## Steps to reproduce Bazel build failure

```
bazel build //...
```

which produces this error:

```
INFO: Analyzed 2 targets (0 packages loaded, 0 targets configured).
ERROR: /private/var/tmp/_bazel_htie/20c187929af89a4b25912a1ae815433e/external/gazelle~~go_deps~com_github_pebbe_zmq4/BUILD.bazel:3:11: GoCompilePkg external/gazelle~~go_deps~com_github_pebbe_zmq4/zmq4.a failed: (Exit 1): builder failed: error executing GoCompilePkg command (from target @@gazelle~~go_deps~com_github_pebbe_zmq4//:zmq4) bazel-out/darwin_arm64-opt-exec-ST-d57f47055a04/bin/external/rules_go~~go_sdk~bazel-cgo__download_0/builder_reset/builder compilepkg -sdk external/rules_go~~go_sdk~bazel-cgo__download_0 -goroot ... (remaining 69 arguments skipped)

Use --sandbox_debug to see verbose messages from the sandbox and retain the sandbox build root for debugging
_main/external/gazelle~~go_deps~com_github_pebbe_zmq4/auth.go:19:10: fatal error: 'zmq.h' file not found
#include <zmq.h>
         ^~~~~~~
1 error generated.
compilepkg: error running subcommand external/rules_go~~go_sdk~bazel-cgo__download_0/pkg/tool/darwin_arm64/cgo: exit status 2
Use --verbose_failures to see the command lines of failed build steps.
INFO: Elapsed time: 0.322s, Critical Path: 0.09s
INFO: 2 processes: 2 internal.
ERROR: Build did NOT complete successfully
```

Despite the fact that `zmq.h` is present inside `@libzmq//:libzmq_headers_only`.

Q: How to make `com_github_pebbe_zmq4` see `zmq.h` in Bazel?
