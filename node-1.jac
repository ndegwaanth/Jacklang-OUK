node Vehicle {
    has wheels: int;
    has color: str;
    has brand: str;
    has model: str;
}

node Car(Vehicle) {

    has doors: int;
    has is_electric: str;
}


with entry {
    vehicle = (root ++> Vehicle(
        wheels=4,
        color="red",
        brand="Toyota",
        model="Corolla"
    ))[0];

    car = (vehicle ++> Car(
        doors=4,
        wheels=4,
        color="red",
        brand="Toyota",
        model="Corolla",    
        is_electric="false"
    ))[0];


    print(f"Vehicle: {vehicle.brand} {vehicle.model}, Color: {vehicle.color}, Wheels: {vehicle.wheels}");
    print(f"Car: {car.brand} {car.model}, Color: {car.color}, Doors: {car.doors}, Electric: {car.is_electric}");
}