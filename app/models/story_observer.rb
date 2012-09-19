class StoryObserver < ActiveRecord::Observer
  def after_save(story)
    related_movies = []
    story.search_movie do |line, mark, movie|
      related_movies << movie
      unless story.movies.detect{|registed_movie| registed_movie == movie}
        story.movies << movie
      end
    end

    removed_movies = story.movies.reject do |movie|
      related_movies.map{|movie|movie.id}.include? movie.id
    end

    removed_movies.each do |movie|
      story.movies.delete movie
    end
  end

  def after_destroy(story)
    story.movies.each do |movie|
      movie.destroy
    end
  end
end
