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
        uint256 age;
        string specialConditions;
        string bloodGroup;
        mapping(string => Allergies) allergies;
        mapping(string => Prescription) prescriptions;
        uint256 prescriptionsCount;
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
        uint256 _age,
        string memory _specialConditions,
        string memory _bloodGroup
    ) public {
        Patient storage patient = patients[_id];
        patient.name = _name;
        patient.age = _age;
        patient.specialConditions = _specialConditions;
        patient.bloodGroup = _bloodGroup;
    }

    function updateAllergies(
        string memory _p_id,
        string[] memory _food,
        string[] memory _medicines,
        string[] memory _others
    ) public onlyDoctor {
        Patient storage patient = patients[_p_id];
        patient.allergies[_p_id] = Allergies(_food, _medicines, _others);
    }

    function updateVaccine(
        string memory _p_id,
        string memory _name,
        string memory _date
    ) public onlyDoctor {
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
        string memory _description
    ) public onlyDoctor {
        Patient storage patient = patients[_p_id];
        uint256 prescriptionsIndex = patient.prescriptionsCount;
        patient.prescriptions[prescriptionsIndex] = Prescription(_date, _doctorName, _interval, _name, _description);
        patient.prescriptionsCount++;
        
    }

    function updateBloodPressure(
        string memory _p_id,
        string memory _date,
        uint256 _SP,
        uint256 _DP,
        uint256 _HB
    ) public onlyDoctor {
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
    ) public onlyDoctor {
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
        uint256,
        string memory,
        string[] memory
    )
{
    Patient storage patient = patients[_p_id];

    return (patient.name, patient.age,_specialConditions ? patient.specialConditions : "");
}

function getPrescription(string memory _p_id,bool _prescriptions)
    public
    view
    returns (Prescription[] memory) 
    {
      if( _prescriptions)
        Patient storage patient = patients[_p_id];
        uint256 count = patient.prescriptionsIndex;
        Prescription[] memory Prescriptions = new Prescription[](count);

        for (uint256 i = 0; i < count; i++) {
            Prescriptions[i] = patient.prescriptions[i];
        }
        return Prescriptions;
        }

    }
function getAllergies(string memory _p_id,bool _allergies)
        public
        view
        returns (string[] memory, string[] memory, string[] memory)
    {   
        if( _allergies)
        { 
        Patient storage patient = patients[_p_id];
        Allergies storage allergies = patient.allergies[_p_id];
        return (allergies.food, allergies.medicines, allergies.others);
        }
    }

    function getPatientBloodPressure(string memory _p_id,bool _bloodPressure)
        public
        view
        returns (BloodPressure[] memory)
    {
        if( _bloodPressure)
        {
        Patient storage patient = patients[_p_id];
        uint256 count = patient.bloodPressureCount;
        BloodPressure[] memory bloodPressures = new BloodPressure[](count);

        for (uint256 i = 0; i < count; i++) {
            bloodPressures[i] = patient.bloodPressures[i];
        }
        return bloodPressures;
        }

        
    }

    function getPatientSugar(string memory _p_id,bool _sugar) public view returns (Sugar[] memory) {
        if(_sugar)
        {
        Patient storage patient = patients[_p_id];
        uint256 count = patient.sugarCount;
        Sugar[] memory sugars = new Sugar[](count);

        for (uint256 i = 0; i < count; i++) {
            sugars[i] = patient.sugars[i];
        }
        return sugars;
        } 
    }

    function getPatientVaccines(string memory _p_id, bool _vaccine) public view returns (Vaccine[] memory) {
        if(_vaccine)
        {
        Patient storage patient = patients[_p_id];
        uint256 count = patient.vaccineCount;
        Vaccine[] memory vaccines = new Vaccine[](count);

        for (uint256 i = 0; i < count; i++) {
            vaccines[i] = patient.vaccines[i];
        }
        return vaccines;
        }
    }
}

contract Doctor {
    struct DoctorInfo {
        string name;
        string doctorId;
        string hospitalName;
        string license;
        string description;
    }

    mapping(address => DoctorInfo) private doctors;

    function addDoctor(
        string memory _name,
        string memory _doctorId,
        string memory _hospitalName,
        string memory _license,
        string memory _description
    ) public {
        doctors[msg.sender] = DoctorInfo(_name, _doctorId, _hospitalName, _license, _description);
    }

    function getDoctorInfo(address _doctorAddress)
        public
        view
        returns (
            string memory,
            string memory,
            string memory,
            string memory,
            string memory
        )
    {
        DoctorInfo storage doctor = doctors[_doctorAddress];
        return (
            doctor.name,
            doctor.doctorId,
            doctor.hospitalName,
            doctor.license,
            doctor.description
        );
    }
}