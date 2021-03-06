require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    index_page = Nokogiri::HTML(open(index_url))
    scraped_students = []
    index_page.css("div.roster-cards-container").each do |card|
      card.css(".student-card a").each do |student|
        student_profile_link = "#{student.attr('href')}"
        student_location = student.css('.student-location').text
        student_name = student.css('.student-name').text
        scraped_students << {name: student_name, location: student_location, profile_url: student_profile_link}
      end
      # binding.pry
    end
    scraped_students
  end

  def self.scrape_profile_page(profile_url)
    student_info = {}
    profile = Nokogiri::HTML(open(profile_url))
    links = profile.css(".social-icon-container").children.css("a").map {|x| x.attribute('href').value}
    links.each do |link|
      if link.include?("linkedin")
        student_info[:linkedin] = link
      elsif link.include?("github")
        student_info[:github] = link
      elsif link.include?("twitter")
        student_info[:twitter] = link
      else
        student_info[:blog] = link
      end
    end
    student_info[:profile_quote] = profile.css(".profile-quote").text if profile.css(".profile-quote")
    student_info[:bio] = profile.css("div.bio-content.content-holder div.description-holder p").text if profile.css("div.bio-content.content-holder div.description-holder p")

    student_info
  end

end

