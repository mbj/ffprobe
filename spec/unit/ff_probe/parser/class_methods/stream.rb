require 'spec_helper'

describe FFProbe::Parser,'.stream' do
  subject { object.stream(raw) }

  let(:object) { described_class }

  context 'with nb_frames of type string' do
    let(:raw) { { 'nb_frames' => nb_frames } }

    context 'when valid' do
      let(:nb_frames) { '100' }
      its(:nb_frames) { should be(100) }
    end
  end
end
