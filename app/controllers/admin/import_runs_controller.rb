class Admin::ImportRunsController < Admin::RecordsController
  private

  def record_scope
    ImportRun.all.order(created_at: :desc)
  end

  def record_path(...)
    admin_import_run_path(...)
  end

  def record_class
    ImportRun
  end

  def index_columns
    %w[id key status records_count started_at completed_at]
  end

  def show_columns
    %w[id key status records_count started_at completed_at error_message created_at updated_at]
  end

  def authorized_for_create?
    false
  end

  def authorized_for_update?
    false
  end
end
