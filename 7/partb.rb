require 'set'
directions = []
File.open("input.txt", "r") do |f|
  f.each_line do |line|
    directions.push(line.sub(/\n/, ""))
  end
end

class Graph
  @adjacency_list

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

  def get_time(v)
    alphabet = "abcdefghijklmnopqrstuvwxyz"
    return alphabet.index(v.downcase) + 61
  end

  def dfs
    number_of_workers = 5
    total_time = 0
    to_visit = get_start()
    working = {}
    for v in to_visit do
      if working.length < number_of_workers
        working[v] = get_time(v)
        puts "Starting working: #{v} at #{total_time} seconds!"
      end
    end
    to_visit.clear()
    visited = Set[]
    while (to_visit.length > 0 or working.length > 0)
      print "#{total_time} #{working.keys.join(' ')} #{visited.to_a.join('')}\n"
      total_time += 1
      possible = []
      working.each_key do |v|
        working[v] -= 1
        if working[v] <= 0
          working.delete(v)
          # puts "Done working #{v} at #{total_time} seconds!"
          visited.add(v)
          possible.push(*neighbors(v))
        end
      end
      if possible.length != 0
        possible = possible.select { |q| !visited.include?(q) and !to_visit.include?(q) and can_begin(q, visited) }
      end
      to_visit.push(*possible.uniq)
      to_visit = to_visit.sort
      if working.length < number_of_workers and to_visit.length > 0 
        while working.length < number_of_workers and to_visit.length > 0
          v = to_visit.shift
          working[v] = get_time(v) 
          # puts "Starting working: #{v} at #{total_time} seconds!"
        end
      end
    end
    print "#{total_time} #{working.keys.join(' ')} #{visited.to_a.join('')}\n"
    puts "Took #{total_time} seconds to complete all steps!"
  end

  # def dfs
  #   v = to_visit.shift
  #   working[v] = get_time(v)
  #   puts "Starting working: #{v} for #{get_time(v)} seconds!"
  #   perform_dfs(to_visit, working, )
  # end

end

g = Graph.new()

for d in directions do
  points = d.match(/\s(.)\s.*\s(.)\s/).captures
  g.add_edge(points[0], points[1])
end
# puts g.get_time("A")
g.dfs