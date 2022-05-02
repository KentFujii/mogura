RSpec.describe Mogura do
  it "defines Init" do
    expect(defined?(Mogura::Init)).to be_truthy
  end

  it "defines Push" do
    expect(defined?(Mogura::Push)).to be_truthy
  end

  it "defines VERSION" do
    expect(defined?(Mogura::VERSION)).to be_truthy
  end

  it "has a version number" do
    expect(Mogura::VERSION).not_to be nil
  end
end
