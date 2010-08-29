class Array
  def humanize_join(first, last)
    array = self
    last = array.pop unless array.size < 2
    string = array.join(", ")
    string += " & #{last}" unless array.size < 2
    string
  end
end