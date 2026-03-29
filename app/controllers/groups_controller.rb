class GroupsController < ApplicationController
  require_authentication except: %i[show]

  def index
    @owned = current_user.owned_groups
    @member_of = current_user.groups.where.not(id: @owned.select(:id))
  end

  def show
    @group = Group.find(params[:id])
    unless @group.public? || (authenticated? && @group.member?(current_user))
      redirect_to root_path, alert: "Group not found."
      return
    end

    @memberships = @group.group_memberships.includes(:user)
    @pending_invitations = @group.group_invitations.pending if authenticated? && @group.editor?(current_user)
    @activities = @group.group_activities.includes(:user).limit(20)
    @collections = @group.collections.includes(:passages)
    @curricula = @group.curricula.includes(:curriculum_items)
    @annotations = @group.annotations.includes(passage: { division: { scripture: :corpus } }, tags: []).limit(10)
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner = current_user
    if @group.save
      @group.group_memberships.create!(user: current_user, role: "owner")
      redirect_to group_path(@group), notice: "Group created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @group = current_user.owned_groups.find(params[:id])
  end

  def update
    @group = current_user.owned_groups.find(params[:id])
    if @group.update(group_params)
      redirect_to group_path(@group), notice: "Group updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    current_user.owned_groups.find(params[:id]).destroy
    redirect_to groups_path
  end

  private

  def group_params
    params.require(:group).permit(:name, :description, :public)
  end
end
