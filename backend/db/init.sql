-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Enable Row Level Security Extension
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Organisations (your customers - estate agencies)

CREATE TABLE organisation (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL, -- e.g., 'paris-realty'
    api_key UUID DEFAULT uuid_generate_v4() UNIQUE NOT NULL,
    plan VARCHAR(50) DEFAULT 'free' -- free, startup, growth, entreprise,
    credits_remaining INTEGER DEFAULT 100,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPZ DEFAULT NOW(),
    updated_at TIMESTAMPZ DEFAULT NOW(),

);

-- Users (belong to organisations)
CREATE TABLE users (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    organisation_id UUID NOT NULL REFERENCES organisations(id) ON DELETE CASCADE,
    email VARCHAR(255) NOT NULL,
    hashed_password VARCHAR(255) NOT NULL,
    role VARCHAR(50) DEFAULT 'member', -- admin, member, readonly
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPZ DEFAULT NOW(),
    UNIQUE(organisation_id, email)
);

-- Tenant application to verify
CREATE TABLE verifications (

    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    organisation_id UUID NOT NULL REFERENCES organisations(id) ON DELETE CASCADE,

    -- Applicant details
    applicant_name VARCHAR(255) NOT NULL,
    applicant_email VARCHAR(255) NOT NULL,
    applicant_phone VARCHAR(50),

    -- Verification status
    status VARCHAR(50) DEFAULT 'pending', -- pending, processing, completed, failed
    risk_score DECIMAL(3,2), -- 0.00 to 1.00

    -- Results (JSONB for flexibility)
    identity_check JSONB,
    income_check JSONB,
    reference_check JSONB,

    -- Metadata
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMPW DEFAULT NOW(),
    completed_at TIMESTAMPZ,


    -- Index for performance
    INDEX idx_org_status (organisation_id, status),
    INDEX idx_created_at (created_at DESC)
);



-- Documents (stored in S3, metadata here)
CREATE TABLE documents (

    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    organisation_id UUID NOT NULL REFERENCE organisation_id(id) ON DELETE CASCADE,
    verifcation_id UUID REFERENCE verifications_id(id) ON DELETE CSCADE,

    document_type VARCHAR(100) NOT NULL, -- passport, bank_statement, payslip
    file_name VARCHAR(255) NOT NULL,
    s3_key VARCHAR(500) NOT NULL, -- Path in S3
    file_size_bytes INTEGER,
    Mime_type VARCHAR(100),

    -- Security
    upload_by UUID REFERENCES users(id),
    upload_at TIMESTAMPZ DEFAULT NOW(),

    INDEX idx_verification_docs (verification_id)

);

-- Enable Row Level Security (THE MAGIC!)
ALTER TABLE verifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Policy: Users can only see their organisations's data
CREATE POLICY tenant_isolation_verification ON verifications
    FOR ALL
    USING (organisation_id = current_setting('app.current_organisation')::uuid);


CREATE POLICY tenant_isolation_documents ON documents
    FOR ALL 
    USING (organisation_id = current_setting('app.current_organisation')::uuid);

CREATE POLICY tenant_isolation_users ON users
    FOR ALL
    USING (organisation_id = current_setting('app.current_organisation')::uuid)
