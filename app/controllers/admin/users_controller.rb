class Admin::UsersController < Admin::RecordsController
  private

  def record_scope
    User.all
  end

  def record_path(...)
    admin_user_path(...)
  end

  def record_class
    User
  end

  def index_columns
    %w[id email display_name admin language created_at]
  end

  def show_columns
    %w[id email display_name admin language default_corpus_slug default_translation_abbreviation created_at updated_at]
  end

  def edit_columns
    %w[email display_name admin language default_corpus_slug default_translation_abbreviation]
  end

  def record_params
    params.require(:user).permit(:email, :display_name, :admin, :language, :default_corpus_slug, :default_translation_abbreviation)
  end
end
