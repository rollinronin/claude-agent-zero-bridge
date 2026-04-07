# Agent Zero .env Template — Recovery Reference
# Created: 2026-04-07 (Session 7 - bulletproofing)
# PURPOSE: If the container volume is wiped, restore these values to /a0/usr/.env
# NOTE: AUTH_PASSWORD is NOT stored here for security — retrieve from Doppler

# ============================================================
# CRITICAL VALUES (determines the stable A2A/MCP token)
# ============================================================

A0_PERSISTENT_RUNTIME_ID=968da31779950a2c6eb2e83ed53e82a4
AUTH_LOGIN=ptahmes
AUTH_PASSWORD=<retrieve_from_doppler>

# ============================================================
# COMPUTED TOKEN (for reference)
# ============================================================
# sha256(A0_PERSISTENT_RUNTIME_ID:AUTH_LOGIN:AUTH_PASSWORD)[:16] base64url
# = 6cv6Y1NWS8_axKmv  (stable as of 2026-04-07)

# ============================================================
# TO VERIFY/RECOMPUTE TOKEN:
# ============================================================
# python3 -c "
import hashlib, base64
runtime_id = '968da31779950a2c6eb2e83ed53e82a4'
username = 'ptahmes'
password = '<AUTH_PASSWORD>'
hash_bytes = hashlib.sha256(f'{runtime_id}:{username}:{password}'.encode()).digest()
b64 = base64.urlsafe_b64encode(hash_bytes).decode().replace('=','')
print('Token:', b64[:16])
# "
