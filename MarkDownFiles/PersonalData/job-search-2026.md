---
title: Job Search 2026 — Career-Ops Pipeline
tags:
  - personal
  - career
  - job-search
created: 2026-05-15
---

# Job Search 2026 — Career-Ops Pipeline

## Setup Complete ✅

**Date:** 2026-05-15 10:30 IST
**System:** career-ops v1.7.1
**Profile:** Backend Developer, Spring Boot + Microservices, Entry-Mid level
**Location:** Chennai, India | Remote
**Target Comp:** ₹12L–18L

### Configuration
- **CV:** Synced from vault resume (B.Tech CSE, ERP System, Microservices experience)
- **Target Roles:** Backend Developer, Microservices Engineer, Systems Engineer
- **Job Boards:** 45+ companies + Indian portals (LinkedIn, Naukri, Indeed India, etc.)

---

## First Scan Results — India Focus

**Date:** 2026-05-15 10:26 IST
**Scope:** Indian job boards + major tech companies + Chennai/Remote filter
**Total Scanned:** 4,993 roles
**Filtered:** 4,964 (title/location mismatch)
**New Opportunities:** 3

### Opportunities Found

| # | Company | Role | Location | Portal | Score | Status |
|---|---------|------|----------|--------|-------|--------|
| 1 | **Glean** | Software Engineer, Backend | Bangalore | Greenhouse API | TBD | Pending eval |
| 2 | **Zapier** | Sr. Engineer, Backend - Enterprise | India (remote) | Ashby | TBD | Pending eval |
| 3 | **Celonis** | Senior Software Engineer - Java | Bangalore | Greenhouse API | TBD | Pending eval |

**Stack Match:** All 3 align with Java/Spring Boot/Distributed Systems expertise from ERP project.

---

## Key Insights

- **Bangalore vs Chennai:** Web indexing lag means Bangalore roles show up first; Chennai jobs may appear in future scans
- **Portal Performance:** Greenhouse & Ashby APIs fast (~2s per company); Naukri/Indeed slower (web search)
- **Title Filter Working:** 99.7% filtered out (non-matching roles like "Sales", "HR", "Intern", ".NET")
- **Location Filter Working:** Other metros blocked (Delhi, Mumbai, Hyderabad); only Chennai + Remote pass

---

## Next Steps

1. **Evaluate 3 roles:** `/career-ops pipeline` → generates A-F reports + PDFs
2. **Adjust filter:** Allow Bangalore if willing to relocate
3. **Automate scans:** Set up recurring scans (e.g., every 3 days)
4. **Build tracker:** Applications.md will auto-populate with evaluations

---

## System Commands

```bash
# Scan for new offers
/career-ops scan

# Evaluate pending URLs
/career-ops pipeline

# Generate ATS-optimized CV
/career-ops pdf

# View tracker
/career-ops tracker

# Deep company research
/career-ops deep [company]

# Interview prep
/career-ops interview-prep [company]
```

---

## Career Story (from profile)

**Headline:** Backend Developer specializing in Spring Boot & Microservices

**Proof Point:** ERP System — Built 6 microservices (Java + Go) with Resilience4j Circuit Breaker, Eureka Service Discovery, Kafka event streams. Production-grade architecture.

**Superpowers:**
- Spring Boot & Microservices patterns
- Event-driven architecture (Kafka)
- PostgreSQL & MongoDB at scale

---

## Notes

- System does NOT auto-submit applications — you review & decide
- PDF generation includes ATS keywords from JD + case study links
- Reports track all signals: CV match, comp research, red flags, legitimacy
- All customizable: archetypes, scores, archetypes, narratives in `config/profile.yml` + `modes/_profile.md`

**Source:** [[Clippings/santifercareer-ops AI-powered job search system built on Claude Code. 14 skill modes, Go dashboard, PDF generation, batch processing.|career-ops]]
