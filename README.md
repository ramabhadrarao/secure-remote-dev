# Secure Remote Dev (Docker, Ubuntu 24.04)

**Goal:** Let employees work **only inside the server**, using a streamed desktop (via Guacamole) that connects to a locked-down dev container (no local files). You host your Git in **Gitea**. Reverse proxy is **Nginx**. Clipboard/file-transfer can be disabled in Guacamole (set per-connection).

> Hard truth: screenshots cannot be absolutely prevented. This stack focuses on practical DLP: no downloads, no clipboard, no direct repo access from laptops.

---

## 1) Prereqs on fresh Ubuntu 24.04

```bash
sudo apt update
sudo apt install -y docker.io docker-compose-plugin
sudo usermod -aG docker $USER
# log out/in to apply docker group
```

Point DNS of these hostnames to your server's static IP:
- `guac.${DOMAIN}` (Guacamole portal)
- `git.${DOMAIN}` (Gitea)

Copy this folder to the server, edit `.env`, and add TLS certs to `nginx/certs/` (e.g., `fullchain.pem`, `privkey.pem`). You can start with self-signed, then move to Let's Encrypt.

---

## 2) Bring up the stack

```bash
docker compose up -d --build
```

- Nginx: ports 80/443
- Guacamole UI: `https://guac.${DOMAIN}`
- Gitea: `https://git.${DOMAIN}`

> First boot may take a few minutes.

---

## 3) Create a Guacamole connection to DevBox (with clipboard & transfer disabled)

1. Browse to `https://guac.${DOMAIN}`
2. Login with the built-in `guacadmin` account (created by initdb). **Immediately change password**.
3. In **Settings → Connections → New Connection**:
   - **Name:** DevBox
   - **Protocol:** RDP
   - **Parameters:**
     - **Hostname:** `devbox`
     - **Port:** `3389`
     - **Security:** negotiate
     - **Username:** value from `.env` → `DEVBOX_RDP_USER`
     - **Password:** value from `.env` → `DEVBOX_RDP_PASSWORD`
     - **Disable clipboard**: **enable** (turn off clipboard redirection)
     - **File transfer / drive redirection**: **disable**
     - **Recording**: optional (check local laws before enabling)
4. Save. Assign the connection to your user group(s).

**Result:** Users log into Guacamole via browser and open **DevBox**. They get an XFCE desktop with VS Code (`code`), Node 20, Python 3.11, and Git. They can clone/pull/push **only** to your internal Gitea.

---

## 4) Initialize Gitea (internal Git)

Open `https://git.${DOMAIN}` and finish the setup wizard:
- Database: Postgres
  - Host: `gitea-db:5432`
  - User: `gitea`
  - Password: value from `.env`
  - DB name: `gitea`
- Server URL: `https://git.${DOMAIN}/` (disable SSH in app.ini already set)
- Create admin user with values in `.env` or your own.

**Branch protection & reviews:** Configure per repo (Settings → Branches).

---

## 5) Day-to-day flow

1. Employee visits `https://guac.${DOMAIN}`, logs in.
2. Opens **DevBox** connection; desktop appears.
3. Launches **VS Code** (menu) or terminal:
   - `git clone https://git.${DOMAIN}/group/project.git`
   - Work entirely in server.
4. No clipboard or file transfer from the session (as configured).

---

## 6) Security recommendations

- Change all passwords in `.env`.
- Restrict DevBox egress with firewall (allow only Git, package mirrors you trust).
- Add 2FA to Gitea and Guacamole (via SSO if you prefer).
- Back up volumes:
  - `./gitea/data`, `./gitea/db-data`
  - `./guacamole/db-data`
  - `devbox-home` (volume)
- Consider session recording (ensure compliance with local law and employee consent).

---

## 7) Notes & limits

- This setup prioritizes **Docker-only** components.
- For stronger DLP (e.g., watermarking, keystroke throttling), consider switching the streaming layer to **Kasm Workspaces** later.
- Absolute screenshot prevention is not possible on BYOD; use contracts, watermarks, and process controls too.

---

## 8) Commands

```bash
# Check status
docker compose ps
docker compose logs -f guacamole

# Restart services
docker compose restart nginx
docker compose restart devbox

# Tear down (data preserved in volumes/dirs)
docker compose down
```
