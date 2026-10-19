class AddDirectorAndPersonalRatingToMovies < ActiveRecord::Migration[8.1]
  def change
    add_column :movies, :director, :string
    add_column :movies, :stars, :integer
  end
end
