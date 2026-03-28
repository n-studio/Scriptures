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

  def add_passage
    @curriculum = current_user.curricula.find(params[:id])
    passage = Passage.find(params[:passage_id])
    position = @curriculum.curriculum_items.maximum(:position).to_i + 1
    @curriculum.curriculum_items.find_or_create_by!(passage: passage) do |ci|
      ci.position = position
      ci.title = params[:title]
      ci.notes = params[:notes]
    end

    redirect_back fallback_location: curriculum_path(@curriculum)
  end

  def remove_passage
    @curriculum = current_user.curricula.find(params[:id])
    @curriculum.curriculum_items.find_by!(passage_id: params[:passage_id]).destroy
    redirect_back fallback_location: curriculum_path(@curriculum)
  end

  def reorder
    @curriculum = current_user.curricula.find(params[:id])
    item_ids = params[:item_ids] || []
    item_ids.each_with_index do |id, index|
      @curriculum.curriculum_items.where(id: id).update_all(position: index + 1)
    end
    head :ok
  end

  def mark_read
    @curriculum = Curriculum.find(params[:id])
    passage = Passage.find(params[:passage_id])
    current_user.reading_progresses.find_or_create_by!(passage: passage) do |rp|
      rp.read_at = Time.current
    end
    redirect_back fallback_location: curriculum_path(@curriculum)
  end

  def mark_unread
    @curriculum = Curriculum.find(params[:id])
    current_user.reading_progresses.find_by(passage_id: params[:passage_id])&.destroy
    redirect_back fallback_location: curriculum_path(@curriculum)
  end

  def export
    @curriculum = Curriculum.find(params[:id])

    unless @curriculum.public? || (authenticated? && @curriculum.user == current_user)
      redirect_to root_path, alert: "Curriculum not found."
      return
    end

    @items = @curriculum.curriculum_items.includes(passage: { division: { scripture: :corpus } })

    respond_to do |format|
      format.text do
        text = render_plain_text(@curriculum, @items)
        send_data text, filename: "#{@curriculum.name.parameterize}.txt", type: "text/plain"
      end
    end
  end

  private

  def curriculum_params
    params.require(:curriculum).permit(:name, :description, :public, :curriculum_type)
  end

  def render_plain_text(curriculum, items)
    lines = []
    lines << curriculum.name
    lines << "=" * curriculum.name.length
    lines << ""
    lines << curriculum.description if curriculum.description.present?
    lines << "" if curriculum.description.present?
    lines << "#{items.size} passages"
    lines << ""

    items.each_with_index do |item, i|
      passage = item.passage
      scripture = passage.division.scripture
      corpus = scripture.corpus
      ref = "#{scripture.name} #{passage.division.number}:#{passage.number}"
      lines << "#{i + 1}. #{ref} (#{corpus.name})"
      lines << "   #{item.title}" if item.title.present?
      lines << "   #{item.notes}" if item.notes.present?
    end

    lines.join("\n")
  end
end
