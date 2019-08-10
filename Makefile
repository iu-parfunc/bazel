DOCKER_NAME=bazel-det
DOCKER_TAG=0.22-1

build:
	bazel build //src:bazel

docker:
	docker build -t ${DOCKER_NAME}:${DOCKER_TAG} .

run-docker: docker
	docker run --rm -it ${DOCKER_NAME}:${DOCKER_TAG}
