FROM ubuntu:18.04

RUN apt-get update -y && \
    apt-get install -y g++ make strace python3 libseccomp-dev openjdk-8-jdk openssh-server fuse libfuse-dev less unzip valgrind zip

# RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
RUN apt-get update -y
RUN apt-get install -y software-properties-common clang-6.0 clang++-6.0 lldb-6.0 lld-6.0

RUN apt-get update -y
RUN apt-get install -y pkg-config libarchive-dev libacl1-dev liblzo2-dev liblzma-dev liblz4-dev libbz2-dev libxml2-dev libssl-dev

RUN apt-get update -y
RUN apt-get install -y cpio

RUN apt-get update -y
RUN apt-get install -y libelfin-dev

RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-6.0 60 \
		--slave /usr/bin/clang++ clang++ /usr/bin/clang++-6.0 \
		--slave /usr/bin/clang-cpp clang-cpp /usr/bin/clang-cpp-6.0 \
		--slave /usr/bin/lldb lldb /usr/bin/lldb-6.0

ADD . /src
WORKDIR /src/dettrace/
RUN make -j build

WORKDIR /bin
RUN wget https://github.com/bazelbuild/bazel/releases/download/0.25.2/bazel-0.25.2-linux-x86_64 -O bazel && chmod +x bazel

WORKDIR /src

RUN make build
RUN mv /bin/bazel /bin/bazel-bootstrap
ENV PATH="/src/bazel-bin/src:/src/dettrace/bin:${PATH}"
RUN DETTRACE=/src/dettrace/bin/dettrace bazel info

ENTRYPOINT /bin/bash
