package main;

import "os"
import "fastsixel"

func main() {
	args := os.Args[1:];

	if (len(args) > 0) {
		fastsixel.ImgFileToSixel(args[0]);
	} else {
		fastsixel.PrintMessage("Command line args is 0. Smoke Test");
	}
}
