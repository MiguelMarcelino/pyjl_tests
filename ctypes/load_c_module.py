# Implementation from Guillaume Androz

import ctypes

import numpy as np


def load_module():
    # load library
    cmodule = ctypes.cdll.LoadLibrary('./levenshtein.so')
    # define arguments type
    cmodule.levenshtein.argtypes = [ctypes.c_char_p, 
                                    ctypes.c_char_p, 
                                    ctypes.c_int, 
                                    ctypes.c_int, 
                                    ctypes.c_int]
    # define return type
    cmodule.levenshtein.restype = ctypes.c_int
    return cmodule

if __name__ == "__main__":
    # load c library
    cmodule = load_module()
    # define source and target strings
    source = "levenshtein"
    target = "levenstein"
    # define edition costs
    insert_cost = 1
    delete_cost = 1
    replace_cost = 2
    # call c function
    res = cmodule.levenshtein(source.encode('utf-8'),  # encode the string into binary representation
                            target.encode('utf-8'),
                            np.int32(insert_cost),  #explicitly tells that we need a 32bits integer
                            np.int32(delete_cost),
                            np.int32(replace_cost))
    print(f"Levenshtein distance between '{source}' and '{target}': {res}")
    # prints "Levenshtein distance between 'levenshtein' and 'levenstein': 1"
