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

  def new_prio_0_issues?(search_filter)
    # latest 5 issues from a project with '0' priority

    puts "#{@result_filter}+#{search_filter}"
    response = RestClient.get(@jira_url + @result_filter + search_filter)
    fail 'Error with the http request!' if (response.code != 200)

    data = JSON.parse(response.body)
    if data['issues'].any?
      puts "Prio '0' issue(s) found that is New"
      data['issues'].each do |issue|
        puts "Key: #{issue['key']}, Summary: #{issue['fields']['summary']}"
      end
      return true
    end
    false
  end

  def ongoing_prio_0_issues?(search_filter)
    # latest 5 issues from a project with '0' priority

    puts "#{@result_filter}+#{search_filter}"
    response = RestClient.get(@jira_url + @result_filter + search_filter)
    fail 'Error with the http request!' if (response.code != 200)

    data = JSON.parse(response.body)
    if data['issues'].any?
      puts "Prio '0' issue(s) found that is New"
      data['issues'].each do |issue|
        puts "Key: #{issue['key']}, Summary: #{issue['fields']['summary']}"
      end
      return true
    end
    false
  end
end
