module Annotations
  class SharedController < ApplicationController
    def show
      @user = User.find(params[:user_id])
      @annotations = @user.annotations.publicly_visible.includes(passage: { division: { scripture: :corpus } }, tags: [])
      @annotations = @annotations.joins(:tags).where(tags: { name: params[:tag] }) if params[:tag].present?
      @tags = Tag.joins(:annotations).where(annotations: { user_id: @user.id, public: true }).distinct
    end
  end
end
