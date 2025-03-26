# Makefile for Demo Docker App
SHELL=/bin/bash
.PHONY: build run root test

RED   = \033[0;31m
NOCOL = \033[0m
IMAGE = fantastic-ferries:dev
PORT  = 5050

build:
	docker build -t ${IMAGE} .

run:
	docker run --rm -it -p ${PORT}:${PORT} ${IMAGE}

root:
	docker run --rm -it -p ${PORT}:${PORT} --user 0 --entrypoint /bin/bash ${IMAGE}

test:
	@which container-structure-test || { echo -e "\nMissing ${RED}container-structure-test${NOCOL}. See https://github.com/GoogleContainerTools/container-structure-test\n"; exit 7; }; \
	container-structure-test test --image ${IMAGE} --config container-structure-test.yaml