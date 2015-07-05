require 'spec_helper'

RSpec.describe Api::MessagesController, :type => :request do

  it "accepts a message from a valid integration" do
    post "/api/integration/71DVI4QvVAyIfyCNT7J6-DhBLUDuH6spcI9PoNyOI4k/message", {a: 1, b: 2}
    expect(response).to have_http_status(:created)
  end
end
