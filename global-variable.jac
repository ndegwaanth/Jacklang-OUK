glob patient_name: str = "Alice";
glob doctor_name: str = "Dr. Brown";
glob appointment_date: str = "2024-01-15";

def schedule_appointment(patient_name: str, doctor_name: str, appointment_date: str) -> str {
    :g: patient_name = patient_name;
    :g: doctor_name = doctor_name;
    :g: appointment_date = appointment_date;

    print("Appointment scheduled for {} with {} on {}".format(patient_name, doctor_name, appointment_date));
    return "Appointment confirmed for {} with {} on {}".format(patient_name, doctor_name, appointment_date);
}

with entry {
    print(schedule_appointment(patient_name, doctor_name, appointment_date));
}
