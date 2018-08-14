task :default => %i[run]

task :run do
    sh "ruby site.rb"
end

task :setup do
    sh "bundle install"
end

task :test do
    sh "rspec"
    sh "rubocop api.rb auth.rb db.rb helpers.rb site.rb"
end
