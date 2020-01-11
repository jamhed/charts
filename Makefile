.PHONY: packages sanity

bump: packages
	git add .
	git commit -a -m "Update generated"
	git push origin HEAD

packages: sanity
	for folder in $$(find . -type d -maxdepth 1 -not -name docs -not -name '.*'); do helm package $$folder -d docs; done
	helm repo index docs --url https://jamhed.github.io/charts

sanity:
	command -v helm
	command -v find
