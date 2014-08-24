# audiothority

[![Build Status](https://travis-ci.org/mthssdrbrg/audiothority.svg?branch=master)](https://travis-ci.org/mthssdrbrg/audiothority)
[![Coverage Status](https://img.shields.io/coveralls/mthssdrbrg/audiothority.svg)](https://coveralls.io/r/mthssdrbrg/audiothority?branch=master)

Audiothority is a small command-line app for finding albums (or directories if
you prefer) with inconsistent tags among the tracks, and either enforce some
basic guidelines or move all inconsistent albums to a new directory.

Currently the `artist`, `album`, and `year` tags are checked for uniqueness, and
the `track` tag is checked for missing tack numbers.

## Installation

Audiothority depends on `taglib-ruby`, which requires `taglib`.
See [taglib-ruby](https://github.com/robinst/taglib-ruby) for instructions on
how to install `taglib` on a few different operating systems.

```
gem install audiothority
```

This will make the `audiothorian` command available.
For basic usage run `audiothorian --help`, and run any of the subcommands
without arguments to see their usage (or `audiothorian help <CMD>` if you
prefer).

## Copyright

Released under the [MIT License](http://www.opensource.org/licenses/MIT) :: 2014 Mathias Söderberg.
