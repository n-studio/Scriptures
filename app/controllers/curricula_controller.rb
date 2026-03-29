class CurriculaController < ApplicationController
  require_authentication except: :show

  def index
    @curricula = current_user.curricula.includes(:curriculum_items)
  end

  def show
    @curriculum = Curriculum.find(params[:id])

    unless @curriculum.public? || (authenticated? && @curriculum.user == current_user)
      redirect_to root_path, alert: "Curriculum not found."
      return
    end

    @items = @curriculum.curriculum_items.includes(passage: { division: { scripture: :corpus } })

    if authenticated?
      read_ids = ReadingProgress.where(user: current_user, passage_id: @items.map(&:passage_id)).pluck(:passage_id).to_set
      @read_ids = read_ids
      @progress = @items.any? ? (read_ids.size.to_f / @items.size * 100).round : 0
    else
      @read_ids = Set.new
      @progress = 0
    end
  end

  def new
    @curriculum = current_user.curricula.build
  end

  def create
    @curriculum = current_user.curricula.build(curriculum_params)
    if @curriculum.save
      redirect_to curriculum_path(@curriculum), notice: "Curriculum created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @curriculum = current_user.curricula.find(params[:id])
  end

  def update
    @curriculum = current_user.curricula.find(params[:id])
    if @curriculum.update(curriculum_params)
      redirect_to curriculum_path(@curriculum), notice: "Curriculum updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    current_user.curricula.find(params[:id]).destroy
    redirect_to curricula_path
  end

  private

  def curriculum_params
    params.require(:curriculum).permit(:name, :description, :public, :curriculum_type)
  end
end
