# Using Bazel + a determinism sandbox

1. First, build Bazel from this repo. One of the following methods should suffice:

   * Nix

   ```
   $ nix-shell
   $ make build
   ```

   * Docker

   ```
   make docker
   ```

   * As a third option, you can try just running `make build`. You will need
     JDK 8 installed, possibly other things.

2. Find the locally built `bazel` binary. It's usually located somewhere like
   `/path/to/bazel/repo/bazel-bin/src/bazel`. For the remainder of this
   document, I'm just going to refer to this binary as `bazel`.

3. Ensure that the Bazel server is not currently running. If it is, you can
   stop it with the following command:

   ```
   $ bazel clean --expunge
   ```

4. Start the Bazel server, setting the `DETCMD` environment variable to the
   location of the determism-sandbox on your machine. For example:

   ```
   $ DETCMD=/path/to/cloudseal bazel info
   ```

5. Run `bazel` as you normally would! To verify that it is actually using
   `cloudseal`, you can pass the `--subcommands` flag to `bazel build` to
   see the individually subprocesses being wrapped by `cloudseal`.

# Things built

Here is a list of large-ish projects that I have successfully managed to build
using Bazel + `cloudseal`. Most of these projects were taken from
https://github.com/bazelbuild/bazel/wiki/Bazel-Users#open-source-projects-using-bazel:

1. `abseil-cpp`: https://github.com/abseil/abseil-cpp
2. `incubator-brpc`: https://github.com/apache/incubator-brpc
3. `jsonnet`: https://github.com/google/jsonnet
4. `roughtime`: https://roughtime.googlesource.com/roughtime
5. `served`: https://github.com/meltwater/served

The Dockerfile within this repository builds the modified version of
bazel (say, detbazel) and includes an `/examples` directory. Here's
how to run the `abseil-cpp` tests and verify that all the build
outputs are deterministic.

First, after you build the container, run it with
`docker run --rm -it --privileged --userns=host --cap-add=SYS_ADMIN`.  This provides external permissions that are required for running our prototype sandbox.  Then run the tests:

```
$ cd /examples/abseil-cpp
$ bazel test --subcommands //absl/...
$ hashdeep -r bazel-bin/ > hashes.txt
```

Next, perform a second build, and audit the results against the first:

```
$ bazel clean --expunge
$ bazel test --subcommands //absl/...
$ hashdeep -rvak hashes.txt bazel-bin/
hashdeep: Audit passed
          Files matched: 5202
Files partially matched: 0
            Files moved: 0
        New files found: 0
  Known files not found: 0
```

Running with a deterministic sandbox enabled should ensure that this
audit always passes.  If not, please report the problem as a bug.

# Regression tests

We have compiled a collection of test cases to stress-test Bazel + `cloudseal`
under the `tests/` directory. These test cases are a combination of:

1. Hand-crafted tests designed to test particular facets of irreproducibility
   in builds. (See, for instance, `tests/nondet-genrule`).
2. Pinned versions of "in-the-wild" projects that use Bazel. We test these
   against Bazel + `cloudseal` to catch potential regressions.

To execute all tests, go the `tests/` directory and run the following command:

```
$ ./run-tests.sh ${DETCMD} ${BAZEL}
```

Where:

* `${DETCMD}` is the path to the `cloudseal` executable
* `${BAZEL}` is the path to the `cloudseal`-aware Bazel executable

If you wish to run an individual test, navigate to its directory (e.g.,
`tests/nondet-genrule`) and run the following command:

```
$ ../test-determinism.sh ${DETCMD} ${BAZEL} ${TARGET}
```

Where:

* `${DETCMD}` is the path to the `cloudseal` executable
* `${BAZEL}` is the path to the `cloudseal`-aware Bazel executable
* `${TARGET}` is the `bazel build` target to run (e.g., `//...`). Most test
  cases expect a specific target, so refer to `tests/run-tests.sh` to see
  which target to use for each test case.

# Bazel builds that exhibit nondeterminism (when run without a sandbox)

The following Bazel builds are known to be nondeterministic:

1. `govisor` (https://github.com/google/gvisor/tree/0a246fab80581351309cdfe39ffeeffa00f811b1):

   ```
   hashdeep: Audit failed
      Input files examined: 0
     Known files expecting: 0
             Files matched: 6863
   Files partially matched: 0
               Files moved: 0
           New files found: 15
     Known files not found: 15
   ```

   Unfortunately, Bazel + `cloudseal` gets stuck when trying to build this:

   ```
   [232 / 787] GoToolchainBinary external/go_sdk/builder [for host]; 12s linux-sandbox
   ```
