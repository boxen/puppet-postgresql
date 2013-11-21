require "spec_helper"

describe "postgresql::package" do
  let(:facts) { default_test_facts }

  it do
    should contain_homebrew__formula("postgresql")

    should contain_package("boxen/brews/postgresql")
  end

  context "Ubuntu" do
    let(:facts) { default_test_facts.merge(:operatingsystem => "Ubuntu") }

    it do
      should_not contain_homebrew__formula("postgresql")

      should contain_package("postgresql-server-9.1")
    end
  end
end

