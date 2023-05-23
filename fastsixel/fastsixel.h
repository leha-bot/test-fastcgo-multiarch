// Simplest C FFI API for testing goasm fast calls
#pragma once
#ifdef __cplusplus
extern "C" {
#endif

// Determines standard stream for printing FFI messages.
enum print_to {
    to_stdout, to_stderr
};

enum print_to cur_print_message_mode();
void set_print_message_mode(enum print_to mode);

void print_message(const char *message);
int sixel_image(const char *name);

#ifdef __cplusplus
}
#endif
