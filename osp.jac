obj calculator{
    has a : int;
    has b : int;

    def add() -> int {
        return self.a + self.b;
    }

    def subtract() -> int {
        return self.a - self.b;
    }

    def multiply() -> int {
        return self.a * self.b;
    }

    def divide() -> float {
        if self.b != 0 {
            return self.a / self.b;
        }
        return 0;
    }
}

with entry {
    calc = calculator(a=10, b=5);

    print("Addition: 10 + 5 = {}".format(calc.add()));
    print("Subtraction: 10 - 5 = {}".format(calc.subtract()));
    print("Multiplication: 10 * 5 = {}".format(calc.multiply()));
    print("Division: 10 / 5 = {}".format(calc.divide()));

    calc_zero_div = calculator(a=10, b=0);
    print("Division by zero: 10 / 0 = {}".format(calc_zero_div.divide()));
}