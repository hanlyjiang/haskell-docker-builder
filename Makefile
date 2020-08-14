SHELL := /bin/bash

HASKELL_BUILDER_VERSION ?= $(shell date '+%Y%m%d')
#BUSYBOX_BUILDER_VERSION := b806ff0a2624776464ec9c7ecbda16c2c9ec5e69
BUSYBOX_BUILDER_VERSION := dist-arm64v8

HASKELL_BUILDER_TAG := hanlyjiang/haskell-docker-packager:$(HASKELL_BUILDER_VERSION)
BUSYBOX_BUILDER_DOCKERFILE_URL := busybox/$(BUSYBOX_BUILDER_VERSION)/glibc/Dockerfile.builder
BUSYBOX_BUILDER_DOCKERFILE_PATH := busybox/$(BUSYBOX_BUILDER_VERSION)/glibc/

build:
	image_id_file=$$(mktemp) && \
	docker build --iidfile "$$image_id_file" -f '$(BUSYBOX_BUILDER_DOCKERFILE_URL)' '$(BUSYBOX_BUILDER_DOCKERFILE_PATH)' && \
	docker build . -t '$(HASKELL_BUILDER_TAG)' \
		--build-arg busybox_builder="$$(cat $$image_id_file)"

push: build
	docker push '$(HASKELL_BUILDER_TAG)'

.PHONY: build push
