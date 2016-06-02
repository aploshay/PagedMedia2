require 'rails_helper'
describe PagedMedia::ObjectBehavior do
  class StubObject
    include PagedMedia::ObjectBehavior
    def members
      []
    end
    def member_of
      []
    end
  end
  let(:stub_object) { StubObject.new }

  describe '#descendents_tree' do
    it 'returns a Hash of objects' do
      expect(stub_object.descendents_tree).to be_a Hash
    end
  end
  describe '#descendents_tree_ids' do
    it 'returns a Hash of ids' do
      expect(stub_object.descendents_tree_ids).to be_a Hash
    end
  end
  describe '#descendents_list'
    it 'returns an array of objects' do
      expect(stub_object.descendents_list).to be_a Array
    end
  describe '#descendents_list_ids' do
    it 'returns an array of ids' do
      expect(stub_object.descendents_list_ids).to be_a Array
    end
  end
#titles
#cont_array
end
