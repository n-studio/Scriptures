class AnnotationsController < ApplicationController
  require_authentication except: :index

  def index
    if params[:user_id] && authenticated?
      @annotations = current_user.annotations.includes(passage: { division: { scripture: :corpus } }, tags: [])
      @annotations = @annotations.joins(:tags).where(tags: { name: params[:tag] }) if params[:tag].present?
    else
      @annotations = Annotation.none
    end

    if params[:q].present?
      @annotations = @annotations.where("body LIKE ?", "%#{Annotation.sanitize_sql_like(params[:q])}%")
    end

    @tags = current_user&.tags || Tag.none
  end

  def create
    @annotation = current_user.annotations.new(annotation_params)
    @annotation.tag_list = params[:annotation][:tag_list] if params.dig(:annotation, :tag_list)

    if @annotation.save
      redirect_back fallback_location: root_path, notice: "Annotation saved."
    else
      redirect_back fallback_location: root_path, alert: @annotation.errors.full_messages.join(", ")
    end
  end

  def update
    @annotation = current_user.annotations.find(params[:id])
    @annotation.assign_attributes(annotation_params)
    @annotation.tag_list = params[:annotation][:tag_list] if params.dig(:annotation, :tag_list)

    if @annotation.save
      redirect_back fallback_location: annotations_path(user_id: current_user), notice: "Annotation updated."
    else
      redirect_back fallback_location: root_path, alert: @annotation.errors.full_messages.join(", ")
    end
  end

  def destroy
    current_user.annotations.find(params[:id]).destroy
    redirect_back fallback_location: annotations_path(user_id: current_user)
  end

  private

  def annotation_params
    params.require(:annotation).permit(:passage_id, :body)
  end
end
