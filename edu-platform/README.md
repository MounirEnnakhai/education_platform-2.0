# edu-platform

Education platform backend — Zig 0.15.2 + SQLite + Docker.

## Start

```bash
# 1. Set your secret
cp backend/.env.example backend/.env
node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"
# paste the output as JWT_SECRET in backend/.env

# 2. Resolve dependency hashes (one-time setup)
cd backend
zig build --fetch
# Zig prints the real hashes — paste them into build.zig.zon
# then run zig build --fetch once more (should complete silently)
cd ..

# 3. Boot
docker compose up
```

## Ports
| Service    | URL                        |
|------------|----------------------------|
| API        | http://localhost:8080       |
| PostgreSQL | localhost:5432              |
| pgAdmin    | http://localhost:5050       |

pgAdmin only starts with: `docker compose --profile dev up`

## Hot reload
Edit any `.zig` file in `backend/src/` — the container detects the change,
recompiles, and restarts automatically. No `docker compose restart` needed.

## Build phases
| # | Feature                  | Status  |
|---|--------------------------|---------|
| 0 | Scaffold + Docker        | ✅ Done |
| 1 | Auth (register/login/JWT)| 🔜 Next |
| 2 | Class management         | ⬜      |
| 3 | Enrollment               | ⬜      |
| 4 | Scheduling               | ⬜      |
| 5 | Live classes (WebSocket) | ⬜      |
