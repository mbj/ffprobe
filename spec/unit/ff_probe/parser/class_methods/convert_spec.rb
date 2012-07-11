require 'spec_helper'

describe FFProbe::Parser,'.convert' do
  subject { object.convert(model,raw) }

  let(:object) { described_class } 
  let(:model)  { FFProbe::Stream }
  let(:raw)    { { 'avg_frame_rate' => value } }

  context 'without error' do
    let(:value) { '25/1' }

    it 'should return converted attributes' do
      should == model.new(:avg_frame_rate => Rational(25,1))
    end
  end

  context 'with error' do
    let(:value) { 'foo' }

    it 'should raise error' do
      expect { subject }.to raise_error(RuntimeError,'Unable to coerce "foo" to #<Virtus::Attribute::Rational @name=:avg_frame_rate>')
    end
  end
end
