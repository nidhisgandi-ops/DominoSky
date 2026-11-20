# ✈ DOMINO SKY
## Flight Disruption Cascade & Recovery Simulator

> A professional airline operations digital twin built for hackathon demonstration.  
> Simulates how a single airport closure cascades through an interconnected flight network,
> affecting aircraft rotations, passenger connections, and crew duty limits.

---

## 🚀 Quick Start

### Prerequisites
- Python 3.9+
- Node.js 18+
- npm 9+

### 1. Install Backend Dependencies
```bash
cd backend
pip install -r requirements.txt
```

### 2. Start the Backend
```bash
cd backend
python main.py
# Backend runs at http://localhost:8000
# API docs at http://localhost:8000/docs
```

### 3. Install Frontend Dependencies
```bash
cd frontend
npm install
```

### 4. Start the Frontend
```bash
cd frontend
npm run dev
# Frontend runs at http://localhost:5173
```

### 5. Open in Browser
Navigate to: **http://localhost:5173** (or **http://localhost:8000** for unified fullstack)

---

## 🌐 1-Click Cloud Deployment

Domino Sky is pre-configured for instant zero-configuration deployment across all major cloud providers:

### Option A: Vercel (Recommended 1-Click)
1. Push this repository to GitHub.
2. Go to [Vercel Dashboard](https://vercel.com/new) and select **Import Repository**.
3. Leave all default settings as-is (`vercel.json` automatically configures Vite build + Python serverless API).
4. Click **Deploy**. Your live site is ready immediately!

### Option B: Render
1. In [Render Dashboard](https://dashboard.render.com/), choose **New Web Service** and link your GitHub repo.
2. Render detects `render.yaml` or you can set:
   - **Build Command**: `cd frontend && npm install && npm run build && cd ../backend && pip install -r requirements.txt`
   - **Start Command**: `cd backend && uvicorn main:app --host 0.0.0.0 --port $PORT`
3. Click **Create Web Service**. FastAPI serves both the React OCC dashboard and the simulation API.

### Option C: Railway / Docker / Fly.io
- A production-grade multi-stage [Dockerfile](file:///c:/Users/NIDHIS%20GANDHI%20D/OneDrive/Desktop/Domino-Sky/Dockerfile) and [Procfile](file:///c:/Users/NIDHIS%20GANDHI%20D/OneDrive/Desktop/Domino-Sky/Procfile) are included at the root.
- Simply deploy with Docker: `docker build -t domino-sky . && docker run -p 8000:8000 domino-sky`.

### Option D: Netlify / GitHub Pages (Autonomous Edge Mode)
- Domino Sky includes a self-contained deterministic edge simulation engine bundled with `flight_network.json`.
- Even on pure static hosting or during server cold-starts, **all 16 airports, 70 flights, rotation propagation, missed connections, crew alerts, and AI recovery strategies work seamlessly without showing error pages**.

---

## 📋 Dataset

The application uses `flight_network.json` as the **exclusive source of operational data**.

| Resource | Count |
|---|---|
| Airports | 16 |
| Scheduled Flights | 70 |
| Active Aircraft | 16 |
| Passenger Connections | 21 |
| Crew Records | 16 |
| Spare Aircraft | 2 |

**Operating day:** Single day, IST (UTC+05:30), 24-hour format  
**Min turnaround:** 30 minutes  
**Aircraft seats:** 180

---

## 🎮 Demonstration Workflow

1. Open the **Disruption Control Room** page
2. Click **"LOAD DEMO SCENARIO"** to pre-fill BOM closure, 08:00, 90 minutes
3. Click **"START SIMULATION"**
4. Watch the **Live Network** map highlight affected routes
5. Open **Cascade Analysis** to inspect flight-level delay chains
6. Open **Passenger Impact** to see missed connections
7. Open **Crew Operations** to check duty violations
8. Open **AI Dispatcher** to evaluate recovery strategies
9. Apply a strategy and view **Before/After** comparison
10. Open **Scenario Lab** to compare multiple closure scenarios

---

## 🏗️ Architecture

```
Domino-Sky/
├── flight_network.json        # Authoritative data source (read-only)
├── backend/                   # FastAPI simulation engine
│   ├── main.py               # App entry point + startup validation
│   ├── data_loader.py        # JSON loading and validation
│   ├── models.py             # Pydantic data models
│   ├── validators.py         # Dataset integrity checks
│   ├── simulation/
│   │   ├── time_engine.py    # HH:MM ↔ integer minutes conversion
│   │   ├── baseline_engine.py # Normal schedule calculation
│   │   ├── disruption_engine.py # Airport closure simulation
│   │   ├── aircraft_engine.py  # Rotation propagation
│   │   ├── passenger_engine.py # Connection feasibility
│   │   ├── crew_engine.py     # Duty limit calculation
│   │   ├── recovery_engine.py  # Cancellation + spare substitution
│   │   ├── scenario_engine.py  # Multi-scenario isolation
│   │   └── explanation_engine.py # Causal chain generation
│   ├── api/
│   │   ├── flights.py
│   │   ├── airports.py
│   │   ├── simulation.py
│   │   ├── recovery.py
│   │   └── scenarios.py
│   └── tests/
└── frontend/                  # React + TypeScript application
    └── src/
        ├── pages/            # 8 application pages
        ├── components/       # Reusable UI components
        ├── stores/           # Zustand state management
        ├── services/         # API client
        └── types/            # TypeScript interfaces
```

---

## 🔬 Simulation Methodology

### Airport Closure Engine
When an airport is closed for a configured duration:
- Flights cannot **depart from** a closed origin
- Flights cannot **arrive at** a closed destination
- Departure is held until all constraints are satisfied

### Aircraft Rotation Propagation
For each aircraft, flights are processed in `leg_order`:
```
Actual Departure = max(
  scheduled_departure,
  previous_actual_arrival + min_turnaround_minutes,
  airport_open_time  # if origin was closed
)
Actual Arrival = Actual Departure + block_minutes
Delay = Actual Departure - Scheduled Departure
```

### Delay Causation Chain
Every delay is traced to its root cause:
```
AIRPORT_CLOSURE → PREVIOUS_FLIGHT_DELAY → AIRCRAFT_TURNAROUND → DOWNSTREAM_DELAY
```

### Passenger Connection Feasibility
```
Actual Slack = actual_dep(to_flight) - actual_arr(from_flight)
FEASIBLE if Slack ≥ min_connect_minutes
MISSED otherwise
```

### Crew Duty Calculation
```
Actual Duty = actual_arrival_of_last_assigned_flight - duty_start
VIOLATION if Actual Duty > max_duty_mins
WARNING if remaining ≤ 60 minutes (application policy threshold)
```

---

## ⚠️ Dataset Limitations

1. **Spare crew not provided** — Aircraft substitution warnings indicate crew availability is unverified
2. **Single-day schedule** — No multi-day rotation data available
3. **Connection passenger overlap** — Passenger counts across connection records may overlap (not unique passengers)
4. **No repositioning flights** — Spare aircraft cannot be transported; only base-location substitutions are evaluated
5. **Block time is fixed** — Flight duration is preserved exactly as supplied

---

## 🧪 Running Tests

```bash
cd backend
pytest tests/ -v
```

---

## 📊 API Documentation

With the backend running, visit:  
**http://localhost:8000/docs** — Swagger UI  
**http://localhost:8000/redoc** — ReDoc

---

## 🎨 Design

Dark aviation command-centre aesthetic optimised for desktop use.

| Token | Value | Usage |
|---|---|---|
| Background | `#080D18` | App background |
| Panel | `#151F30` | Card/panel backgrounds |
| Primary | `#35B6F6` | Accents, links, normal routes |
| Success | `#36D6B0` | On-time, feasible states |
| Warning | `#F5B942` | Delayed flights, crew warnings |
| Critical | `#F05B67` | Cancellations, violations, missed connections |
| Text | `#E8EEF8` | Primary text |
| Muted | `#91A0B8` | Secondary text |

---

*Built for hackathon demonstration. All calculations are deterministic and derived exclusively from `flight_network.json`.*
