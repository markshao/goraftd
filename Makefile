GOCMD=go
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test

BINARY_NAME=goraftd
CMD_KVCLIENT=kvclient

all: clean build

output_dir := ./output
gen_dir := ./gen

build_linux: clean
	mkdir -p ./output/linux
	GOOS=linux GOARCH=amd64 $(GOBUILD) -o ./output/linux/$(BINARY_NAME) main.go utils.go
	GOOS=linux GOARCH=amd64 $(GOBUILD) -o ./output/linux/$(CMD_KVCLIENT) cmd/kvclient/main.go

build_arm64: clean
	mkdir -p ./output/arm64
	$(GOBUILD) -o ./output/arm64/$(BINARY_NAME) main.go utils.go
	$(GOBUILD) -o ./output/arm64/$(CMD_KVCLIENT) cmd/kvclient/main.go

clean:
	$(GOCLEAN)
	@if [ -e "$(output_dir)" ]; then \
            echo "Removing $(output_dir)"; \
            rm -r "$(output_dir)"; \
        else \
            echo "$(output_dir) does not exist."; \
        fi

clean_gen:
	@if [ -e "$(gen_dir)" ]; then \
                    echo "Removing $(output_dir)"; \
                    rm -r "$(gen_dir)"; \
                else \
                    echo "$(gen_dir) does not exist."; \
                fi

test:
	$(GOTEST) -v ./...

run:
	$(GOBUILD) -o ./output/$(BINARY_NAME) -v
	./output/$(BINARY_NAME)%

buildImage:
	docker build -t goraftd .

install_deps:
	go install google.golang.org/protobuf/cmd/protoc-gen-go
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

gen: clean_gen install_deps
	mkdir ./gen
	protoc --go_out=./gen --go_opt=paths=source_relative \
        --go-grpc_out=./gen --go-grpc_opt=paths=source_relative \
        idl/kv.proto

.PHONY: run test clean build gen buildImage