# -----------------------------
# Define Node Types
# -----------------------------
node Doctor {
    has name: str;
    has specialty: str;
    has patients: list;
}

node Patient {
    has name: str;
    has condition: str;
}

# -----------------------------
# Define a Walker (Logic/Behavior)
# -----------------------------
walker show_relationships {
    take -> Doctor;  # Start at all Doctor nodes
    std.out("Hello, I'm Dr. " + here.name + ", a " + here.specialty + " specialist.");

    # Traverse to connected Patient nodes
    take -> Patient;
    std.out("I treat " + here.name + " who has " + here.condition);
}

# -----------------------------
# Create Nodes and Connect Them
# -----------------------------
walker setup {
    spawn here ++> Doctor(name="Amina", specialty="Cardiology");
    spawn here ++> Patient(name="John Doe", condition="Flu");
    here +> Doctor;  # Connect the root node to the doctor
    Doctor +> Patient;  # Connect doctor to patient
}
with entry {
    # Initialize the graph with nodes and edges
    root +> setup;

    # Execute the walker to show relationships
    root +> show_relationships;
}