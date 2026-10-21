# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

movies = [
  { title: "My Neighbor Totoro", rating: "G",     director: "Hayao Miyazaki", release_date: "16-Apr-1988" },
  { title: "Green Book",         rating: "PG-13", director: "Peter Farrelly", release_date: "16-Nov-2018" },
  { title: "Parasite",           rating: "R",     director: "Bong Joon Ho", release_date: "30-May-2019" },
  { title: "Nomadland",          rating: "R",     director: "Chloe Zhao", release_date: "19-Feb-2021" },
  { title: "CODA",               rating: "PG-13", director: "Sian Heder", release_date: "13-Aug-2021" },
  { title: "The Dark Knight",    rating: "PG-13", director: "Christopher Nolan", release_date: "18-Jul-2008" },
  { title: "Inside Out",         rating: "PG",    director: "Pete Docter", release_date: "19-Jun-2015" },
  { title: "Oppenheimer",        rating: "R",     director: "Christopher Nolan", release_date: "21-Jul-2023" },
  { title: "Everything Everywhere All at Once", rating: "R", director: "Daniel Kwan & Daniel Scheinert", release_date: "25-Mar-2022" }
]

movies.each do |attrs|
  Movie.find_or_initialize_by(title: attrs[:title]).update!(attrs)
end
