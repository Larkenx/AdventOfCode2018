require 'set'
directions = []
File.open("input.txt", "r") do |f|
  f.each_line do |line|
    directions.push(line.sub(/\n/, ""))
  end
end

class Graph
  def initialize
    @adjacency_list = {}
  end

  def get_start
    result = []
    @adjacency_list.each_key do |k|
      matches_one = false
      @adjacency_list.each_key do |j|
        matches_one = matches_one || (k != j && @adjacency_list[j].include?(k))
      end
      if not matches_one
        result.push(k)
      end
    end
    return result.sort
  end

  def add_edge(origin, target)
    if @adjacency_list.has_key?(origin)
      @adjacency_list[origin].push(target)
    else
      @adjacency_list[origin] = [target]
    end
  end

  def to_s
    result = ""
    for k in @adjacency_list.keys do
      values = @adjacency_list[k]
      result = "#{result}\n#{k} -> [#{values.join(",")}]"
    end
    return result
  end

  def vertices
    return @adjacency_list.keys
  end

  def neighbors(v)
    if @adjacency_list.has_key?(v)
      return @adjacency_list[v]
    else 
      return []
    end
  end

  def prerequisites(v)
    prereqs = []
    @adjacency_list.each_key do |k|
      if @adjacency_list[k].include?(v)
        prereqs.push(k)
      end
    end
    return prereqs
  end

  def can_begin(v, visited)
    return prerequisites(v).all? { |q| visited.include?(q)}
  end

  def perform_dfs(to_visit, visited)
    while (to_visit.length > 0) do
      v = to_visit.shift
      visited.add(v)
      possible = neighbors(v)
      if possible.length != 0
        possible = possible.select { |q| !visited.include?(q) and !to_visit.include?(q) and can_begin(q, visited) }
      end
      to_visit.push(*possible)
      to_visit = to_visit.sort
      #  Pretty printing
      # if to_visit.length != 0
      #   print "#{v} => "
      # else 
      #   print "#{v}"
      # end
      print "#{v}"

    end
  end

  def dfs
    to_visit = get_start()
    perform_dfs(to_visit, Set[])
  end

end

g = Graph.new

for d in directions do
  points = d.match(/\s(.)\s.*\s(.)\s/).captures
  g.add_edge(points[0], points[1])
end
puts g
g.dfs