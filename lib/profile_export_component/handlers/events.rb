module ProfileExportComponent
  module Handlers
    class Events
      include Messaging::Handle
      include Messaging::StreamName
      include Log::Dependency
      include Evt::Profile::Client::Messages::Events


      dependency :write, Messaging::Postgres::Write
      dependency :get_last, MessageStore::Postgres::Get::Last

      def configure
        Messaging::Postgres::Write.configure(self)
        MessageStore::Postgres::Get::Last.configure(self)
      end
      
      category :profile_data

      handle Initiated do |initiated|
        profile_id = initiated.profile_id

        stream_name = stream_name(profile_id)

        if current?(initiated)
          logger.info(tag: :ignored) { "Event ignored (Event: #{initiated.message_type}, Profile ID: #{profile_id})" }
          return
        end

        create_command = ViewData::Commands::Create.follow(initiated, strict: false)

        create_command.identifier = profile_id

        create_command.name = 'profiles'

        create_command.data = {
          name: initiated.name,
          email: initiated.email,
          avatar_url: initiated.avatar_url,
          created_at: initiated.time
        }
        write.(create_command, stream_name)
      end

      def current?(event)
        profile_id = event.profile_id

        data_command_stream = stream_name(profile_id)

        last_command = get_last.(data_command_stream)

        return false if last_command.nil?

        last_command_position = last_command.metadata[:causation_message_position]

        last_command_position >= event.metadata.position
      end
    end
  end
end
