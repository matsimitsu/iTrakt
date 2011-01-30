desc "Convert requirements to HTML"
task :requirements do
  sh "saga convert design/requirements.txt > design/requirements.html"
end

desc "Start the fixture server needed for the specs"
task :serve_fixtures do
  puts "[!] Starting web server on localhost:9292"
  exec "rackup -s webrick ./Spec/fixtures/config.ru"
end

desc "Run the specs"
task :spec do
  exec "ruby #{File.expand_path('../vendor/NuBacon/bin/nu-bacon.rb', __FILE__)} --project iTrakt.xcodeproj --target Specs"
end

task :default => :spec
