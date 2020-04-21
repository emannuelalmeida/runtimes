build:
	docker build --no-cache -t kubeless/lua:latest$$RUNTIME_TAG_MODIFIER -f Dockerfile .

push:
	docker push kubeless/lua:latest$$RUNTIME_TAG_MODIFIER

build-all: build
push-all: push