require 'appscript'

class SkypeStatus
  class << self
    
    def get_status
      get_single_word_status(get_status_response)
    end
  
    def set_status(status)
      Appscript.app("Skype").send_(:script_name => "u", :command => "SET USERSTATUS #{status}")
    end
  
    def fullname(username)
      raw =  Appscript.app("Skype").send_(:script_name => "u", :command => "GET USER #{username} FULLNAME")
      fullname = raw.split("FULLNAME ").last.strip
      if fullname == ""
        then return username
      else
        return fullname
      end
    end
  
    def friend_status(username)
      raw =  Appscript.app("Skype").send_(:script_name => "u", :command => "GET USER #{username} ONLINESTATUS")
      raw.split("ONLINESTATUS ").last.strip.capitalize 
    end

    def get_friends
      split_friends(raw_friends)
    end
  
    def check_friends_status
      friends = get_friends
      friends.each do |username|
        status = friend_status(username)
        fullname = fullname(username)
        puts "#{fullname} (#{username}) is: #{status}" #unless status == "Offline"
      end    
    end

    private
      def get_status_response
        raw = Appscript.app("Skype").send_(:script_name => "u", :command => "GET USERSTATUS")
        raw
      end

      def get_single_word_status(response)
        response.split("\n").last.scan(/\w+$/).last.capitalize    
      end

      def raw_friends
        Appscript.app("Skype").send_(:script_name => "u", :command => "SEARCH FRIENDS")
      end
  
      def split_friends(raw)
        friends = raw.split("USERS ").last.strip.split(", ")
        friends = friends.select{|f| !f.match(/^\+/)}
      end
  
  end
end
