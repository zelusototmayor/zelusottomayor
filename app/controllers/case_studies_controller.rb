class CaseStudiesController < ApplicationController
  def show
    @case_study = CaseStudy.published.find_by!(slug: params[:id])
    @related_studies = CaseStudy.published
                                 .where.not(id: @case_study.id)
                                 .where(client_type: @case_study.client_type)
                                 .ordered
                                 .limit(3)
  rescue ActiveRecord::RecordNotFound
    redirect_to work_path, alert: "Case study not found."
  end
end
