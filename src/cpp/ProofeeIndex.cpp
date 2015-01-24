#include <iostream>
#include <istream>
#include <fstream>
#include <cstring>
#include <sstream>
#include <iterator>


#include <stdio.h>
#include <ctype.h>

#include "ProofeeIndex.h"

using namespace std;

ProofeeIndex::ProofeeIndex() {

}

ProofeeIndex::~ProofeeIndex() {

}

struct tokens: std::ctype<char>
{
    tokens(): std::ctype<char>(get_table()) {}

    static std::ctype_base::mask const* get_table()
    {
        typedef std::ctype<char> cctype;
        static const cctype::mask *const_rc= cctype::classic_table();

        static cctype::mask rc[cctype::table_size];
        std::memcpy(rc, const_rc, cctype::table_size * sizeof(cctype::mask));

        rc[' '] = std::ctype_base::alnum;
        rc['+'] = std::ctype_base::alnum;
        rc[','] = std::ctype_base::alnum;
        rc[':'] = std::ctype_base::space;
        return &rc[0];
    }
};


size_t ProofeeIndex::LoadFromFile(string fileName) {

    ifstream file(fileName);

    if (file) {
        string line;

//          space problem
//        while (file >> line) {m_Lines.push_back(line);}

        while (getline(file, line)) {
            m_Lines.push_back(line);
        }

        vector<string>::iterator it_lines = m_Lines.begin();
        while (m_Lines.end() != it_lines) {
            stringstream ss(*it_lines);

            ss.imbue(locale(locale(), new tokens()));
            istream_iterator<string> begin(ss);
            istream_iterator<string> end;
            vector<string> vstrings(begin, end);
            // copy(vstrings.begin(), vstrings.end(), ostream_iterator<string>(cout, "\n"));

            // cout << vstrings.size() << " " << *it_lines << std::endl;
            if (1 < vstrings.size()) {
                for (vector<string>::iterator it = vstrings.begin(); it != vstrings.end(); it++) {
                    cout << "  -" << *it << std::endl;
                }

            }
            it_lines++;
        }

    }


    return 0;
}
