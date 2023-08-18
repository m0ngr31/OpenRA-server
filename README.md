# Dockerfile for an OpenRA dedicated server

Based on the work that [rmoriz](https://github.com/rmoriz/openra-dockerfile) did originally. This project is scripted to automatically publish versions as they get released.

## Usage Example
```sh

$ docker run -d -p 1234:1234 \
             -e Name="DOCKER SERVER" \
             -e Mod=ra \
             -e ListenPort="1234" \
             --name openra \
             m0ngr31/openra:release

```

see https://github.com/OpenRA/OpenRA/blob/bleed/launch-dedicated.sh for all options.

## Versioning
Don't use the `:latest` tag (which is used by default). Use a specific version number (ex: `:playtest-20210131`), or you can grab the latest release or playtest using `:release` or `:playtest`.

## Multi-arch Image

The latest release is available for amd64/x86_64 and aarch64/ARMv8. Usually docker
should automatically download the right image.

`docker pull m0ngr31/openra:<TAG>` should just work.

## FYI

Seems like an example server with RA-mod needs at least 500MB of memory, maybe even more.
