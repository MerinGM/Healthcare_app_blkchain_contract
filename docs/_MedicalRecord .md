# Solidity API

## MedicalRecords

### Contract
MedicalRecords : contracts/_MedicalRecord .sol

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

### getPrescriptionIndex

```solidity
function getPrescriptionIndex(string _p_id, string _date, string _doctor) public view returns (uint256 prescriptionId)
```

### updateMedicine

```solidity
function updateMedicine(string _p_id, string _date, string _doctor, bool _morning, bool _afternoon, bool _evening, string _name, string _description) public
```

### updateBloodPressure

```solidity
function updateBloodPressure(string _p_id, string _date, uint256 _SP, uint256 _DP, uint256 _HB) public
```

### updateSugar

```solidity
function updateSugar(string _p_id, string _date, bool _fasting, bool _afterMeal, uint256 _level) public
```

### authorizeDoctor

```solidity
function authorizeDoctor(string _doctorId, string _p_id) public
```

### revokeDoctor

```solidity
function revokeDoctor(string _doctorId, string _p_id) public
```

### getPatientInfo

```solidity
function getPatientInfo(string _p_id, bool _bloodGroup, bool _allergies, bool _specialConditions) public view returns (string, string, string, string)
```

### getPrescriptions

```solidity
function getPrescriptions(string _p_id, bool _prescriptions) public view returns (struct MedicalRecords.Prescription[])
```

### getPatientBloodPressure

```solidity
function getPatientBloodPressure(string _p_id, bool _bloodPressure) public view returns (struct MedicalRecords.BloodPressure[])
```

### getPatientSugar

```solidity
function getPatientSugar(string _p_id, bool _sugar) public view returns (struct MedicalRecords.Sugar[])
```

### getPatientVaccines

```solidity
function getPatientVaccines(string _p_id, bool _vaccine) public view returns (struct MedicalRecords.Vaccine[])
```

