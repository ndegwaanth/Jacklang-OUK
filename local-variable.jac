def bread_standardisation(bread_type: int) -> str {
    for a in [200, 600, 800, 1500] {
        if bread_type == a {
            has result: int = a + a;
            print("Processing bread type: {}, intermediate result: {}".format(bread_type, result));
        }
    }

    if bread_type == 200 {
        return "white-200g";
    } elif bread_type == 600 {
        return "brown-600g";
    } elif bread_type == 800 {
        return "white-800g";
    } elif bread_type == 1500 {
        return "brown-1500g";
    } else {
        return "Invalid bread type";
    }
}

with entry {
    print(bread_standardisation(200));
    print(bread_standardisation(600));
    print(bread_standardisation(800));
    print(bread_standardisation(1500));
    print(bread_standardisation(0));
}
