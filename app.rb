require "rubygems"
require "haml"
require "sinatra"
require 'twilio-ruby'
require 'pry'
require "sinatra/reloader"

helpers do 
  def params_correct?
    redirect '/' if params[:phone].empty? && params[:message].empty?
  end
end

class TwilioMessenger
  ACCOUNT_SID = ''
  AUTH_TOKEN = ''
  APP_PHONE_NUMBER = ''

  def self.client
    Twilio::REST::Client.new(ACCOUNT_SID, AUTH_TOKEN)
  end

  def self.send_message(receiver_phone, message)
    message = client.account.sms.messages.create(
      :from => APP_PHONE_NUMBER,
      :to => receiver_phone,
      :body => message[0...160]
    )

    message
  end
end


get "/" do
  haml :index
end

post "/send_message" do
  @message = TwilioMessenger.send_message(params[:phone], params[:message]) if params_correct?
end


__END__
@@index
.well
  %form.input{action: "/send_message", method: "post"}
    %label{for: "phone"}
      %b Phone Number:
    %input#phone.xlarge{name: "phone", size: "10", type: "text"}/
    %br/
    %br/
    %label{for: "message"}
      %b SMS Message:
    %input#message{name: "message", type: "text"}/
    %br/
    %br/
    %input{type: "submit", value: "Send Message"}/


  
