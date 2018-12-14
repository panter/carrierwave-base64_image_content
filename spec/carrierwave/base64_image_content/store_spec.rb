# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CarrierWave::Base64ImageContent::Store do
  class ImageUploader < CarrierWave::Uploader::Base
  end

  class Note < ActiveRecord::Base
    include CarrierWave::Base64ImageContent::Store

    mount_uploaders :images, ImageUploader

    base64_image_content_store content: :text_content, images: :images
  end

  let(:image1_placeholder) do
    '360593ff547c864bd9d16bbed6eb8860d9fad9a407aa74e066039db23b525338'
  end

  let(:image1_data) do
    'data:image/png;base64,/9j/4AAQSkZJRgABAQEASABKdhH//2Q='
  end

  let(:image2_data) do
    'data:image/png;base64,/8c/4AAQSkZJRgABAQEASABKdhH//2Q='
  end

  # subject(:note) do
  #   Note.create!
  # end


  describe '#content=' do
    context 'when content contains 1 image' do
      let(:note) do
        Note.create!(
          content: %(content1 <img src="#{image1_data}" />)
        )
      end

      after { note.remove_images! }

      it 'saves an image as a file' do
        expect(note.images.count).to eq 1
        expect(note.images.first.file).to exist
      end

      it 'replaces the base64 part with the file hash' do
        expect(note.text_content).to eq(
          %(content1 <img src="#{image1_placeholder}" />)
        )
      end

      it 'adds one image and removes one' do
        note.update!(
          content:
            %(content1 <img src="#{image1_data}" />) +
            %(content2 <img src="#{image2_data}" />)
        )

        first_file = note.images[0].file
        second_file = note.images[1].file

        expect(note.images.count).to eq 2
        expect(first_file).to exist
        expect(second_file).to exist

        note.update!(
          content: %(content2 <img src="#{image2_data}" />)
        )

        expect(note.images.count).to eq 1
        expect(first_file).not_to exist
        expect(second_file).to exist
      end
    end

    it 'saves equal images as one file' do
      note = Note.create!(
        content:
          %(content1 <img src="#{image1_data}" />) +
          %(content2 <img src="#{image1_data}" />)
      )

      expect(note.images.count).to eq 1
      expect(note.images[0].file).to exist
    end
  end

  describe '#content' do
    it 'retrieves equal images from one file' do
      note = Note.create!(
        content:
          %(content1 <img src="#{image1_placeholder}" />) +
          %(content2 <img src="#{image1_placeholder}" />),
        images: [CarrierWave::Base64ImageContent::Base64StringIO.new(image1_data)]
      )

      expect(note.content).to eq(
        %(content1 <img src="#{image1_data}" />) +
        %(content2 <img src="#{image1_data}" />)
      )
    end
  end
end
