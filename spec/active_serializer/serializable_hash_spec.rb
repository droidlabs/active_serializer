require 'spec_helper'

module SerializableHashTest
  describe ActiveSerializer::SerializableHash do
    class PhoneNumbersSerializer
      include ActiveSerializer::SerializableHash

      serialization_rules do |phone_numbers|
        attributes :number
      end
    end

    class ContactSerializer
      include ActiveSerializer::SerializableHash

      serialization_rules do |contact, home_address, contact_emails, phone_numbers|
        attributes :first_name, :last_name, contact

        attribute :full_name do
          "#{contact[:first_name]} #{contact[:last_name]}"
        end

        serialize_collection :phone_numbers, phone_numbers, PhoneNumbersSerializer
        serialize_entity :phone_number, phone_numbers.first, PhoneNumbersSerializer

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
        contact = {
          first_name: 'John',
          last_name: 'Smith',
        }

        contact_emails = [
          { email: 'test@test.com'},
          { email: 'test2@test.com'},
        ]

        home_address = {
          country: 'Russia',
          city:    'Kazan',
          street:  'Kosmonavton',
        }

        phone_numbers = [
          {
            number: '123456'
          }
        ]

        serialized_contact = ContactSerializer.serialize(contact, home_address, contact_emails, phone_numbers)
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
          ],
          phone_numbers: [
            {
              number: '123456'
            }
          ],
          phone_number: {
            number: '123456'
          }
        }
      end
    end

    class ContactIgnoreBlankSerializer
      include ActiveSerializer::SerializableHash

      serialization_rules ignore_blank: true do |contact|
        attributes :first_name, :last_name

        attribute :full_name
        attribute(:address) if contact[:full_name]
      end
    end

    describe "#serialize" do
      it "should not return blank values" do
        contact = {
          first_name: nil,
          last_name: nil,
          full_name: nil,
        }

        serialized_contact = ContactIgnoreBlankSerializer.serialize(contact)
        serialized_contact.should == {}
      end
    end
  end
end

