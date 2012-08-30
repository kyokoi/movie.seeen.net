# encoding: utf-8

module SeensHelper
  def author_name_for_unlogin_user(star, wish, recently)
    if star && star.count > 0
      return "「#{star.first.movie.name_of_japan}」がお気に入りさん"
    end
    if wish && wish.count > 0
      return "「#{wish.first.movie.name_of_japan}」が見たい人さん"
    end
    if recently && recently.count > 0
      return "「#{recently.first.movie.name_of_japan}」を見た人さん"
    end
    "もっと映画をみましょうさん"
  end
end
