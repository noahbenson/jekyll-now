#! /bin/bash
# Start the Jekyll server on your local computer
# Assumes you have installed bundle.

[ -d ./_posts ] && [ -r ./_config.yml ] || {
    echo "run.sh needs to be run from in the blog directory!"
    exit 1
}

[ -a ./Gemfile ] || {
    echo "source 'https://rubygems.org'" > Gemfile
    echo "gem 'github-pages', group: :jekyll_plugins" >> Gemfile
}

bundle exec jekyll serve --incremental
