#pragma once

__host__ __device__
void generatePassword(int idx, char* out, int len) {
    const char charset[] = "abcdefghijklmnopqrstuvwxyz";
    int base = 26;

    for (int i = 0; i < len; i++) {
        out[i] = charset[idx % base];
        idx /= base;
    }
}