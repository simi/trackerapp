require 'spec_helper'

describe "TimeParser" do
  # # 1:30, 1.5, 90, 1h, 270 minut
  it "parses '\\d+ minut'" do
    minutes = TimeParser.new("666 minut").minutes
    expect(minutes).to eq(666)
  end

  it "parses '\\d+:\\d+'" do
    minutes = TimeParser.new("1:45").minutes
    expect(minutes).to eq(105)
  end

  it "parses '\\d+.\\d+'" do
    minutes = TimeParser.new("1.7").minutes
    expect(minutes).to eq(102)
  end

  it "parses '\\d+h'" do
    minutes = TimeParser.new("3h").minutes
    expect(minutes).to eq(180)
  end

  it "parses '\\d+'" do
    minutes = TimeParser.new("333").minutes
    expect(minutes).to eq(333)
  end

  it "parses 'h'" do
    minutes = TimeParser.new("h").minutes
    expect(minutes).to eq(0)
  end

  it "parses 'minutes'" do
    minutes = TimeParser.new("minut").minutes
    expect(minutes).to eq(0)
  end

  it "fails when unknown string is given" do
    minutes = TimeParser.new("test").minutes
    expect(minutes).to eq(0)
  end

  it "fails when unknown string + nr is given" do
    minutes = TimeParser.new("test66").minutes
    expect(minutes).to eq(0)
  end
end
