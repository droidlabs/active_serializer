# ActiveSerializer

Active Serializer is a simple objects to hash serializer.

## Usage

Here's an example serializer:
```ruby
class ContactSerializer
  include ActiveSerializer::SerializableObject

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
```

Let's use it:
```ruby
ContactSerializer.serialize(contact, home_address, contact_emails)
```

And we get a result:
```ruby
{
  first_name: "John",
  last_name: "Smith",
  full_name: "John Smith",
  address: {
    country: "Russia",
    city: "Kazan",
    street: "Kosmonavton"
  },
  emails: [
    { email: "test@test.com", type: "home" },
    { email: "test2@test.com", type: "home" }
  ]
}
```

## Installation

Add this line to your application's Gemfile:

    gem 'active_serializer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_serializer

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

