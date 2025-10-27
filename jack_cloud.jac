walker get_weather {
    has city: str;

    obj __specs__ {
        static has auth: bool = False;
    }

    can get_weather_data with `root entry {
        # Your weather logic here
        weather_info = f"Weather in {self.city}: Sunny, 25°C";
        report {"city": self.city, "weather": weather_info};
    }
}