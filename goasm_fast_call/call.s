// +build amd64 amd64p32 arm64

#include "go_asm.h"
#include "textflag.h"

// Brief info about registers' aliases
//
// - RARGn is a Register alias for ARGn.
// - R_SP  is a Register alias for Stack Pointer (SP for x86, R13 for ARM).
// - RTMP0, RTMP1 are Register aliases for temporary Generic Registers
//                (to avoid using the reserved registries' names).

#ifdef GOOS_windows
#define RARG0 CX
#define RARG1 DX
#define RARG2 R8
#define RARG3 R9
#define R_SP  SP
#define RTMP0 R13
#define RTMP1 R14
#else
#ifdef GOARCH_arm64
// see https://developer.arm.com/documentation/den0024/a/The-ABI-for-ARM-64-bit-Architecture/Register-use-in-the-AArch64-Procedure-Call-Standard/Parameters-in-general-purpose-registers
// for details of all ARM regs,
// For asm details see https://9p.io/sys/doc/asm.html
#define RARG0 R0
#define RARG1 R1
#define RARG2 R2
#define RARG3 R3
#define R_SP  R13
#define RTMP0 R8
#define RTMP1 R9
#else
#define RARG0 DI
#define RARG1 SI
#define RARG2 DX
#define RARG3 CX
#define R_SP  SP
#define RTMP0 R13
#define RTMP1 R14
#endif
#endif

#ifdef GOARCH_arm64
/* CALL_REG is a temporary register for storing an actual pointer to called function. */
#define CALL_REG R4
#define G_VAR g
#define MOV_64bit MOVD
#define MOV_adr64bit MOVD.P
#define PREPARE_CALL                                                            \
	MOVD fn+0(FP), CALL_REG
#define AND_64bit ANDD
#else
#define CALL_REG AX
#define G_VAR (TLS)
#define PREPARE_CALL                                                            \
        MOV fn+0(FP), CALL_REG
#define MOV_64bit MOVQ
#define AND_64bit ANDQ
#endif

#define UNSAFE_CALL                                                                 \
	/* Switch stack to g0 */                                                    \
	MOV_64bit G_VAR, RTMP1;                     /* Load g */                             
	MOV_64bit g_m(RTMP1), RTMP0;                /* Load g.m */                           
	MOV_64bit R_SP, R12;                        /* Save SP in a callee-saved register */
	MOV_64bit m_g0(RTMP0), RTMP1;               /* Load m.go */                         
	MOV_64bit (g_sched+gobuf_sp)(RTMP1), R_SP;  /* Load g0.sched.sp */                  
	AND $~15, R_SP;                     /* Align the stack to 16-bytes */       
	CALL CALL_REG;                                                             
	MOV_64bit R12, R_SP;                        /* Restore SP */                        
	
// func UnsafeCall0(fn unsafe.Pointer)
// Switches SP to g0 stack and calls fn.
TEXT ·UnsafeCall0(SB), NOSPLIT, $0-0
	PREPARE_CALL
	UNSAFE_CALL
	RET


// func UnsafeCall1(fn unsafe.Pointer, arg0 uintptr)
// Switches SP to g0 stack and calls fn with one arg.
TEXT ·UnsafeCall1(SB), NOSPLIT, $0-0
	// MOVD fn+0(FP), CALL_REG /*PREPARE_CALL: store pointer to temporary register. */
	PREPARE_CALL
	MOV_64bit arg0+8(FP), RARG0
	MOV_64bit G_VAR, RTMP1;                     /* Load g */                             
	MOV_64bit g_m(RTMP1), RTMP0;                /* Load g.m */                           
	MOV_64bit R_SP, R12;                        /* Save SP in a callee-saved register */
	MOV_64bit m_g0(RTMP0), RTMP1;               /* Load m.go */                         
	MOV_64bit (g_sched+gobuf_sp)(RTMP1), R_SP;  /* Load g0.sched.sp */                  
	AND $~15, R_SP;                     /* Align the stack to 16-bytes */       
	CALL CALL_REG;                                                             
	MOV_64bit R12, R_SP;                        /* Restore SP */                        
	RET


// func UnsafeCall4(fn unsafe.Pointer, arg0, arg1, arg2, arg3 uintptr)
// Switches SP to g0 stack and calls fn.
TEXT ·UnsafeCall4(SB), NOSPLIT, $0-0
	PREPARE_CALL
	MOV_64bit arg0+8(FP), RARG0
	MOV_64bit arg1+16(FP), RARG1
	MOV_64bit arg2+24(FP), RARG2
	MOV_64bit arg3+32(FP), RARG3
	UNSAFE_CALL
	RET
