// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Doctor {
    struct DoctorInfo {
        string name;
        string doctorId;
        string hospitalName;
        string license;
        string description;
      //  address doctorAddress;
    }

    mapping(string => DoctorInfo) private doctors;

    function addDoctor(
        string memory _name,
        string memory _doctorId,
        string memory _hospitalName,
        string memory _license,
        string memory _description
       // address _doctorAddress
    ) internal {
        doctors[_doctorId] = DoctorInfo(_name, _doctorId, _hospitalName, _license, _description);
    }

    function getDoctorInfo(string _doctorId)
        public
        view
        returns (
            string memory,
            string memory,
            string memory,
            string memory
        )
    {
        DoctorInfo storage doctor = doctors[_doctorId];
        return (
            doctor.name,
            doctor.hospitalName,
            doctor.license,
            doctor.description
        );
    }
}
