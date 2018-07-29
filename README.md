# Commit Time Web Dashboard

Web Dashboard for [commit-time](https://github.com/karagenit/commit-time).

## Setup

To install the Ruby Gem dependencies, simply run:

```
$ bundle install
```

Then, launch the server:

```
$ ruby site.rb
```

and navigate to `localhost:4567`.

> **NOTE:** This site uses `Redis` for caching - I don't think it will run without `Redis` being available. Check your package manager or [go here](https://redis.io/download) to install.

## Roadmap

- [ ] Pagination
- [ ] Background jobs with AJAX Status
- [ ] Auto timestamp-based (or most-recent-commit-has based??) cache update - if new commits, fetch them
- [ ] On cache update, only grab commits we don't have in our CommitTime objects

#### Visualizations

- [ ] Total time
- [ ] Total time for each project (top 20 or so) - separate tab for "all repos" list
- [ ] Time spent over time (both for total and per project) (on a monthly/yearly scale as line graph)
- [ ] Language Breakdowns
