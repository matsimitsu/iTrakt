###############################
#
# The actual mappings
#

mappings = lambda do
  map('/hello') do
    serve_text_fixture('hello-world')
  end

  map(%r{/status-code\?code=(\d+)}) do |code|
    send_status(code)
  end

  map(%r{/sleep\?sec=(\d+)}) do |seconds|
    sleep seconds.to_i
    send_status 200
  end

  map('/basic-auth') do
    send_text(basic_auth_data)
  end

  map('/json/simple-array') do
    serve_json_fixture('simple-array')
  end

  map('/json/simple-dictionary') do
    serve_json_fixture('simple-dictionary')
  end

  map('/poster.jpg') do
    serve_jpeg_fixture('poster')
  end

  map('/api/users/calendar.json') do
    with_proper_auth do
      serve_json_fixture('user-calendar-shows')
    end
  end

  map('/api/users/library.json') do
    with_proper_auth do
      serve_json_fixture('user-show-library')
    end
  end

  map('/api/shows/recommendations.json') do
    serve_json_fixture('recommendations')
  end

  map('/api/shows/82066.json') do
    serve_json_fixture('show')
  end

  map('/api/shows/82066/seasons_with_episodes') do
    serve_json_fixture('show-seasons-and-episodes')
  end

  map('/api/uploads/82066/poster-82066.jpg') do
    serve_jpeg_fixture('poster')
  end

  map('/api/uploads/82066/thumb-82066-3-12.jpg') do
    serve_jpeg_fixture('thumb')
  end

  %w{ seen unseen }.each do |action|
    map("/trakt/show/episode/#{action}/apikey") do
      with_proper_auth do
        if $env['REQUEST_METHOD'] == 'POST' && $env['rack.input'].read == "{ \"tvdb_id\":\"82066\", \"episodes\":[{ \"season\":3, \"episode\":1 }] }"
          send_status 200
        else
          ohnoes_404!
        end
      end
    end
  end

end


###############################
#
# The implementation, boring...
#

require "base64"


module FixtureServe
  HOST = 'http://localhost:9292'
  FIXTURES = File.dirname(__FILE__)

  # password is a SHA1 hash of `secret'
  BASIC_AUTH = 'bob:e5e9fa1ba31ecd1ae84f75caaa474f3a663f05f4'

  extend self

  def map(path, &block)
    @mappings ||= {}
    @mappings[path] = block
  end

  def call(env)
    $env = env
    request_path = env['REQUEST_URI'][HOST.length..-1]
    _, block = @mappings.find { |path, _| path === request_path }
    block ? block.call($1) : ohnoes_404!
  end

  private

  def basic_auth_data
    if auth_header = $env['HTTP_AUTHORIZATION']
      data = auth_header.match(/^Basic (.+)/)[1]
      Base64.decode64(data)
    end
  end

  def with_proper_auth
    if basic_auth_data == BASIC_AUTH
      yield
    else
      [401, { 'Content-Type' => 'text/plain' }, ['401 Unauthorized']]
    end
  end

  def fixture(name)
    File.join(FIXTURES, name)
  end

  def fixture_io(name)
    File.open(fixture(name), 'r')
  end

  def send_status(code)
    code = code.to_i
    [code, { 'Content-Type' => 'text/plain' }, "Explicitely send status code: #{code}"]
  end

  def send_text(text)
    [200, { 'Content-Type' => 'text/plain' }, text]
  end

  def serve_text_fixture(name)
    send_text(fixture_io("#{name}.txt"))
  end

  def serve_json_fixture(name)
    [200, { 'Content-Type' => 'application/json' }, fixture_io("#{name}.json")]
  end

  def serve_jpeg_fixture(name)
    [200, { 'Content-Type' => 'image/jpeg' }, fixture_io("#{name}.jpg")]
  end

  def ohnoes_404!
    [404, { 'Content-Type' => 'text/plain' }, ['404 fixture not found']]
  end
end

FixtureServe.instance_eval(&mappings)

run FixtureServe
