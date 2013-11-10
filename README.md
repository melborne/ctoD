# CtoD

CtoD is a tool for exporting a CSV data to database.

## Installation

Add this line to your application's Gemfile:

    gem 'ctoD'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ctoD

## Usage

It comes with `ctoD` command.

    # Display help.
    % ctoD
    Commands:
      ctoD create_table CSV DATABASE  # Create a database table for CSV
      ctoD export CSV DATABASE        # Export CSV data to a DATABASE
      ctoD help [COMMAND]             # Describe available commands or one specific command

    # Export movies.csv data to a table named 'movies' at postgres movies database.
    % ctoD export movies.csv postgres://localhost/movies

    # Export movies.csv data to movies.sqlite3 database file.
    % ctoD export movies.csv sqlite3://localhost/${HOME}/.db/movies.sqlite3

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
