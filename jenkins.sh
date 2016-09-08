#!/bin/sh -xe

gem install -N bundler --version=1.12.0

bundle
rake jenkins || :
