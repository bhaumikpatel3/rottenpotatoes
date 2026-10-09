# RottenPotatoes

A Ruby on Rails movie catalog for [Programming Assignment 2: Hello Rails](https://github.com/tamu-edu-students/hw-hello-rails).

## Deployed app

Deployment is pending. Replace this sentence with the verified public app URL before submitting.

## Run locally

Use the Ruby version in `.ruby-version` and install Bundler. From this directory:

```sh
bundle install
bundle exec rails db:prepare
bundle exec rails db:seed
bundle exec rails server
```

Open http://localhost:3000. SQLite stores development and test data separately; production uses PostgreSQL through `DATABASE_URL`.

## Features

- Add, view, edit, and delete movies with a title, rating, release date, and optional description.
- Sort title, rating, or release date in either direction by selecting a table heading.
- Retain the selected column and direction in the Rails session while navigating between pages.
- Highlight the sorted column green for ascending and purple for descending, with arrow indicators, `aria-sort`, and a written sort status.
- Seed the original five movies plus three additions without duplicating unchanged seed records on repeated runs.
- Style all four pages with handwritten CSS and no CSS framework or template.

## How the code fits together

| File | Responsibility |
| --- | --- |
| `config/routes.rb` | Maps HTTP requests to the movie controller; sends `/` to `/movies`. |
| `db/migrate/*_create_movies.rb` | Creates the movie table and its columns. |
| `app/models/movie.rb` | Validates movie attributes and performs database sorting with allowed columns and directions. |
| `app/controllers/movies_controller.rb` | Handles CRUD, permits only movie form fields, and remembers the sort selection. |
| `app/helpers/movies_helper.rb` | Builds heading links and accessible sorting indicators. |
| `app/views/movies/` | Renders the table, details, and shared create/edit form. |
| `app/assets/stylesheets/application.css` | Handwritten styling for every page. |
| `db/seeds.rb` | Finds or creates each seed movie using its title and release date. |

Sorting happens in SQL through ActiveRecord, before rendering the view. Request parameters are checked against allowed values. The session stores only the selected column and direction. Deletion uses a form with the HTTP DELETE override and Rails CSRF protection, so it works without JavaScript.

Seed identity is title plus release date. Running seeds again preserves edits to a movie's rating or description. Renaming a seed movie or changing its release date changes that identity, so a later seed run can recreate the original entry.

## Verification

```sh
bundle exec rails test
bundle exec rubocop
bundle exec brakeman --no-pager --quiet
```

Tests cover CRUD, invalid inputs, six sorting combinations, session persistence across navigation and CRUD, table structure, sort indicators, missing records, empty collections, escaped content, and repeated seeding. GitHub Actions also checks production asset compilation on Linux.

## Deploy and submit

Follow [the deployment guide](docs/DEPLOYMENT.md) and [the rubric checklist](docs/RUBRIC_CHECKLIST.md). Submit this GitHub repository's URL to Canvas after the deployed app URL has been committed and pushed here.
