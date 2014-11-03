require 'spec_helper'

describe Api::MessagesController do

  it "accepts a message from a valid integration" do
    post "/api/integration/71DVI4QvVAyIfyCNT7J6-DhBLUDuH6spcI9PoNyOI4k/message", {a: 1, b: 2}
    expect(response).to have_http_status(:created)
  end

  it "rejects a message from a invalid integration" do
    post "/api/integration/unknown/message", {a: 1, b: 2}
    expect(response).to have_http_status(:not_found)
  end

end
