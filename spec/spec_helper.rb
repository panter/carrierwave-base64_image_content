require 'bundler/setup'
require 'pg'
require 'carrierwave/base64_image_content'
require 'pry'

databaseConfig = {
  adapter: 'postgresql',
  encoding: 'unicode',
}
database = 'carrierwave-base64_image_content_test'

ActiveRecord::Base.establish_connection(databaseConfig.merge(database: "template1"))
begin
  ActiveRecord::Base.connection.create_database database
rescue ActiveRecord::StatementInvalid => e # database already exists
end
ActiveRecord::Base.establish_connection(databaseConfig.merge(database: database))

ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define version: 0 do
  create_table :notes, force: true do |t|
    t.column :text_content, :text
    t.column :images, :string, array: true
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before do
    Note.delete_all
  end
end
