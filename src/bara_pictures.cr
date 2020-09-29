require "kemal"
require "json"
require "dotenv"
require "./functions/*"

module Bara_pictures
  DOTENV   = Dotenv.load ".env"
  CHIPS    = ["bara"]
  WRAPPERS = {
    "Crystal"    => ["bara-pictures/bara.pictures.cr"],
    "JavaScript" => ["bara-pictures/bara.pictures.js"],
    "Ruby"       => ["bara-pictures/bara.pictures.rb"],
  }
  Kemal.run
end
