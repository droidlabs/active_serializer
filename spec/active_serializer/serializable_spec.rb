require 'spec_helper'
require 'active_serializer'

describe ActiveSerializer::Serializable do
  class Contact
    attr_accessor :first_name, :last_name
  end

  class Address
    attr_accessor :country, :city, :street
  end

  class Email
    attr_accessor :email
  end

  class ContactSerializer
    include ActiveSerializer::Serializable

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

  describe "#serialize" do
    it "should serialize object" do
      contact = Contact.new
      contact.first_name = 'John'
      contact.last_name  = 'Smith'

      home_email1 = Email.new
      home_email1.email = 'test@test.com'
      home_email2 = Email.new
      home_email2.email = 'test2@test.com'
      contact_emails = [home_email1, home_email2]

      home_address = Address.new
      home_address.country = 'Russia'
      home_address.city    = 'Kazan'
      home_address.street  = 'Kosmonavton'

      serialized_contact = ContactSerializer.serialize(contact, home_address, contact_emails)
      serialized_contact.should == {
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
    end

    class ContactsSerializer
      include ActiveSerializer::Serializable

      serialization_rules no_root_node: true do |contacts, home_address|
        resources :contacts, contacts do |contact|
          attributes :first_name, :last_name, contact
          resource :address, home_address do |address|
            attributes :country, :city, :street, address
          end
        end
      end
    end

    it "should return Array when no_root_node: true specified" do
      contact1 = Contact.new
      contact1.first_name = 'John'
      contact1.last_name  = 'Smith'
      contact2 = Contact.new
      contact2.first_name = 'John'
      contact2.last_name  = 'Smith'
      home_address = Address.new
      home_address.country = 'Russia'
      home_address.city    = 'Kazan'
      home_address.street  = 'Kosmonavton'

      serialized_contacts = ContactsSerializer.serialize([contact1, contact2], home_address)
      serialized_contacts.should be_an_instance_of(Array)
    end
  end
end

