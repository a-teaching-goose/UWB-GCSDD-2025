#include <iostream>

// Finds the element-wise maximum between two arrays of length n
int *maxArrays(int *arr1, int *arr2, int n) {
    int *result = new int[n];   // allocate n integers from heap
    int *ptr = result;
    for (int i = 0; i < n; ++i) {
        *ptr = (*arr1 > *arr2) ? *arr1 : *arr2;
        arr1++;
        arr2++;
        ptr++;
    }
    return result;
}

// reference is only syntax sugar to pointer

int main() {
    int a[] = {1, 7, 3, 9, 5};
    int b[] = {2, 6, 4, 8, 10};
    int *result;

    result = maxArrays(a, b, 5);

    std::cout << "Element-wise max array: ";
    for (int i = 0; i < 5; ++i) {
        std::cout << result[i] << " ";
    }
    std::cout << "\n";
}
