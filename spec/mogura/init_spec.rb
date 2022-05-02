RSpec.describe Mogura::Init do
  it "initializes a sample dig" do
    pathname = Pathname.new("/app")
    allow(Rails).to receive(:root).and_return(pathname)
    allow(Dir).to receive(:mkdir).with(pathname.join('config/digdag').to_s)
    io = double('io')
    allow(File).to receive(:new).with(pathname.join('config/digdag/sample.dig').to_s, 'w').and_return(io)
    expect(io).to receive(:puts).with(described_class.send(:dig_sample_content)).once
    expect(io).to receive(:close).once

    described_class.send(:init_dig)
  end

  it "initializes a sample dag" do
    pathname = Pathname.new("/app")
    allow(Rails).to receive(:root).and_return(pathname)
    allow(Dir).to receive(:mkdir).with(pathname.join('app/dags').to_s)
    io = double('io')
    allow(File).to receive(:new).with(pathname.join('app/dags/sample_dag.rb').to_s, 'w').and_return(io)
    expect(io).to receive(:puts).with(described_class.send(:dag_sample_content)).once
    expect(io).to receive(:close).once

    described_class.send(:init_dag)
  end
end
