RSpec.describe Mogura::Push do
  it "push dig to a digdag server" do
    path = File.expand_path("#{File.dirname(__FILE__)}/../fixtures")
    allow(Rails).to receive_message_chain(:root, :join, :to_s).and_return(path)
    allow(Rails).to receive_message_chain(:application, :class, :module_parent_name).and_return('mogura')
    http = double('http')
    allow(Net::HTTP).to receive(:start).and_yield(http)
    expect(http).to receive(:request).once
    described_class.push
  end
end
