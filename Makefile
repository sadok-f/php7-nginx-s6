VERSION  = $(shell git describe --tags)
IMAGE_NAME  = php7-nginx-s6
IMAGE_PATH = sadokf/$(IMAGE_NAME):$(VERSION)
IMAGE_PATH_LATEST = sadokf/$(IMAGE_NAME):latest

build:
	docker build -t $(IMAGE_NAME) .

push: build
	docker tag $(IMAGE_NAME) $(IMAGE_PATH)
	docker tag $(IMAGE_NAME) $(IMAGE_PATH_LATEST)
	docker push $(IMAGE_PATH)
	docker push $(IMAGE_PATH_LATEST)
	@echo "PUSHED ${IMAGE_PATH}"