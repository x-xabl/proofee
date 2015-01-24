#ifndef PROOFEE_INDEX_H
#define PROOFEE_INDEX_H

#include <iostream>
#include <vector>
#include <string>

using namespace std;

typedef struct ProofeeIndexItem {
  string Tag;
  vector<size_t> Items();
} ProofeeIndexItem;


class ProofeeIndex
{
private:
    vector<ProofeeIndexItem> m_Items;
    vector<string> m_Lines;
public:
    ProofeeIndex();
    virtual ~ProofeeIndex();

    size_t  LoadFromFile(string fileName);
};

#endif // PROOFEE_INDEX_H
