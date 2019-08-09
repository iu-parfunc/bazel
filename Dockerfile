FROM l.gcr.io/google/bazel:0.22.0

RUN apt-get update -y && \
    apt-get install -y make

ADD . /src
WORKDIR /src
RUN make build
ENTRYPOINT /bin/bash
