HOMOSAPIENS = {
    'a': 0.3029549426680,
    'c': 0.1979883004921,
    'g': 0.1975473066391,
    't': 0.3015094502008,
}

def lookup_dict(key):
    if key in HOMOSAPIENS:
        return HOMOSAPIENS[key]

