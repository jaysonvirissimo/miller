require 'miller/version'

class Miller
  def initialize(matrix)
    @conditioned_property = setup_conditioned_property(matrix)
    @data = setup_data(matrix)
    @occurrence_numbers = setup_occurrence_numbers(matrix)
    @possible_conditioning_properties = setup_conditioning_properties(matrix)
  end

  private

  attr_reader :conditioned_property,
              :data,
              :occurrence_numbers,
              :possible_conditioning_properties

  def setup_conditioned_property(matrix)
    matrix.row(0).to_a.last
  end

  def setup_data(matrix)
    matrix.minor(1..matrix.row_count, 1..matrix.column_count).collect do |value|
      convert_to_proper_truth_value(value)
    end
  end

  def setup_occurrence_numbers(matrix)
    matrix.column(0).to_a
  end

  def setup_conditioning_properties(matrix)
    array = matrix.row(0).to_a
    array.slice(1...array.length - 1)
  end

  def convert_to_proper_truth_value(value)
    case value
    when false, 0, '0', 'A', 'Absent', 'a', 'false'
      false
    when true, 1, '1', 'P', 'Present', 'p', 'true'
      true
    else
      fail "Invalid truth value: #{value}"
    end
  end
end
