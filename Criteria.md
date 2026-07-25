# Elevate App - Skill Tiers & Job Matching Criteria

This document outlines the scoring model, tier classification criteria (Bronze, Silver, Gold), and automated job matching rules used in the Elevate App platform.

---

## 1. Skill Test Marks & Tier Distribution

When a job seeker completes a Skill Test, their score percentage determines their **Skill Tier**:

| Tier Level | Score Percentage Criteria | Badge Symbol | Eligibility Status |
| :--- | :--- | :--- | :--- |
| **Gold Tier** | **$\ge 90\%$** | 🥇 Gold | **Mastery**: Access to All Jobs (Gold, Silver, Bronze) |
| **Silver Tier** | **$75\% \le \text{Score} < 90\%$** | 🥈 Silver | **Proficient**: Access to Silver & Bronze Jobs |
| **Bronze Tier** | **$50\% \le \text{Score} < 75\%$** | 🥉 Bronze | **Competent**: Access to Bronze & Internship Jobs |
| **Unranked / Fail** | **$< 50\%$** | ❌ Failed | Must retake the skill test to unlock jobs |

---

## 2. Job Experience & Tier Mapping

Job postings created by registered companies on the platform are automatically categorized into tiers based on required experience:

| Job Tier | Experience Level Text | Targeted Candidate Level |
| :--- | :--- | :--- |
| **Bronze Tier Job** | `Internship`, `0 years`, `Fresher`, `Entry Level` | Junior Developers, Interns, Fresh Graduates |
| **Silver Tier Job** | `1 to 5 years`, `1-5 years`, `Intermediate` | Mid-level Developers & Specialists |
| **Gold Tier Job** | `5+ years`, `5 to onward`, `Senior`, `Lead` | Senior Engineers, Lead Developers, Tech Leads |

---

## 3. Job Recommendation Eligibility Matrix

The system calculates candidate job recommendations based on the highest score achieved for each skill:

```
[Candidate Gold Tier (≥ 90%)]   ──> Unlocks ──> [Gold Jobs] + [Silver Jobs] + [Bronze Jobs]
[Candidate Silver Tier (75-89%)] ──> Unlocks ──> [Silver Jobs] + [Bronze Jobs]
[Candidate Bronze Tier (50-74%)] ──> Unlocks ──> [Bronze / Internship Jobs]
```

### Hierarchy Rules:
- **Gold Tier Candidates** have maximum flexibility; they are qualified for Senior (Gold), Mid (Silver), and Junior (Bronze) positions.
- **Silver Tier Candidates** qualify for Mid and Junior positions.
- **Bronze Tier Candidates** qualify for Entry-level & Internship positions to help build initial industry experience.

---

## 4. Skill Test Structure & Evaluation Details

- **Test Types**:
  - `Pure`: Core technical and syntax questions.
  - `Experience`: Practical scenario-based coding and problem-solving questions.
  - `Vibe`: Soft skills, workplace behavior, and collaboration style.
- **Passing Threshold**: Minimum $50\%$ overall score required to pass and receive a Bronze tier or above.
- **Scoring Logic**: Each correct answer contributes equally to the total test score percentage.
- **Best Score Retention**: If a candidate takes a skill test multiple times, the platform always uses their **highest passed score** to determine their active Tier.

---

## 5. More Jobs Screen — External Platform Algorithm (Deep Dive)

This section covers every detail of how the "More Jobs" screen works — from fetching external job data to what the user actually sees and in what order.

---

### Overview: What Happens When User Taps "More Jobs"?

```
User Taps "More Jobs"
        │
        ▼
Firebase: Get Candidate's Passed Skills + Tiers
        │
        ▼
Build Search Query from Skill Names
        │
        ▼
Step 1: Fire JSearch + Arbeitnow APIs at same time
        │
        ▼
Step 2: Merge results → Remove duplicates (JobCleaner)
        │
        ▼
Step 3: Score & Rank every job (JobRanker)
        │
        ▼
Step 4: Show ranked list with live filters on screen
```

---

### Step 1 — Parallel API Aggregation

The app simultaneously fires **two separate HTTP requests** using Dart's `Future.wait`. This means both run at exactly the same time, not one after another.

**APIs Used:**

| API | Endpoint | Coverage | Query-based? |
| :--- | :--- | :--- | :--- |
| **JSearch** (RapidAPI) | `jsearch.p.rapidapi.com/search` | LinkedIn, Indeed, Glassdoor, ZipRecruiter | ✅ Yes — searches by keyword |
| **Arbeitnow** | `arbeitnow.com/api/job-board-api` | Remote-first & European tech jobs | ❌ No — returns a global feed |

**How the query is built:**
- Candidate's passed skill names are joined into one string.
- Example: if the candidate passed `Flutter Developer` and `UI/UX Designer`, the query becomes `"Flutter Developer UI/UX Designer"`.
- This query is sent to JSearch. Arbeitnow receives no query (it returns its full listing, which is then ranked by relevance later).

**Why parallel and not sequential?**

If both APIs each take ~1.5 seconds to respond:
- Sequential: 1.5s + 1.5s = **3 seconds total wait**
- Parallel: max(1.5s, 1.5s) = **1.5 seconds total wait**

The user waits half as long. If one API fails, it returns an empty list and the other still shows results — it never crashes.

---

### Step 2 — Deduplication (`JobCleaner`)

The same job is often cross-posted on multiple platforms. For example, Google might post the same "Flutter Developer" role on both LinkedIn (via JSearch) AND Arbeitnow. Without deduplication, the user would see the same job twice.

**How it works:**
1. For every job in the merged list, create a **fingerprint key**: `normalizedTitle@normalizedCompany`
2. `TextNormalizer.normalize()` = `text.toLowerCase().trim()` — removes casing and whitespace differences.
3. Store each job in a `Map<String, ApiJobModel>` keyed by this fingerprint.
4. `putIfAbsent` ensures only the **first-seen version** is kept. All later duplicates are silently dropped.

**Full Deduplication Example:**

Raw merged list from both APIs (10 jobs):

| # | Source | Job Title | Company | Normalized Key |
| :--- | :--- | :--- | :--- | :--- |
| 1 | JSearch | `Flutter Developer` | `Google` | `flutter developer@google` |
| 2 | Arbeitnow | `Flutter Developer` | `Google` | `flutter developer@google` ← **DUPLICATE** |
| 3 | JSearch | `React Native Dev` | `Meta` | `react native dev@meta` |
| 4 | JSearch | `UI/UX Designer` | `Careem` | `ui/ux designer@careem` |
| 5 | Arbeitnow | `ui/ux designer ` | `careem` | `ui/ux designer@careem` ← **DUPLICATE** |
| 6 | JSearch | `Flutter Developer` | `Shopify` | `flutter developer@shopify` |
| 7 | Arbeitnow | `Backend Engineer` | `Noon` | `backend engineer@noon` |

After cleaning: **5 unique jobs** remain (rows 1, 3, 4, 6, 7). Rows 2 and 5 are removed.

---

### Step 3 — Weighted Relevance Ranking (`JobRanker`)

This is the intelligence of the system. Every job is scored based on how relevant and fresh it is. Jobs with higher scores appear at the top of the list.

**Scoring Table:**

| Signal | What It Checks | Points Awarded |
| :--- | :--- | :--- |
| **Title Match** | Does the job title contain the search query? | **+5** |
| **Company Match** | Does the company name contain the search query? | **+2** |
| **Remote Bonus** | Is `isRemote == true`? | **+2** |
| **Recency — Hot** | Posted less than 24 hours ago | **+3** |
| **Recency — Fresh** | Posted less than 72 hours ago | **+1** |
| **No match, old** | None of the above apply | **+0** |

> **Note:** Recency is `+3` OR `+1`, not both. If a job was posted 10 hours ago, it gets `+3` only.

---

#### Example A: Single Skill — Flutter Developer (Gold Tier)

Query = `"flutter developer"`, posted time = current moment

| Job Title | Company | Remote | Posted | T | C | R | Re | **Score** |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| Flutter Developer | Google | ✅ Yes | 5 hours ago | +5 | +0 | +2 | +3 | **10** |
| Flutter Developer | TikTok | ❌ No | 3 days ago | +5 | +0 | +0 | +0 | **5** |
| Senior Flutter Dev | Amazon | ✅ Yes | 2 hours ago | +5 | +0 | +2 | +3 | **10** |
| Mobile Developer | Careem | ✅ Yes | 1 hour ago | +0 | +0 | +2 | +3 | **5** |
| React Native Dev | Meta | ❌ No | 10 days ago | +0 | +0 | +0 | +0 | **0** |

*(T = Title, C = Company, R = Remote, Re = Recency)*

**Final Ranking:**
1. 🥇 Flutter Developer @ Google — **Score: 10** (title + remote + fresh)
2. 🥇 Senior Flutter Dev @ Amazon — **Score: 10** (title + remote + fresh)
3. 🥈 Flutter Developer @ TikTok — **Score: 5** (title match only)
4. 🥈 Mobile Developer @ Careem — **Score: 5** (remote + very fresh)
5. ❌ React Native Dev @ Meta — **Score: 0** (no matches)

---

#### Example B: Multiple Skills — Flutter Developer (Gold) + UI/UX Designer (Silver)

Query = `"flutter developer ui/ux designer"`

| Job Title | Company | Remote | Posted | Score Breakdown | **Score** |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Flutter & UX Lead | Spotify | ✅ Yes | 1 day ago | Title +5, Remote +2, 72hrs +1 | **8** |
| UI/UX Designer | Adobe | ❌ No | 6 hours ago | Title +5, Fresh +3 | **8** |
| Flutter Developer | Noon | ❌ No | 5 hours ago | Title +5, Fresh +3 | **8** |
| UX Researcher | Canva | ✅ Yes | 4 days ago | Remote +2 | **2** |
| iOS Developer | Apple | ❌ No | 3 days ago | None | **0** |

All three top jobs tied at 8. When scores tie, the list keeps original order from the API response. The iOS Developer appears last.

---

#### Example C: No Skill Match — Arbeitnow Fallback Ranking

Sometimes Arbeitnow returns jobs that have nothing to do with the candidate's skills (it returns a general feed). These still get scored:

Query = `"flutter developer"` — Arbeitnow returns random remote tech jobs:

| Job Title | Company | Remote | Posted | Score Breakdown | **Score** |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Backend Node.js | Revolut | ✅ Yes | 2 hours ago | Remote +2, Fresh +3 | **5** |
| Flutter Dev (Contract) | Freelancer.eu | ✅ Yes | 1 hour ago | Title +5, Remote +2, Fresh +3 | **10** |
| Data Analyst | KPMG | ❌ No | 1 week ago | None | **0** |

Even without a query, the Flutter freelance job still wins because the title matches and it's remote + fresh. The ranking algorithm automatically surfaces it.

---

### Step 4 — Real-Time Multi-Dimensional Filtering

After ranking, the user can apply up to **4 simultaneous filters** on screen — no new API call is needed because all results are already in memory:

| Filter | Type | What It Does |
| :--- | :--- | :--- |
| **Passed Skill Chip** | Horizontal chip row | Tap a skill chip (e.g., "Flutter Developer • Gold") to show only jobs where the title contains that skill keyword. Tap again to deselect. |
| **Platform Chip** | Horizontal chip row | Tap a platform name (LinkedIn, Glassdoor, Arbeitnow, etc.) to show only jobs sourced from that board. |
| **Company Dropdown** | Dropdown selector | Select a specific company to narrow to that company's listings only. |
| **Search Bar** | Live text input | Instantly filters by any typed text against job title, company name, and location — no debounce delay. |

**All 4 filters stack on top of each other.** For example:
- Skill: `Flutter Developer` AND Platform: `LinkedIn` AND Company: `Google` → shows only Google Flutter jobs from LinkedIn.

When no filter is active, the full ranked list is shown.

---

### Summary: Why This Is Better Than Simple Search

| Feature | Simple Search | Elevate's Pipeline |
| :--- | :--- | :--- |
| Speed | Sequential (slow) | Parallel APIs (fast) |
| Duplicates | Shows same job multiple times | Auto-removed by `JobCleaner` |
| Ordering | Random API order | Smart relevance + freshness score |
| Filtering | No filtering | 4 real-time dimensions |
| Failure handling | Crashes if one API fails | Graceful fallback — other API still works |





---

## 6. Main Job Screen (`Job_screen.dart`) Final Layout & Alignment Architecture

This section documents the exact visual hierarchy and filtering workflow of the main **Job Screen**.

---

### Layout Hierarchy (Top to Bottom):

```
1. Header (JobScreenHeader)
        │
        ▼
2. Recommended For You (Horizontal Featured Job Cards - 10 Unfiltered Matches)
        │
        ▼
3. Your Passed Skills (Outline Cards, Score %, Badge Symbol 🥇/🥈/🥉, Theme-Matched)
        │
        ▼
4. Followed Companies (Horizontal Carousel Filter)
        │
        ▼
5. Experience Level Filters (All, Bronze / Intern, Silver / Mid, Gold / Senior Chips)
        │
        ▼
6. Matching Positions List (Vertical Job Compact Tiles + "MORE JOBS" Navigation Button)
```

---

### Section Details & Rules:

1. **Header**: Clean search and welcome bar (`JobScreenHeader`). Top Welcome GIF is completely removed.
2. **Recommended For You**:
   - Displays 10 top jobs matched to the candidate's primary skill/company recommendations using `FeaturedJobCard` (black cards).
   - **No active filters affect this section** — it always serves as an unfiltered top-recommendations baseline.
3. **Your Passed Skills**:
   - Header text: `"Your Passed Skills"`.
   - Card Style: Clean white container with light grey outline (`Border.all`), dark selected state, no heavy filled background.
   - Badge Symbol: Shows `🥇 Gold`, `🥈 Silver`, `🥉 Bronze` badges without the word "Tier".
   - Tapping a skill card filters the matching positions list below.
4. **Followed Companies**:
   - Displays candidate's followed companies from `JobSeekerModel.followedCompanies`.
   - Fallback: Shows all registered companies if no companies are followed yet.
   - Tapping a company card filters jobs posted by that specific company.
5. **Experience Level Filters**:
   - Section header `"Experience Level"` rendered in bold black text (`Colors.black87`, `16px`) positioned **above** the horizontal scroll view for optimal readability.
   - Horizontal chips ordered tier-wise: `All`, `Bronze / Intern`, `Silver / Mid`, `Gold / Senior`.
   - Highlight state styled with a sleek charcoal theme (`#333333`) to blend seamlessly with the app theme.
6. **Matching Positions List**:
   - Displays filtered jobs dynamically using `JobCompactTile`.
   - Features a top-right **"MORE JOBS"** button navigating directly to the external platform jobs screen (`OtherPlatformJobs`).
