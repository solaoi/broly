# Broly

This is a high performance stub server.

## Usage

```sh
broly target.json -p 9999
```

JSON format is below.   
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

## Benchmark
