# Exercise 15

**Level:** Advanced · **Concepts:** multi-platform images, Buildx builders, cross-compilation, `BUILDPLATFORM` and `TARGETPLATFORM`, registries

## Problem definition

ARM machines are everywhere now: Apple Silicon laptops, Raspberry Pis, and cloud instances like AWS Graviton, which are usually cheaper than their x86 equivalents. An image built only for `linux/amd64` either does not run on them or runs slowly under emulation. That is why most images are published for several platforms under the same tag: the registry stores one image per platform, plus an index that lists them, and each machine pulls the one that matches it.

The files in `src/` build a small Go program that prints the platform it runs on. The `run.sh` script:

1. starts a local registry at `localhost:5015`;
2. creates a Buildx builder with the `docker-container` driver, because the default builder cannot store multi-platform images;
3. builds the image for `linux/amd64` and `linux/arm64` and pushes it to the registry.

It works, but slowly. On an amd64 machine, the builder runs every instruction of the arm64 image under emulation (QEMU), the Go compiler included. Run it with `BUILDKIT_PROGRESS=plain ./run.sh` and compare how long the `go build` step takes for each platform. With a real project, that difference is minutes.

Change the `Dockerfile` so that the Go compiler always runs natively on the builder's platform, and still produces an image for each target platform.

## Deliverables

The fixed `Dockerfile`.

## How to check your solution

1. Run `BUILDKIT_PROGRESS=plain ./run.sh`. The `go build` steps should take about the same time for both platforms, and the arm64 one should show the builder's platform in its name, like `[linux/amd64->arm64 build 4/4]`.
2. `docker buildx imagetools inspect localhost:5015/hello-multiarch:1.0` must list an image for `linux/amd64` and one for `linux/arm64`.
3. Run `docker run --rm localhost:5015/hello-multiarch:1.0`. It must print the platform of your machine. If your machine can emulate other platforms, try `--platform linux/arm64` too.
4. When you are done, remove the registry container (`docker rm -f registry`) and the builder (`docker buildx rm multiarch`).

`sol/test.sh` checks that the starting `Dockerfile` compiles under emulation, and that the reference solution cross-compiles and publishes a working image for each platform.

## Hints

- `FROM --platform=...` chooses the platform of the image of a stage, regardless of the platform being built.
- BuildKit defines the `BUILDPLATFORM`, `TARGETPLATFORM`, `TARGETOS` and `TARGETARCH` build arguments. Look at [how to use them](https://docs.docker.com/build/building/variables/#multi-platform-build-arguments), and remember that you must declare them with `ARG` in each stage that uses them.
- Go can compile for another platform with the `GOOS` and `GOARCH` environment variables, as long as cgo is disabled.
- Which instructions of the final stage need to run code of the target platform, and which ones only copy files?

## Going further

- Find out what your machine can build with `docker buildx ls`, and install emulators for more platforms with `docker run --privileged --rm tonistiigi/binfmt --install all`.
- Cross-compiling is easy with Go and harder with other languages. Look at [`tonistiigi/xx`](https://github.com/tonistiigi/xx), which helps cross-compile C, C++ and Rust in a Dockerfile.
- Instead of emulation, a builder can have native nodes for each platform: `docker buildx create --append` adds a remote ARM machine to it.
- Publish the image from CI with `docker/setup-qemu-action`, `docker/setup-buildx-action` and `docker/build-push-action`, setting `platforms: linux/amd64,linux/arm64`.
