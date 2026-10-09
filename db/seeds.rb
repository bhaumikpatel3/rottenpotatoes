# Keep the five assignment movies and add three more. Using a stable identity
# means running db:seed again does not duplicate records or overwrite edits
# to ratings and descriptions.
movies = [
  { title: "My Neighbor Totoro", rating: "G", release_date: "1988-04-16", description: "Two sisters discover forest spirits near their new country home." },
  { title: "Green Book", rating: "PG-13", release_date: "2018-11-16", description: "A pianist and his driver form an unlikely friendship on a concert tour." },
  { title: "Parasite", rating: "R", release_date: "2019-05-30", description: "A family's new jobs draw them into the lives of a wealthy household." },
  { title: "Nomadland", rating: "R", release_date: "2021-02-19", description: "A woman builds a life on the road in the American West." },
  { title: "CODA", rating: "PG-13", release_date: "2021-08-13", description: "A young singer balances her ambitions with her family's fishing business." },
  { title: "Spirited Away", rating: "PG", release_date: "2001-07-20", description: "A girl enters a mysterious spirit world and searches for a way home." },
  { title: "The Incredibles", rating: "PG", release_date: "2004-11-05", description: "A family of superheroes returns to action to face a new threat." },
  { title: "The Grand Budapest Hotel", rating: "R", release_date: "2014-03-28", description: "A hotel concierge and a lobby boy become entangled in a stolen painting mystery." }
]

movies.each do |attributes|
  Movie.find_or_create_by!(title: attributes[:title], release_date: attributes[:release_date]) do |movie|
    movie.rating = attributes[:rating]
    movie.description = attributes[:description]
  end
end
