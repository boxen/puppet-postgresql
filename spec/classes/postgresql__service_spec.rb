require "spec_helper"

describe "postgresql::service" do
  let(:facts) { default_test_facts }

  it do
    should contain_service("com.boxen.postgresql").with_ensure(:stopped)

    should contain_exec("init-postgresql-db").with_creates("/test/boxen/data/postgresql/PG_VERSION")
    should contain_service("dev.postgresql").with_ensure(:running)
    should contain_exec("wait-for-postgresql").with_unless("nc -z 127.0.0.1 15432")
  end

  context "Ubuntu" do
    let(:facts) { default_test_facts.merge(:operatingsystem => "Ubuntu") }

    it do
      should_not contain_service("com.boxen.postgresql")

      should contain_exec("init-postgresql-db").with_creates("/var/lib/postgresql/PG_VERSION")
      should contain_service("postgresql-9.1").with_ensure(:running)
      should contain_exec("wait-for-postgresql").with_unless("nc -z 127.0.0.1 5432")
    end
  end
end

