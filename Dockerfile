# Start with the full Go image for building
FROM golang:1.16-buster AS builder

# Set the working directory outside the GOPATH to enable the Go modules feature
WORKDIR /app

# Copy the go.mod and go.sum file (if you have one)
COPY go.* ./

# Download the dependencies (if you have any)
RUN go mod download

# Copy the source code
COPY main.go ./

# Build the Go app
RUN CGO_ENABLED=0 go build -o /hello_go_http

# Start a new stage from a smaller image for runtime
FROM golang:1.18-bullseye

# Copy the compiled binary from the first stage
COPY --from=builder /hello_go_http /hello_go_http

# Run the web service on container startup
ENTRYPOINT ["/hello_go_http"]
