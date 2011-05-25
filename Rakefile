desc "Convert requirements to HTML"
task :requirements do
  sh "saga convert --template design/requirements_template design/requirements.txt > design/requirements.html"
end

desc "Start the fixture server needed for the specs"
task :serve_fixtures do
  puts "[!] Starting web server on localhost:9292"
  exec "rackup -s webrick ./Spec/fixtures/config.ru"
end

def is_fixture_server_running?
  require 'socket'
  TCPSocket.new('localhost', 9292)
  true
rescue Errno::ECONNREFUSED
  false
end

desc "Run the specs"
task :spec do
  ios_sim = `which ios-sim`.strip
  if ios_sim.empty?
    puts "[!] Unable to find `ios-sim'. Install it with: $ brew install ios-sim"
    exit 1
  elsif !is_fixture_server_running?
    puts "[!] It seems the fixture server isn't running. Start it with: $ rake serve_fixtures"
  else
    sh "xcodebuild -project iTrakt.xcodeproj -target Specs -configuration Debug -sdk iphonesimulator4.2"
    exec "#{ios_sim} launch build/Debug-iphonesimulator/Specs.app"
  end
end

task :default => :spec
