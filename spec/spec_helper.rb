# frozen_string_literal: true

require 'bundler/setup'
require 'pg'
require 'carrierwave/base64_image_content'
require 'pry'

database_config = {
  adapter: 'postgresql',
  encoding: 'unicode'
}
database = 'carrierwave-base64_image_content_test'

ActiveRecord::Base.establish_connection(
  database_config.merge(database: 'template1')
)
begin
  ActiveRecord::Base.connection.create_database database
# database already exists
rescue ActiveRecord::StatementInvalid # rubocop:disable Lint/HandleExceptions
end
ActiveRecord::Base.establish_connection(
  database_config.merge(database: database)
)

ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define version: 0 do
  create_table :notes, force: true do |t|
    t.column :text_content, :text
    t.column :images, :string, array: true
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before do
    Note.delete_all
  end
end
