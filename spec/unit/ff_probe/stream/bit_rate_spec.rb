require 'spec_helper'

describe FFProbe::Stream,'#bit_rate' do
  subject { object.bit_rate }

  let(:object)   { described_class.new(:size => size,:duration => duration) }
  let(:size)     { 100 }
  let(:duration) { 100 }

  it { should eql(Rational(8,1)) }
end
