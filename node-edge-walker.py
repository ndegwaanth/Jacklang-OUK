# -----------------------------
# Define the Doctor class (like a Jac Node)
# -----------------------------
class Doctor:
    def __init__(self, name, specialty):
        self.name = name
        self.specialty = specialty
        self.patients = []  # Will hold Patient objects

    def add_patient(self, patient):
        self.patients.append(patient)

    def introduce(self):
        print(f"Hello, I'm Dr. {self.name}, a {self.specialty} specialist.")


# -----------------------------
# Define the Patient class (like another Jac Node)
# -----------------------------
class Patient:
    def __init__(self, name, condition):
        self.name = name
        self.condition = condition

    def introduce(self):
        print(f"My name is {self.name}. I have {self.condition}.")


# -----------------------------
# Create objects and link them (like Jac Edges)
# -----------------------------
doctor = Doctor("Amina", "Cardiology")
patient1 = Patient("John Doe", "Flu")

# Create a connection (Edge) between doctor and patient
doctor.add_patient(patient1)

# -----------------------------
# Traverse relationships (like a Jac Walker)
# -----------------------------
def show_relationship(doctor):
    doctor.introduce()
    for patient in doctor.patients:
        print("I treat:")
        patient.introduce()


show_relationship(doctor)