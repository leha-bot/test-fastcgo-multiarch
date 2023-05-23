package main

import (
	"fastsixel"
	"flag"
	"fmt"
	"os"
)

func main() {
	args := os.Args[1:]
	var filename string
	var message string = ""
	var useStdErrForMsg bool = false
	var printCurrentMsgPrintMode bool = false
	flag.StringVar(&filename, "filename", "", "Filename for converting to sixel string")
	flag.StringVar(&message, "message", "", "Message for FFI test")
	flag.BoolVar(&useStdErrForMsg, "stderr", false, "Use stderr for FFI messages")
	flag.BoolVar(&printCurrentMsgPrintMode, "printcurmode", false, "Print current message print mode (0 - stdout, 1 - stderr)")
	flag.Parse()

	if useStdErrForMsg {
		fastsixel.SetPrintMode(fastsixel.ToStdErr)
	}

	if len(args) > 0 {
		if printCurrentMsgPrintMode {
			var curPrintMode = fastsixel.GetPrintMode()
			var curPrintModeMessage = fmt.Sprint("Current print mode: ", curPrintMode)
			fastsixel.PrintMessage(curPrintModeMessage)
		}
		if len(message) > 0 {
			fastsixel.PrintMessage(message)
		}
		if len(filename) > 0 {
			fastsixel.ImgFileToSixel(filename)
		}
	} else {
		flag.CommandLine.Usage()
		fastsixel.PrintMessage("After usage there is a smoke test.")
	}
}
