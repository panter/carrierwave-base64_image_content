# CarrierWave::Base64ImageContent

This gem allows storing content with base64 images to a model with CarrierWave
file uploads. The base64 images are extracted from the content and stored as
physical files using CarrierWave's configured storage. When reading the content
the files are converted back to base64 images.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'carrierwave-base64_image_content'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install carrierwave-base64_image_content

## Usage

The prerequisite for this gem is a model with an existing [multiple file
uploads
field](https://github.com/carrierwaveuploader/carrierwave#multiple-file-uploads).

1. Include the module `CarrierWave::Base64ImageContent::Store`
1. Call `base64_image_content_store` with the following two parameters:
  * The model's content attribute, which is the actual database field that
    stores the content
  * The images attribute, which uses CarrierWave to store the files


```ruby
class Note < ActiveRecord::Base
  include CarrierWave::Base64ImageContent::Store

  mount_uploaders :images, ImageUploader

  base64_image_content_store content: :text_content, images: :images
end
```

### Example

```ruby
# Create a note containing a base64 image in the content
Note.create!(
  content: 'content1 <img src="data:image/png;base64,/9j/4AAQSkZJRgABAQEASABKdhH//2Q=" />'
)

# The stored content has the base64 image replaced
note.text_content
# => content1 <img src="360593ff547c864bd9d16bbed6eb8860d9fad9a407aa74e066039db23b525338"  />

# The note has one image...
note.images.count
# => 1

# ... which corresponds to the original base64 image
note.images.first.filename
# => "360593ff547c864bd9d16bbed6eb8860d9fad9a407aa74e066039db23b525338.png"

# Getting the content contains the base64 image again
note.content
# => "content1 <img src=\"data:image/png;base64,/9j/4AAQSkZJRgABAQEASABKdhH//2Q=\" />"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/carrierwave-base64_image_content. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the Carrierwave::Base64ImageContent project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/carrierwave-base64_image_content/blob/master/CODE_OF_CONDUCT.md).
