require 'spec_helper'

describe "postgresql::db" do
  let(:facts) { default_test_facts }
  let(:title) { 'testdb' }

  it do
    should include_class("postgresql")

    should contain_exec("postgresql-db-#{title}").with({
      :command => "/test/boxen/homebrew/bin/createdb -p15432 -E UTF-8 -O testuser #{title}",
      :unless  => "/test/boxen/homebrew/bin/psql -a -p15432 -t -l | cut -d \\| -f 1 | grep -w '#{title}'"
    })
  end
end
