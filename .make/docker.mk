# .make/docker.mk — Docker image management

.PHONY: update clean

update: ## Build and push the Docker image (latest + tagged with GIT_SHA)
	docker compose down --remove-orphans
	docker build --load -t $(REGISTRY_USERNAME)/$(IMAGE_NAME):latest .
	docker tag $(REGISTRY_USERNAME)/$(IMAGE_NAME):latest $(REGISTRY_USERNAME)/$(IMAGE_NAME):$(GIT_SHA)
	docker push $(REGISTRY_USERNAME)/$(IMAGE_NAME):$(GIT_SHA)
	docker push $(REGISTRY_USERNAME)/$(IMAGE_NAME):latest

clean: ## Remove stopped containers and force-remove volumes/networks
	docker compose rm -fs

nuke: ## Stop and remove all containers, volumes, and networks (destructive!)
	docker compose down -v --remove-orphans
	docker system prune -af
