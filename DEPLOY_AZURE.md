# Deploying BrightStart (PHP API + MySQL) to Azure

Result: an HTTPS API at `https://<your-app>.azurewebsites.net/api/` that the Android app can reach from any phone.

## 1. Database - Azure Database for MySQL Flexible Server
1. Azure Portal -> **Create a resource -> Azure Database for MySQL Flexible Server**.
2. Resource group `brightstart-rg`, server name e.g. `brightstart-db`, region close to you (South Africa North), MySQL 8.0, workload **Development / Burstable B1ms**.
3. Set an admin username and a strong password (write them down).
4. **Networking:** public access ON, tick **Allow public access from any Azure service**, and **Add current client IP address** (so you can import data).
5. When it is created, open the server -> **Databases** is not needed; the script creates `brightstart`.
6. Import the schema and data (Azure Cloud Shell has the `mysql` client, or use MySQL Workbench):
   ```bash
   mysql -h brightstart-db.mysql.database.azure.com -u <admin> -p --ssl-mode=REQUIRED < database/schema.sql
   mysql -h brightstart-db.mysql.database.azure.com -u <admin> -p --ssl-mode=REQUIRED < database/seed.sql
   ```
   (Azure's flexible server folds table names to lower case by default, so the older web pages that say `tblDonation` still work.)

## 2. API - Azure App Service
1. **Create a resource -> Web App**: Publish **Code**, Runtime stack **PHP 8.2 (or newer)**, OS **Linux**, plan **Free F1** or **Basic B1**.
2. **Settings -> Environment variables -> App settings**, add:

   | Name | Value |
   |---|---|
   | `DB_HOST` | `brightstart-db.mysql.database.azure.com` |
   | `DB_NAME` | `brightstart` |
   | `DB_USER` | your admin username |
   | `DB_PASS` | your admin password |
   | `DB_SSL` | `1` |
   | `GOOGLE_CLIENT_ID` | the **Web** OAuth client ID (see the Android README) |
   | `SSO_AUTO_APPROVE` | `0` (new Google users wait for approval) or `1` for the demo |

3. **Deployment Center -> Source: GitHub**, pick this repo and branch `main` (Azure creates a GitHub Actions workflow and redeploys on every push). Alternative: `az webapp deploy --src-path brightstart.zip --type zip`.
4. Open `https://<your-app>.azurewebsites.net/api/login.php` in a browser. Seeing `{"success":false,"message":"Email and password are required"}` means the API is live.

## 3. Quick tests (replace the host)
```bash
# login -> returns a token
curl -s -X POST https://<app>.azurewebsites.net/api/login.php \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@brightstart.org","password":"BrightStart@2026"}'

# protected endpoint WITHOUT a token -> 401
curl -s https://<app>.azurewebsites.net/api/get_students.php

# protected endpoint WITH the token -> 200 + 15 students
curl -s https://<app>.azurewebsites.net/api/get_students.php -H "Authorization: Bearer <token>"
```

## 4. Demo accounts (password `BrightStart@2026` - change before real use)
`admin@brightstart.org` (Admin) | `coordinator@brightstart.org` | `volunteer@brightstart.org` | `pending1@brightstart.org` (pending approval)

## 5. For the demonstration video
Show on screen: the Azure App Service overview and its Environment variables (hide the values), the MySQL server in the portal plus the tables with their rows in MySQL Workbench (including the bcrypt `PasswordHash` column), and a request to the live API.

## Security notes
- API tokens are random 256-bit values; only their SHA-256 hash is stored (`tblauthtoken`). They expire after 7 days and are deleted on logout / password change.
- Roles are enforced on the server: deletes need Admin or Coordinator; user approval and role changes need Admin. Self-registration can never create an Admin.
- Never commit real credentials. Configuration comes from environment variables.
