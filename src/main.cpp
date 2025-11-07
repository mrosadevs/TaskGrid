#include <iostream>
#include "EmployeeInfo.h"
using namespace std;

int main()
{
    ConfirmInfo employee;
    employee.inputEmployeeInfo();
    employee.displayEmployeeInfo();
    employee.confirmInfo();

    return 0;
}