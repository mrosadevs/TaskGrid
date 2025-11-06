//Juan Task
// Manuel Task
# include <iostream>
#include "EmployeeInfo.h"
using namespace std;

int main() {
    ConfirmInfo e1;
    e1.inputEmployeeInfo();

    cout << "\nEmployee Information:\n";
    e1.displayEmployeeInfo();
    e1.confirmInfo();

    return 0;
}