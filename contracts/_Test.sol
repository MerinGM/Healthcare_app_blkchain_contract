// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MedicalRecords {
    struct Allergies public {
        string[] food;
        string[] medicines;
        string[] others;
    }
}