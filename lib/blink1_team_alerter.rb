require "blink1_team_alerter/version"
require 'blink1'
require 'gocd_client'
require 'jira_client'

module Blink1TeamAlerter
  def self.check_for_alerts(jira, alert_filter, warn_filter, gocd)

    if jira.has_new_prio_0_issues? alert_filter
      blink1_police
    elsif jira.has_ongoing_prio_0_issues? warn_filter
      blink1_yellow
    elsif gocd.has_failing_projects?
      blink1_red
    else
      blink1_blue
    end
  end

  def blink1_off
    Blink1.open do |blink1|
      blink1.off
    end
  end

  def self.blink1_police
    puts "Blink1 Police"
    30.times do
      system( "blink1-tool -l 2 --red " )
      system( "blink1-tool -l 1 --blue" )
      system( "sleep 0.5" )
      system( "blink1-tool -l 1 --red" )
      system( "blink1-tool -l 2 --blue" )
      system( "sleep 0.5" )
    end
  end

  def self.blink1_red
    Blink1.open do |blink1|
      blink1.set_rgb(255, 0, 0)
      puts "Blink1 Red"
    end
  end

  def self.blink1_yellow
    Blink1.open do |blink1|
      blink1.set_rgb(255, 170, 0)
      puts "Blink1 Yellow"
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
