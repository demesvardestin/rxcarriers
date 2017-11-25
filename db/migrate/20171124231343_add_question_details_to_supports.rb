class AddQuestionDetailsToSupports < ActiveRecord::Migration
  def change
    add_column :supports, :question_details, :string
  end
end
