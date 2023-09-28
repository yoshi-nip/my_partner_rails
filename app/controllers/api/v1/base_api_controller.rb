class Api::V1::BaseApiController < ApplicationController
  ## 仮の実装、モック
  def current_user
    @current_user = User.first
  end
end
