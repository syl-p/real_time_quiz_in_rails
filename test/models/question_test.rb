class QuestionTest < ActiveSupport::TestCase
  setup do
    @quiz = Quiz.create!(title: "My quiz")
    @question = @quiz.questions.build(content: "This is a question ?")
    @question.choices.build(label: "A.")
    @question.choices.build(label: "B.")
    @question.choices.build(label: "C.")
  end

  test "Question must have one correct choice" do
    @question.valid?
    assert_includes @question.errors[:choices], "doit avoir au moins une réponse correcte"

    @question.choices.build(label: "D.", correct: true)
    @question.valid?
    assert_empty @question.errors[:choices]
  end
end
