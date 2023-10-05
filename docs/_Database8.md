# Solidity API

## MedicalRecords

### Contract
MedicalRecords : contracts/_Database8.sol

 --- 
### Functions:
### constructor

```solidity
constructor() public
```

### addPatient

```solidity
function addPatient(string _id, string _name, string _DOB, string _phoneNo, string _specialConditions, string _allergies, string _bloodGroup) public
```

### updateVaccine

```solidity
function updateVaccine(string _p_id, string _name, string _date) public
```

### updatePrescription

```solidity
function updatePrescription(string _p_id, string _date, string _doctorName) public
```

### updateMedicine

```solidity
function updateMedicine(string _p_id, uint256 _prescriptionId, bool _morning, bool _afternoon, bool _evening, string _name, string _description) public
```

### getPrescriptions

```solidity
function getPrescriptions(string _p_id, bool _prescriptions) public view returns (struct MedicalRecords.Prescription[])
```

