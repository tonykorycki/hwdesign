#ifndef VMULT_H
#define VMULT_H

// Configuration parameters for vector multiplication
// We check if the parameters are defined by the TCL script.
// If not, we set them to default values.
#ifndef PIPELINE_EN  
#define PIPELINE_EN 0  // Enables pipelining
#endif
#ifndef UNROLL_FACTOR  
#define UNROLL_FACTOR 4  // Unrolls loops when > 1
#endif
#ifndef MAX_SIZE  
#define MAX_SIZE 1024  // Array size to test
#endif
#ifndef DATA_FLOAT   
#define DATA_FLOAT 1   // Data type:  1= float, 0=int
#endif

#define POLY_DEGREE 3

#if DATA_FLOAT
typedef float data_t;
#else
typedef int data_t;
#endif

void poly_vec(
    float *x_in,         // AXI master input
    float *y_out,        // AXI master output
    float coeffs[POLY_DEGREE+1],     // AXI-lite control: coeffs[0]=a, coeffs[1]=b, coeffs[2]=c, coeffs[3]=d
    int size             // AXI-lite control
);

#endif
