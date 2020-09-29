require "moongoon"

module Bara_pictures
  Moongoon.connect(
    database_url: DOTENV["MONGO"],
    database_name: DOTENV["DB"]
  )

  class Image < Moongoon::Collection
    collection DOTENV["COLL"]

    index keys: {url: 1}, options: {unique: true}

    property url : String
    property artist : String
    property uploader : String
    property type : Int32
  end

  DB         = Moongoon.database
  COLLECTION = DB[DOTENV["COLL"]]
end
