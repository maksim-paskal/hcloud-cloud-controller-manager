KUBECONFIG=$(HOME)/.kube/kurento-stage
image=paskalmaksim/hcloud-cloud-controller-manager
tag=`git rev-parse --short HEAD`

build:
	go run github.com/goreleaser/goreleaser@latest build --rm-dist --snapshot --skip-validate
	mv dist/hcloud-cloud-controller-manager_linux_amd64_v1/hcloud-cloud-controller-manager .
	docker buildx build --pull --push . -t $(image):$(tag)

.PHONY: deploy
deploy:
	make build tag=dev
	kubectl -n kube-system rollout restart deployment hcloud-cloud-controller-manager
logs:
	kubectl -n kube-system logs -lapp=hcloud-cloud-controller-manager -f