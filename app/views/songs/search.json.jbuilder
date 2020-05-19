json.array! @songs do |song|
  json.id song.id
  json.title song.title
  json.jam song.jam
  json.standard song.standard
  json.beginner song.beginner
  json.chord_text song.chords, :text
end

