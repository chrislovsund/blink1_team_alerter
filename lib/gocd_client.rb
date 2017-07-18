require 'pp'
require 'active_support/core_ext/hash'
require 'json'
require 'fileutils'

class GocdClient
  def initialize(gocd_addr, username, password, projects)
    @gocd_addr = gocd_addr
    @user_pass = "'#{username}:#{password}'"
    @pipeline_names = projects
  end

  def failing_projects?
    pp @pipeline_names
    status_html = ''

    @pipeline_names.each do |pipe_name|
      if @user_pass
        hash = JSON.parse(`curl -u #{@user_pass} #{@gocd_addr}/go/api/pipelines/#{pipe_name}/history 2>/dev/null`)
      else
        hash = JSON.parse(`curl #{@gocd_addr}/go/api/pipelines/#{pipe_name}/history 2>/dev/null`)
      end

      event = hash['pipelines'].first

      event['stages'].each do |stage|
        next unless stage['result'] == 'Failed'
        stage_url = "#{@gocd_addr}/go/pipelines/#{pipe_name}/#{event['counter']}/#{stage['name']}/#{stage['counter']}/"
        stage_display_name = "#{pipe_name} - #{event['label']} Stage #{stage['name']} = #{stage['result']}"
        status_html += "<a href=\"#{stage_url}\" target=\"_blank\" style=\"color:white\" >#{stage_display_name}</a><br>\n"
      end
    end
    status_html
  end
end
