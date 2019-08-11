FROM l.gcr.io/google/bazel:0.22.0

RUN apt-get update -y && \
    apt-get install -y make
ADD . /src
WORKDIR /src
RUN make build


FROM ubuntu:16.04
RUN apt-get update -y && \
    apt-get install -y wget hashdeep bzip2 git
RUN cd /tmp && \
    wget --progress=dot:giga https://www.cloudseal.io/s/cloudseal_alpha_pkg_01667.tbz && \
    mkdir -p /usr/cloudseal-alpha/ && \
    tar -xf cloudseal_alpha_pkg_01667.tbz -C /usr/cloudseal-alpha/ && \
    ln -s /usr/cloudseal-alpha/bin/cloudseal /usr/bin/

ENV DETTRACE /usr/bin/cloudseal
COPY --from=0 /src/bazel-bin/src/bazel /usr/bin/bazel
RUN mkdir /examples
RUN bazel version

WORKDIR /examples
RUN git clone https://github.com/abseil/abseil-hello.git
RUN git clone https://github.com/abseil/abseil-cpp.git

ENTRYPOINT /bin/bash
