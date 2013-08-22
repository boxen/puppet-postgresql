require 'spec_helper'

describe "postgresql::db" do
  let(:facts) { default_test_facts }
  let(:title) { 'testdb' }

  it do
    should include_class("postgresql")

    should contain_exec("postgresql-db-#{title}").with({
      :command => "createdb -p15432 -E UTF-8 -O testuser #{title}",
      :require => 'Exec[wait-for-postgresql]',
      :unless  => "psql -aA -p15432 -t -l | cut -d \\| -f 1 | grep -w '#{title}'"
    })
  end
end
