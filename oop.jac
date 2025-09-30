obj Doctor {
    has name: str;
    has specialty: str;
    has years_of_experience: int;
    has patients: list = [];
    has available_appointments: list = [];
    has medical_history: dict = {};

    can add_patient(patient: str) {
        self.patients.append(patient);
    }
}

obj Patient {
    has name: str;
    has age: int;
    has medical_conditions: list = [];
    has medications: list = [];
    has allergies: list = [];
    has emergency_contact: dict = {};

    can add_medical_condition(condition: str) {
        self.medical_conditions.append(condition);
    }
}

with entry {
    doc = Doctor(
        name="Dr. Smith",
        specialty="General Practitioner",
        years_of_experience=10,
        available_appointments=["2024-01-10 10:00", "2024-01-11 14:00"]
    );

    pat = Patient(
        name="John Doe",
        age=30,
        medical_conditions=["hypertension"],
        medications=["lisinopril"],
        allergies=["penicillin"],
        emergency_contact={"name": "Jane Doe", "phone": "555-1234"}
    );

    doc.add_patient(pat.name);
    pat.add_medical_condition("diabetes");

    print(f"Doctor: {doc.name}, Specialty: {doc.specialty}, "
          f"Experience: {doc.years_of_experience} years, "
          f"Patients: {doc.patients}, "
          f"Available Appointments: {doc.available_appointments}");

    print(f"Patient: {pat.name}, Age: {pat.age}, "
          f"Medical Conditions: {pat.medical_conditions}, "
          f"Medications: {pat.medications}, "
          f"Allergies: {pat.allergies}, "
          f"Emergency Contact: {pat.emergency_contact}");
}
