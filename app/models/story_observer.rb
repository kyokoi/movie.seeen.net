class StoryObserver < ActiveRecord::Observer
   def after_save(story)
     story.search_movie do |line, mark, movie|
      unless story.movies.detect{|registed_movie| registed_movie == movie}
        story.movies << movie
      end
    end
   end

  def after_destroy(story)
    story.movies.each do |movie|
      movie.destroy
    end
  end
 end

