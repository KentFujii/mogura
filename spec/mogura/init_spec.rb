RSpec.describe Mogura::Init do
  it "generate a sample dig" do
    described_class.instance_variable_set(:@project, "test")

    pathname = Pathname.new("/rails_app")
    allow(Rails).to receive(:root).and_return(pathname)
    allow(FileUtils).to receive(:mkdir_p).with(pathname.join('app/views/test_dag').to_s)
    io = double('io')
    allow(File).to receive(:new).with(pathname.join('app/views/test_dag/sample.json.jbuilder').to_s, 'w').and_return(io)
    expect(io).to receive(:puts).with(described_class.send(:dig_sample_content)).once
    expect(io).to receive(:close).once

    described_class.send(:generate_dig_file)
  end

  it "generate a sample dag" do
    described_class.instance_variable_set(:@project, "test")

    pathname = Pathname.new("/rails_app")
    allow(Rails).to receive(:root).and_return(pathname)
    allow(FileUtils).to receive(:mkdir_p).with(pathname.join('app/dags').to_s)
    io = double('io')
    allow(File).to receive(:new).with(pathname.join('app/dags/test.rb').to_s, 'w').and_return(io)
    expect(io).to receive(:puts).with(described_class.send(:dag_sample_content)).once
    expect(io).to receive(:close).once

    described_class.send(:generate_dag_file)
  end
end
