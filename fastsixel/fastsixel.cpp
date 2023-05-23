#include <stdlib.h>
#include <stdio.h>

#include <string>

#include "fastsixel.h"

static print_to cur_print_mode = to_stdout;

extern "C" print_to cur_print_message_mode() {
	return cur_print_mode;
}

extern "C" void set_print_message_mode(print_to mode) {
	cur_print_mode = mode;
}

extern "C" void print_message(const char *message) {
	printf("C FFI message: %s\n", message);
}

extern "C" int sixel_image(const char *name) {
	using namespace std::string_literals;

	std::string cmd = "img2sixel ";
	cmd += name;
	print_message(("Calling " + cmd + "...").c_str());
	return system(cmd.c_str());
}

