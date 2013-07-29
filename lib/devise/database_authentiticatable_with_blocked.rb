require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    # Default strategy for signing in a user, based on his email and password in the database.
    class DatabaseAuthenticatableWithBlocked < Authenticatable
      def authenticate!
        resource = valid_password? && mapping.to.find_for_database_authentication(authentication_hash)
        return fail(:not_found_in_database) unless resource
        return fail(:blocked) if resource.respond_to?(:blocked?) && resource.blocked?
        if validate(resource){ resource.valid_password?(password) }
          resource.after_database_authentication
          success!(resource)
        end
      end
    end
  end
end

Warden::Strategies.add(:database_authenticatable_with_blocked, Devise::Strategies::DatabaseAuthenticatableWithBlocked)