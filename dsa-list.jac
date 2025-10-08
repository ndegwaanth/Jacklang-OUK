"""
Lists are ordered collections of items that can be of mixed types. In Jac, lists are declared with the list type.
"""

with entry {

    names: list[str] = ["Alice", "Bob", "Charlie"];

    for n in names {
        print("Hello, {}! You are visitor number {}.".format(n, names.index(n) + 1));
    }

    # list methods
    names.append("Diana");
    print("After append: {}".format(names));
    names.remove("Alice");
    print("After remove: {}".format(names));
    names.sort();
    print("After sort: {}".format(names));
    names.reverse();
    print("After reverse: {}".format(names));
    print("Index of Bob: {}".format(names.index("Bob")));
    print("Count of Charlie: {}".format(names.count("Charlie")));

}