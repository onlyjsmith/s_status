require 'appscript'
require 'net/http'
require 'uri'


class SkypeStatus
 
  def self.get_status_response
    raw = Appscript.app("Skype").send_(:script_name => "u", :command => "GET USERSTATUS")
    raw
  end

  def self.get_single_word_status(response)
    response.split("\n").last.scan(/\w+$/).last.capitalize    
  end

  def self.get_status
    get_single_word_status(get_status_response)
  end
  
  def self.set_status(status)
    Appscript.app("Skype").send_(:script_name => "u", :command => "SET USERSTATUS #{status}")
  end
  
  def self.fullname(username)
    raw =  Appscript.app("Skype").send_(:script_name => "u", :command => "GET USER #{username} FULLNAME")
    fullname = raw.split("FULLNAME ").last.strip
    if fullname == ""
      then return username
    else
      return fullname
    end
  end
  
  def self.friend_status(username)
    raw =  Appscript.app("Skype").send_(:script_name => "u", :command => "GET USER #{username} ONLINESTATUS")
    raw.split("ONLINESTATUS ").last.strip.capitalize 
  end

  def self.raw_friends
    Appscript.app("Skype").send_(:script_name => "u", :command => "SEARCH FRIENDS")
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
