require 'spec_helper'

module SerializableObjectTest
  describe ActiveSerializer::SerializableObject do
    class Contact
      attr_accessor :first_name, :last_name
    end

    class Address
      attr_accessor :country, :city, :street
    end

    class Email
      attr_accessor :email
    end

    class PhoneNumber
      attr_accessor :number
    end

    class PhoneNumbersSerializer
      include ActiveSerializer::SerializableObject

      serialization_rules do |phone_numbers|
        attributes :number
      end
    end

    class ContactSerializer
      include ActiveSerializer::SerializableObject

      serialization_rules do |contact, home_address, contact_emails, phone_numbers|
        attributes :first_name, :last_name, contact

        attribute :full_name do
          "#{contact.first_name} #{contact.last_name}"
        end

        resource :address, home_address do |address|
          attributes :country, :city, :street, address
        end

        serialize_collection :phone_numbers, phone_numbers, PhoneNumbersSerializer
        serialize_entity     :phone_number, phone_numbers.first, PhoneNumbersSerializer

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

        phone_number = PhoneNumber.new
        phone_number.number = '123456'

        serialized_contact = ContactSerializer.serialize(contact, home_address, contact_emails, [phone_number])
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
          phone_number: {
            number: '123456'
          },
          phone_numbers: [
            {
              number: '123456'
            }
          ]
        }
      end

      class ContactsSerializer
        include ActiveSerializer::SerializableObject

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


      class Company
        attr_accessor :name, :emails, :address
      end
      class CompanySerializer
        include ActiveSerializer::SerializableObject

        serialization_rules do |company|
          attributes :name
          resource :address do |address|
            attributes :country, :city, :street
          end
          resources :emails do |email|
            attribute :email do
              email.email
            end
          end
        end
      end

      it "should serialize only fields spefied in serializable_fields option" do
        company = Company.new
        company.name = "MyCo"

        email1 = Email.new
        email1.email = 'test@test.com'
        email2 = Email.new
        email2.email = 'test2@test.com'
        company.emails = [email1, email2]

        address = Address.new
        address.country = 'Russia'
        address.city    = 'Kazan'
        address.street  = 'Kosmonavton'
        company.address = address

        serialized_company = CompanySerializer.serialize(company, serializable_fields: { name: true, emails: { email: true}, address: { country: true }})
        serialized_company.should =={
          name: "MyCo",
          address: {country: "Russia"},
          emails: [
            { email: "test@test.com"  },
            { email: "test2@test.com" }
          ]
        }
        serialized_company = CompanySerializer.serialize(company, serializable_fields: { emails: true})
        serialized_company.should == {
          emails: [
            { email: "test@test.com"  },
            { email: "test2@test.com" }
          ]
        }
      end
    end
  end

end
