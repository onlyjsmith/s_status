require 'applescript'

class StatusChecker
  def self.get_status_response
    AppleScript.execute(
      'tell application "Skype"
      send command "GET USERSTATUS" script name "My Script"
      end tell'
      )
  end

  def self.get_single_word_status(response)
    response.split("\n").last.scan(/\w+$/).last.capitalize    
  end

  def self.get_status
    puts "Current status is: " + get_single_word_status(get_status_response)
  end

end

StatusChecker.get_status