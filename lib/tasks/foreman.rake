namespace :foreman do
  desc ">> Start redis, sidekiq, and rails servers"
  task start: :environment do
    sh %( foreman s -f Procfile.dev )
  end
end
