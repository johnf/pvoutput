# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable RSpec/FilePath
describe PVOutput do
  it 'has a version number' do
    expect(PVOutput::VERSION).not_to be nil
  end
end
# rubocop:enable RSpec/FilePath
