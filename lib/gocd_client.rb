require 'pp'
require 'active_support/core_ext/hash'
require 'json'

class GocdClient

  def initialize(gocd_addr, username, password, projects)
    @gocd_addr = gocd_addr
    @user_pass = "'#{username}:#{password}'"
    @pipeline_names = projects
  end
  
  
  def has_failing_projects?
    pp @pipeline_names
    
    @pipeline_names.each do |pipe_name|
      
      if @user_pass
        hash = JSON.parse(`curl -u #{@user_pass} #{@gocd_addr}/go/api/pipelines/#{pipe_name}/history 2>/dev/null`)
      else
        hash = JSON.parse(`curl #{@gocd_addr}/go/api/pipelines/#{pipe_name}/history 2>/dev/null`)
      end

      event = hash["pipelines"].first
      puts "#{pipe_name} - #{event["label"]}"

      event["stages"].each do |stage|
        puts "Stage #{stage["name"]} = #{stage["result"]}"        
        if stage["result"] == "Failed"
          puts "FAIL"
          return true
        else
          puts "OK"
        end
      end
    end
    return false
  end
end
