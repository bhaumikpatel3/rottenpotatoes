# Deploy on Render

The supplied `render.yaml` defines a Rails web service and a PostgreSQL database on Render's Free plans. Review the current plan labels before creating services; do not select a paid plan accidentally.

1. Create a Render account and connect the GitHub account that owns this repository. Limit the GitHub integration to this repository when possible.
2. In Render, choose **New > Blueprint**, select this repository, and review the resources from `render.yaml`.
3. Confirm both resources use the Free plan and deploy. The build script installs gems, compiles CSS, migrates the database, and seeds the eight movies. Render generates `SECRET_KEY_BASE` and connects `DATABASE_URL`; neither value belongs in Git.
4. Wait until the web service is live, then open its public HTTPS URL. Verify the movie collection and every item in `RUBRIC_CHECKLIST.md`.
5. Replace the pending deployment sentence in `README.md` with a Markdown link to that working URL.
6. Commit and push the README change. In GitHub Desktop, write `add deployed app address`, commit, and push.
7. Submit the GitHub repository URL to Canvas. If the repository is private, ensure the course staff have the access your course requires.

The web service reads Render's `PORT` through `config/puma.rb`. `WEB_CONCURRENCY=0` keeps Puma in single-process mode for this small app. Production uses PostgreSQL, so records survive service restarts.

## Free hosting lifetime

Render's free web service sleeps after 15 idle minutes and can take about a minute to wake. Its free PostgreSQL database expires 30 days after creation. Keep the app and database available through grading, not just through the submission deadline. Upgrade only if you choose to pay, or arrange an appropriate hosting alternative before expiration.

This deployment's database was created on October 17, 2026. Render displays **November 16, 2026** as its expiration date. If grading extends beyond that date, arrange continued database hosting before expiration. The sleeping web service wakes on a visit; an expired database does not.

## Troubleshooting

- Check Render's build logs first. A failed migration or missing environment variable prevents a successful deployment.
- The lockfile includes Linux dependencies; keep `Gemfile`, `Gemfile.lock`, and `.ruby-version` in sync.
- A local Windows error saying an Application Control policy blocked a Ruby DLL is a runtime/security-policy problem. Ask your administrator about an approved Ruby installation, or use an approved Linux development environment. Do not disable security protections.
- If a native gem fails with profiling linker errors, check whether a `DEBUG` environment variable enabled debug compilation. Clearing it for the install command is sufficient; no permanent environment change is needed.

## Heroku alternative

The `Procfile` supports Heroku: its release process migrates and seeds the database, and its web process starts Rails. A Heroku app and PostgreSQL add-on must be provisioned first. Review costs and any student credits before provisioning.

References: [Render Rails 8 guide](https://render.com/docs/deploy-rails-8), [Render free-plan limits](https://render.com/docs/free), [Heroku Rails 8 guide](https://devcenter.heroku.com/articles/getting-started-with-rails8).
