module SearchHelper
  def next_page(search_count, offset, each_limit_when_search)
    offset_count = offset * each_limit_when_search
    if (search_count - (offset_count + each_limit_when_search)) > each_limit_when_search && (search_count - (offset_count + each_limit_when_search)) >= 0
      word = each_limit_when_search
    elsif (search_count - (offset_count + each_limit_when_search)) > 0
      word = search_count - (offset_count + each_limit_when_search)
    else
      word = nil
    end
    word
  end

  def build_search_condition(search)
    return '' if search.blank?
    query_string = '?'
    query_string << search.collect do |key, value|
      "search[#{url_encode key}]=#{url_encode value}"
    end.join('&')
  end

  def url_path(action, offset, search)
    if action == 'movies' || action == 'movies_list'
      path = "/search/list/movies/#{offset}/"
    else
      path = "/search/list/#{offset}/"
    end

    path += build_search_condition search
  end
end
