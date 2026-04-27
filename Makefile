VERSION ?= $(shell yq '.directories[0].contents[0].helmChart.version' service/vendir.yml)

.PHONY: sync release version

version:
	@echo $(VERSION)

sync:
	cd service && vendir sync
	git checkout -- service/upstream/templates/supervisor/ service/upstream/values.yaml

release:
	cd service && kctrl package release -y -v $(VERSION)
	cp service/carvel-artifacts/packages/argo-workflows.field.vmware.com/metadata.yml argo-workflows-service.yml
	cat service/carvel-artifacts/packages/argo-workflows.field.vmware.com/package.yml >> argo-workflows-service.yml
