# Broly

![license](https://img.shields.io/github/license/solaoi/broly)

This is a high performance stub server.

<div align="center">
  <a href="https://github.com/solaoi/broly">
    <img alt="broly" src="https://user-images.githubusercontent.com/46414076/180388418-fa1beef3-251e-4803-8342-ab22867c63c2.png">
  </a>
</div>

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
VERSION=v0.2.1
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
--mount type=bind,src=`pwd`/$STUB_JSON,dst=/target.json \
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

- Tool: [Vegeta](https://github.com/tsenart/vegeta)
- Command:   
```echo 'GET http://localhost:9999/hello' | vegeta attack -duration=60s | vegeta report```
- Environment: on DockerContainer

### Broly

```
Requests      [total, rate, throughput]         3000, 50.02, 50.01
Duration      [total, attack, wait]             59.985s, 59.982s, 3.197ms
Latencies     [min, mean, 50, 90, 95, 99, max]  958.602µs, 2.906ms, 2.989ms, 3.334ms, 3.439ms, 3.682ms, 8.954ms
Bytes In      [total, mean]                     51000, 17.00
Bytes Out     [total, mean]                     0, 0.00
Success       [ratio]                           100.00%
Status Codes  [code:count]                      200:3000  
Error Set:
```

### [WireMock](https://wiremock.org/)

demo is [here](https://github.com/solaoi/broly-wiremock-demo).

```
Requests      [total, rate, throughput]         3000, 50.02, 50.02
Duration      [total, attack, wait]             59.98s, 59.976s, 3.466ms
Latencies     [min, mean, 50, 90, 95, 99, max]  1.036ms, 6.185ms, 3.421ms, 4.056ms, 4.36ms, 34.511ms, 567.831ms
Bytes In      [total, mean]                     48000, 16.00
Bytes Out     [total, mean]                     0, 0.00
Success       [ratio]                           100.00%
Status Codes  [code:count]                      200:3000  
Error Set:
```

## Affinity

broly's JSON Format is compatible with [co-metub](https://github.com/solaoi/co-metub).

[co-metub](https://github.com/solaoi/co-metub) is a GUI tool to manage stubs and export stubs in JSON Format.

If you manage stubs with GUI, you should use [co-metub](https://github.com/solaoi/co-metub).
But if you switch some stubs or attack strongly a stub server, you should use Broly.
