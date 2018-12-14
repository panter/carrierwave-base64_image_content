# frozen_string_literal: true

module CarrierWave
  module Base64ImageContent
    module Store
      extend ActiveSupport::Concern

      module ClassMethods
        attr_reader :base64_image_content_content_attribute
        attr_reader :base64_image_content_images_attribute

        def base64_image_content_store(content: :text_content, images: :images)
          @base64_image_content_content_attribute = content
          @base64_image_content_images_attribute = images
        end
      end

      def content=(content)
        content, new_image_files = extract_image_files_from_content(content)

        remove_obsolete_files!(new_image_files)
        add_new_files!(new_image_files)

        # FIXME: https://github.com/carrierwaveuploader/carrierwave/issues/1990
        self[self.class.base64_image_content_images_attribute] =
          read_images_attribute.map(&:file).map(&:original_filename)

        write_content_attribute(content)
      end

      def content
        return unless read_content_attribute

        content = read_content_attribute.dup

        read_images_attribute.map do |image|
          base64_file = Base64File.new(image.file)
          content = replace_placeholder_by_data(content, base64_file)
        end

        content
      end

      private

      def replace_placeholder_by_data(content, base64_file)
        content.gsub(
          /
          (<img.*? src=['"])
          (#{base64_file.filename_without_extension})
          (['"].*?>)
          /x,
            "\\1#{base64_file.data_url}\\3"
        )
      end

      def extract_image_files_from_content(content)
        matches = content
          .scan(%r{<img.*? src=['"](data:image/[^;]+;base64,[^'"]+)['"].*?>})
          .flatten

        image_files = matches.uniq.map do |match|
          Base64StringIO.new(match).tap do |file|
            content = content.sub(match, file.file_name)
          end
        end

        [content, image_files]
      end

      def remove_obsolete_files!(new_image_files)
        new_file_names = new_image_files.map(&:original_filename)

        read_images_attribute
          .reject { |image| new_file_names.include?(image.file.original_filename) }
          .each do |image|
          read_images_attribute.delete(image)
          image.remove!
        end
      end

      def add_new_files!(new_image_files)
        old_file_names = read_images_attribute.map(&:file).map(&:original_filename)

        new_image_files
          .reject { |image| old_file_names.include?(image.original_filename) }
          .each do |image|
          write_images_attribute(read_images_attribute + [image])
        end
      end

      def read_content_attribute
        self[self.class.base64_image_content_content_attribute]
      end

      def write_content_attribute(content)
        self[self.class.base64_image_content_content_attribute] = content
      end

      def read_images_attribute
        public_send(self.class.base64_image_content_images_attribute)
      end

      def write_images_attribute(images)
        public_send(
          "#{self.class.base64_image_content_images_attribute}=",
          images 
        )
      end
    end
  end
end
