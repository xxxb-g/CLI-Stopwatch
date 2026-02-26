.PHONY: build build-tinygo build-go clean

build: build-tinygo

build-tinygo:
	tinygo build -o stopwatch -opt=2 -gc=leaking -no-debug
	strip stopwatch
	upx --ultra-brute --lzma stopwatch

build-go:
	CGO_ENABLED=0 go build -ldflags="-s -w" -o stopwatch
	strip stopwatch
	upx --ultra-brute --lzma stopwatch

clean:
	rm -f stopwatch