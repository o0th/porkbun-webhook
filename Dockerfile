FROM --platform=$BUILDPLATFORM golang:1.23.5-alpine3.21 AS builder

WORKDIR /workspace

COPY go.mod go.sum ./

RUN go mod download

COPY main.go ./main.go
COPY ./porkbun ./porkbun

RUN CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -o webhook -ldflags '-w -extldflags "-static"'

FROM --platform=$BUILDPLATFORM alpine:3.21

WORKDIR /workspace

COPY --from=builder /workspace/webhook ./webhook

ENTRYPOINT ["webhook"]
