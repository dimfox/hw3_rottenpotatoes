# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(:title=> movie["title"],
		:release_date=>movie["release_date"],
		:rating=>movie["rating"])
  end
  #assert false, "Unimplmemented"

end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  rex = /^.*(#{e1}).*(#{e2}).*$/
  if page.body.gsub(/\n/,"") =~ rex
    assert true, "#{e1} is before #{e2}"
  else
    assert false, "#{e1} is not before #{e2}"
  end

end

Then /I should see the following movies in order: (.*)/ do |movie_list|
  # ensure that the movies in the list occure one after the other

  movies = movie_list.split(/\s*,\s*/)
  for i in 1..movies.length-1
    puts %Q{I should see #{movies[i-1]} before #{movies[i]}}
  end
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  ratings = rating_list.split(",").map{|c| c.strip}
  ratings.each do |r|
    if uncheck == 'un'
      step %Q{I uncheck "ratings_#{r}"}
    else
      step %Q{I check "ratings_#{r}"}
    end
  end
end

# I should see the following movies:"a", "b", "c"
Then /I should (not )?see the following movies: (.*)/ do |my_not,movie_list|
  #remove leading and trailing double quote
  movie_list = movie_list.gsub(/^"/,"").gsub(/"$/,"")

  movie_list.split(/"\s*,\s*"/).each do |movie|
    
    if my_not
      step %Q{I should not see "#{movie}"}
    else
      step %Q{I should see "#{movie}"}
    end

  end
end

# I should see no/all movies
Then /I should see (none|all) of the movies/ do |m_no_all|

  Movie.all.each do |movie|
    if m_no_all == 'none'
      step %Q{I should not see "#{movie.title}"}
    else
      step %Q{I should see "#{movie.title}"}
    end
  end
end
