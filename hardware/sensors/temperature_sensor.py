"""
Temperature sensor interface module
"""

# TODO: Import necessary libraries (e.g., Adafruit_DHT, board, etc.)
# TODO: Define sensor type and GPIO pin
# TODO: Implement read_temperature() function
# TODO: Implement read_humidity() function (if combined sensor)
# TODO: Add error handling for sensor failures
# TODO: Add calibration if needed

class TemperatureSensor:
    """Interface for temperature/humidity sensor (e.g., DHT22)"""
    
    def __init__(self, pin):
        """Initialize sensor with GPIO pin"""
        pass
    
    def read(self):
        """
        Read sensor data
        Returns: dict with temperature and humidity values
        """
        pass
