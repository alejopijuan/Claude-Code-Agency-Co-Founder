-- ============================================================
-- Agency Ops Hub -- Supabase Schema Extension
-- Run AFTER the base schema (leads, deals, clients tables)
-- Adds calls + agent_configs tables for voice agent tracking
-- ============================================================

-- ============================================================
-- AGENT CONFIGS TABLE (must be created BEFORE calls)
-- Tracks voice agent configurations per client
-- One config per client per use case
-- ============================================================

CREATE TABLE agent_configs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  client_id UUID REFERENCES clients(id),
  use_case TEXT CHECK (use_case IN ('inbound-receptionist', 'speed-to-lead', 'database-reactivation')),
  voice_platform TEXT DEFAULT 'retell' CHECK (voice_platform IN ('retell', 'elevenlabs', 'vapi')),
  phone_number TEXT,
  status TEXT DEFAULT 'building' CHECK (status IN ('building', 'testing', 'live', 'paused')),
  go_live_date DATE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Unique constraint: one config per client per use case
ALTER TABLE agent_configs ADD CONSTRAINT agent_configs_client_usecase_unique UNIQUE (client_id, use_case);

-- ============================================================
-- CALLS TABLE
-- Stores post-call reporting data from voice agent calls
-- References both clients and agent_configs
-- ============================================================

CREATE TABLE calls (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  client_id UUID REFERENCES clients(id),
  agent_config_id UUID REFERENCES agent_configs(id),
  call_type TEXT CHECK (call_type IN ('inbound', 'outbound')),
  caller_number TEXT,
  duration_seconds INTEGER,
  outcome TEXT CHECK (outcome IN ('appointment-booked', 'transferred', 'voicemail', 'no-answer', 'completed', 'failed')),
  transcript_url TEXT,
  recording_url TEXT,
  crm_synced BOOLEAN DEFAULT false,
  call_date TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- ROW LEVEL SECURITY (consistent with existing tables)
-- ============================================================

ALTER TABLE calls ENABLE ROW LEVEL SECURITY;
ALTER TABLE agent_configs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow anon read" ON agent_configs FOR SELECT USING (true);
CREATE POLICY "Allow anon insert" ON agent_configs FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow anon update" ON agent_configs FOR UPDATE USING (true);

CREATE POLICY "Allow anon read" ON calls FOR SELECT USING (true);
CREATE POLICY "Allow anon insert" ON calls FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow anon update" ON calls FOR UPDATE USING (true);
