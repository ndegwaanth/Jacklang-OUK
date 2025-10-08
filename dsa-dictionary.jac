"""
Dictionaries are perfect for storing data as key-value pairs, which allows you to look up a value instantly if you know its key. You declare a dictionary with the dict type, specifying the type for the keys and the values.
"""

# with entry {
#     my_dict: dict = {
#         "apple": 1,
#         "banana": 2,
#         "cherry": 3
#     };
#     print("Apple's value: {}".format(my_dict["apple"]));
#     print("Banana's value: {}".format(my_dict["banana"]));
#     print("Cherry's value: {}".format(my_dict["cherry"]));
# }

# Dictionary methods
with entry {
    my_dict: dict = {
        "apple": 1,
        "banana": 2,
        "cherry": 3
    };

    # Adding a new key-value pair
    my_dict["date"] = 4;
    print("After adding date: {}".format(my_dict));

    # Updating an existing key's value
    my_dict["banana"] = 5;
    print("After updating banana: {}".format(my_dict));

    # Removing a key-value pair
    my_dict.pop("apple");
    print("After removing apple: {}".format(my_dict));

    # Checking if a key exists
    if "cherry" in my_dict {
        print("Cherry is in the dictionary.");
    } else {
        print("Cherry is not in the dictionary.");
    }

    # Getting all keys
    keys = my_dict.keys();
    print("Keys: {}".format(keys));

    # Getting all values
    values = my_dict.values();
    print("Values: {}".format(values));

    # Getting all items
    items = my_dict.items();
    print("Items: {}".format(items));

    # iterating through the dictionary
    for k in my_dict.keys() {
        print("Key: {}, Value: {}".format(k, my_dict[k]));
    }
}