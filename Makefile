REGISTRY := zubrailx
PREFIX := base-
SRCS = $(wildcard *.dockerfile)
TGTS = $(patsubst %.dockerfile, %, $(SRCS))

all: $(patsubst %, tag/%, $(TGTS))

define make-build-rule

build/$(1): $(1).dockerfile
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
