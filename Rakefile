desc "Convert requirements to HTML"
task :requirements do
  sh "saga convert design/requirements.txt > design/requirements.html"
end

desc "Run the specs"
task :spec do
  exec "ruby #{File.expand_path('../vendor/NuBacon/bin/nu-bacon.rb', __FILE__)} --project iTrakt.xcodeproj --target Specs"
end

task :default => :spec
