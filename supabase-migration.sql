-- ELEOT Database Schema Migration
-- Run this in Supabase SQL Editor

-- ============================================
-- 1. TEACHERS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS teachers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  school_id TEXT,
  name_ar TEXT NOT NULL,
  name_en TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- 2. VISITS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS visits (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  teacher_id UUID NOT NULL REFERENCES teachers(id) ON DELETE CASCADE,
  teacher_name_snapshot TEXT NOT NULL,
  subject TEXT,
  grade_key TEXT,
  segment TEXT CHECK (segment IN ('Beginning', 'Middle', 'End')),
  visit_date DATE NOT NULL,
  supervisor_id UUID NOT NULL,
  supervisor_email TEXT,
  lesson_description TEXT,
  overall_score NUMERIC(4,2),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- 3. VISIT_ENVIRONMENT_SCORES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS visit_environment_scores (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  visit_id UUID NOT NULL REFERENCES visits(id) ON DELETE CASCADE,
  env_code TEXT NOT NULL CHECK (env_code IN ('A','B','C','D','E','F','G')),
  avg_score NUMERIC(4,2),
  justification TEXT,
  recommendations_html TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(visit_id, env_code)
);

-- ============================================
-- 4. VISIT_CRITERIA_SCORES TABLE (for future use)
-- ============================================
CREATE TABLE IF NOT EXISTS visit_criteria_scores (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  visit_id UUID NOT NULL REFERENCES visits(id) ON DELETE CASCADE,
  env_code TEXT NOT NULL,
  criterion_key TEXT NOT NULL,
  score NUMERIC(4,2),
  justification TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- INDEXES
-- ============================================
CREATE INDEX IF NOT EXISTS idx_visits_teacher_id_date ON visits(teacher_id, visit_date DESC);
CREATE INDEX IF NOT EXISTS idx_visits_supervisor_id_date ON visits(supervisor_id, visit_date DESC);
CREATE INDEX IF NOT EXISTS idx_visits_visit_date ON visits(visit_date DESC);
CREATE INDEX IF NOT EXISTS idx_visit_env_scores_visit_id ON visit_environment_scores(visit_id);
CREATE INDEX IF NOT EXISTS idx_teachers_name_ar ON teachers(name_ar);

-- ============================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================

-- Enable RLS on all tables
ALTER TABLE teachers ENABLE ROW LEVEL SECURITY;
ALTER TABLE visits ENABLE ROW LEVEL SECURITY;
ALTER TABLE visit_environment_scores ENABLE ROW LEVEL SECURITY;
ALTER TABLE visit_criteria_scores ENABLE ROW LEVEL SECURITY;

-- ============================================
-- RLS POLICIES - TEACHERS
-- ============================================

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Authenticated users can view teachers" ON teachers;
DROP POLICY IF EXISTS "Authenticated users can insert teachers" ON teachers;

-- SELECT: Any authenticated user can view teachers
CREATE POLICY "Authenticated users can view teachers" ON teachers
  FOR SELECT
  USING (auth.role() = 'authenticated');

-- INSERT: Any authenticated user can insert teachers
CREATE POLICY "Authenticated users can insert teachers" ON teachers
  FOR INSERT
  WITH CHECK (auth.role() = 'authenticated');

-- ============================================
-- RLS POLICIES - VISITS
-- ============================================

DROP POLICY IF EXISTS "Authenticated users can view visits" ON visits;
DROP POLICY IF EXISTS "Supervisor can insert visits" ON visits;
DROP POLICY IF EXISTS "Supervisor can update own visits" ON visits;
DROP POLICY IF EXISTS "Supervisor can delete own visits" ON visits;

-- SELECT: Authenticated users can view all visits
CREATE POLICY "Authenticated users can view visits" ON visits
  FOR SELECT
  USING (auth.role() = 'authenticated');

-- INSERT: Only if supervisor_id matches authenticated user
CREATE POLICY "Supervisor can insert visits" ON visits
  FOR INSERT
  WITH CHECK (auth.uid() = supervisor_id);

-- UPDATE: Only the owner (supervisor_id = auth.uid())
CREATE POLICY "Supervisor can update own visits" ON visits
  FOR UPDATE
  USING (auth.uid() = supervisor_id)
  WITH CHECK (auth.uid() = supervisor_id);

-- DELETE: Only the owner (supervisor_id = auth.uid())
CREATE POLICY "Supervisor can delete own visits" ON visits
  FOR DELETE
  USING (auth.uid() = supervisor_id);

-- ============================================
-- RLS POLICIES - VISIT_ENVIRONMENT_SCORES
-- ============================================

DROP POLICY IF EXISTS "Authenticated users can view env scores" ON visit_environment_scores;
DROP POLICY IF EXISTS "Supervisor can manage own visit env scores" ON visit_environment_scores;

-- SELECT: Authenticated users can view
CREATE POLICY "Authenticated users can view env scores" ON visit_environment_scores
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM visits
      WHERE visits.id = visit_environment_scores.visit_id
      AND auth.role() = 'authenticated'
    )
  );

-- INSERT/UPDATE/DELETE: Only if visit belongs to auth.uid()
CREATE POLICY "Supervisor can manage own visit env scores" ON visit_environment_scores
  FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM visits
      WHERE visits.id = visit_environment_scores.visit_id
      AND visits.supervisor_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM visits
      WHERE visits.id = visit_environment_scores.visit_id
      AND visits.supervisor_id = auth.uid()
    )
  );

-- ============================================
-- RLS POLICIES - VISIT_CRITERIA_SCORES
-- ============================================

DROP POLICY IF EXISTS "Authenticated users can view criteria scores" ON visit_criteria_scores;
DROP POLICY IF EXISTS "Supervisor can manage own visit criteria scores" ON visit_criteria_scores;

-- SELECT: Authenticated users can view
CREATE POLICY "Authenticated users can view criteria scores" ON visit_criteria_scores
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM visits
      WHERE visits.id = visit_criteria_scores.visit_id
      AND auth.role() = 'authenticated'
    )
  );

-- INSERT/UPDATE/DELETE: Only if visit belongs to auth.uid()
CREATE POLICY "Supervisor can manage own visit criteria scores" ON visit_criteria_scores
  FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM visits
      WHERE visits.id = visit_criteria_scores.visit_id
      AND visits.supervisor_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM visits
      WHERE visits.id = visit_criteria_scores.visit_id
      AND visits.supervisor_id = auth.uid()
    )
  );


