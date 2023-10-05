// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MedicalRecords {
    struct Allergies {
        string[] food;
        string[] medicines;
        string[] others;
    }

    struct Vaccine {
        string name;
        string date;
    }

    struct Prescription {
        string date;
        string doctorName;
        uint256 interval;
        string name;
        string description;
    }

    struct Patient {
        string name;
        string p_id;
        uint256 age;
        mapping(uint256 => BloodPressure) BP; // Mapping to store BloodPressure instances
        mapping(uint256 => Sugar) sugar; // Mapping to store Sugar instances
        mapping(uint256 => Vaccine) vaccines; // Mapping to store Vaccine instances
        uint256 vaccineCount; // Track the number of vaccines
        string specialConditions;
        string bloodGroup;
        Prescription[] prescriptions;
    }

    struct BloodPressure {
        string Date;
        uint256 SP;
        uint256 DP;
        uint256 HB; 
    }

    struct Sugar{
       string Date;
       bool Fasting;
       bool afterMeal;
       uint256 level; 

    }

    struct Doctor {
        address doctorAddress; // New field to store the doctor's address
        string name;
        string d_id;
        string hospital;
        string license;
        string description;
    }


    mapping(address => Doctor) private doctors; // Use address as the key for doctors mapping
    mapping(string => Patient) private patients;
    mapping(string => Allergies) private patientAllergies;

    modifier onlyDoctor() {
        require(doctors[msg.sender].doctorAddress == msg.sender, "Only authorized doctors can access this function");
        _;
    }

    function addDoctor(
        string memory _name,
        string memory _d_id,
        string memory _hospital,
        string memory _license,
        string memory _description
    ) public {
        doctors[msg.sender] = Doctor(msg.sender, _name, _d_id, _hospital, _license, _description);
    }

    function addPatient (
        string memory _name,
        string memory _p_id,
        uint256 _age,
        string memory _specialConditions,
        string memory _bloodGroup
    ) public {
        Patient storage newPatient = patients[_p_id];
        newPatient.name = _name;
        newPatient.p_id = _p_id;
        newPatient.age = _age;
        newPatient.specialConditions = _specialConditions;
        newPatient.bloodGroup = _bloodGroup;
    }

    function updateAllergy(
        string memory _p_id,
        string[] memory _food,
        string[] memory _medicines,
        string[] memory _others
    ) external onlyDoctor {
        patientAllergies[_p_id] = Allergies(_food, _medicines, _others);
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
        string memory _doctorName,
        uint256 _interval,
        string memory _name,
        string memory _description,
        bool _isVisible
    ) public {
        patients[_p_id].prescriptions.push(
            Prescription(_date, _doctorName, _interval, _name, _description, _isVisible)
        );
    }

    function getPatientAllergies(string memory _p_id)
        external
        view
        returns (string[] memory, string[] memory, string[] memory)
    {
        Allergies storage allergies = patientAllergies[_p_id];
        return (allergies.food, allergies.medicines, allergies.others);
    }

    function getPatientBP(string memory _p_id)
        external
        view
        returns (string[] memory, uint256[] memory, uint256[] memory, uint256[] memory)
    {
        Patient storage patient = patients[_p_id];
        uint256 count = patient.BPCount();
        string[] memory dates = new string[](count);
        uint256[] memory spValues = new uint256[](count);
        uint256[] memory dpValues = new uint256[](count);
        uint256[] memory hbValues = new uint256[](count);

        for (uint256 i = 0; i < count; i++) {
            BloodPressure storage bp = patient.BP[i];
            dates[i] = bp.Date;
            spValues[i] = bp.SP;
            dpValues[i] = bp.DP;
            hbValues[i] = bp.HB;
        }

        return (dates, spValues, dpValues, hbValues);
    }

    function getPatientSugar(string memory _p_id)
        external
        view
        returns (string[] memory, bool[] memory, bool[] memory, uint256[] memory)
    {
        Patient storage patient = patients[_p_id];
        uint256 count = patient.sugarCount();
        string[] memory dates = new string[](count);
        bool[] memory fastingValues = new bool[](count);
        bool[] memory afterMealValues = new bool[](count);
        uint256[] memory levelValues = new uint256[](count);

        for (uint256 i = 0; i < count; i++) {
            Sugar storage sugar = patient.sugar[i];
            dates[i] = sugar.Date;
            fastingValues[i] = sugar.Fasting;
            afterMealValues[i] = sugar.afterMeal;
            levelValues[i] = sugar.level;
        }

        return (dates, fastingValues, afterMealValues, levelValues);
    }
    function getPatientInfo(string memory _p_id)
        external
        view
        returns (
            string memory,
            string memory,
            uint256,
            uint256[] memory,
            uint256[] memory,
            string memory,
            string memory,
            Prescription[] memory
        )
    {
        Patient storage patient = patients[_p_id];
        return (
            patient.name,
            patient.p_id,
            patient.age,
            patient.specialConditions,
            patient.bloodGroup,
            patient.prescriptions
        );
    }

     function getPatientBPCount(string memory _p_id) external view returns (uint256) {
        Patient storage patient = patients[_p_id];
        return patient.BPCount();
    }
    
    function getPatientSugarCount(string memory _p_id) external view returns (uint256) {
        Patient storage patient = patients[_p_id];
        return patient.sugarCount();
    }
}