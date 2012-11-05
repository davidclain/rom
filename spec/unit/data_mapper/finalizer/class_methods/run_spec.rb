require 'spec_helper'

describe Finalizer, '.run' do
  subject { described_class.run }

  let(:user_model)     { mock_model(:User) }
  let(:user_mapper)    { mock_mapper(user_model) }
  let(:address_model)  { mock_model(:Address) }
  let(:address_mapper) { mock_mapper(address_model) }

  let(:mappers) { [ address_mapper, user_mapper ] }

  let(:finalizer) { mock('finalize') }

  it "runs finalization for all defined mappers" do
    described_class.should_receive(:new).with(mappers.reverse).and_return(finalizer)
    finalizer.should_receive(:run)
    subject
  end
end
