FROM golang:alpine as builder
WORKDIR /usr/src/app
COPY go.mod ./
RUN go mod download && go mod verify
COPY . .
RUN go build -o randomstring

FROM alpine as production
COPY --from=builder /usr/src/app/randomstring .
CMD ["./randomstring"]
EXPOSE 8081