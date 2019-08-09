FROM golang:1.12 as build

ENV GOPROXY https://goproxy.io
ENV GO111MODULE on

WORKDIR /go/cache

ADD go.mod .
ADD go.sum .
RUN go mod download

WORKDIR /go/release

COPY . .

RUN GOOS=linux CGO_ENABLED=0 GOARCH=amd64 go build -ldflags="-s -w" -installsuffix cgo -o cni-ipam-etcd main.go

From alpine:3.9 

COPY --from=build /go/release/cni-ipam-etcd /
