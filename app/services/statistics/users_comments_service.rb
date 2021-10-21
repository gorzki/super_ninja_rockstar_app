module Statistics
  class UsersCommentsService
    def initialize(users)
      @users = users
    end

    def comments_statistic
      @comments_statistic ||= fetch_users_statistic
    end

    private

    attr_reader :users

    def fetch_users_statistic
      users
        .comments
        .group(:user_id)
        .pluck_to_struct(:user_id, Arel.sql('COUNT(*) as total_count'))
    end
  end
end