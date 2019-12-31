# frozen_string_literal: true

require 'test_helper'

class CasesTest < Minitest::Test
  Dir[File.join(__dir__, 'cases', '*.test')].each do |filepath|
    define_method(:"test_#{File.basename(filepath, '.test')}") do
      input, output = File.read(filepath).split("---\n")
      assert_change input, output
    end
  end

  EXPECTED_EVENTS = %i[
    alias_error
    arg_ambiguous
    assign_error
    class_name_error
    excessed_comma
    heredoc_dedent
    magic_comment
    mlhs_new
    nokw_param
    number_arg
    operator_ambiguous
    param_error
    parse_error
    stmts_new
  ].freeze

  TODO_EVENTS = %i[aryptn hshptn].freeze

  def test_event_types
    events = Ripper::PARSER_EVENTS - EXPECTED_EVENTS - TODO_EVENTS
    methods = events.map { |event| :"to_#{event}" }

    assert_empty methods - Preval::Node.instance_methods
  end
end
