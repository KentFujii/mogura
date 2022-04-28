RSpec.describe Mogura::Push do
  it "push dig to a digdag server" do
    path = File.expand_path("#{File.dirname(__FILE__)}/../fixtures")
    allow(Rails).to receive_message_chain(:root, :join, :to_s).and_return(path)
    allow(Rails).to receive_message_chain(:application, :class, :module_parent_name).and_return('mogura')
    described_class.send(:push)
  end
end
