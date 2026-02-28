.PHONY: build build-tinygo clean build-windows build-fast windows

build: build-fast
windows: build-windows

build-tiny:
	tinygo build -o stopwatch -opt=z -gc=leaking -no-debug
	strip stopwatch
	upx --ultra-brute --lzma stopwatch

build-windows:
	CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -ldflags="-s -w" -o stopwatch.exe
	strip stopwatch.exe
	upx --ultra-brute --lzma stopwatch.exe

build-fast:
	tinygo build -o stopwatch -opt=2 -gc=leaking -no-debug
	strip stopwatch


clean:
	rm -f stopwatch
	rm -f stopwatch.exe