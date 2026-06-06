-- ═══════════════════════════════════════════════════
-- ADD THIS to your existing Supabase schema
-- Run in SQL Editor — adds pick & pack sessions table
-- ═══════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS pick_pack_sessions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at timestamptz DEFAULT now(),
  packer_name text NOT NULL,
  session_date date,
  shift text,                  -- morning / afternoon / full day / overtime
  store_channel text,          -- Shopify / Takealot / Bulk / etc.
  orders_picked integer DEFAULT 0,
  units_packed integer DEFAULT 0,
  start_time text,             -- stored as HH:MM string
  end_time text,
  duration_mins numeric,       -- calculated minutes
  units_per_hour numeric,      -- calculated UPH
  orders_per_hour numeric,     -- calculated OPH
  errors integer DEFAULT 0,    -- mispicks / errors
  notes text
);

CREATE INDEX IF NOT EXISTS idx_pp_packer ON pick_pack_sessions(packer_name);
CREATE INDEX IF NOT EXISTS idx_pp_date ON pick_pack_sessions(session_date);
CREATE INDEX IF NOT EXISTS idx_pp_store ON pick_pack_sessions(store_channel);

ALTER TABLE pick_pack_sessions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "open_pick_pack" ON pick_pack_sessions FOR ALL USING (true) WITH CHECK (true);
