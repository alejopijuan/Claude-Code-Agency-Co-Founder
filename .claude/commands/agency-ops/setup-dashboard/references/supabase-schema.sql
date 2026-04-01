-- ============================================================
-- Agency Ops Hub -- Supabase Schema
-- Run this in Supabase SQL Editor (supabase.com/dashboard > SQL Editor)
-- Creates tables for leads, deals, clients, agent_configs, and calls with upsert support
-- ============================================================

-- ============================================================
-- LEADS TABLE
-- Stores outreach leads from context/outreach/ markdown files
-- Unique constraint on (name, company) enables upsert via PostgREST
-- ============================================================

CREATE TABLE leads (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  company TEXT,
  channel TEXT CHECK (channel IN ('linkedin', 'instagram', 'whatsapp', 'email', 'phone')),
  stage TEXT DEFAULT 'new-lead' CHECK (stage IN ('new-lead', 'messaged', 'replied', 'call-booked', 'discovery', 'proposal', 'closed')),
  source TEXT,
  last_contact DATE,
  next_follow_up DATE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Unique constraint for upsert: match leads by name + company
ALTER TABLE leads ADD CONSTRAINT leads_name_company_unique UNIQUE (name, company);

-- ============================================================
-- DEALS TABLE
-- Stores pipeline deals from context/pipeline/ markdown files
-- Unique constraint on (name) enables upsert via PostgREST
-- ============================================================

CREATE TABLE deals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  contact TEXT,
  outreach_file TEXT,
  stage TEXT DEFAULT 'new-lead' CHECK (stage IN ('new-lead', 'messaged', 'replied', 'call-booked', 'discovery', 'proposal', 'closed')),
  niche TEXT,
  value INTEGER DEFAULT 0,
  next_action TEXT,
  created DATE,
  last_updated DATE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Unique constraint for upsert: match deals by name
ALTER TABLE deals ADD CONSTRAINT deals_name_unique UNIQUE (name);

-- ============================================================
-- CLIENTS TABLE
-- Stores active client data from context/clients/ markdown files
-- Unique constraint on (name) enables upsert via PostgREST
-- ============================================================

CREATE TABLE clients (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  industry TEXT,
  status TEXT DEFAULT 'active' CHECK (status IN ('active', 'paused', 'churned')),
  monthly_value INTEGER DEFAULT 0,
  start_date DATE,
  meeting_cadence TEXT DEFAULT 'biweekly',
  last_updated DATE,
  staleness_threshold_days INTEGER DEFAULT 14,
  open_commitments_count INTEGER DEFAULT 0,
  next_meeting_date DATE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Unique constraint for upsert: match clients by name
ALTER TABLE clients ADD CONSTRAINT clients_name_unique UNIQUE (name);

-- ============================================================
-- AGENT CONFIGS TABLE
-- Tracks voice agent configurations per client
-- One config per client per use case
-- If upgrading from base-only schema: run only this section
-- and the calls section below
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
-- ROW LEVEL SECURITY (RLS)
-- Enable RLS on all tables and allow anonymous access
-- The dashboard uses the anon key for read/write operations
-- ============================================================

-- Enable RLS
ALTER TABLE leads ENABLE ROW LEVEL SECURITY;
ALTER TABLE deals ENABLE ROW LEVEL SECURITY;
ALTER TABLE clients ENABLE ROW LEVEL SECURITY;

-- Leads: allow anonymous read, insert, update
CREATE POLICY "Allow anon read" ON leads FOR SELECT USING (true);
CREATE POLICY "Allow anon insert" ON leads FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow anon update" ON leads FOR UPDATE USING (true);

-- Deals: allow anonymous read, insert, update
CREATE POLICY "Allow anon read" ON deals FOR SELECT USING (true);
CREATE POLICY "Allow anon insert" ON deals FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow anon update" ON deals FOR UPDATE USING (true);

-- Clients: allow anonymous read, insert, update
CREATE POLICY "Allow anon read" ON clients FOR SELECT USING (true);
CREATE POLICY "Allow anon insert" ON clients FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow anon update" ON clients FOR UPDATE USING (true);

-- Agent Configs: allow anonymous read, insert, update
ALTER TABLE agent_configs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow anon read" ON agent_configs FOR SELECT USING (true);
CREATE POLICY "Allow anon insert" ON agent_configs FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow anon update" ON agent_configs FOR UPDATE USING (true);

-- Calls: allow anonymous read, insert, update
ALTER TABLE calls ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow anon read" ON calls FOR SELECT USING (true);
CREATE POLICY "Allow anon insert" ON calls FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow anon update" ON calls FOR UPDATE USING (true);
