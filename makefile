IMAGE_NAME = webpackapt-web:latest
RELEASE_NAME = webpackapt-release
CHART_DIR = ./webpackapt-chart

# One-time initialization target
init:
	@if [ ! -d "$(CHART_DIR)" ]; then \
		helm create $(CHART_DIR); \
		echo "Helm chart created successfully!"; \
	else \
		echo "Helm chart already exists, skipping creation."; \
	fi

build:
	docker build -t $(IMAGE_NAME) .
	minikube image load $(IMAGE_NAME)

deploy: build init
	helm upgrade --install $(RELEASE_NAME) $(CHART_DIR) \
		--set image.repository=webpackapt-web \
		--set image.tag=latest

refresh: deploy
	kubectl rollout restart deployment/$(RELEASE_NAME)-webpackapt-chart

url:
	minikube service $(RELEASE_NAME)-webpackapt-chart --url