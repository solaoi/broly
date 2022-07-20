FROM nimlang/nim:1.6.6-ubuntu AS builder
RUN apt-get update && apt-get install -y musl-tools

WORKDIR /app

# install deps
COPY broly.nimble ./
RUN nimble install -y --depsOnly

# build
COPY ./src ./src
RUN nim --gcc.exe:musl-gcc --gcc.linkerexe:musl-gcc --passL:-static c ./src/broly.nim

# dummy json for mount
COPY target.json ./

FROM busybox
COPY --from=builder /app/src/broly /app/target.json ./

ENTRYPOINT [ "./broly" ]
CMD [ "target.json" ]
