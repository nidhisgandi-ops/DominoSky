"""Vercel Serverless Function entry point for Domino Sky FastAPI backend.

Routes all incoming /api/* requests to the FastAPI application instance.
"""

import sys
from pathlib import Path

CURRENT_FILE = Path(__file__).resolve()
ROOT_DIR = CURRENT_FILE.parent.parent
BACKEND_DIR = ROOT_DIR / "backend"

# Detach root 'api' namespace from sys.modules temporarily so backend/api package is loaded
sys.modules.pop("api", None)
if str(BACKEND_DIR) not in sys.path:
    sys.path.insert(0, str(BACKEND_DIR))
if str(ROOT_DIR) not in sys.path:
    sys.path.append(str(ROOT_DIR))

from main import app

# Export handler for Vercel ASGI runner
handler = app
