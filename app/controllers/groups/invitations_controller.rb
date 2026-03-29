module Groups
  class InvitationsController < ApplicationController
    require_authentication except: :show

    def create
      @group = find_editor_group
      invitation = @group.group_invitations.new(
        email: params[:email],
        role: params[:role].presence || "viewer",
        invited_by: current_user
      )
      if invitation.save
        GroupMailer.invitation(invitation).deliver_later
        redirect_to group_path(@group), notice: "Invitation sent to #{invitation.email}."
      else
        redirect_to group_path(@group), alert: invitation.errors.full_messages.join(", ")
      end
    end

    def show
      invitation = GroupInvitation.pending.find_by!(token: params[:token])
      invitation.accept!(current_user)
      redirect_to group_path(invitation.group), notice: "You joined #{invitation.group.name}."
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, alert: "Invalid or expired invitation."
    end

    private

    def find_editor_group
      group = Group.find(params[:group_id])
      raise ActiveRecord::RecordNotFound unless group.editor?(current_user)
      group
    end
  end
end
