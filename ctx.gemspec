Gem::Specification.new do |s|
  s.name         = 'ctx'
  s.version      = '2.2.0'
  s.homepage     = 'https://github.com/gnovos/ctx'
  s.description  = 'Scoped and contextual method definition for use in writing more expressive DSLs without screwing defintions in other pieces of code'
  s.summary      = 'Contextual method define'
  s.authors      = %w(Mason)
  s.email        = 'ctx@chipped.net'
  s.files        = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
  s.require_path = 'lib'
  s.bindir       = 'bin'

  s.add_dependency 'mobj'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rr'
  s.add_development_dependency 'awesome_print'
end
