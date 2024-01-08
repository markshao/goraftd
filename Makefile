GOCMD=go
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test

BINARY_NAME=goraftd

all: clean build

output_dir := ./output
gen_dir := ./gen

build: clean
	mkdir ./output
	GOOS=linux GOARCH=amd64 $(GOBUILD) -o ./output/$(BINARY_NAME) -v

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

gen: clean_gen
	mkdir ./gen
	protoc --go_out=./gen --go_opt=paths=source_relative \
        --go-grpc_out=./gen --go-grpc_opt=paths=source_relative \
        idl/kv.proto

.PHONY: run test clean build gen buildImage