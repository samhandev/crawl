## Development

Developed with ruby 2.3.1

Run using the following:

    $ bin/crawl "https://gocardless.com"

Run the tests after making sure you have the required gems installed:

    $ bundle install
    $ bundle exec rspec

## Improvements
To do / things to think about:

[] change the Http requests and processing of the html to make use of threads for performance
[] currently the processed pages are stored in a hash (in memeory) with the url as the key and a `Page` object the value.
The `Page` object contains the `url`, `parent`, `links` and `assets`.
Should probably store these to disk / database as we are processing so that we still have some processed data in the program crashes or is interrupted.
[] deal with network unreliability. Should we have a set number of retries before discarding a url as being unable to process?
[] respect the `Request-Rate` and `Crawl-Delay` from `/robots.txt` if they are present
[] write tests for the `Crawl` class!
[] formatting of information. Currently we just pretty print the hash.
[] refactor `StaticAssetExtractor` class so that it takes a list of functions that describe the different types of assets to extract

