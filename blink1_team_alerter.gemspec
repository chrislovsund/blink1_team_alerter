# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'blink1_team_alerter/version'

Gem::Specification.new do |spec|
  spec.name          = "blink1_team_alerter"
  spec.version       = Blink1TeamAlerter::VERSION
  spec.authors       = ["Christian Lövsund"]
  spec.email         = ["chris@lovsund.se"]

  spec.summary       = "Help the team spot important situations by using blink1 to visualize events like important JIRA issue"
  spec.description   = "Help the team spot important situations by using blink1 to visualize events like important JIRA issue"
  spec.homepage      = "https://github.com/chrislovsund/blink1_team_alerter"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_runtime_dependency "activesupport"
  spec.add_runtime_dependency "rb-blink1"
  spec.add_runtime_dependency "rest-client"
  spec.add_runtime_dependency "json"

end
