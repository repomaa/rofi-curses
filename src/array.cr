class Array
  def select_with_index!
    index = -1
    select! do |item|
      index += 1
      yield(item, index)
    end
  end
end
