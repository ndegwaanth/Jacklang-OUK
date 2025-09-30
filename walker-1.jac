"""Walker attributes."""

node Doctor {
    has name: str = "Dr. Smith";
    has specialty: str = "General Practitioner";
    has years_of_experience: int = 10;
    has is_available: bool = true;
}

node Patient {
    has name: str = "John Doe";
    has age: int = 30;
    has symptoms: list[str] = ["cough", "fever"];
    has has_insurance: bool = false;
}

edge Treats {
    has treatment_date: str;
    has notes: str = "No additional notes.";
}

with entry {
    doctor = (root ++> Doctor)[0];
    patient = (root ++> Patient)[0];

    treat_edge = (doctor +> Treats(
        treatment_date="2024-01-15",
        notes="Prescribed medication for cough and fever."
    ) +> patient)[0];

    print(f"Doctor: {doctor.name}, Specialty: {doctor.specialty}, "
          f"Experience: {doctor.years_of_experience} years, "
          f"Available: {doctor.is_available}");
    
    print(f"Patient: {patient.name}, Age: {patient.age}, "
          f"Symptoms: {patient.symptoms}, "
          f"Has Insurance: {patient.has_insurance}");
    
    print(f"Treatment Date: {treat_edge.treatment_date}, "
          f"Notes: {treat_edge.notes}");
}