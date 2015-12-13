i = 0
json.array! @labels do |label|
  json.id i
  json.color label
  i = i+ 1
end