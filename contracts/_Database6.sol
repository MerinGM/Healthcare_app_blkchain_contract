// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MedicalRecords {
//  struct Allergies {
//        string[] food;
//        string[] medicines;
//        string[] others;
//    }

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
        string allergies;
        mapping(uint256 => Prescription) prescriptions;
        uint256 prescriptionCount;
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

    constructor() {
    }

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

//    function updateAllergies(
//        string memory _p_id,
//        string[] memory _food,
//        string[] memory _medicines,
//        string[] memory _others
//    ) internal {
//        Patient storage patient = patients[_p_id];
//        patient.allergies[_p_id] = Allergies(_food, _medicines, _others);
//    }

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


    function authorizeDoctor(string memory _doctorId, string memory _p_id) public {
        Patient storage patient = patients[_p_id];
        patient.authorizedDoctors[_doctorId] = true;
    }

    function revokeDoctor(string memory _doctorId, string memory _p_id) public {
        Patient storage patient = patients[_p_id];
        patient.authorizedDoctors[_doctorId] = false;
    }

     function getPatientInfo(
        string memory _p_id,
        bool _bloodGroup,
        bool _allergies,
        bool _specialConditions
        
    )
        public
        view
        returns (
            string memory,
            string memory,
            string memory,
            string memory
        )
    {
        Patient storage patient = patients[_p_id];

        return (patient.name, _bloodGroup ? patient.bloodGroup : "",_allergies ? patient.allergies : "",_specialConditions ? patient.specialConditions : "");
    }

    function getPrescriptions(string memory _p_id,bool _prescriptions) public view returns (Prescription[] memory) {
       if( _prescriptions)
       { Patient storage patient = patients[_p_id];
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


   
//   function getAllergies(string memory _p_id,bool _allergies) public view returns (Allergies memory) {
//     if( _allergies)
//        {     
//        Patient storage patient = patients[_p_id];
//        require(patient.authorizedDoctors[msg.sender] || msg.sender == tx.origin, "Only authorized doctors or patients can access allergies");
//        return patient.allergies[_p_id];
//        }
//    }

    function getPatientBloodPressure(string memory _p_id,bool _bloodPressure) public view returns (BloodPressure[] memory) {
        if( _bloodPressure)
        {
        Patient storage patient = patients[_p_id];
        uint256 count = patient.bloodPressureCount;
        BloodPressure[] memory bloodPressures = new BloodPressure[](count);

        for (uint256 i = 0; i < count; i++) {
            bloodPressures[i] = patient.bloodPressures[i];
        }

        return bloodPressures;
        }else {
        return new BloodPressure[](0); // Return an empty array if _bloodPressure is false
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
        }else {
        return new Sugar[](0); // Return an empty array if _sugar is false
    }
    }

    function getPatientVaccines(string memory _p_id,bool _vaccine) public view returns (Vaccine[] memory) {
      if(_vaccine)
        {
        Patient storage patient = patients[_p_id];
        uint256 count = patient.vaccineCount;
        Vaccine[] memory vaccines = new Vaccine[](count);

        for (uint256 i = 0; i < count; i++) {
            vaccines[i] = patient.vaccines[i];
        }
        return vaccines;
        }else {
        return new Vaccine[](0); // Return an empty array if _vaccine is false
    }
    }

 /*   function viewPatientInfo(
        string memory _doctorId,
        string memory _p_id, 
        bool _bloodGroup,
        bool _specialConditions,
        bool _allergies,
        bool _vaccine,
        bool _bloodPressure,
        bool _sugar,
        bool _prescriptions) public view returns 
       (string memory,
        string memory,
        string memory,
        string memory,
        Prescription[] memory,
        Vaccine[] memory,
        BloodPressure[] memory,
        Sugar[] memory)
   
    {   Patient storage patient = patients[_p_id];
        if(patient.authorizedDoctors[_doctorId])
        {
            getPatientInfo(_p_id, _bloodGroup, _allergies, _specialConditions);
            getPatientVaccines(_p_id,_vaccine);
            getPatientBloodPressure(_p_id,_bloodPressure);
            getPatientSugar(_p_id,_sugar);
            getPrescriptions(_p_id,_prescriptions); 
        }
    }
    */
}
