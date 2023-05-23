//go:build !NO_FAST_CALLS

package fastsixel

import (
	"goasm_fast_call"
	"unsafe"
)

// #cgo CFLAGS: -I.
// #cgo CXXFLAGS: -I.
// #cgo LDFLAGS: -L.
// #include <stdlib.h>
// #include <fastsixel.h>
import "C"

const ToStdOut uint = 0
const ToStdErr uint = 1

func GetPrintMode() uint {
	return C.cur_print_message_mode()
}

func SetPrintMode(mode uint) {
	if mode <= 2 {
		return
	}
	goasm_fast_call.UnsafeCall1(C.set_print_message_mode, (uintptr)(mode))
}

func PrintMessage(message string) {
	msg := C.CString(message)
	defer C.free(unsafe.Pointer(msg))
	goasm_fast_call.UnsafeCall1(C.print_message, uintptr(unsafe.Pointer(msg)))
}

func ImgFileToSixel(filename string) {
	img := C.CString(filename)
	defer C.free(unsafe.Pointer(img))
	C.sixel_image(img)
}
