import numpy as np

def softmax(x):
    e = np.exp(x - np.max(x))
    s = np.sum(e)
    return e / s

print(softmax(np.array([4, 0, 2, 9])))
print(softmax(np.array([10, 10, 10, 10])))
print(softmax(np.array([0, 0, 0, 10])))
print(softmax(np.array([200, 1000, 100, 200])))