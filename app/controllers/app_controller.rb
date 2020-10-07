class Api::V1::AppController < ApplicationController
  def test
    render plain: '{"hello": "you"}'
  end
end
