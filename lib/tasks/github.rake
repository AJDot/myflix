namespace :github do
  desc ">> Commit with Message"
  task :commit, [:message] => :environment do |task, args|
    sh %( git add -A )
    sh %( git commit -m "#{args.message}" )
    sh %( git push )
  end
end
