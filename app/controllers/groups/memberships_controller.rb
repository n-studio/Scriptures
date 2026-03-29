module Groups
  class MembershipsController < ApplicationController
    require_authentication

    def destroy
      @group = Group.find(params[:group_id])

      if params[:user_id]
        # Owner removing a member
        raise ActiveRecord::RecordNotFound unless @group.owner == current_user
        membership = @group.group_memberships.find_by!(user_id: params[:user_id])
        membership.destroy unless membership.user == @group.owner
        redirect_to group_path(@group)
      else
        # Member leaving
        if @group.owner == current_user
          redirect_to group_path(@group), alert: "Owners cannot leave. Transfer ownership or delete the group."
        else
          @group.group_memberships.find_by(user: current_user)&.destroy
          redirect_to groups_path, notice: "You left #{@group.name}."
        end
      end
    end
  end
end
