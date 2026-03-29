class Admin::DashboardController < Admin::ApplicationController
  def index
    @stats = {
      traditions: Tradition.count,
      corpora: Corpus.count,
      scriptures: Scripture.count,
      passages: Passage.count,
      translations: Translation.count,
      users: User.count,
      groups: Group.count,
      annotations: Annotation.count,
      commentaries: Commentary.count,
      lexicon_entries: LexiconEntry.count
    }
    @recent_users = User.order(created_at: :desc).limit(5)
    @recent_annotations = Annotation.includes(:user, :passage).order(created_at: :desc).limit(5)
  end
end
