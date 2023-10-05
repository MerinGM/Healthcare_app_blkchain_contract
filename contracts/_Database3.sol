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
        Prescription[] prescriptions;
        mapping(uint256 => BloodPressure) bloodPressures;
        mapping(uint256 => Sugar) sugars;
        mapping(uint256 => Vaccine) vaccines;
        uint256 vaccineCount;
        uint256 bloodPressureCount;
        uint256 sugarCount;

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
        uint256 _interval,
        string memory _name,
        string memory _description
    ) public {
        Patient storage patient = patients[_p_id];
        patient.prescriptions.push(
            Prescription(_date, _doctorName, _interval, _name, _description)
        );
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

    function getAllergies(string memory _p_id)
        public
        view
        returns (string[] memory, string[] memory, string[] memory)
    {
        Patient storage patient = patients[_p_id];
        Allergies storage allergies = patient.allergies[_p_id];
        return (allergies.food, allergies.medicines, allergies.others);
    }

    function getVaccines(string memory _p_id)
        public
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

    function getPrescriptions(string memory _p_id)
        public
        view
        returns (Prescription[] memory)
    {
        Patient storage patient = patients[_p_id];
        return patient.prescriptions;
    }

   function getPatientBloodPressure(string memory _p_id)
        public
        view
        returns (string[] memory, uint256[] memory, uint256[] memory, uint256[] memory)
    {
        Patient storage patient = patients[_p_id];
        uint256 count = patient.bloodPressureCount;
        string[] memory dates = new string[](count);
        uint256[] memory SPs = new uint256[](count);
        uint256[] memory DPs = new uint256[](count);
        uint256[] memory HBs = new uint256[](count);

        for (uint256 i = 0; i < count; i++) {
            BloodPressure storage bloodPressure = patient.bloodPressures[i];
            dates[i] = bloodPressure.date;
            SPs[i] = bloodPressure.SP;
            DPs[i] = bloodPressure.DP;
            HBs[i] = bloodPressure.HB;
        }

        return (dates, SPs, DPs, HBs);
    }
    function getPatientSugar(string memory _p_id)
        public
        view
        returns (string[] memory, bool[] memory, bool[] memory, uint256[] memory)
    {
        Patient storage patient = patients[_p_id];
        uint256 count = patient.sugarCount;
        string[] memory dates = new string[](count);
        bool[] memory fastingStatus = new bool[](count);
        bool[] memory afterMealStatus = new bool[](count);
        uint256[] memory levels = new uint256[](count);

        for (uint256 i = 0; i < count; i++) {
            Sugar storage sugar = patient.sugars[i];
            dates[i] = sugar.date;
            fastingStatus[i] = sugar.fasting;
            afterMealStatus[i] = sugar.afterMeal;
            levels[i] = sugar.level;
        }

        return (dates, fastingStatus, afterMealStatus, levels);
    }
    function getPatientInfo(string memory _p_id)
        public
        view
        returns (
            string memory,
            uint256,
            string memory,
            string memory
        )
    {
        Patient storage patient = patients[_p_id];
        return (
            patient.name,
            patient.age,
            patient.specialConditions,
            patient.bloodGroup
        );
    }
}
