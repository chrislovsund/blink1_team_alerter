require 'blink1_team_alerter/version'
require 'blink1'
require 'gocd_client'
require 'jira_client'

module Blink1TeamAlerter
  def self.check_for_alerts(jira, alert_filter, warn_filter, gocd)
    message = jira.issues? alert_filter
    unless message.empty?
      blink1_police
      create_html_status_page('red', 'Found unassigned blocker JIRA issue')
      return
    end
    message = jira.issues? warn_filter
    unless message.empty?
      blink1_yellow
      create_html_status_page('yellow', 'Found assigned blocker JIRA issue')
      return
    end
    message = gocd.failing_projects?
    if message.empty?
      blink1_blue
      create_html_status_page('blue', 'Everything is dandy')
    else
      blink1_purple
      create_html_status_page('purple', message)
    end
  end

  def blink1_off
    Blink1.open(&:off)
  end

  def self.blink1_police
    puts 'Blink1 Police'
    30.times do
      system('blink1-tool -l 2 --red')
      system('blink1-tool -l 1 --blue')
      system('sleep 0.5')
      system('blink1-tool -l 1 --red')
      system('blink1-tool -l 2 --blue')
      system('sleep 0.5')
    end
  end

  def self.create_html_status_page(color, message)
    status_file = File.new('status.html', 'w+')
    status_file.puts "<HTML><BODY BGCOLOR='#{color}'>"
    status_file.puts "#{message}"
    status_file.puts '</BODY></HTML>'
    status_file.close
  end

  def self.blink1_red
    Blink1.open do |blink1|
      blink1.set_rgb(255, 0, 0)
      puts 'Blink1 Red'
    end
  end

  def self.blink1_yellow
    Blink1.open do |blink1|
      blink1.set_rgb(255, 210, 0)
      puts 'Blink1 Yellow'
    end
  end

  def self.blink1_orange
    Blink1.open do |blink1|
      blink1.set_rgb(255, 150, 0)
      puts 'Blink1 Orange'
    end
  end

  def self.blink1_purple
    Blink1.open do |blink1|
      blink1.set_rgb(128, 0, 128)
      puts 'Blink1 Purple'
    end
  end

  def self.blink1_green
    Blink1.open do |blink1|
      blink1.set_rgb(0, 255, 0)
    end
    puts 'Blink1 Green'
  end

  def self.blink1_blue
    Blink1.open do |blink1|
      blink1.set_rgb(0, 0, 255)
    end
    puts 'Blink1 Blue'
  end
end
