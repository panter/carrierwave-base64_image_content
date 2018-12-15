# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'carrierwave/base64_image_content/version'

# rubocop:disable Metrics/BlockLength
Gem::Specification.new do |spec|
  spec.name          = 'carrierwave-base64_image_content'
  spec.version       = CarrierWave::Base64ImageContent::VERSION
  spec.authors       = ['Alexis Reigel']
  spec.email         = ['mail@koffeinfrei.org']

  spec.summary       = 'Upload content with base64 images to Carrierwave.'
  spec.description   = "Allows storing content with base64 images to a model
                          with Carrierwave file uploads. The base64 images are
                          extracted from the content and stored as physical
                          files using Carrierwave's configured storage. When
                          reading the content the files are converted back to
                          base64 images."
  spec.homepage      = 'https://github.com/panter/carrierwave-base64_image_content'

  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`
      .split("\x0")
      .reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'activerecord', '>= 4.2'
  spec.add_runtime_dependency 'carrierwave', '>= 1.2'
  spec.add_runtime_dependency 'rails', '>= 4.2'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'pg'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-rspec'
end
# rubocop:enable Metrics/BlockLength
