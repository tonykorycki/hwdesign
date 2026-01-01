# include "../include/poly_vec.h"
#include <iostream>

int main() {
    float x[MAX_SIZE], y[MAX_SIZE], y_exp[MAX_SIZE];
    float coeffs[POLY_DEGREE+1] = {1.0, 2.0, 3.0, 4.0}; // Example coefficients for cubic polynomial
    int n = MAX_SIZE;

    // Initialize input vector uniformly spaced from xmin to xmax
    float xmin = -1.0;
    float xmax = 1.0;
    for (int i = 0; i < n; i++) {
        x[i] = xmin + i * (xmax - xmin) / (n - 1);
    }

    // Compute expected output using the polynomial
    for (int i = 0; i < n; i++) {
        y_exp[i] = coeffs[3] * x[i] * x[i] * x[i] + coeffs[2] * x[i] * x[i] + coeffs[1] * x[i] + coeffs[0];
    }

    // Call the HLS function
    poly_vec(x, y, coeffs, n);

    // Verify results
    bool pass = true;
    float tol = 1e-8;

    for (int i = 0; i < n; i++) {
        if (std::abs(y[i] - y_exp[i]) > tol) {
            std::cout << "Mismatch at " << i << ": " << y[i] << " != " << y_exp[i] << std::endl;
            pass = false;
        }
    }

    std::cout << (pass ? "Test passed!" : "Test failed!") << std::endl;
    return 0;
}
