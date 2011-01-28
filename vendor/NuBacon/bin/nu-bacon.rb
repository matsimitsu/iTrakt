require 'optparse'

CONFIG = { :verbose => false }

option_parser = OptionParser.new do |opts|
  opts.banner = "Usage: #{__FILE__} --project MyProject.xcodeproj --target SpecRunner [options]"

  opts.on("--project PATH", "The path to the XCode project file") do |project|
    project = File.expand_path(project)
    CONFIG[:project] = File.basename(project)
    CONFIG[:project_dir] = File.dirname(project)
  end

  opts.on("--target NAME", "The of the target in the XCode project that is the spec runner") do |target|
    CONFIG[:target] = target
  end

  opts.on("--product NAME", "The name of the product that's build by the target (defaults to `--target')") do |product|
    CONFIG[:product] = product
  end

  opts.on("--sdk VERSION", "The version of the iOS SDK to build and run on (defaults to the latest available)") do |sdk|
    CONFIG[:sdk] = sdk
  end

  opts.on("--family DEVICE", "The device family to run on (defaults to `iphone')") do |family|
    CONFIG[:family] = family
  end

  opts.on("--verbose", "See commands performed and the output") do |verbose|
    CONFIG[:verbose] = true
  end
end
option_parser.parse!

unless CONFIG[:project] && CONFIG[:target]
  puts option_parser
  exit 1
end

CONFIG[:product] ||= CONFIG[:target]
CONFIG[:family]  ||= 'iphone'
CONFIG[:sdk]     ||= Dir.glob("/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/*.sdk").map { |sdk| File.basename(sdk).match(/\d+\.\d+/)[0] }.sort.last
CONFIG[:sdk_dir]   = "/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator#{CONFIG[:sdk]}.sdk"
CONFIG[:ios_sim] = `which ios-sim`.strip

if CONFIG[:ios_sim].empty?
  puts "Could not locate the ios-sim binary. Install it with: $ brew install ios-sim"
  exit 1
end

def sh(cmd)
  puts(cmd) if CONFIG[:verbose]
  output = `#{cmd}`
  puts(output) if CONFIG[:verbose]
  $?.success?
end

if sh("cd #{CONFIG[:project_dir]} && xcodebuild -project #{CONFIG[:project]} -target #{CONFIG[:target]} -configuration Debug -sdk #{CONFIG[:sdk_dir]}")
  exec "#{CONFIG[:ios_sim]} launch #{File.join(CONFIG[:project_dir], "build/Debug-iphonesimulator/#{CONFIG[:product]}.app")} --sdk #{CONFIG[:sdk]} --family #{CONFIG[:family]}#{ ' --verbose' if CONFIG[:verbose] }"
else
  puts "[!] Failed to build the spec runner app."
end
