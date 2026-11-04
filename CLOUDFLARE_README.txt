CLOUDFLARE PAGES DEPLOY

IMPORTANT: Cloudflare Pages dashboard drag-and-drop does NOT deploy Functions. Use Git-connected Pages build or Wrangler CLI.

1. Set Cloudflare Pages environment variables (Secrets): SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, ADMIN_PASSWORD. Never put these in public/.
2. Install Node.js 20+ and run: npm install
3. Authenticate: npx wrangler login
4. Deploy: npx wrangler pages deploy public --project-name YOUR_PAGES_PROJECT --compatibility-flags nodejs_compat
   Wrangler uses functions/ from project directory. If using Git integration, set build command npm install and output directory public, compatibility flag nodejs_compat.
5. Check https://YOUR_DOMAIN/api via POST.

No Supabase SQL changes are needed. Do not run NOVEMBER_SETUP.sql again.

SECURITY NOTE: The game client reports matched pairs, and this backend does not independently verify card flips; do not use scores for high-stakes prizes without stronger server-side validation.
