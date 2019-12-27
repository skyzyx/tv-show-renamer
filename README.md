# TV Show Renamer

Fixes a number of small annoyances when purchasing complete TV series’ from the iTunes Store.

1. In a title such as “Season 1, Episode 1: Pilot”, it will set Season to `1`, Episode to `1`, and Title to _Pilot_.

1. Will attempt some basic cleanup around apostrophes, quotes, etc.

## Usage

* Assumes GNU tools instead of BSD tools: <https://flwd.dk/31ELAKJ>
* `brew install mp4v2`

I tend to run it like this:

```bash
find /path/to/shows -type f -name "*.m4v" -print0 \
| xargs -0 --no-run-if-empty -I% ./itunes-store-complete-series-episode-fixer.sh "%"
```
