.PHONY: docs
docs:	## Generate terraform docs
	@terraform-docs markdown table . > README.md

.PHONY: fmt
fmt:	## Format tofu code
	@tofu fmt