class AddWorkflowStepsToCaseStudies < ActiveRecord::Migration[8.0]
  def change
    add_column :case_studies, :workflow_steps, :text
  end
end
