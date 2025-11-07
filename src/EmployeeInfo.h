//
#ifndef PROTOTYPE1_EMPLOYEEINFO_H
#define PROTOTYPE1_EMPLOYEEINFO_H

#include <string>
using namespace std;

class Person
{
public:
    std::string name;
    int age;

    void inputPersonInfo();
    void displayPersonInfo() const;
};

class Employee : public Person
{
public:
    long double salary;
    long double hours;
    std::string employeeID;

    void inputEmployeeInfo();
    void displayEmployeeInfo() const;
};

class ConfirmInfo : public Employee
{
public:
    void confirmInfo();
};

#endif // PROTOTYPE1_EMPLOYEEINFO_H
// Created by JUAND on 11/5/2025.
//

#ifndef TASKGRID_EMPLOYEEINFO_H
#define TASKGRID_EMPLOYEEINFO_H

#endif //TASKGRID_EMPLOYEEINFO_H