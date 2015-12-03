require 'rest-client'
require 'json'

class JiraClient
  def initialize(username, password, host, project_key)
    # Instance variables
    @username = username
    @password = password
    @host = host
    @project_key = project_key
    @jira_url = "https://#{username}:#{password}@#{host}/rest/api/2/search?"
    @result_filter = "maxResults=5&fields=summary,status,resolution&jql=project+%3D+%22#{project_key}%22+"
  end

  def issues?(search_filter)
    # latest 5 issues from a project with '0' priority

    puts "#{@result_filter}+#{search_filter}"
    response = RestClient.get(@jira_url + @result_filter + search_filter)
    fail 'Error with the http request!' if (response.code != 200)

    status_html = ''

    data = JSON.parse(response.body)
    if data['issues'].any?
      puts 'Issue(s) found'
      data['issues'].each do |issue|
        puts "Key: #{issue['key']}, Summary: #{issue['fields']['summary']}"
        link_url = "https://#{@host}/browse/#{issue['key']}"
        link_text += "#{issue['key']}: #{issue['fields']['summary']}"
        status_html += "<a href=\"#{link_url}\" target=\"_blank\">#{link_text}</a>\n"
      end
      return status_html
    end
    status_html
  end
end
