package goasm_fast_call

import "unsafe"

// UnsafeCall0 allows calling a C function from Go. The function takes no arguments
// and does not return a value. The C function is invoked on the system stack,
// but no attempt is made to play nice with the Go scheduler or GC, so care
// must be taken. Do not use unless you know what you are doing.
func UnsafeCall0(fn unsafe.Pointer)

// UnsafeCall1 allows calling a C function taking 1 uintptr argument from Go.
func UnsafeCall1(fn unsafe.Pointer, arg0 uintptr)

// UnsafeCall1 allows calling a C function taking 1 uintptr argument from Go.
func UnsafeCall1WithRet(fn unsafe.Pointer, arg0 uintptr) uintptr

// UnsafeCall4 allows calling a C function taking 4 uint64 arguments from Go.
func UnsafeCall4(fn unsafe.Pointer, arg0, arg1, arg2, arg3 uintptr)
