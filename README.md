# ActiveSerializer

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'active_serializer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_serializer

## Usage

Example serializer:

class ContactSerializer
  serialization_rules do |contact, home_address, contact_emails|
    attributes :first_name, :last_name, contact

    attribute :full_name do
      "#{contact.first_name} #{contact.last_name}"
    end

    resource :address, home_address do |address|
      attributes :country, :city, :street, address
    end

    resources :emails, contact_emails do |email|
      attributes :email
      attribute :type do
        'home'
      end
    end
  end
end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

