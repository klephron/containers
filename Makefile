REGISTRY := klephron
PREFIX :=
SRCS = $(wildcard Dockerfile.*)
TGTS = $(patsubst Dockerfile.%, %, $(SRCS))

default: tag

build: $(patsubst %, build/%, $(TGTS))
tag: $(patsubst %, tag/%, $(TGTS))
push: $(patsubst %, push/%, $(TGTS))

define make-build-rule

build/$(1): Dockerfile.$(1)
	docker build -f $$< -t $$(PREFIX)$(1) .

endef

define make-tag-rule

tag/$(1): build/$(1)
	docker tag $$(PREFIX)$(1) $$(REGISTRY)/$$(PREFIX)$(1)
	docker rmi $$(PREFIX)$(1)

endef

define make-push-rule

push/$(1): tag/$(1)
	docker push $$(REGISTRY)/$$(PREFIX)$(1)

endef

$(foreach target, $(TGTS), $(eval $(call make-build-rule,$(target))))
$(foreach target, $(TGTS), $(eval $(call make-tag-rule,$(target))))
$(foreach target, $(TGTS), $(eval $(call make-push-rule,$(target))))
