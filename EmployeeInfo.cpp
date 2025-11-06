#include "EmployeeInfo.h"
#include <iostream>

using std::cin;
using std::cout;
using std::endl;
using std::getline;

void Person::inputPersonInfo() {
    cout << "Name: ";
    getline(cin, name);
    cout << "Age: ";
    cin >> age;
    cin.ignore(); // clear newline
}

void Person::displayPersonInfo() const {
    cout << "Name: " << name << endl;
    cout << "Age: " << age << endl;
}

void Employee::inputEmployeeInfo() {
    inputPersonInfo();
    cout << "Salary: ";
    cin >> salary;
    cout << "Hours: ";
    cin >> hours;
    cin.ignore();
    cout << "Employee ID: ";
    getline(cin, employeeID);
}

void Employee::displayEmployeeInfo() const {
    displayPersonInfo();
    cout << "Salary: $" << salary << endl;
    cout << "Hours: " << hours << endl;
    cout << "Employee ID: " << employeeID << endl;
}

void ConfirmInfo::confirmInfo() {
    int confirm;
    cout << "Is the employee info correct? (1 = Yes, 2 = No): ";
    cin >> confirm;

    if (confirm == 1) cout << "Employee info confirmed." << endl;
    else if (confirm == 2) cout << "Employee info not confirmed." << endl;
    else cout << "Invalid choice." << endl;
}
//
// Created by JUAND on 11/5/2025.
//