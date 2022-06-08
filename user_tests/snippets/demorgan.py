def demorgan(a: bool, b: bool) -> bool:
    return (a and b) == (not ((not a) or (not b)))