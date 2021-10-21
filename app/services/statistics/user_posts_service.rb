module Statistics
  class UserPostsService
    def initialize(user)
      @user = user
    end

    def posts_statistic
      @posts_statistic ||= fetch_user_statistic
    end

    private

    attr_reader :user

    def fetch_user_statistic
      user
        .posts
        .pluck_to_struct(
          Arel.sql('COUNT(*) as total_count'),
          Arel.sql('COALESCE(SUM(CASE WHEN published_at IS NULL THEN 0 ELSE 1 END), 0) AS published_count')
        ).first
    end
  end
end