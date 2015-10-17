# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
  expect(result).to be_truthy
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

 Then /^(?:|I )should see "([^"]*)"$/ do |text|
    expect(page).to have_content(text)
 end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW5. 
# Note that you may need to add additional step definitions beyond these


# Add a declarative step here for populating the DB with movies.

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create(movie)
    # Each returned movie will be a hash representing one row of the movies_table
    # The keys will be the table headers and the values will be the row contents.
    # Entries can be directly to the database with ActiveRecord methods
    # Add the necessary Active Record call(s) to populate the database.
  end
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|

    all= Movie.all_ratings
      all.each do |x|
        uncheck("ratings_#{x}")
    end

    arr=arg1.split(',').map!(&:strip)
    arr.each do |x|
        check("ratings_#{x}")
    end

    click_on "ratings_submit"
    
  # HINT: use String#split to split up the rating_list, then
  # iterate over the ratings and check/uncheck the ratings
  # using the appropriate Capybara command(s)
end

Then /^I should see only movies rated: "(.*?)"$/ do |arg1|

all= Movie.all_ratings
#arr=arg1.split(',')
arr=arg1.split(',').map!(&:strip)

arr.each do |i|
all.delete(i)
end

puts all
puts arr


#rat = page.all('table#rodents td').map(&:text)


 result = false
 all("tbody tr").each do |tr|
     arr.each do |i|
        puts tr.text 
        if tr.has_content?(i)
          #puts i
          result = true
        end
     end
end   
#  all("tr").each do |tr|
#      all.each do |i|
#      if tr.has_content?(i)
#       result = false
#      end
#  end
#   end 
  expect(result).to be_truthy

end

Then /^I should see all of the movies$/ do
  #pending  #remove this statement after implementing the test step
resut=false

rows=page.all("#movies tr").size-1
if (rows==Movie.count)
result=true
end
expect(result).to be_truthy

end



When /^I have opted to sort: "(.*?)"$/ do |arg1|
   click_on arg1
end
   
Then /^I should see "(.*?)" before "(.*?)"$/ do |e,f|
result=false
#puts page.body
if (page.body =~ /#{e}.+#{f}/m)
    result=true
end
expect(result).to be_truthy
end
