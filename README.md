# Broly

## Usage

### 1. Binary

### 2. Docker

#### RunOnly

```sh
# Specify the port you want to provide
HOST_PORT=80
# Specify the filename you want to serve
STUB_JSON=filename.json

# Run Container
docker run --init \
-p $HOST_PORT:8080 \
--mount type=bind,source="$(pwd)/$STUB_JSON",target=/target.json \ 
ghcr.io/solaoi/broly:latest
```

#### Local Build & Run

```sh
# Specify the port you want to provide
HOST_PORT=80

# Edit stubs for serving
vi target.json

# Build DockerImage
docker build -t broly .

# Run Container
docker run --init \
-p $HOST_PORT:8080 \
-t broly
```
