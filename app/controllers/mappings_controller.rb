class MappingsController < ApplicationController

  def index
    @forms = OdkAggregate::Form.all
  end

end
