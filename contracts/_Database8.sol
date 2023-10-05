// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MedicalRecords {
    struct Vaccine {
        string name;
        string date;
    }

    struct Prescription {
        uint256 prescriptionId;
        string date;
        string doctorName;
    }

    struct Medicine {
        bool morning;
        bool afternoon;
        bool evening;
        string name;
        string description;
    }

    struct Patient {
        string name;
        string DOB;
        string phoneNo;
        string specialConditions;
        string bloodGroup;
        string allergies;
        mapping(uint256 => Prescription) prescriptions;
        mapping(uint256 => mapping(uint256 => Medicine)) medicines; // Mapping to store medicines for each prescription
        uint256 prescriptionCount;
        uint256 medicineCount;
        mapping(uint256 => BloodPressure) bloodPressures;
        uint256 bloodPressureCount;
        mapping(uint256 => Sugar) sugars;
        uint256 sugarCount;
        mapping(uint256 => Vaccine) vaccines;
        uint256 vaccineCount;
        mapping(string => bool) authorizedDoctors;
    }

    struct BloodPressure {
        string date;
        uint256 SP;
        uint256 DP;
        uint256 HB;
    }

    struct Sugar {
        string date;
        bool fasting;
        bool afterMeal;
        uint256 level;
    }

    mapping(string => Patient) private patients;

    constructor() {}

    function addPatient(
        string memory _id,
        string memory _name,
        string memory _DOB,
        string memory _phoneNo,
        string memory _specialConditions,
        string memory _allergies,
        string memory _bloodGroup
    ) public {
        Patient storage patient = patients[_id];
        patient.name = _name;
        patient.DOB = _DOB;
        patient.phoneNo = _phoneNo;
        patient.allergies = _allergies;
        patient.specialConditions = _specialConditions;
        patient.bloodGroup = _bloodGroup;
    }

    function updateVaccine(
        string memory _p_id,
        string memory _name,
        string memory _date
    ) public {
        Patient storage patient = patients[_p_id];
        uint256 vaccineIndex = patient.vaccineCount;
        patient.vaccines[vaccineIndex] = Vaccine(_name, _date);
        patient.vaccineCount++;
    }

    function updatePrescription(
        string memory _p_id,
        string memory _date,
        string memory _doctorName
    ) public {
        Patient storage patient = patients[_p_id];
        uint256 prescriptionIndex = patient.prescriptionCount;
        patient.prescriptions[prescriptionIndex] = Prescription(
            prescriptionIndex,
            _date,
            _doctorName
        );
        patient.prescriptionCount++;
    }

    function updateMedicine(
        string memory _p_id,
        uint256 _prescriptionId,
        bool _morning,
        bool _afternoon,
        bool _evening,
        string memory _name,
        string memory _description
    ) public {
        Patient storage patient = patients[_p_id];
        uint256 medicineIndex = patient.medicineCount ; // Get the index of the last prescription added

        Medicine memory newMedicine = Medicine(
            _morning,
            _afternoon,
            _evening,
            _name,
            _description
        );
        patient.medicines[_prescriptionId][medicineIndex] = newMedicine;
    }

      function getPrescriptions(string memory _p_id, bool _prescriptions)
        public
        view
        returns (Prescription[] memory)
    {
        if (_prescriptions) {
            Patient storage patient = patients[_p_id];
            uint256 count = patient.prescriptionCount;
            Prescription[] memory prescriptions = new Prescription[](count);

            for (uint256 i = 0; i < count; i++) {
                prescriptions[i] = patient.prescriptions[i];
            }
            return prescriptions;
        } else {
            return new Prescription[](0); // Return an empty array if _prescriptions is false
        }
    }

    // Rest of the contract code...

  /*  function getPrescriptions(string memory _p_id)
        public
        view
        returns (Prescription[] memory)
    {
        Patient storage patient = patients[_p_id];
        uint256 count = patient.prescriptionCount;
        Prescription[] memory prescriptions = new Prescription[](count);

        for (uint256 i = 0; i < count; i++) {
            prescriptions[i] = patient.prescriptions[i];
        }
        return prescriptions;
    }
    */
}
