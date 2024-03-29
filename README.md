[![Build Image](https://github.com/silentmecha/steamcmd-wine/actions/workflows/build.yml/badge.svg)](https://github.com/silentmecha/steamcmd-wine/actions/workflows/build.yml)
[![Docker Pulls](https://img.shields.io/docker/pulls/silentmecha/steamcmd-wine.svg)](https://hub.docker.com/r/silentmecha/steamcmd-wine)
[![Image Size](https://img.shields.io/docker/image-size/silentmecha/steamcmd-wine/latest.svg)](https://hub.docker.com/r/silentmecha/steamcmd-wine)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

# silentmecha/steamcmd-wine

A base image of SteamCMD with [WINE](https://www.winehq.org/) for downloading and running Steam game servers
and game server software that requires windows. The image is built automatically every 6 hours with
[Github Actions](https://github.com/silentmecha/steamcmd-wine/actions) and pushed to [Docker Hub](https://hub.docker.com/).

## Usage

### Pull latest image
```shell
docker pull silentmecha/steamcmd-wine:latest
```
### Test interactively
```shell
docker run -it silentmecha/steamcmd-wine:latest /bin/sh
```
### Download PixARK server
```shell
docker run -it silentmecha/steamcmd-wine:latest /bin/sh steamcmd +@sSteamCmdForcePlatformType windows +login anonymous +app_update 824360 +quit
```
### Download PixARK server to local mounted directory "data"
```shell
docker run -it -v $PWD:/data silentmecha/steamcmd-wine:latest /bin/sh steamcmd +@sSteamCmdForcePlatformType windows +force_install_dir /data +login anonymous +app_update 824360 validate +quit
```

## License

[MIT license](LICENSE)