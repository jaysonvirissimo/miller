require 'spec_helper'

describe Miller do
  let(:valid_observation_set) do
    properties = [0, 'A', 'B', 'C', 'D', 'E']
    occurrence_1 = [1, true, true, true, false, true]
    occurrence_2 = [2, true, false, true, true, true]
    occurrence_3 = [3, false, true, true, false, true]
    Matrix[properties, occurrence_1, occurrence_2, occurrence_3]
  end

  let(:invalid_observation_set) do
    properties = [0, 'A', 'B', 'C', 'D', 'E']
    occurrence_1 = [1, 'this', 'is', 'not', 'valid', 'data']
    Matrix[properties, occurrence_1]
  end

  let(:present_and_absent_observation_set) do
    properties = [0, 'A', 'B', 'C', 'D', 'E']
    occurrence_1 = [1, 'P', 'P', 'P', 'A', 'P']
    occurrence_2 = [2, 'P', 'A', 'P', 'P', 'P']
    occurrence_3 = [3, 'A', 'P', 'P', 'A', 'P']
    Matrix[properties, occurrence_1, occurrence_2, occurrence_3]
  end

  let(:zero_and_one_observation_set) do
    occurrence_0 = [0, 'A', 'B', 'C', 'D', 'E']
    occurrence_1 = [1, 1, 1, 1, 0, 1]
    occurrence_2 = [2, 1, 0, 1, 1, 1]
    occurrence_3 = [3, 0, 1, 1, 0, 1]
    Matrix[occurrence_0, occurrence_1, occurrence_2, occurrence_3]
  end

  let(:valid_data_set) do
    one = [true, true, true, false, true]
    two = [true, false, true, true, true]
    three = [false, true, true, false, true]
    Matrix[one, two, three]
  end

  it 'has a version number' do
    expect(Miller::VERSION).not_to be nil
  end

  it 'converts 0 and 1 to true and false' do
    miller = Miller.new(zero_and_one_observation_set)
    data = miller.send(:data)

    expect(data).to eq(valid_data_set)
  end

  it 'converts P and A to true and false' do
    miller = Miller.new(present_and_absent_observation_set)
    data = miller.send(:data)

    expect(data).to eq(valid_data_set)
  end

  it 'raises error with invalid data' do
    expect { Miller.new(invalid_observation_set) }.to raise_error(RuntimeError)
  end

  context 'with valid obeservation set' do

    before(:each) do
      @miller = Miller.new(valid_observation_set)
    end

    it 'distinguishes the occurrence numbers from the data' do
      occurrence_numbers = @miller.send(:occurrence_numbers)

      expect(occurrence_numbers).to eq([0, 1, 2, 3])
    end

    it 'distinguishes the conditioning properties from the data' do
      properties = @miller.send(:possible_conditioning_properties)

      expect(properties).to eq(%w(A B C D))
    end

    it 'distinguishes the conditioned property from the data' do
      property = @miller.send(:conditioned_property)

      expect(property).to eq('E')
    end

    it 'sets data' do
      data = @miller.send(:data)

      expect(data).to eq(valid_data_set)
    end

    it 'responds to #direct_method_of_agreement' do
      expect(@miller).to respond_to(:direct_method_of_agreement)
    end

    it 'responds to #inverse_method_of_agreement' do
      expect(@miller).to respond_to(:inverse_method_of_agreement)
    end

    it 'responds to #direct_method_of_agreement' do
      expect(@miller).to respond_to(:method_of_difference)
    end
  end
end
