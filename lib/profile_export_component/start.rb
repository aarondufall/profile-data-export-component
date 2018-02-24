module ProfileExportComponent
  module Start
    def self.call
      Consumers::Events.start('profile')
      
      DataCommand::Consumer.start('profileData')
    end
  end
end
