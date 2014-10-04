require 'spec_helper'

describe "postgresql::db" do
  let(:facts) { default_test_facts }
  let(:title) { 'testdb' }

  it do
    should include_class("postgresql")
  end

  context "without a specified db owner" do
    it do
      should contain_exec("postgresql-db-#{title}").with({
        :command => "createdb -p15432 -E UTF-8 -O testuser #{title}",
        :unless  => "psql -aA -p15432 -t -l | cut -d \\| -f 1 | grep -w '#{title}'"
      })
    end
  end

  context "with a specified db owner" do
    let(:params) { { :owner => 'foo' } }

    it do
      should contain_exec("postgresql-db-#{title}").with({
        :command => "createdb -p15432 -E UTF-8 -O foo #{title}",
        :unless  => "psql -aA -p15432 -t -l | cut -d \\| -f 1 | grep -w '#{title}'"
      })
    end
  end
end
