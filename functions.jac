# Simple calculator
def add(a:any, b: any) -> int {
    return a + b;
}

def subtract(a:any, b: any) -> int {
    return a - b;
}

def multiply(a:any, b: any) -> int {
    return a * b;
}

def divide(a:any, b: any) -> float {
    if b != 0 {
        return a / b;
    }
    return 0;
}

with entry {
    print("Addition: 5 + 3 = {}".format(add(5, 3)));
    print("Subtraction: 5 - 3 = {}".format(subtract(5, 3)));
    print("Multiplication: 5 * 3 = {}".format(multiply(5, 3)));
    print("Division: 5 / 3 = {}".format(divide(5, 3)));
    print("Division by zero: 5 / 0 = {}".format(divide(5, 0)));
}