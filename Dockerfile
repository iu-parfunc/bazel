FROM l.gcr.io/google/bazel:0.25.2

ADD . /src
WORKDIR /src
RUN bazel build //src:bazel
ENTRYPOINT /bin/bash
