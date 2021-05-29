# containers
A repository for auto-building and pushing containers

# Layout
Each top-level folder containing a Dockerfile will be auto-built and pushed via the
[docker buildx GitHub Action](https://github.com/marketplace/actions/docker-setup-buildx).

To build locally, simply run [`./build.sh`](/build.sh).
