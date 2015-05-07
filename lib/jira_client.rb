require 'rest-client'
require 'json'

module JiraClient
  def self.has_prio_0_issues? (username, password, host, project_key, search_filter)
    jira_url = "https://#{username}:#{password}@#{host}/rest/api/2/search?"
    # latest 5 issues from a project with '0' priority

    result_filter = "maxResults=5&fields=summary,status,resolution&jql=project+%3D+%22#{project_key}%22+"
    puts result_filter+search_filter
    response = RestClient.get(jira_url+result_filter+search_filter)
    if(response.code != 200)
      raise "Error with the http request!"
    end

    data = JSON.parse(response.body)
    if data['issues'].any?
      puts "Prio '0' issue(s) found that is New"
      data['issues'].each do |issue|
        puts "Key: #{issue['key']}, Summary: #{issue['fields']['summary']}"
      end
      return true
    end
    return false
  end
end
