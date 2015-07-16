class TeamMembersController < ApplicationController

  skip_before_filter :require_login

  def get_all
    @members = TeamMember.all
    render json: @members.to_json
  end
end
