class CaseStudiesController < ApplicationController

  skip_before_filter :require_login

  def get_all
    @cases = CaseStudy.all
    render json: @cases.to_json
  end
end
