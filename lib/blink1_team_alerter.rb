require 'blink1_team_alerter/version'
require 'blink1'
require 'gocd_client'
require 'jira_client'

module Blink1TeamAlerter
  def self.check_for_alerts(jira, alert_filter, warn_filter, gocd)
    if jira.has_new_prio_0_issues? alert_filter
      blink1_police
      create_html_status_page('red')
    elsif jira.has_ongoing_prio_0_issues? warn_filter
      blink1_yellow
      create_html_status_page('yellow')
    elsif gocd.has_failing_projects?
      blink1_purple
      create_html_status_page('purple')
    else
      blink1_blue
      create_html_status_page('blue')
    end
  end

  def blink1_off
    Blink1.open do |blink1|
      blink1.off
    end
  end

  def self.blink1_police
    puts 'Blink1 Police'
    30.times do
      system( "blink1-tool -l 2 --red " )
      system( "blink1-tool -l 1 --blue" )
      system( "sleep 0.5" )
      system( "blink1-tool -l 1 --red" )
      system( "blink1-tool -l 2 --blue" )
      system( "sleep 0.5" )
    end
  end

  def create_html_status_page(color)
    status_file = File.new('status.html', 'w+')
    status_file.puts "<HTML><BODY BGCOLOR='#{color}'></BODY></HTML>"
    status_file.close
  end

  def self.blink1_red
    Blink1.open do |blink1|
      blink1.set_rgb(255, 0, 0)
      puts "Blink1 Red"
    end
  end

  def self.blink1_yellow
    Blink1.open do |blink1|
      blink1.set_rgb(255, 210, 0)
      puts "Blink1 Yellow"
    end
  end

  def self.blink1_orange
    Blink1.open do |blink1|
      blink1.set_rgb(255, 150, 0)
      puts "Blink1 Orange"
    end
  end

  def self.blink1_purple
    Blink1.open do |blink1|
      blink1.set_rgb(128, 0, 128)
      puts "Blink1 Purple"
    end
  end

  def self.blink1_green
    Blink1.open do |blink1|
      blink1.set_rgb(0, 255, 0)
    end
    puts "Blink1 Green"
  end

  def self.blink1_blue
    Blink1.open do |blink1|
      blink1.set_rgb(0, 0, 255)
    end
    puts "Blink1 Blue"
  end
end
