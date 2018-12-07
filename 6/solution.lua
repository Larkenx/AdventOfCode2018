local open = io.open
local output = io.output
local lines = io.lines
local path = "input.txt"
-- https://stackoverflow.com/questions/1426954/split-string-in-lua
function split(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={} ; i=1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end
-- https://en.wikibooks.org/wiki/Lua_Functional_Programming/Functions
function map(func, array)
  local new_array = {}
  for i,v in ipairs(array) do
    new_array[i] = func(v)
  end
  return new_array
end
-- https://stackoverflow.com/questions/9168058/how-to-dump-a-table-to-console
function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

function manhattan(x1, x2, y1, y2) 
    return math.abs(x1-x2) + math.abs(y1 - y2)
end

function uid(n)
    local alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local remainder = (n % 62)
    -- print(string.sub(alphabet, remainder, remainder))
    return string.sub(alphabet, remainder, remainder)
end

coords = {}
startx = 0
starty = 0
width = 0
height = 0
for line in io.lines(path) do
    local point = map(tonumber, split(line, ", "))
    local id = uid(#coords+1)
    local coord = {x=point[1], y=point[2], id=id}
    if  coord.x > width then 
        width = coord.x
    end

    if  coord.y > height then 
        height = coord.y
    end
    coords[#coords + 1] = coord
end 

histogram = {}
visualization = {}
idealVisualization = {}
infiniteRegions = {}
idealRegion = {}
for y = starty, height, 1
do 
    visualization[y] = {}
    idealVisualization[y] = {}

    for x = startx, width, 1
    do
        local closest= nil
        local minDist = math.huge
        local tied = false
        local sum = 0
        for index, coord in pairs(coords) do
            local dist = manhattan(x, coord.x, y, coord.y)
            sum = sum + dist
            if dist == minDist then
                tied = true
            end

            if dist < minDist then
                minDist = dist
                closest = coord
                tied = false
            end
        end

        if sum < 10000 then
            idealRegion[#idealRegion + 1] = {x=x, y=y}
            idealVisualization[y][x] = "/"
        else 
            idealVisualization[y][x] = closest.id
        end


        if x == width or y == height or x == startx or y == starty then
            infiniteRegions[closest.id] = true
        end

        if tied then
            visualization[y][x] = "."
        else
            visualization[y][x] = closest.id
            if histogram[closest.id] == nil then
                histogram[closest.id] = 1
            else 
                histogram[closest.id] = histogram[closest.id] + 1
            end
        end

    end
end

function visualize() 
    string = ""
    idealString = ""
    for y = starty, height, 1
    do 
        for x = startx, width, 1
        do
            string = string .. visualization[y][x]
            idealString = idealString .. idealVisualization[y][x]

        end
        string = string .. "\n"
    end

    local visfile = open("visualization.txt", "w")
    output(visfile)
    io.write(string)

    local visfile = open("idealVisualization.txt", "w")
    output(visfile)
    io.write(idealString)
end

biggestSpace = 0
print("Starting at " .. "(" .. startx .. ", " .. starty ..") " .. "and going to " .. "(" .. width .. ", " .. height ..") ")
for index, coord in pairs(coords) do
    if histogram[coord.id] ~= nil then
        local dist = histogram[coord.id]
        if infiniteRegions[coord.id] == true then 
            print(coord.id .. " @ " .. "("..coord.x..","..coord.y..")".. " is infinite!")
        else
            if dist > biggestSpace then 
                biggestSpace = dist 
            end 
            print(coord.id .. " @ " .. "("..coord.x..","..coord.y..")".. " : " .. histogram[coord.id])
        end
        
    end
end
print("Largest area : "..biggestSpace)
print("Size of ideal region : " .. #idealRegion)

