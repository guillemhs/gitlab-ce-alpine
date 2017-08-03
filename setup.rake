namespace :gitlab do
  desc "GitLab | Setup production application"
  task setup: :environment do
    setup_db
  end

  def setup_db
    warn_user_is_not_gitlab
    Rake::Task["db:reset"].invoke
    Rake::Task["add_limits_mysql"].invoke
    Rake::Task["setup_postgresql"].invoke
    Rake::Task["db:seed_fu"].invoke
  rescue Gitlab::TaskAbortedByUserError
    puts "Quitting...".color(:red)
    exit 1
  end
end