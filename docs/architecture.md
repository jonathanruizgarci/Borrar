# System Architecture

## Overview

INAOE Xalitzintla is a multi-platform agriculture monitoring system consisting of:

1. **Hardware Layer** - Raspberry Pi with sensors
2. **Database Layer** - Supabase (PostgreSQL + Real-time)
3. **Mobile App** - Flutter mobile application
4. **Web Dashboard** - React web application

## Data Flow

```
Sensors (Raspberry Pi) 
    ↓
    → Collect readings (temperature, humidity, soil moisture, light)
    ↓
Supabase Database
    ↓
    → Store time-series data
    → Trigger alerts based on thresholds
    ↓
Mobile App & Web Dashboard
    ↓
    → Display real-time data
    → Show historical trends
    → Manage alerts
```

## Components

### Hardware (Raspberry Pi)
- Collects sensor data at regular intervals
- Sends data to Supabase via REST API
- Handles sensor failures and reconnection

### Database (Supabase)
- Stores user profiles and authentication
- Stores sensor metadata and plot information
- Stores time-series sensor readings
- Provides real-time subscriptions
- Manages alerts and notifications

### Mobile App (Flutter)
- User authentication
- Real-time sensor data visualization
- Historical data charts
- Alert notifications
- Plot management

### Web Dashboard (React)
- Admin interface
- Advanced data analytics
- Bulk data export
- System configuration
- User management

## Security

- Row Level Security (RLS) in Supabase
- JWT-based authentication
- API key management for hardware devices
- HTTPS for all communications
