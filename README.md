# Broly

![license](https://img.shields.io/github/license/solaoi/broly)

This is a high performance stub server.

## Usage

```sh
broly target.json -p 9999
```

stub settings (JSON Format) is below.   
see a sample [here](https://raw.githubusercontent.com/solaoi/broly/main/target.json).

| Field       | Type                    | Required | Default          | Sample                  |
| ----------- | ----------------------- | -------- | ---------------- | ----------------------- |
| - (parent)  | JSONArray or JSONObject | True     | -                | -                       |
| path        | string                  | True     | -                | "/hello"                |
| method      | string                  | True     | -                | "GET"                   |
| contentType | string                  | False    | application/json | "application/json"      |
| statusCode  | string                  | True     | -                | "200"                   |
| response    | string                  | True     | -                | "{\"name\": \"hello\"}" |
| sleep       | number                  | False    | 0                | 1000 (milliseconds)     |

Option is below.

| Option    | Description                        |
| --------- | ---------------------------------- |
| -p,--port | specify the port you want to serve |

## Install

### 1. Mac

```
# Install
brew install solaoi/tap/broly
# Update
brew upgrade broly
```

### 2. BinaryRelease

```sh
# Install with wget or curl
## set the latest version on releases.
VERSION=v0.2.0
## set the OS you use. (linux or macos)
OS=linux
## case you use wget
wget https://github.com/solaoi/broly/releases/download/$VERSION/broly_${OS}.tar.gz
## case you use curl
curl -LO https://github.com/solaoi/broly/releases/download/$VERSION/broly_${OS}.tar.gz
## extract
tar xvf ./broly_${OS}.tar.gz
## move it to a location in your $PATH, such as /usr/local/bin.
mv ./broly /usr/local/bin/
```

### 3. Docker

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
# Download this repo
git clone https://github.com/solaoi/broly.git
cd broly

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

## Benchmark
