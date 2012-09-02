#!/usr/bin/env ruby

require "json"
require "rest_client"

def haproxy
  "http://127.0.0.1:2345"
end

def ping
  RestClient.get "#{haproxy}/ping"
end

def boom
  RestClient.get "#{haproxy}/fail"
end

def create_contact
  contact_details = {:first_name => "Sean", :last_name => "Porter"}.to_json
  response = RestClient.post "#{haproxy}/contacts", contact_details, :content_type => :json, :accept => :json
  response.code == 201 ? JSON.parse(response.body) : nil
end

def get_contact(id)
  response = RestClient.get "#{haproxy}/contacts/#{id}"
  response.code == 200 ? JSON.parse(response.body) : nil
end

def update_contact(id)
  contact_details = {:first_name => "Sean", :middle_name => "Ellis", :last_name => "Porter"}.to_json
  response = RestClient.put "#{haproxy}/contacts/#{id}", contact_details, :content_type => :json, :accept => :json
  if response.code == 201
    JSON.parse(response.body)
  elsif response.code == 200
    {"id" => id}
  else
    nil
  end
end

def delete_contact(id)
  response = RestClient.delete "#{haproxy}/contacts/#{id}"
  response.code == 204
end

def schedule(&block)
  Thread.new do
    loop do
      begin
        block.call
      rescue => error
        puts error.to_s
        sleep 10
      end
    end
  end
end

5.times do
  schedule do
    sleep rand(10)
    ping
  end
end

2.times do
  schedule do
    sleep rand(25)
    boom
  end
end

30.times do
  schedule do
    sleep rand(5..20)
    contact = create_contact
    unless contact.nil?
      id = contact["id"]
      5.times do
        sleep rand(2)
        get_contact(id)
      end
      update_contact(id)
      sleep rand(2)
      get_contact(id)
      delete_contact(id)
    end
  end
end

loop do
  sleep 30
end
