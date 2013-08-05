namespace :db do
 task :migrate do
   puts "Skipping db:migrate as activerecord is not enabled"
 end
end