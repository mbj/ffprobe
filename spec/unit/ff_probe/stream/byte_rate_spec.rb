require 'spec_helper'

describe FFProbe::Stream,'#byte_rate' do
  subject { object.byte_rate }

  let(:object)   { described_class.new(:size => size,:duration => duration) }
  let(:size)     { 100 }
  let(:duration) { 100 }

  it { should eql(Rational(1,1)) }
end
