# frozen_string_literal: true

%w[
  .ruby-version
  .rbenv-vars
  tmp/restart.txt
  tmp/caching-dev.txt
].each do |path| Spring.watch(path) end
