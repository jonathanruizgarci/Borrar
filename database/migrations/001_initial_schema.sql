-- Initial schema for INAOE Xalitzintla
-- Migration: 001_initial_schema

-- TODO: Create users table (extends Supabase auth.users)
-- CREATE TABLE profiles (
--   id UUID REFERENCES auth.users PRIMARY KEY,
--   full_name TEXT,
--   role TEXT CHECK (role IN ('admin', 'farmer', 'researcher')),
--   created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
-- );

-- TODO: Create farms/plots table
-- CREATE TABLE plots (
--   id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
--   name TEXT NOT NULL,
--   location GEOGRAPHY(POINT),
--   owner_id UUID REFERENCES profiles(id),
--   created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
-- );

-- TODO: Create sensors table
-- CREATE TABLE sensors (
--   id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
--   device_id TEXT UNIQUE NOT NULL,
--   plot_id UUID REFERENCES plots(id),
--   sensor_type TEXT NOT NULL,
--   status TEXT DEFAULT 'active',
--   created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
-- );

-- TODO: Create sensor_readings table (time-series data)
-- CREATE TABLE sensor_readings (
--   id BIGSERIAL PRIMARY KEY,
--   sensor_id UUID REFERENCES sensors(id),
--   temperature DECIMAL,
--   humidity DECIMAL,
--   soil_moisture DECIMAL,
--   light_level DECIMAL,
--   timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW()
-- );

-- TODO: Create indexes for performance
-- CREATE INDEX idx_readings_sensor_time ON sensor_readings(sensor_id, timestamp DESC);

-- TODO: Create alerts table
-- CREATE TABLE alerts (
--   id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
--   sensor_id UUID REFERENCES sensors(id),
--   alert_type TEXT NOT NULL,
--   message TEXT,
--   severity TEXT CHECK (severity IN ('low', 'medium', 'high')),
--   resolved BOOLEAN DEFAULT FALSE,
--   created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
-- );

-- TODO: Enable Row Level Security (RLS)
-- ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE plots ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE sensors ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE sensor_readings ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE alerts ENABLE ROW LEVEL SECURITY;

-- TODO: Create RLS policies for each table
