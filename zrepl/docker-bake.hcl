variable "zrepl_version" {
	default = "v0.4.0"
}

variable "iteration" {
	default = 2
}

variable "platforms" {
	default = "linux/amd64,linux/386,linux/arm64/v8"
}

variable "registries" {
	default = "dlo9,ghcr.io/dlo9,docker.io/dlo9"
}

target "zrepl" {
	tags = "${tags(
		[split(",", "${registries}")],
		"zrepl",
		["latest", "${zrepl_version}", "${zrepl_version}-${iteration}"]
	)}"

	args = {
		ZREPL_VERSION = "${zrepl_version}"
	}

	platforms = split(",", "${platforms}")
}

group "default" {
	targets = ["zrepl"]
}

function "tags" {
	params = [registries, image, versions]
	result = flatten([for registry in flatten([registries]): [for version in flatten([versions]): "${registry}/${image}:${version}"]])
}

