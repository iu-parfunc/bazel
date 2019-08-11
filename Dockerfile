FROM l.gcr.io/google/bazel:0.25.2

RUN apt-get update -y && \
    apt-get install -y make hashdeep bzip2

RUN cd /tmp && \
    wget https://www.cloudseal.io/s/cloudseal_alpha_pkg_01667.tbz && \
    mkdir -p /usr/cloudseal-alpha/ && \
    tar -xf cloudseal_alpha_pkg_01667.tbz -C /usr/cloudseal-alpha/ && \
    ln -s /usr/cloudseal-alpha/bin/cloudseal /usr/bin/

ADD . /src
WORKDIR /src
RUN make build

ENV DETTRACE /usr/bin/cloudseal
RUN rm -rf /usr/local/lib/bazel/ /usr/local/bin/bazel
RUN mv /src/bazel-bin/src/bazel /usr/bin/bazel
RUN rm -rf /src && mkdir /examples
RUN bazel version

WORKDIR /examples
RUN git clone https://github.com/abseil/abseil-hello.git
RUN git clone https://github.com/abseil/abseil-cpp.git

ENTRYPOINT /bin/bash
