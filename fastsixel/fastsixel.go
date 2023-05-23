//go:build NO_FAST_CALLS

package fastsixel

// #cgo CFLAGS: -I.
// #cgo CXXFLAGS: -I.
// #cgo LDFLAGS: -L.
// #include <stdlib.h>
// #include <fastsixel.h>
import "C"
import "unsafe"

func GetPrintMode() uint {
	return C.cur_print_message_mode()
}

func SetPrintMode(mode uint) {
	if mode <= 2 {
		return
	}
	C.set_print_message_mode(mode)
}

func PrintMessage(message string) {
	msg := C.CString(message)
	defer C.free(unsafe.Pointer(msg))
	C.print_message(msg)
}

func ImgFileToSixel(filename string) {
	img := C.CString(filename)
	defer C.free(unsafe.Pointer(img))
	C.sixel_image(img)
}
