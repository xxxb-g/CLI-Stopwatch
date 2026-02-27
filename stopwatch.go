package main

import (
	"fmt"
	"os"
	"os/signal"
	"syscall"
	"time"

	"golang.org/x/term"
)

func main() {
	start := time.Now()
	running := true

	// Terminal in Raw Mode setzen
	oldState, err := term.MakeRaw(int(os.Stdin.Fd()))
	if err != nil {
		panic(err)
	}
	defer term.Restore(int(os.Stdin.Fd()), oldState)

	// Kanal für Signale
	sigChan := make(chan os.Signal, 1)
	signal.Notify(sigChan, os.Interrupt, syscall.SIGTERM)

	// Strg+C-Goroutine
	go func() {
		<-sigChan
		running = false
	}()

	// Tastendruck-Goroutine (jede Taste!)
	go func() {
		buf := make([]byte, 1)
		for {
			_, err := os.Stdin.Read(buf)
			if err == nil {
				running = false
				return
			}
		}
	}()

	fmt.Println("Stopwach started. Press any key to stop.")

	for running == true {
		if running == true {
			fmt.Printf("\rElapsed time: %s", time.Since(start))
		}
		if running == false {
			time.Sleep(0)
			fmt.Printf("\rElapsed time: %s", time.Since(start))
			term.Restore(int(os.Stdin.Fd()), oldState)
			fmt.Println()
		}
	}
}
