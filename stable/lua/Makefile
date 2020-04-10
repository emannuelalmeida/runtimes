build5.1:
	docker build --no-cache -t kubeless/lua:5.1$$RUNTIME_TAG_MODIFIER -f Dockerfile.5.1 .

build5.2:
	docker build --no-cache -t kubeless/lua:5.2$$RUNTIME_TAG_MODIFIER -f Dockerfile.5.2 .

build5.3:
	docker build --no-cache -t kubeless/lua:5.3$$RUNTIME_TAG_MODIFIER -f Dockerfile.5.3 .

push5.1:
	docker push kubeless/lua:5.1$$RUNTIME_TAG_MODIFIER

push5.2:
	docker push kubeless/lua:5.2$$RUNTIME_TAG_MODIFIER

push5.3:
	docker push kubeless/lua:5.3$$RUNTIME_TAG_MODIFIER

build-all: build5.1 build5.2 build5.3
push-all: push5.1 push5.2 push5.3