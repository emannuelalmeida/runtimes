build:
	env GOOS=linux GOARCH=amd64 go build $$GOPATH/src/github.com/kubeless/kubeless/pkg/function-proxy/proxy.go
	#docker build --no-cache -t emannuelalmeida/lua$$RUNTIME_TAG_MODIFIER -f Dockerfile .
	docker build -t emannuelalmeida/lua$$RUNTIME_TAG_MODIFIER -f Dockerfile .

push:
	docker push emannuelalmeida/lua$$RUNTIME_TAG_MODIFIER

# Mandatory jobs
build-all: build
push-all: push

# Testing jobs
deploy: get-lua scheduled-get-lua timeout-lua get-lua-secrets post-lua
test: get-lua-verify scheduled-get-lua-verify timeout-lua-verify get-lua-secrets-verify post-lua-verify

get-lua:
	kubeless function deploy get-lua --runtime lua2.1 --handler helloget.foo --from-file examples/helloget.lua

get-lua-verify:
	kubectl rollout status deployment/get-lua && sleep 2
	kubeless function call get-lua |egrep hello.world
	kubeless function top --function get-lua --out yaml |egrep total_calls.*[1-100000]

#get-lua-deps:
#	cd examples && zip hellowithdeps.zip hellowithdeps.lua  hellowithdepshelper.lua && cd ..
#	kubeless function deploy get-lua-deps --runtime lua2.1 --handler hellowithdeps.foo --from-file examples/hellowithdeps.zip --dependencies examples/requirements.txt

#get-lua-deps-verify:
#	kubectl rollout status deployment/get-lua-deps && sleep 2
#	kubeless function call get-lua-deps |egrep Google

#get-lua-url-deps:
#	kubeless function deploy get-lua-url-deps --runtime lua2.1 --handler helloget.foo --from-file https://raw.githubusercontent.com/kubeless/kubeless/v1.0.0-alpha.1/examples/lua/hellowithdeps.py --dependencies https://raw.githubusercontent.com/kubeless/kubeless/v1.0.0-alpha.1/examples/lua/requirements.txt

#get-lua-url-deps-verify:
#	kubectl rollout status deployment/get-lua-url-deps && sleep 2
#	kubeless function call get-lua-url-deps |egrep Google

scheduled-get-lua:
	kubeless function deploy scheduled-get-lua --schedule "* * * * *" --runtime lua2.1 --handler helloget.foo --from-file examples/helloget.lua

scheduled-get-lua-verify:
	number="1"; \
	timeout="70"; \
	found=false; \
	while [ $$number -le $$timeout ] ; do \
		pod=`kubectl get po -oname -l function=scheduled-get-lua`; \
		logs=`kubectl logs $$pod | grep "GET / HTTP/1.1\" 200 11 \"\""`; \
    	if [ "$$logs" != "" ]; then \
			found=true; \
			break; \
		fi; \
		sleep 1; \
		number=`expr $$number + 1`; \
	done; \
	$$found

timeout-lua:
	$(eval TMPDIR := $(shell mktemp -d))
	printf 'function foo(event, context) \nwhile (true) do \nprint "hello world"\n end' > $(TMPDIR)/hello-loop.lua
	kubeless function deploy timeout-lua --runtime lua2.1 --handler helloget.foo  --from-file $(TMPDIR)/hello-loop.lua --timeout 3
	rm -rf $(TMPDIR)

timeout-lua-verify:
	kubectl rollout status deployment/timeout-lua && sleep 2
	$(eval MSG := $(shell kubeless function call timeout-lua 2>&1 || true))
	echo $(MSG) | egrep Request.timeout.exceeded

get-lua-secrets:
	kubectl create secret generic test-secret --from-literal=key=MY_KEY || true
	kubeless function deploy get-lua-secrets --runtime lua2.1 --handler helloget.foo --from-file examples/helloget.lua --secrets test-secret

get-lua-secrets-verify:
	kubectl rollout status deployment/get-lua-secrets && sleep 2
	$(eval pod := $(shell kubectl get pod -l function=get-lua-secrets -o go-template -o custom-columns=:metadata.name --no-headers=true))
	kubectl exec -it $(pod) cat /test-secret/key | egrep "MY_KEY"

#custom-get-lua:
#	kubeless function deploy --runtime-image kubeless/get-lua-example@sha256:6a14400f14e26d46a971445b7a850af533fe40cb75a67297283bdf536e09ca5e custom-get-lua

#custom-get-lua-verify:
#	kubectl rollout status deployment/custom-get-lua && sleep 2
#	kubeless function call custom-get-lua |egrep hello.world

post-lua:
	kubeless function deploy post-lua --runtime lua2.1 --handler hellowithdata.handler --from-file examples/hellowithdata.lua

post-lua-verify:
	kubectl rollout status deployment/post-lua && sleep 2
	kubeless function call post-lua --data '{"status": "It is alive, Jhonny!!"}'|egrep "it.*alive"
	# Verify event context
	logs=`kubectl logs --tail=1000 -l function=post-lua`; \
	echo $$logs | grep -q "it.*alive" && \
	echo $$logs | grep -q "event-time.*Z" && \
	echo $$logs | grep -q "event-type.*application/json" && \
	echo $$logs | grep -q "event-namespace.*cli.kubeless.io" && \
	echo $$logs | grep -q "event-id.*"