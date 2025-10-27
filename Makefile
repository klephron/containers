REGISTRY ?= klephron

SRCS := $(wildcard Dockerfile.*)
TGTS := $(patsubst Dockerfile.%, %, $(SRCS))

default: tag

build: $(patsubst %, build/%, $(TGTS))
tag: $(patsubst %, tag/%, $(TGTS))
push: $(patsubst %, push/%, $(TGTS))

define make-build-rule

build/$(1): Dockerfile.$(1)
	@./docker.sh build "$$(REGISTRY)" "$(1)" $$(TGTS)
endef

define make-tag-rule

tag/$(1):
	@./docker.sh tag "$$(REGISTRY)" "$(1)" $$(TGTS)
endef

define make-push-rule

push/$(1):
	@./docker.sh push "$$(REGISTRY)" "$(1)" $$(TGTS)
endef

$(foreach target, $(TGTS), $(eval $(call make-build-rule,$(target))))
$(foreach target, $(TGTS), $(eval $(call make-tag-rule,$(target))))
$(foreach target, $(TGTS), $(eval $(call make-push-rule,$(target))))

build/%:
	@image=$*; \
	./docker.sh build $(REGISTRY) "$$image" $$(TGTS)

tag/%:
	@image=$*; \
	./docker.sh tag $(REGISTRY) "$$image" $$(TGTS)

push/%:
	@image=$*; \
	./docker.sh push $(REGISTRY) "$$image" $$(TGTS)

list:
	@echo $(TGTS)
