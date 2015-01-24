#include <iostream>

#include "ProofeeIndex.h"

using namespace std;

int main() {
    cout << "Hello, World!" << endl;

    ProofeeIndex proofeeIndex;
    proofeeIndex.LoadFromFile("/home/user/devel/prj/proofee/roofee-0000.csv");

    // ProofeeIndex * proofeeIndex = new ProofeeIndex();
    // proofeeIndex->LoadFromFile("");

    return 0;
}
