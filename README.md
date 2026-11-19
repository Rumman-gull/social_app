# Community Forum

A React, TypeScript, and Vite community forum backed by Supabase for authentication, database access, and post image storage.

## Requirements

- Node.js 20.19+ or 22.12+
- npm
- A Supabase project

## Local Setup

1. Install dependencies:

   ```sh
   npm install
   ```

2. Copy `.env.example` to `.env.local` and set the project URL and publishable key (or legacy anon key). Find these in your Supabase project's API settings.

   ```env
   VITE_SUPABASE_URL=https://your-project-ref.supabase.co
   VITE_SUPABASE_PUBLISHABLE_KEY=your-publishable-or-anon-key
   ```

   The key is included in the browser bundle. Never put a Supabase `service_role` or secret key in a `VITE_` variable.

3. In the Supabase Dashboard, open **SQL Editor**, paste the contents of `supabase/migrations/20261116000000_initial_schema.sql`, and run it. This creates the tables, row-level security policies, post image bucket, and `get_posts_with_counts()` function used by the app.

4. If `public.posts` already existed before that migration, also run `supabase/migrations/20261118143500_add_avatar_url_to_posts.sql`. `create table if not exists` does not add columns to an existing table.

5. If your existing `public.posts` table is also missing `community_id`, run `supabase/migrations/20261118143800_add_community_id_to_posts.sql`.

6. Configure GitHub sign-in in **Authentication > Providers > GitHub**. Add the GitHub OAuth app's client ID and secret there. Add your local app URL to Supabase's allowed redirect URLs (for example, `http://localhost:5173/**`). The GitHub OAuth callback URL shown by Supabase must also be registered in the GitHub OAuth app.

7. Start the development server:

   ```sh
   npm run dev
   ```

Vite prints the local URL, normally `http://localhost:5173`.

## Available Checks

```sh
npm run build
npm run lint
```

## Deploy to GitHub Pages

This repository includes a GitHub Actions workflow at `.github/workflows/deploy.yml`. It builds the Vite site for the repository's Pages URL, adds an SPA fallback for client-side routes, and deploys after a push to `main` or `master`.

1. Push the project to a GitHub repository.
2. In **Settings > Pages**, set the build and deployment source to **GitHub Actions**.
3. In **Settings > Secrets and variables > Actions**, add repository secrets named `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY`. Use the Supabase project URL and its publishable key (or legacy anon key), never a service-role or secret key.
4. In Supabase **Authentication > URL Configuration**, set the site URL to `https://YOUR-GITHUB-USERNAME.github.io/YOUR-REPOSITORY/` and add that URL with `/**` to the allowed redirect URLs. Configure the GitHub OAuth callback URL shown by Supabase in the GitHub OAuth app.
5. Push to `main` or `master`, or run **Deploy to GitHub Pages** from the repository's Actions tab. The workflow summary shows the published URL.

The workflow assumes a GitHub project site (URL includes the repository name). A GitHub user/organization site uses a different base path and needs the workflow's `VITE_BASE_PATH` adjusted to `/`.

## Supabase Data Model

- `communities`: public community listings; signed-in users can create them.
- `posts`: public posts associated with an optional community; signed-in users can create posts.
- `votes`: one upvote or downvote per user and post.
- `comments`: public threaded comments; signed-in users can add comments and replies.
- `post-images`: public image bucket for post images; uploads require sign-in.

Row-level security is enabled for all application tables. The migration grants public reads needed by the forum and restricts writes to authenticated users, with ownership checks for posts, votes, and comments.