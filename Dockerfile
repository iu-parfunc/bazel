FROM l.gcr.io/google/bazel:0.25.2

RUN apt-get update -y && \
    apt-get install -y make

ADD . /src
WORKDIR /src
RUN make build

RUN apt-get install -y bzip2

RUN cd /tmp && \
    wget https://www.cloudseal.io/s/cloudseal_alpha_pkg_01667.tbz && \
    mkdir -p /usr/cloudseal-alpha/ && \
    tar -xf cloudseal_alpha_pkg_01667.tbz -C /usr/cloudseal-alpha/ && \
    ln -s /usr/cloudseal-alpha/bin/cloudseal /usr/bin/

ENV DETTRACE /usr/bin/cloudseal

ENTRYPOINT /bin/bash
