#include <stdlib.h>
#include <stdio.h>

#include <string>

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

