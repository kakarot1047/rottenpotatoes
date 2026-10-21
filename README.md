# RottenPotatoes

A small movie catalog I built in Rails for CSCE 606 (Homework 2, "Hello Rails"). It's a loose take on Rotten Tomatoes: you can add movies, look them up, fix their details, delete the ones you regret adding, and sort the whole list however you like.

**Live app:** https://hw2-csce606-rottenpotatoes-a3e086b562d0.herokuapp.com

## What it does

- **Full CRUD on movies.** Add a movie, open it to see everything about it, edit it, or delete it.
- **A proper table on the main page.** Title, rating, director, release date and my own star rating, built with `<thead>`, `<tbody>` and a `<tfoot>` that shows how many movies there are.
- **Sorting on every column, both directions.** Click a header to sort ascending, click it again to flip it. The sorted column gets a highlight (warm yellow for ascending, soft blue for descending) and a ▲ or ▼ next to its name, so you can tell what's going on even without the colors. There's also `aria-sort` on the header for screen readers.
- **It remembers how you sorted.** If you sort by director, go add a movie and come back, the list is still sorted by director.
- **Personal star ratings.** Every movie can get 1 to 5 stars from me, or stay "Not rated". This is separate from the MPAA rating (G, PG, R and so on).
- **Hand-written CSS only.** No Bootstrap, no Tailwind, no templates. The header, footer, table, cards and forms are all styled in `app/assets/stylesheets/application.css`.

## A note on where the sorting happens

The assignment hinted that there's a "best" place to sort and that we'd be judged on it. I put it in the model:

```ruby
Movie.sorted_by("director", "desc")
```

That turns into a plain SQL `ORDER BY`, so the database does the work instead of Ruby or the browser. The controller stays thin; it only reads the sort from the URL, checks it against an allow-list, and saves it in the session. The allow-list matters: only `title`, `rating`, `director`, `release_date` and `stars` are accepted, so nobody can sneak SQL in through the URL.

When you come back to the list without any sort in the URL, the controller redirects you to the URL with your saved sort. That keeps the address bar honest about what you're looking at, and it means a sorted view can be bookmarked or shared.

## Running it locally

You'll need Ruby 3.3.9 and Bundler. I developed it on Ubuntu under WSL.

```sh
git clone git@github.com:kakarot1047/rottenpotatoes.git
cd rottenpotatoes
bundle config set --local without 'production'   # skips the Postgres gem locally
bundle install
rails db:migrate
rails db:seed
rails server
```

Then open http://localhost:3000. The root path just redirects to `/movies`.

Locally it runs on SQLite. In production on Heroku it uses Postgres, which is why `pg` sits in the `:production` group of the Gemfile and `sqlite3` sits in `:development, :test`.

## Seed data

`db/seeds.rb` has nine movies: the five from the assignment handout plus four I added (The Dark Knight, Inside Out, Oppenheimer, and Everything Everywhere All at Once).

You can run `rails db:seed` as many times as you want without getting duplicates. Each movie is looked up by title first and only created if it isn't there yet (existing ones just get their details refreshed). I learned this the hard way: my first Heroku deploy seeded twice with plain `create!` and I ended up with two of everything.

Star ratings are deliberately left out of the seeds. Those get set through the edit form, since they're my opinions and not part of the dataset.

## Deploying to Heroku

The `Procfile` handles the database on every deploy:

```
web: bundle exec rails server -p $PORT
release: bundle exec rails db:migrate && bundle exec rails db:seed
```

So deploying is just:

```sh
git push heroku main
```

The release step runs any new migrations and re-seeds before the new version goes live. If the release step fails, Heroku keeps serving the previous version, which saved me once when I forgot to commit the `pg` gem.

For a first-time setup on a new Heroku app:

```sh
heroku create <app-name>
heroku addons:create heroku-postgresql:essential-0
git push heroku main
```

## Where things live

| What | File |
|---|---|
| Movie model, sort logic, star validation | `app/models/movie.rb` |
| Sorting, session memory, the redirect | `app/controllers/movies_controller.rb` (`index`) |
| Sortable headers and star display helpers | `app/helpers/movies_helper.rb` |
| The movie table | `app/views/movies/index.html.erb` |
| Add/edit form | `app/views/movies/_form.html.erb` |
| Movie detail card | `app/views/movies/_movie.html.erb` |
| Site header and footer | `app/views/layouts/application.html.erb` |
| All the styling | `app/assets/stylesheets/application.css` |
| Database schema | `db/migrate/` and `db/schema.rb` |

## Things I'd add with more time

- Search by title or director
- Filtering by MPAA rating (just the PG-13 movies, say)
- Making unrated movies always sort to the bottom, since Postgres and SQLite disagree on where blanks go
- Tests. The scaffold was generated with `--skip-test` as the assignment asked, so there aren't any yet.

## Built with

Ruby 3.3.9, Rails 8.1, SQLite (development), PostgreSQL (production), Heroku, and a fair amount of trial and error.

— Gokulan Valavan
