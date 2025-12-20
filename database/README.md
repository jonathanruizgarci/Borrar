# Database Schema and Migrations

Supabase database configuration for INAOE Xalitzintla platform.

## Structure

- `/migrations` - SQL migration files
- `/schemas` - Database schema documentation
- `seed.sql` - Initial seed data

## Tables

### Users
- User authentication and profiles

### Sensors
- Sensor device registration and metadata

### Sensor Readings
- Time-series data from sensors

### Alerts
- Threshold-based alerts and notifications

### Farms/Plots
- Agricultural plot information

## Setup

1. Create Supabase project
2. Run migrations in order
3. Configure Row Level Security (RLS) policies
4. Set up real-time subscriptions
