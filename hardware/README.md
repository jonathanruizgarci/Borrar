# Hardware (Raspberry Pi + Sensors)

Python code for Raspberry Pi to collect sensor data and send to Supabase.

## Structure

- `/sensors` - Sensor interface modules
- `/datasheets` - Sensor datasheets and technical documentation
- `/utils` - Helper functions
- `main.py` - Main execution script
- `config.py` - Configuration settings
- `requirements.txt` - Python dependencies

## Sensors

- Temperature sensor
- Humidity sensor
- Soil moisture sensor
- Light sensor
- (Add other sensors as needed)

## Setup

1. Install Python 3.8+
2. Run `pip install -r requirements.txt`
3. Configure sensors in `config.py`
4. Set Supabase credentials in environment variables
5. Run `python main.py`
