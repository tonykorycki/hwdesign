import numpy as np
import matplotlib.pyplot as plt

def subc_divide(
        a : np.uint32,
        b : np.uint32,
        nbits : int = 16
    ) -> np.int32:
    """
    Perform integer division of using conditional subtraction.

    Given two unsigned integers `a` and `b`, with `b > a >= 0`, the function 
    computes a rational approximation of the division:

        a/b ~= qhat = z/(2^nbits)

    The error is bounded by:

        qhat  < a/b  <= qhat + 2^(-nbits)

    Parameters
    ----------
    a : np.uint32
        The dividend.
    b : np.uint32
        The divisor.
    nbits : int, optional
        The number of bits for the fractional part of the quotient. Default is 16.

    Returns:
    ------
    z: int: 
        The numerator of the rational approximation of the quotient.
    """
    if b == 0:
        raise ValueError("Division by zero is not allowed.")
    if (a >= b) or (a < 0):
        raise ValueError("We must have a < b and a >= 0.")
    
    # TODO: Implement the conditional subtraction division algorithm
    z = 0

    for i in range(nbits):
        a <<= 1  # Shift a left by 1 (multiply by 2)
        z <<= 1  # Shift z left by 1 (multiply by 2)
        if a >= b:
            a -= b  # Subtract b from a
            z |= 1  # Set the least significant bit of z to 1

    return z