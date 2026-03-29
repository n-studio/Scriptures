require "test_helper"

class Groups::InvitationsControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as(users(:scholar)) }

  test "create sends invitation email" do
    group = Group.create!(name: "Test", owner: users(:scholar))
    group.group_memberships.create!(user: users(:scholar), role: "owner")

    assert_enqueued_emails 1 do
      post group_invitations_path(group), params: { email: "new@example.com", role: "editor" }
    end
    assert_redirected_to group_path(group)
    assert_equal 1, group.group_invitations.count
  end

  test "show accepts invitation" do
    group = Group.create!(name: "Test", owner: users(:scholar))
    inv = group.group_invitations.create!(email: "scholar@example.com", invited_by: users(:scholar), role: "viewer")

    get group_invitation_accept_path(token: inv.token)
    assert_redirected_to group_path(group)
    assert group.member?(users(:scholar))
    assert inv.reload.accepted?
  end

  test "show rejects invalid token" do
    get group_invitation_accept_path(token: "bogus")
    assert_redirected_to root_path
  end
end
