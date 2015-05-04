require "blink1_team_alerter/version"
require 'rest-client'
require 'json'
require 'blink1'
#require 'blink1-patterns' 

module Blink1TeamAlerter

#  check_jira
  
  def self.check_jira(username, password, host, project_key)
    jira_url = "https://#{username}:#{password}@#{host}/rest/api/2/search?"
    # latest 5 issues from a project with '0' priority
    filter = "maxResults=5&fields=summary,status,resolution&jql=project+%3D+%22#{project_key}%22+AND+priority+%3D+%220%22+AND+status+in+(Open%2C+New)"

    puts jira_url+filter
    response = RestClient.get(jira_url+filter)
    if(response.code != 200)
      raise "Error with the http request!"
    end

    data = JSON.parse(response.body)
     if data['issues'].any?
       data['issues'].each do |issue|
         puts "Key: #{issue['key']}, Summary: #{issue['fields']['summary']}"
       end 
         #      Blink::Patterns.police
       Blink1.open do |blink1|
#      blink1.write_pattern_line(100, 255, 255, 255, 0)
#      blink1.write_pattern_line(100, 0,   255, 255, 1)
#      blink1.write_pattern_line(100, 255, 255, 0,   2)
#      blink1.write_pattern_line(100, 255, 0,   255, 3)
#      blink1.write_pattern_line(100, 255, 255, 255, 4)
#      blink1.write_pattern_line(100, 0,   255, 255, 5)
#      blink1.write_pattern_line(100, 255, 255, 0,   6)
#      blink1.write_pattern_line(100, 255, 0,   255, 7)
#      blink1.write_pattern_line(100, 255, 255, 255, 8)
#      blink1.write_pattern_line(100, 0,   255, 255, 9)
#      blink1.write_pattern_line(100, 255, 255, 0,   10)
#      blink1.play(0)
       blink1.set_rgb(255, 0, 0)
     end
    else
#      Blink::Patterns.off      
      Blink1.open do |blink1|
        blink1.set_rgb(0, 255, 0)
     end
     end
   end

  def blink1_off 
    Blink1.open do |blink1|
      blink1.off
    end
  end  
end

