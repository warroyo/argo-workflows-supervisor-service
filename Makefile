VERSION ?= $(shell yq '.directories[0].contents[0].helmChart.version' service/vendir.yml)

.PHONY: sync release version

version:
	@echo $(VERSION)

sync:
	cd service && vendir sync
	yq eval-all 'select(fileIndex == 0) *+ select(fileIndex == 1)' \
		service/upstream/values.yaml service/supervisor-values.yaml \
		> /tmp/argo-merged-values.yaml
	mv /tmp/argo-merged-values.yaml service/upstream/values.yaml
	git checkout -- service/upstream/templates/supervisor/

release:
	cd service && kctrl package release -y -v $(VERSION)
	cp service/carvel-artifacts/packages/argo-workflows.field.vmware.com/metadata.yml argo-workflows-service.yml
	cat service/carvel-artifacts/packages/argo-workflows.field.vmware.com/package.yml >> argo-workflows-service.yml
