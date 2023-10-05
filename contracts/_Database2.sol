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
        bool isVisible;
    }

    struct Patient {
        string name;
        string p_id;
        uint256 age;
        mapping(uint256 => BloodPressure) BP;
        mapping(uint256 => Sugar) sugar;
        mapping(uint256 => Vaccine) vaccines;
        uint256 BPCount;
        uint256 sugarCount;
        uint256 vaccineCount;
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

    struct Sugar {
        string Date;
        bool Fasting;
        bool afterMeal;
        uint256 level; 
    }

    struct Doctor {
        address doctorAddress;
        string name;
        string d_id;
        string hospital;
        string license;
        string description;
    }

    mapping(address => Doctor) private doctors;
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
    ) public  {
        patientAllergies[_p_id] = Allergies(_food, _medicines, _others);
    }

    function updateBP(
        string memory _p_id,
        string memory _date,
        uint256 _SP,
        uint256 _DP,
        uint256 _HB
    ) public {
        Patient storage patient = patients[_p_id];
        uint256 bpIndex = patient.BPCount;
        patient.BloodPressure[bpIndex] = BloodPressure(_date,_SP, _DP,_HB);
        patient.BPCount++;
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

    function getPatientVaccines(string memory _p_id)
        external
        view
        returns (string[] memory, string[] memory)
    {
        Patient storage patient = patients[_p_id];
        uint256 count = patient.vaccineCount;
        string[] memory names = new string[](count);
        string[] memory dates = new string[](count);

        for (uint256 i = 0; i < count; i++) {
            Vaccine storage vaccine = patient.vaccines[i];
            names[i] = vaccine.name;
            dates[i] = vaccine.date;
        }

        return (names, dates);
    }

    function getPatientPrescriptions(string memory _p_id)
        external
        view
        returns (Prescription[] memory)
    {
        Patient storage patient = patients[_p_id];
        return patient.prescriptions;
    }

    function getPatientBloodPressure(string memory _p_id, uint256 _index)
        external
        view
        returns (string memory, uint256, uint256, uint256)
    {
        Patient storage patient = patients[_p_id];
        BloodPressure storage bp = patient.BP[_index];
        return (bp.Date, bp.SP, bp.DP, bp.HB);
    }

    function getPatientSugar(string memory _p_id)
        external
        view
        returns (string memory, bool, bool, uint256)
    {
        Patient storage patient = patients[_p_id];
        Sugar storage sugar = patient.sugar;
        return (sugar.Date, sugar.Fasting, sugar.afterMeal, sugar.level);
    }

    function getPatientInfo(string memory _p_id)
        external
        view
        returns (
            string memory,
            string memory,
            uint256,
            string memory,
            string memory
        )
    {
        Patient storage patient = patients[_p_id];
        return (
            patient.name,
            patient.p_id,
            patient.age,
            patient.specialConditions,
            patient.bloodGroup
        );
    }
}
