require "rubygems"
require "haml"
require "sinatra"
require 'twilio-ruby'
require 'pry'
require "sinatra/reloader"

helpers do 
  def params_present?
    !(params[:phone].empty? && params[:message].empty?)
  end

  def message
    @message
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
  if params_present?
    @message = TwilioMessenger.send_message(params[:phone], params[:message]) 
    haml :status
  else
    haml :error
  end
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

@@status
%b status:
= message.status
%br/
%b from:
= message.from
%br/
%b to: 
= message.to
%br/
%b body: 
= message.body
%br
%b date_created:
= message.date_created
%br
%b date_updated:
= message.date_updated
%br
%b date_sent:
= message.date_sent
%br
%b account_sid:
= message.account_sid
%br
%b direction:
= message.direction
%br
%b api_version:
= message.api_version
%br
%b price:
= message.price
%br
%b price_unit:
= message.price_unit
%br
%b uri:
= message.uri


@@error
%h5 Message or phone number can't be blank 
%a{href: '/'} Try Again
  
