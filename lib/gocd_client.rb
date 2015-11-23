require 'pp'
require 'active_support/core_ext/hash'
require 'json'
require 'fileutils'

class GocdClient
  def initialize(gocd_addr, username, password, projects)
    @gocd_addr = gocd_addr
    @user_pass = "'#{username}:#{password}'"
    @pipeline_names = projects
    @failure_file = 'failing_pipelines.html'
  end

  def failing_projects?
    pp @pipeline_names
    failing = false

    log('<HTML><BODY>')
    @pipeline_names.each do |pipe_name|
      if @user_pass
        hash = JSON.parse(`curl -u #{@user_pass} #{@gocd_addr}/go/api/pipelines/#{pipe_name}/history 2>/dev/null`)
      else
        hash = JSON.parse(`curl #{@gocd_addr}/go/api/pipelines/#{pipe_name}/history 2>/dev/null`)
      end

      event = hash['pipelines'].first
      log("#{pipe_name} - #{event['label']}")

      event['stages'].each do |stage|
        log("Stage #{stage['name']} = #{stage['result']}")
        if stage['result'] == 'Failed'
          log('<b>Failed</b>')
          failing = true
        end
      end
    end
    log('</BODY></HTML>')
    failing
  end

  def log(row)
    file = File.open("#{@failure_file}", 'a')
    file.puts "#{row}<br>"
    file.close
  end
end
