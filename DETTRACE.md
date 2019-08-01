# Using Bazel + dettrace

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

4. Start the Bazel server, setting the `DETTRACE` environment variable to the
   location of `dettrace` on your machine. For example:

   ```
   $ DETTRACE=/path/to/dettrace bazel info
   ```

5. Run `bazel` as you normally would! To verify that it is actually using
   `dettrace`, you can pass the `--subcommands` flag to `bazel build` to
   see the individually subprocesses being wrapped by `dettrace`.

# Things built

Here is a list of large-ish projects that I have successfully managed to build
using Bazel + `dettrace`. Most of these projects were taken from
https://github.com/bazelbuild/bazel/wiki/Bazel-Users#open-source-projects-using-bazel:

1. `abseil-cpp`: https://github.com/abseil/abseil-cpp
2. `roughtime`: https://roughtime.googlesource.com/roughtime
3. `served`: https://github.com/meltwater/served

# Things that are nondeterministic

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

   Unfortunately, Bazel + `dettrace` gets stuck when trying to build this:

   ```
   [232 / 787] GoToolchainBinary external/go_sdk/builder [for host]; 12s linux-sandbox
   ```
