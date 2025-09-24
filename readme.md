# Tenant Verify SaaS Platform

## 🚀 Vision
Multi-tenant AI-powered verification platform for European estate agencies. Processing tenant applications in 47 seconds instead of 48 hours.

## 📅 Week 1 Goals (Sprint 1)
- [ ] Multi-tenant architecture with PostgreSQL row-level security
- [ ] Document storage pipeline (S3-compatible)
- [ ] Core verification API with FastAPI
- [ ] Tenant isolation middleware
- [ ] Deploy MVP to production

## 🛠 Technical Stack

### Backend
- **FastAPI** (Python 3.11+) - Async API framework
- **PostgreSQL** - Primary database with RLS
- **Redis** - Caching & real-time pub/sub
- **S3/MinIO** - Document storage
- **OpenAI API** - Document verification

### Frontend (Week 2)
- **React 18** with TypeScript
- **React Query** - Server state management
- **Tailwind CSS** - Styling

### Infrastructure
- **Docker** - Local development
- **Railway/Fly.io** - Production deployment

## 🏗 Architecture
├── API Gateway (FastAPI)
├── Tenant Isolation Layer
├── Verification Pipeline
├── Document Storage (S3)
└── Per-tenant Data (PostgreSQL)

## 🎯 Business Metrics Target
- 3 paying estate agencies by Week 4
- 100+ verifications processed
- <200ms p99 latency
- €500 MRR

## 📊 Progress Tracker
- Week 1: Core Platform ⏳
- Week 2: Frontend + Billing
- Week 3: Production + Real Users
- Week 4: Launch + Interviews

## 🔥 The Goal
Land senior fullstack role with REAL production SaaS as proof.

---
*Building in public. From bootcamp to production SaaS in 4 weeks.* 