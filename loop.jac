with entry{
    num = [1, 2, 3, 4, 5];
    for i in range(0, len(num)) {
        print(num[i]);
    }
}

# Loop this name  5 times
with entry{
    name = ["ANTHONY", "DAVID", "JOHN", "MICHAEL", "JAMES"];
    for i in range(0, 5) {
        print(name[i]);
    }
}

with entry {
    print("Converting scores (0-100) to GPA (0-4.0):");

    # This loop starts at 40, continues as long as score <= 100,
    # and increases the score by 10 in each step.
    for score = 40 to score <= 100 by score += 10 {
        gpa: float = (score - 40) * 4.0 / 60.0;
        print(f"Score {score} -> GPA {gpa}");
    }
}