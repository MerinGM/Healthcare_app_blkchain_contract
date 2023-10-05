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
        mapping(string => Allergies) allergies;
        mapping(uint256 => Prescription) prescriptions;
        uint256 prescriptionCount;
        mapping(uint256 => BloodPressure) bloodPressures;
        uint256 bloodPressureCount;
        mapping(uint256 => Sugar) sugars;
        uint256 sugarCount;
        mapping(uint256 => Vaccine) vaccines;
        uint256 vaccineCount;
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
    mapping(address => bool) private authorizedDoctors;

    constructor() {
        authorizedDoctors[msg.sender] = true; // Set the contract deployer as an authorized doctor
    }

    modifier onlyDoctor() {
        require(authorizedDoctors[msg.sender], "Only authorized doctors can access this function");
        _;
    }

    function authorizeDoctor(address _doctor) external onlyDoctor {
        authorizedDoctors[_doctor] = true;
    }

    function revokeDoctor(address _doctor) external onlyDoctor {
        require(msg.sender != _doctor, "The contract deployer cannot revoke themselves");
        authorizedDoctors[_doctor] = false;
    }

    function addPatient(
        string memory _id,
        string memory _name,
        string memory _DOB,
        string memory _phoneNo,
        string memory _specialConditions,
        string memory _bloodGroup
    ) public {
        Patient storage patient = patients[_id];
        patient.name = _name;
        patient.DOB = _DOB;
        patient.phoneNo = _phoneNo;
        patient.specialConditions = _specialConditions;
        patient.bloodGroup = _bloodGroup;
    }

    function updateAllergies(
        string memory _p_id,
        string[] memory _food,
        string[] memory _medicines,
        string[] memory _others
    ) public {
        Patient storage patient = patients[_p_id];
        patient.allergies[_p_id] = Allergies(_food, _medicines, _others);
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
        bool _morning,
        bool _afternoon,
        bool _evening,
        string memory _name,
        string memory _description
    ) public {
        Patient storage patient = patients[_p_id];
        uint256 prescriptionIndex = patient.prescriptionCount;
        patient.prescriptions[prescriptionIndex] = Prescription(_date, _doctorName, _morning, _afternoon, _evening, _name, _description);
        patient.prescriptionCount++;
    }

    function updateBloodPressure(
        string memory _p_id,
        string memory _date,
        uint256 _SP,
        uint256 _DP,
        uint256 _HB
    ) public {
        Patient storage patient = patients[_p_id];
        uint256 bloodPressureIndex = patient.bloodPressureCount;
        patient.bloodPressures[bloodPressureIndex] = BloodPressure(_date, _SP, _DP, _HB);
        patient.bloodPressureCount++;
    }

    function updateSugar(
        string memory _p_id,
        string memory _date,
        bool _fasting,
        bool _afterMeal,
        uint256 _level
    ) public {
        Patient storage patient = patients[_p_id];
        uint256 sugarIndex = patient.sugarCount;
        patient.sugars[sugarIndex] = Sugar(_date, _fasting, _afterMeal, _level);
        patient.sugarCount++;
    }

    function getPatientInfo(
        string memory _p_id,
        bool _bloodGroup,
        bool _specialConditions
    )
        public
        view
        returns (
            string memory,
            string memory,
            string memory
        )
    {
        Patient storage patient = patients[_p_id];

        return (patient.name, _specialConditions ? patient.specialConditions : "", _bloodGroup ? patient.bloodGroup : "");
    }

    function getPrescriptions(string memory _p_id) public view returns (Prescription[] memory) {
        Patient storage patient = patients[_p_id];
        uint256 count = patient.prescriptionCount;
        Prescription[] memory prescriptions = new Prescription[](count);

        for (uint256 i = 0; i < count; i++) {
            prescriptions[i] = patient.prescriptions[i];
        }

        return prescriptions;
    }

    function getAllergies(string memory _p_id) public view returns (Allergies memory) {
        Patient storage patient = patients[_p_id];
        return patient.allergies[_p_id];
    }

    function getPatientBloodPressure(string memory _p_id) public view returns (BloodPressure[] memory) {
        Patient storage patient = patients[_p_id];
        uint256 count = patient.bloodPressureCount;
        BloodPressure[] memory bloodPressures = new BloodPressure[](count);

        for (uint256 i = 0; i < count; i++) {
            bloodPressures[i] = patient.bloodPressures[i];
        }

        return bloodPressures;
    }

    function getPatientSugar(string memory _p_id) public view returns (Sugar[] memory) {
        Patient storage patient = patients[_p_id];
        uint256 count = patient.sugarCount;
        Sugar[] memory sugars = new Sugar[](count);

        for (uint256 i = 0; i < count; i++) {
            sugars[i] = patient.sugars[i];
        }

        return sugars;
    }

    function getPatientVaccines(string memory _p_id) public view returns (Vaccine[] memory) {
        Patient storage patient = patients[_p_id];
        uint256 count = patient.vaccineCount;
        Vaccine[] memory vaccines = new Vaccine[](count);

        for (uint256 i = 0; i < count; i++) {
            vaccines[i] = patient.vaccines[i];
        }

        return vaccines;
    }
}

