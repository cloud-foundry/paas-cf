
RSpec.describe "S3 broker properties" do
  let(:manifest) { manifest_with_defaults }
  let(:properties) { manifest.fetch("instance_groups.s3_broker.jobs.s3-broker.properties.s3-broker") }

  describe "service plans" do
    let(:services) {
      properties.fetch("catalog").fetch("services")
    }
    let(:all_plans) {
      services.flat_map { |s| s["plans"] }
    }

    specify "all services have a unique id" do
      all_ids = services.map { |s| s["id"] }
      duplicated_ids = all_ids.select { |id| all_ids.count(id) > 1 }.uniq
      expect(duplicated_ids).to be_empty,
        "found duplicate service ids (#{duplicated_ids.join(',')})"
    end

    specify "all services have a unique name" do
      all_names = services.map { |s| s["name"] }
      duplicated_names = all_names.select { |name| all_names.count(name) > 1 }.uniq
      expect(duplicated_names).to be_empty,
        "found duplicate service names (#{duplicated_names.join(',')})"
    end

    specify "all plans have a unique id" do
      all_ids = all_plans.map { |p| p["id"] }
      duplicated_ids = all_ids.select { |id| all_ids.count(id) > 1 }.uniq
      expect(duplicated_ids).to be_empty,
        "found duplicate plan ids (#{duplicated_ids.join(',')})"
    end

    specify "all plans within each service have a unique name" do
      services.each { |s|
        all_names = s["plans"].map { |p| p["name"] }
        duplicated_names = all_names.select { |name| all_names.count(name) > 1 }.uniq
        expect(duplicated_names).to be_empty,
          "found duplicate plan names (#{duplicated_names.join(',')})"
      }
    end
  end
end
