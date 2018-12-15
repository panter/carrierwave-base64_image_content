# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CarrierWave::Base64ImageContent::Base64StringIO do
  context 'with correct "image/jpg" data' do
    subject(:io) { described_class.new(data) }

    let(:data) do
      'data:image/jpg;base64,/9j/4AAQSkZJRgABAQEASABKdhH//2Q='
    end

    it 'determines the file format from the Data URI content type' do
      expect(io.file_format).to eql 'jpg'
    end

    it 'responds to :original_filename' do
      expect(io.original_filename).to eql(
        'b729cadfd5b337f7a0c88a4bba48454cdd0ac59ff909da4cb8bdcd57b3cacb2e.jpg'
      )
    end
  end

  context 'with invalid image data' do
    it 'raises an ArgumentError if the data uri content type is missing' do
      expect do
        described_class.new('/9j/4AAQSkZJRgABAQEASABIAADKdhH//2Q=')
      end.to raise_error(
        CarrierWave::Base64ImageContent::Base64StringIO::ArgumentError
      )
    end

    it 'raises ArgumentError if base64 data equals (null)' do
      expect do
        described_class.new('data:image/jpg;base64,(null)')
      end.to raise_error(
        CarrierWave::Base64ImageContent::Base64StringIO::ArgumentError
      )
    end
  end
end
