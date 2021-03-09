SHELL=/bin/bash

mac-lint:
	brew tap liamg/tfsec && brew install tflint tfsec gawk 
	brew install --build-from-source terraform-docs  coreutils
	pip install pre-commit

lint:
	pre-commit run -a

fmt:
	terraform fmt -recursive
