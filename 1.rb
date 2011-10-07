require 'applescript'
require 'appscript'
require 'net/http'
require 'uri'


class LocalStatusChecker
  def self.skype_running?
    raw = AppleScript.execute(
      'tell application "System Events"
      	count (every process whose name is "Skype")
      end tell'           
      )
    case raw.strip
    when '1'
      puts "Skype running"
    when '0'
      puts "Skype not running"
    end
  end
  
  def self.get_status_response
    raw = Appscript.app("Skype").send_(:script_name => "u", :command => "GET USERSTATUS")
    raw
    # AppleScript.execute(
    #   'tell application "Skype"
    #   send command "GET USERSTATUS" script name "My Script"
    #   end tell'
    #   )
  end

  def self.get_single_word_status(response)
    response.split("\n").last.scan(/\w+$/).last.capitalize    
  end

  def self.get_status
    get_single_word_status(get_status_response)
  end
  
  def self.set_status(status)
    Appscript.app("Skype").send_(:script_name => "u", :command => "SET USERSTATUS #{status}")
    # AppleScript.execute(
      # "tell application \"Skype\"
      # send command \"SET USERSTATUS #{status}\" script name \"My Script\"
      # end tell"
    #   )    
  end
  
  def self.fullname(username)
    # puts "Looking for fullname for #{username}"
    raw =  Appscript.app("Skype").send_(:script_name => "u", :command => "GET USER #{username} FULLNAME")
    # raw = AppleScript.execute(
    #   "tell application \"Skype\"
    #   send command \"GET USER #{username} FULLNAME\" script name \"My Script\"
    #   end tell"
    #   )   
    fullname = raw.split("FULLNAME ").last.strip
    if fullname == ""
      then return username
    else
      return fullname
    end
  end
  
  def self.friend_status(username)
    raw =  Appscript.app("Skype").send_(:script_name => "u", :command => "GET USER #{username} ONLINESTATUS")
    # raw = AppleScript.execute(
    #   "tell application \"Skype\"
    #   send command \"GET USER #{username} ONLINESTATUS\" script name \"My Script\"
    #   end tell"
    #   )   
    raw.split("ONLINESTATUS ").last.strip.capitalize 
  end

end

class Friends
  def self.raw_friends
    Appscript.app("Skype").send_(:script_name => "u", :command => "SEARCH FRIENDS")
    # AppleScript.execute(
    #   'tell application "Skype"
    #     send command "SEARCH FRIENDS" script name "My Script"
    #   end tell'
    #   )    
  end
  
  def self.split_friends(raw)
    friends = raw.split("USERS ").last.strip.split(", ")
    friends = friends.select{|f| !f.match(/^\+/)}
  end
  
  def self.get_friends
    split_friends(raw_friends)
  end
  
  def self.local_check_friends
    friends = Friends.get_friends
    friends.each do |username|
      status = LocalStatusChecker.friend_status(username)
      fullname = LocalStatusChecker.fullname(username)
      puts "#{fullname} (#{username}) is: #{status}" #unless status == "Offline"
    end    
  end
end

# class RemoteStatusChecker
#   attr_reader :status, :username
# 
#   def initialize(username)
#     @username = username.to_s
#     update!
#   end
# 
#   def update!
#     @status = "Offline"
#     url = URI.parse("http://mystatus.skype.com/#{@username}.txt")
#     begin
#       @status = Net::HTTP.get(url)
#     rescue
#     end
#   end
# 
#   def online?
#     @status == "Online"
#   end
#   
#   def self.check_all_friends
#     friends = Friends.get_friends
#     friends.each do |username|
#       status = "Offline"#RemoteStatusChecker.new("#{username}").status
#       fullname = LocalStatusChecker.fullname(username)
#       puts "(#{username}) #{fullname} is: #{status}" #unless status == "Offline"
#     end 
#   end
# 
# end

class Decider
  def self.evaluate(username)
    case LocalStatusChecker.get_status
    when "Invisible" 
      puts "You want to let other people know you're online?"
    when "Online"
      puts "You're online"
    when "Offline"
      puts "You want to go online?"
    when "Away"
      puts "Come back soon"
    when "Dnd"
      puts "Really too busy?"
    else
      puts "Unknown status: #{LocalStatusChecker.get_status}"
    end
    
  end
end

class AppScriptTesting
  app("Skype").send_(:command => "GET USERSTATUS")
  
end

# Decider.evaluate("j2jonathan")
# puts "Setting as Away"; LocalStatusChecker.set_status("Away")
# puts LocalStatusChecker.get_status
# RemoteStatusChecker.check_all_friends
puts LocalStatusChecker.skype_running?
Friends.local_check_friends
