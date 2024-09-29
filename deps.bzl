#
# External Bazel module dependencies that are not in Bazel Central Registry
# Note: This file has to be put in the root directory; otherwise Bazel will
# have trouble interpreting its path.
#

# Background: https://bazel.build/external/migration
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# This is needed to build 3rd-party non-Bazel modules (e.g. external projects
# that are based on CMake, Autotools, or other build systems).
# Background: https://bazelbuild.github.io/rules_foreign_cc/main/cmake.html
_ALL_CONTENT = """\
filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
    visibility = ["//visibility:public"],
)
"""

# 3rd party non-Bazel modules that are not in Bazel Central Registry
def zeromq():
    """required by cppzmq below"""
    if "zeromq" not in native.existing_rules():
        http_archive(
            name = "zeromq",
            urls = ["https://github.com/zeromq/libzmq/releases/download/v4.3.5/zeromq-4.3.5.tar.gz"],
            strip_prefix = "zeromq-4.3.5",
            build_file_content = _ALL_CONTENT,
        )

def _non_module_dependencies_impl(_ctx):
    zeromq()

non_module_dependencies = module_extension(
    implementation = _non_module_dependencies_impl,
)

