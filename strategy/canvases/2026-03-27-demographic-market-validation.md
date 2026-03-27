# Demographic Market Validation — Area-Level Intelligence — Product Canvas

## Stage 1: Thesis

### Value Proposition (one sentence)

For **the family evaluating where to acquire a business**, demographic market data validates whether a deal's location has tailwinds (population growth, income growth, business formation) or headwinds (declining population, aging demographics, economic contraction) — turning "good deal in the wrong market" into a scoreable risk.

### Audience Scope

Scope: **Operator**

Would I use this *this week*? Yes — Sunday's call will discuss 7 deals across multiple states. "Charlotte is growing 3% annually" vs "rural Alabama is losing population" is decision-relevant information that changes which deals the family pursues.

### The Problem

The scoring engine evaluates the BUSINESS (price fit, cash flow, maturity, AI resistance). It does not evaluate the MARKET. A laundromat with perfect financials in a declining rural county is a worse acquisition than a laundromat with slightly worse financials in a high-growth metro. The family is spread across NC, SC, FL, WA — they need to see which markets justify the investment, not just which businesses look good on paper.

The 1031 exchange adds urgency: the family has 180 days to close. They can't afford to acquire in a market that's contracting. Market-level validation reduces the risk of a time-pressured decision.

### The Bet

If we layer demographic data onto deal scoring, the family can distinguish between "good deal, good market" and "good deal, declining market." This changes the stack rank — deals in growing markets move up, deals in shrinking markets move down or get flagged. The data is publicly available (Census, IRS, BLS) and can be pre-computed per geography.

### Conviction check

Operator scope: passes. Every deal discussion involves "where is this?" — demographic data turns that question from gut feel into data.

---

## Stage 2: Shape

### One-Paragraph PR/FAQ

Five Pandas now scores the MARKET alongside the BUSINESS. Each deal in the pipeline shows demographic tailwinds and headwinds for its location: population growth, median income, business formation rate, and net migration. A deal in a high-growth metro gets a "Market Tailwind" signal; a deal in a declining area gets a "Market Headwind" flag. This information appears on deal detail pages and factors into the overall score as a new dimension.

### Data sources (all free/public)

| Source | Data | Granularity | Update frequency |
|--------|------|-------------|-----------------|
| **U.S. Census ACS** | Population, median income, age distribution, growth rate | County / Metro | Annual |
| **IRS SOI** (Statistics of Income) | Net migration by county (tax return address changes) | County | Annual |
| **BLS QCEW** | Employment by industry, business establishments | County | Quarterly |
| **U-Haul migration data** | One-way truck rental pricing (proxy for net migration demand) | Metro | Real-time |
| **Census Business Patterns** | Business formation/closure rates by NAICS + county | County | Annual |

### Scoring model

New dimension: **marketTailwind** (0-100)

Inputs:
- Population growth rate (5-year trend) — growing = positive
- Net migration (IRS SOI) — net inflow = positive
- Median household income — higher = more spending power
- Business formation rate — more new businesses = healthy economy
- Industry employment trend — growing in deal's NAICS = positive

Score interpretation:
- **80-100**: Strong tailwind — growing metro, net inflow, rising incomes
- **50-79**: Neutral — stable or mixed signals
- **20-49**: Headwind — declining population, net outflow, or stagnant economy
- **0-19**: Strong headwind — significant decline

### Display

On deal detail page:
```
Market: Charlotte, NC
  Population growth: +2.8%/yr (strong)
  Net migration: +15,000/yr (high inflow)
  Median income: $68K (above national avg)
  Business formation: +4.2% (growing)
  Market Tailwind: 85/100
```

On deal row (review page): badge like "↑ Growing Market" or "↓ Declining Area"

### Integration with scoring

`marketTailwind` becomes the 8th scoring dimension:
- Thesis-weighted like other dimensions
- POA thesis: moderate weight (0.15) — market matters but deal fundamentals matter more
- A future RE-focused thesis might weight this higher (0.25)

### Architecture (multi-tenant ready)

- **DemographicProfile** — platform-wide entity (shared, like Deal). One row per county/metro.
- **marketTailwind score** — per-Deal, computed from DemographicProfile matching deal's state+city/county.
- Pre-compute demographic profiles per county. Refresh annually.
- Deal scoring looks up the profile at scoring time — no API call per deal.

### What's deferred

- U-Haul pricing integration (real-time, needs scraping or API)
- Sub-county granularity (zip code level)
- Predictive modeling (will this market grow next 5 years?)
- Competitive density (how many similar businesses per capita in this area?)

---

## Stage 3: Commit

### Build plan

1. **Download Census ACS + IRS SOI data** for target states (one-time bulk)
2. **Create DemographicProfile model** — county-level: population, growth rate, median income, net migration, business formation
3. **Ingest script** — parse Census/IRS CSVs, populate profiles
4. **Scoring integration** — new `marketTailwind` dimension, computed from deal's location → profile lookup
5. **Display** — market badge on deal rows, detail section on deal detail page
6. **Re-score all deals** with new dimension

### Risks

| Risk | Mitigation |
|------|-----------|
| County vs metro mismatch — deal says "Charlotte" but county is "Mecklenburg" | Geocoding lookup: city+state → county FIPS code. Census provides the mapping. |
| Data is annual — stale by months | Acceptable for investment decisions. Market trends don't change quarterly. |
| Adds complexity to scoring | It's one new dimension with clear semantics. Doesn't change existing 7 dimensions. |

### Relationship to other canvases

- **PPP/FOIA**: PPP candidates can be filtered by demographic profile — outreach only in high-growth markets
- **Broker scraper**: broker-discovered deals get market scores automatically
- **1031 countdown**: market data informs the urgency of which deal to pursue within the 180-day window
