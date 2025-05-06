# .make/docker.mk
.PHONY: update clean

# 📦 Docker Image Commands
update:
	docker compose down --remove-orphans
	docker build --load -t $(REGISTRY_USERNAME)/$(IMAGE_NAME):latest .
	docker tag $(REGISTRY_USERNAME)/$(IMAGE_NAME):latest $(REGISTRY_USERNAME)/$(IMAGE_NAME):$(GIT_SHA)
	docker push $(REGISTRY_USERNAME)/$(IMAGE_NAME):$(GIT_SHA)
	docker push $(REGISTRY_USERNAME)/$(IMAGE_NAME):latest

# 🧹 Cleanup
clean:
	docker compose rm -fs
