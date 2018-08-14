# Commit Time Web

Web Dashboard for [commit-time](https://github.com/karagenit/commit-time).

![commit time web](screenshot.png)

## Setup

To install the Ruby Gem dependencies, simply run:

```
$ rake setup
```

Then, launch the server:

```
$ rake run
```

and navigate to `localhost:4567`.

> **NOTE:** This site uses `Redis` for caching - I don't think it will run without `Redis` being available. Check your package manager or [go here](https://redis.io/download) to install.

### Running Tests

Simply run

```
$ rake test
```
