require "rails_helper"

RSpec.describe DemoWorkspace, type: :model do
  describe ".prepare" do
    context "When the environment is set to enable demo" do
      before { allow(ENV).to receive(:[]).with('DEMO_ENABLED').and_return('true') }

      it "creates a workspace suitable for demoing Convene" do
        demo_workspace = DemoWorkspace.prepare
        aggregate_failures do
          expect(demo_workspace).to be_persisted
          expect(demo_workspace).to be_unlocked
          expect(demo_workspace.access_code).to be_nil
          expect(demo_workspace.name).to eql("Convene Demo")
          expect(demo_workspace.slug).to eql("convene-demo")
          expect(demo_workspace.jitsi_meet_domain).to eql("convene-videobridge-zinc.zinc.coop")
          expect(demo_workspace.branded_domain).to eql("convene-demo.zinc.coop")

          expect(demo_workspace.rooms.find_by(name: "Zee's Desk")).to be_present
          expect(demo_workspace.rooms.find_by(name: "Zee's Desk")).to be_listed
          expect(demo_workspace.rooms.find_by(name: "Vivek's Desk")).to be_present
          expect(demo_workspace.rooms.find_by(name: "Vivek's Desk")).to be_listed
          expect(demo_workspace.rooms.find_by(name: "Water Cooler")).to be_present
          expect(demo_workspace.rooms.find_by(name: "Water Cooler")).to be_listed

          expect(demo_workspace.rooms.find_by(name: "The Ada Lovelace Room")).to be_present
          expect(demo_workspace.rooms.find_by(name: "The Ada Lovelace Room")).to be_listed
        end
      end
    end

    context "When the environment is set to disable demo" do
      before { allow(ENV).to receive(:[]).with('DEMO_ENABLED').and_return(nil) }
      it "does not create demo workspace" do
        expect do
          DemoWorkspace.prepare
        end.not_to change {[ Workspace.count, Client.count, Room.count] }
      end
    end

    it "is idempotent" do
      DemoWorkspace.prepare
      expect do
        DemoWorkspace.prepare
      end.not_to change {[ Workspace.count, Client.count, Room.count] }
    end
  end
end