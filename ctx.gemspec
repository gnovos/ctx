Gem::Specification.new do |s|
  s.name         = 'ctx'
  s.version      = '1.0.0'
  s.homepage     = 'http://rubygems.org/gems/ctx'
  s.summary      = 'Scoped define and context for use in writing more expressive DSLs'
  s.description  = 'Scoped define and context for use in writing more expressive DSLs'
  s.authors      = %w(Mason)
  s.email        = 'ctx@chipped.net'
  s.files        = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
  s.require_path = 'lib'
  s.bindir       = 'bin'

  s.add_development_dependency 'rspec'
end
