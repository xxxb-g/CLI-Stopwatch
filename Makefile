.PHONY: build build-tinygo build-go clean build-windows

build: build-tinygo

build-tinygo:
	tinygo build -o stopwatch -opt=2 -gc=leaking -no-debug
	strip stopwatch
	upx --ultra-brute --lzma stopwatch

build-go:
	CGO_ENABLED=0 go build -ldflags="-s -w" -o stopwatch
	strip stopwatch
	upx --ultra-brute --lzma stopwatch

build-windows:
	CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -ldflags="-s -w" -o stopwatch.exe
	strip stopwatch.exe
	upx --ultra-brute --lzma stopwatch.exe

clean:
	rm -f stopwatch
	rm -f stopwatch.exe