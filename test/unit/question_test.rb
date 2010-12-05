require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "eval all" do
    questions = Question.all
    questions.each do |question|
      if !question.answer.blank?
        eval(question.context)
        eval(@question.prompt)
        assert true
      end
    end
  end
end
