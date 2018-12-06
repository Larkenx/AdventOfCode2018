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
startx = math.huge
starty = math.huge
width = -math.huge
height = -math.huge
for line in io.lines(path) do
    local point = map(tonumber, split(line, ", "))
    local id = uid(#coords+1)
    local coord = {x=point[1], y=point[2], id=id}
    if startx == nil or coord.x < startx then
        startx = coord.x
    end

    if starty == nill or coord.y <  starty then
        starty = coord.y
    end

    if width == nil or coord.x > width then 
        width = coord.x
    end

    if height == nil or coord.y > height then 
        height = coord.y
    end
    -- print(id)
    coords[#coords + 1] = coord
end 

histogram = {}
visualization = {}
infiniteRegions = {}
for y = starty, height, 1
do 
    visualization[y] = {}
    for x = startx, width, 1
    do
        local closest= nil
        local minDist = math.huge
        local tied = false
        for index, coord in pairs(coords) do
            local dist = manhattan(x, coord.x, y, coord.y)
            if dist == minDist then
            visualization[y][x] = "."
                break
            elseif dist < minDist then
                minDist = dist
                closest = coord
            end
        end
        visualization[y][x] = closest.id
        -- whenever there is a point that is on a border, the closest point is immediately infinite!
        if x == width or y == height or x == startx or y == starty then
            infiniteRegions[closest.id] = true
        end

        if histogram[closest.id] == nil then
            histogram[closest.id] = 1
        else 
            histogram[closest.id] = histogram[closest.id] + 1
        end
    end
end

string = ""
for y = starty, height, 1
do 
    for x = startx, width, 1
    do
        string = string .. visualization[y][x]
    end
    string = string .. "\n"
end

local visfile = open("visualization.txt", "w")
output(visfile)
io.write(string)
biggestSpace = 0
for index, coord in pairs(coords) do
    if histogram[coord.id] ~= nil then
        local dist = histogram[coord.id]
        if infiniteRegions[coord.id] ~= nil then 
            print(coord.id .. " @ " .. "("..coord.x..","..coord.y..")".. " is infinite!")
        else
            print(coord.id .. " @ " .. "("..coord.x..","..coord.y..")".. " : " .. histogram[coord.id])
        end
        if dist > biggestSpace then 
            biggestSpace = dist 
        end 
    end
end

print("Largest area : "..biggestSpace)
