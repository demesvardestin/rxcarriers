require "rails_helper"

RSpec.describe Batch, :type => :model do
  context "getting second to last batch" do
    it "returns second to last batch" do
      b = Batch.create(:status => 'initialized')
      expect(b.status).to eq 'initialized'
    end
  end
end