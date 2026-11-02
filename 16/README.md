# Exercise 16

**Level:** Intermediate · **Concepts:** vulnerability scanning, base images, dependency updates, attack surface, SBOMs

## Problem definition

Every package in an image can have known vulnerabilities, and new ones are published every day. The base image and the application's dependencies are where most of them come from, so an image that was fine when it was built becomes vulnerable just by getting old. Scanning images is the way to find out, and keeping the base image and the dependencies small and up to date is the way to fix it.

The files in `src/` build the image of a small Flask app. It works, but it was written years ago and nobody has touched it since: it uses an end-of-life Python version on a full Debian image, and old versions of its Python dependencies.

Scan it with [Grype](https://github.com/anchore/grype):

```bash
docker build -t patched-app .
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  anchore/grype:v0.121.0 patched-app --only-fixed
```

`--only-fixed` lists only the vulnerabilities that already have a fixed version, the ones you can do something about. There are more than a thousand.

Change the image so that it has **no critical or high vulnerabilities with a fix available**, while the app keeps working at <http://localhost:8016> (`docker run -d -p 8016:5000 patched-app`).

## Deliverables

The fixed `Dockerfile` and `requirements.txt`.

## How to check your solution

1. Build the image and scan it with the command above. No vulnerability in the list should have `Critical` or `High` severity.
2. Run the image and open <http://localhost:8016>. You should see the app's message.
3. When you are done, remove the container and the image.

`sol/test.sh` scans the starting image and the reference solution, and checks the solution's app.

New vulnerabilities are published all the time, so the result of a scan changes from one day to the next. If a reference solution stops passing, its base image or its dependencies need updating: that is the lesson of this exercise.

## Hints

- Look at the `TYPE` column of the scan: which vulnerabilities come from the operating system packages, and which from the Python packages?
- Which Python versions are still supported? Look at the [status of Python versions](https://devguide.python.org/versions/).
- Compare the number of packages of the `python` image variants: the default one, `-slim` and `-alpine`. A package that is not in the image cannot be vulnerable.
- Does the app use all the packages in `requirements.txt`?
- Flask's development server is not meant for production. While you are at it, use a production server such as Gunicorn, and do not run it as root.

## Going further

- Generate a software bill of materials (SBOM) of your image with [Syft](https://github.com/anchore/syft), and scan the SBOM with Grype instead of the image.
- Make the scan fail a CI pipeline with `--fail-on high`, and keep the base image and the dependencies up to date automatically with Dependabot or Renovate.
- Try a distroless image, like the ones from [`gcr.io/distroless`](https://github.com/GoogleContainerTools/distroless), or a hardened image such as [Docker Hardened Images](https://docs.docker.com/dhi/). How many packages and vulnerabilities do they have?
- Compare the results of Grype with other scanners, such as Docker Scout (`docker scout cves`).
