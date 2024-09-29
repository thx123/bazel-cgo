# bazel-cgo

## Steps to show that the Go code works

1. Clone this repo:

```
git clone https://github.com/thx123/bazel-cgo.git
cd bazel-cgo
```

2. Run server go code:

```
go mod init bazel-cgo
go mod tidy
go run zmq_server.go
```

3. Run client Go code:

```
go run zmq_client.go
```

Observe that the server and client code work as expected.

## Steps to show that the Go code still works when invoked via bazel

```
bazel run @rules_go//go run zmq_server.go
```

```
bazel run @rules_go//go run zmq_client.go
```

## Steps to reproduce Bazel build failure

```
bazel build //...
```

which produces this error on Apple M3 Pro [14.6.1 (23G93)]:

```
INFO: Analyzed 2 targets (110 packages loaded, 12370 targets configured).
ERROR: /private/var/tmp/_bazel_htie/20c187929af89a4b25912a1ae815433e/external/gazelle~~go_deps~com_github_pebbe_zmq4/BUILD.bazel:3:11: GoCompilePkg external/gazelle~~go_deps~com_github_pebbe_zmq4/zmq4.a failed: (Exit 1): builder failed: error executing GoCompilePkg command (from target @@gazelle~~go_deps~com_github_pebbe_zmq4//:zmq4) bazel-out/darwin_arm64-opt-exec-ST-d57f47055a04/bin/external/rules_go~~go_sdk~bazel-cgo__download_0/builder_reset/builder compilepkg -sdk external/rules_go~~go_sdk~bazel-cgo__download_0 -goroot ... (remaining 69 arguments skipped)

Use --sandbox_debug to see verbose messages from the sandbox and retain the sandbox build root for debugging
_main/external/gazelle~~go_deps~com_github_pebbe_zmq4/auth.go:19:10: fatal error: 'zmq.h' file not found
#include <zmq.h>
         ^~~~~~~
1 error generated.
compilepkg: error running subcommand external/rules_go~~go_sdk~bazel-cgo__download_0/pkg/tool/darwin_arm64/cgo: exit status 2
Use --verbose_failures to see the command lines of failed build steps.
INFO: Elapsed time: 17.849s, Critical Path: 16.76s
INFO: 14 processes: 12 internal, 2 darwin-sandbox.
ERROR: Build did NOT complete successfully
```

And this error on Ubuntu 20.04:

```
INFO: Invocation ID: b63f9e52-c902-4850-9a79-61986a9d69d9
INFO: Analyzed 2 targets (2 packages loaded, 25 targets configured).
ERROR: /home/htie/coding/bazel-cgo/BUILD.bazel:3:10: GoLink zmq_client_/zmq_client failed: (Exit 1): builder failed: error executing GoLink command (from target //:zmq_client) bazel-out/k8-opt-exec-ST-d57f47055a04/bin/external/rules_go~~go_sdk~bazel-cgo__download_0/builder_reset/builder link -sdk external/rules_go~~go_sdk~bazel-cgo__download_0 -installsuffix linux_amd64 -arc ... (remaining 19 arguments skipped)

Use --sandbox_debug to see verbose messages from the sandbox and retain the sandbox build root for debugging
external/rules_go~~go_sdk~bazel-cgo__download_0/pkg/tool/linux_amd64/link: running /usr/bin/gcc failed: exit status 1
/usr/bin/gcc -m64 -s -o bazel-out/k8-fastbuild/bin/zmq_client_/zmq_client -Wl,--export-dynamic-symbol=_cgo_panic -Wl,--export-dynamic-symbol=_cgo_topofstack -Wl,--export-dynamic-symbol=crosscall2 -Wl,--compress-debug-sections=zlib /tmp/go-link-3712729980/go.o /tmp/go-link-3712729980/000000.o /tmp/go-link-3712729980/000001.o /tmp/go-link-3712729980/000002.o /tmp/go-link-3712729980/000003.o /tmp/go-link-3712729980/000004.o /tmp/go-link-3712729980/000005.o /tmp/go-link-3712729980/000006.o /tmp/go-link-3712729980/000007.o /tmp/go-link-3712729980/000008.o /tmp/go-link-3712729980/000009.o /tmp/go-link-3712729980/000010.o /tmp/go-link-3712729980/000011.o /tmp/go-link-3712729980/000012.o /tmp/go-link-3712729980/000013.o /tmp/go-link-3712729980/000014.o /tmp/go-link-3712729980/000015.o /tmp/go-link-3712729980/000016.o /tmp/go-link-3712729980/000017.o /tmp/go-link-3712729980/000018.o /tmp/go-link-3712729980/000019.o /tmp/go-link-3712729980/000020.o /tmp/go-link-3712729980/000021.o /tmp/go-link-3712729980/000022.o /tmp/go-link-3712729980/000023.o /tmp/go-link-3712729980/000024.o /tmp/go-link-3712729980/000025.o /tmp/go-link-3712729980/000026.o /tmp/go-link-3712729980/000027.o /tmp/go-link-3712729980/000028.o /tmp/go-link-3712729980/000029.o /tmp/go-link-3712729980/000030.o -fuse-ld=gold -B/usr/bin -Wl,-no-as-needed -Wl,-z,relro,-z,now -pass-exit-codes -Wl,--push-state,-as-needed -Wl,--pop-state -Wl,--push-state,-as-needed -lm -Wl,--pop-state -pthread -fuse-ld=gold -B/usr/bin -Wl,-no-as-needed -Wl,-z,relro,-z,now -pass-exit-codes -Wl,--push-state,-as-needed -Wl,--pop-state -Wl,--push-state,-as-needed -lm -Wl,--pop-state -pthread -lpthread -fuse-ld=gold -B/usr/bin -Wl,-no-as-needed -Wl,-z,relro,-z,now -pass-exit-codes -Wl,--push-state,-as-needed -Wl,--pop-state -Wl,--push-state,-as-needed -lm -Wl,--pop-state -pthread -lresolv -no-pie -fuse-ld=gold -B/usr/bin -Wl,-no-as-needed -Wl,-z,relro,-z,now -pass-exit-codes -Wl,--push-state,-as-needed -Wl,--pop-state -Wl,--push-state,-as-needed -lm -Wl,--pop-state
/tmp/go-link-3712729980/000003.o:errors.cgo2.c:function _cgo_2acdb4f1918b_Cfunc_zmq_strerror: error: undefined reference to 'zmq_strerror'
/tmp/go-link-3712729980/000008.o:wrappers_unix.cgo2.c:function zmq4_bind: error: undefined reference to 'zmq_bind'
/tmp/go-link-3712729980/000008.o:wrappers_unix.cgo2.c:function zmq4_close: error: undefined reference to 'zmq_close'
/tmp/go-link-3712729980/000008.o:wrappers_unix.cgo2.c:function zmq4_connect: error: undefined reference to 'zmq_connect'
/tmp/go-link-3712729980/000008.o:wrappers_unix.cgo2.c:function zmq4_ctx_get: error: undefined reference to 'zmq_ctx_get'
/tmp/go-link-3712729980/000008.o:wrappers_unix.cgo2.c:function zmq4_ctx_new: error: undefined reference to 'zmq_ctx_new'
/tmp/go-link-3712729980/000008.o:wrappers_unix.cgo2.c:function zmq4_ctx_set: error: undefined reference to 'zmq_ctx_set'
/tmp/go-link-3712729980/000008.o:wrappers_unix.cgo2.c:function zmq4_ctx_term: error: undefined reference to 'zmq_ctx_term'
/tmp/go-link-3712729980/000008.o:wrappers_unix.cgo2.c:function zmq4_curve_keypair: error: undefined reference to 'zmq_curve_keypair'
/tmp/go-link-3712729980/000008.o:wrappers_unix.cgo2.c:function zmq4_curve_public: error: undefined reference to 'zmq_curve_public'
/tmp/go-link-3712729980/000008.o:wrappers_unix.cgo2.c:function zmq4_disconnect: error: undefined reference to 'zmq_disconnect'
/tmp/go-link-3712729980/000008.o:wrappers_unix.cgo2.c:function zmq4_getsockopt: error: undefined reference to 'zmq_getsockopt'
/tmp/go-link-3712729980/000008.o:wrappers_unix.cgo2.c:function zmq4_msg_gets: error: undefined reference to 'zmq_msg_gets'
/tmp/go-link-3712729980/000008.o:wrappers_unix.cgo2.c:function zmq4_msg_recv: error: undefined reference to 'zmq_msg_recv'
/tmp/go-link-3712729980/000008.o:wrappers_unix.cgo2.c:function zmq4_poll: error: undefined reference to 'zmq_poll'
/tmp/go-link-3712729980/000008.o:wrappers_unix.cgo2.c:function zmq4_proxy: error: undefined reference to 'zmq_proxy'
/tmp/go-link-3712729980/000008.o:wrappers_unix.cgo2.c:function zmq4_proxy_steerable: error: undefined reference to 'zmq_proxy_steerable'
/tmp/go-link-3712729980/000008.o:wrappers_unix.cgo2.c:function zmq4_send: error: undefined reference to 'zmq_send'
/tmp/go-link-3712729980/000008.o:wrappers_unix.cgo2.c:function zmq4_setsockopt: error: undefined reference to 'zmq_setsockopt'
/tmp/go-link-3712729980/000008.o:wrappers_unix.cgo2.c:function zmq4_socket: error: undefined reference to 'zmq_socket'
/tmp/go-link-3712729980/000008.o:wrappers_unix.cgo2.c:function zmq4_socket_monitor: error: undefined reference to 'zmq_socket_monitor'
/tmp/go-link-3712729980/000008.o:wrappers_unix.cgo2.c:function zmq4_unbind: error: undefined reference to 'zmq_unbind'
/tmp/go-link-3712729980/000009.o:zmq4.cgo2.c:function zmq4_get_event40: error: undefined reference to 'zmq_msg_data'
/tmp/go-link-3712729980/000009.o:zmq4.cgo2.c:function zmq4_get_event41: error: undefined reference to 'zmq_msg_data'
/tmp/go-link-3712729980/000009.o:zmq4.cgo2.c:function _cgo_2acdb4f1918b_Cfunc_zmq_has: error: undefined reference to 'zmq_has'
/tmp/go-link-3712729980/000009.o:zmq4.cgo2.c:function _cgo_2acdb4f1918b_Cfunc_zmq_msg_close: error: undefined reference to 'zmq_msg_close'
/tmp/go-link-3712729980/000009.o:zmq4.cgo2.c:function _cgo_2acdb4f1918b_Cfunc_zmq_msg_data: error: undefined reference to 'zmq_msg_data'
/tmp/go-link-3712729980/000009.o:zmq4.cgo2.c:function _cgo_2acdb4f1918b_Cfunc_zmq_msg_init: error: undefined reference to 'zmq_msg_init'
/tmp/go-link-3712729980/000009.o:zmq4.cgo2.c:function _cgo_2acdb4f1918b_Cfunc_zmq_version: error: undefined reference to 'zmq_version'
/tmp/go-link-3712729980/000009.o:zmq4.cgo2.c:function _cgo_2acdb4f1918b_Cfunc_zmq_z85_decode: error: undefined reference to 'zmq_z85_decode'
/tmp/go-link-3712729980/000009.o:zmq4.cgo2.c:function _cgo_2acdb4f1918b_Cfunc_zmq_z85_encode: error: undefined reference to 'zmq_z85_encode'
collect2: error: ld returned 1 exit status

link: error running subcommand external/rules_go~~go_sdk~bazel-cgo__download_0/pkg/tool/linux_amd64/link: exit status 2
ERROR: /home/htie/coding/bazel-cgo/BUILD.bazel:17:10: GoLink zmq_server_/zmq_server failed: (Exit 1): builder failed: error executing GoLink command (from target //:zmq_server) bazel-out/k8-opt-exec-ST-d57f47055a04/bin/external/rules_go~~go_sdk~bazel-cgo__download_0/builder_reset/builder link -sdk external/rules_go~~go_sdk~bazel-cgo__download_0 -installsuffix linux_amd64 -arc ... (remaining 19 arguments skipped)

Use --sandbox_debug to see verbose messages from the sandbox and retain the sandbox build root for debugging
external/rules_go~~go_sdk~bazel-cgo__download_0/pkg/tool/linux_amd64/link: running /usr/bin/gcc failed: exit status 1
/usr/bin/gcc -m64 -s -o bazel-out/k8-fastbuild/bin/zmq_server_/zmq_server -Wl,--export-dynamic-symbol=_cgo_panic -Wl,--export-dynamic-symbol=_cgo_topofstack -Wl,--export-dynamic-symbol=crosscall2 -Wl,--compress-debug-sections=zlib /tmp/go-link-4032163743/go.o /tmp/go-link-4032163743/000000.o /tmp/go-link-4032163743/000001.o /tmp/go-link-4032163743/000002.o /tmp/go-link-4032163743/000003.o /tmp/go-link-4032163743/000004.o /tmp/go-link-4032163743/000005.o /tmp/go-link-4032163743/000006.o /tmp/go-link-4032163743/000007.o /tmp/go-link-4032163743/000008.o /tmp/go-link-4032163743/000009.o /tmp/go-link-4032163743/000010.o /tmp/go-link-4032163743/000011.o /tmp/go-link-4032163743/000012.o /tmp/go-link-4032163743/000013.o /tmp/go-link-4032163743/000014.o /tmp/go-link-4032163743/000015.o /tmp/go-link-4032163743/000016.o /tmp/go-link-4032163743/000017.o /tmp/go-link-4032163743/000018.o /tmp/go-link-4032163743/000019.o /tmp/go-link-4032163743/000020.o /tmp/go-link-4032163743/000021.o /tmp/go-link-4032163743/000022.o /tmp/go-link-4032163743/000023.o /tmp/go-link-4032163743/000024.o /tmp/go-link-4032163743/000025.o /tmp/go-link-4032163743/000026.o /tmp/go-link-4032163743/000027.o /tmp/go-link-4032163743/000028.o /tmp/go-link-4032163743/000029.o /tmp/go-link-4032163743/000030.o -fuse-ld=gold -B/usr/bin -Wl,-no-as-needed -Wl,-z,relro,-z,now -pass-exit-codes -Wl,--push-state,-as-needed -Wl,--pop-state -Wl,--push-state,-as-needed -lm -Wl,--pop-state -pthread -fuse-ld=gold -B/usr/bin -Wl,-no-as-needed -Wl,-z,relro,-z,now -pass-exit-codes -Wl,--push-state,-as-needed -Wl,--pop-state -Wl,--push-state,-as-needed -lm -Wl,--pop-state -pthread -lpthread -fuse-ld=gold -B/usr/bin -Wl,-no-as-needed -Wl,-z,relro,-z,now -pass-exit-codes -Wl,--push-state,-as-needed -Wl,--pop-state -Wl,--push-state,-as-needed -lm -Wl,--pop-state -pthread -lresolv -no-pie -fuse-ld=gold -B/usr/bin -Wl,-no-as-needed -Wl,-z,relro,-z,now -pass-exit-codes -Wl,--push-state,-as-needed -Wl,--pop-state -Wl,--push-state,-as-needed -lm -Wl,--pop-state
/tmp/go-link-4032163743/000003.o:errors.cgo2.c:function _cgo_2acdb4f1918b_Cfunc_zmq_strerror: error: undefined reference to 'zmq_strerror'
/tmp/go-link-4032163743/000008.o:wrappers_unix.cgo2.c:function zmq4_bind: error: undefined reference to 'zmq_bind'
/tmp/go-link-4032163743/000008.o:wrappers_unix.cgo2.c:function zmq4_close: error: undefined reference to 'zmq_close'
/tmp/go-link-4032163743/000008.o:wrappers_unix.cgo2.c:function zmq4_connect: error: undefined reference to 'zmq_connect'
/tmp/go-link-4032163743/000008.o:wrappers_unix.cgo2.c:function zmq4_ctx_get: error: undefined reference to 'zmq_ctx_get'
/tmp/go-link-4032163743/000008.o:wrappers_unix.cgo2.c:function zmq4_ctx_new: error: undefined reference to 'zmq_ctx_new'
/tmp/go-link-4032163743/000008.o:wrappers_unix.cgo2.c:function zmq4_ctx_set: error: undefined reference to 'zmq_ctx_set'
/tmp/go-link-4032163743/000008.o:wrappers_unix.cgo2.c:function zmq4_ctx_term: error: undefined reference to 'zmq_ctx_term'
/tmp/go-link-4032163743/000008.o:wrappers_unix.cgo2.c:function zmq4_curve_keypair: error: undefined reference to 'zmq_curve_keypair'
/tmp/go-link-4032163743/000008.o:wrappers_unix.cgo2.c:function zmq4_curve_public: error: undefined reference to 'zmq_curve_public'
/tmp/go-link-4032163743/000008.o:wrappers_unix.cgo2.c:function zmq4_disconnect: error: undefined reference to 'zmq_disconnect'
/tmp/go-link-4032163743/000008.o:wrappers_unix.cgo2.c:function zmq4_getsockopt: error: undefined reference to 'zmq_getsockopt'
/tmp/go-link-4032163743/000008.o:wrappers_unix.cgo2.c:function zmq4_msg_gets: error: undefined reference to 'zmq_msg_gets'
/tmp/go-link-4032163743/000008.o:wrappers_unix.cgo2.c:function zmq4_msg_recv: error: undefined reference to 'zmq_msg_recv'
/tmp/go-link-4032163743/000008.o:wrappers_unix.cgo2.c:function zmq4_poll: error: undefined reference to 'zmq_poll'
/tmp/go-link-4032163743/000008.o:wrappers_unix.cgo2.c:function zmq4_proxy: error: undefined reference to 'zmq_proxy'
/tmp/go-link-4032163743/000008.o:wrappers_unix.cgo2.c:function zmq4_proxy_steerable: error: undefined reference to 'zmq_proxy_steerable'
/tmp/go-link-4032163743/000008.o:wrappers_unix.cgo2.c:function zmq4_send: error: undefined reference to 'zmq_send'
/tmp/go-link-4032163743/000008.o:wrappers_unix.cgo2.c:function zmq4_setsockopt: error: undefined reference to 'zmq_setsockopt'
/tmp/go-link-4032163743/000008.o:wrappers_unix.cgo2.c:function zmq4_socket: error: undefined reference to 'zmq_socket'
/tmp/go-link-4032163743/000008.o:wrappers_unix.cgo2.c:function zmq4_socket_monitor: error: undefined reference to 'zmq_socket_monitor'
/tmp/go-link-4032163743/000008.o:wrappers_unix.cgo2.c:function zmq4_unbind: error: undefined reference to 'zmq_unbind'
/tmp/go-link-4032163743/000009.o:zmq4.cgo2.c:function zmq4_get_event40: error: undefined reference to 'zmq_msg_data'
/tmp/go-link-4032163743/000009.o:zmq4.cgo2.c:function zmq4_get_event41: error: undefined reference to 'zmq_msg_data'
/tmp/go-link-4032163743/000009.o:zmq4.cgo2.c:function _cgo_2acdb4f1918b_Cfunc_zmq_has: error: undefined reference to 'zmq_has'
/tmp/go-link-4032163743/000009.o:zmq4.cgo2.c:function _cgo_2acdb4f1918b_Cfunc_zmq_msg_close: error: undefined reference to 'zmq_msg_close'
/tmp/go-link-4032163743/000009.o:zmq4.cgo2.c:function _cgo_2acdb4f1918b_Cfunc_zmq_msg_data: error: undefined reference to 'zmq_msg_data'
/tmp/go-link-4032163743/000009.o:zmq4.cgo2.c:function _cgo_2acdb4f1918b_Cfunc_zmq_msg_init: error: undefined reference to 'zmq_msg_init'
/tmp/go-link-4032163743/000009.o:zmq4.cgo2.c:function _cgo_2acdb4f1918b_Cfunc_zmq_version: error: undefined reference to 'zmq_version'
/tmp/go-link-4032163743/000009.o:zmq4.cgo2.c:function _cgo_2acdb4f1918b_Cfunc_zmq_z85_decode: error: undefined reference to 'zmq_z85_decode'
/tmp/go-link-4032163743/000009.o:zmq4.cgo2.c:function _cgo_2acdb4f1918b_Cfunc_zmq_z85_encode: error: undefined reference to 'zmq_z85_encode'
collect2: error: ld returned 1 exit status

link: error running subcommand external/rules_go~~go_sdk~bazel-cgo__download_0/pkg/tool/linux_amd64/link: exit status 2
Use --verbose_failures to see the command lines of failed build steps.
INFO: Elapsed time: 0.298s, Critical Path: 0.17s
INFO: 3 processes: 3 internal.
ERROR: Build did NOT complete successfully
```

Despite the fact that `zmq.h` is present inside `@libzmq//:libzmq_headers_only`.

Q: How to make `com_github_pebbe_zmq4` see `zmq.h` in Bazel?
