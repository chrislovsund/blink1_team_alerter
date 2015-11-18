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

    FileUtils.touch(@failure_file)
    @pipeline_names.each do |pipe_name|
      if @user_pass
        hash = JSON.parse(`curl -u #{@user_pass} #{@gocd_addr}/go/api/pipelines/#{pipe_name}/history 2>/dev/null`)
      else
        hash = JSON.parse(`curl #{@gocd_addr}/go/api/pipelines/#{pipe_name}/history 2>/dev/null`)
      end

      event = hash['pipelines'].first
      puts "#{pipe_name} - #{event['label']}"

      event['stages'].each do |stage|
        puts "Stage #{stage['name']} = #{stage['result']}"
        if stage['result'] == 'Failed'
          puts 'FAIL'
          file = File.open("#{@failure_file}", 'a')
          file.write(JSON.pretty_generate(event))
          file.close
          failing = true
        else
          puts 'OK'
        end
      end
    end
    failing
  end
end
