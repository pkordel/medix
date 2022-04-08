# Usage: add this where you need to clean the database: include_context "with database cleaner"
RSpec.shared_context "with database cleaner" do
  before(:all) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end

  around do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
