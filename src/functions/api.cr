module Bara_pictures
  def self.random_image(type : Int32, id : String | Nil = nil) : Hash(Int32, Hash(String, String | Int32))
    response = Hash(String, String | Int32).new
    if id.nil?
      random_image = COLLECTION.aggregate([{"$sample": {size: 1}}])
      if random_image.nil?
        response["error"] = "DB is empty"
        return {404 => response}
      end
      random_hash = random_image.to_a[0].to_h
    else
      random_image = Bara_pictures::Image.find_by_id(id)
      if random_image.nil?
        response["error"] = "Provided ID doesn't match any image"
        return {404 => response}
      end
      random_hash = random_image.to_bson.to_h
    end
    response["id"] = random_hash["_id"].to_s
    response["url"] = random_hash["url"].to_s
    response["artist"] = random_hash["artist"].to_s
    response["total"] = COLLECTION.estimated_document_count
    return {200 => response}
  end

  def self.index_type(type : String) : Int32?
    CHIPS.index { |i| type.downcase == i }
  end

  def self.twitter(url : String) : String
    url.split("?")[0] + ".png"
  end

  before_all "/api/:type" do |env|
    env.response.content_type = "application/json"
  end

  before_get "/api/:type/:id" do |env|
    env.response.content_type = "application/json"
  end

  get "/api/:type" do |env|
    int_type = index_type(env.params.url["type"])
    next {400 => {"error" => "Invalid type"}}.to_json if int_type.nil?
    random_image(int_type).to_json
  end

  get "/api/:type/:id" do |env|
    int_type = index_type(env.params.url["type"])
    next {400 => {"error" => "Invalid type"}}.to_json if int_type.nil?
    random_image(int_type, env.params.url["id"]).to_json
  end

  post "/api/:type" do |env|
    int_type = index_type(env.params.url["type"])
    next {400 => {"error" => "Invalid type"}}.to_json if int_type.nil?
    next {400 => {"error" => "Missing fields"}}.to_json unless env.params.json.has_key?("url") && env.params.json.has_key?("artist") && env.params.json.has_key?("secret") && env.params.json.has_key?("uploader")
    secret = env.params.json["secret"].as(String)
    next {401 => {"error" => "Not allowed"}}.to_json if secret != Bara_pictures::DOTENV["SECRET"]
    url = env.params.json["url"].as(String)
    artist = env.params.json["artist"].as(String)
    uploader = env.params.json["uploader"].as(String)
    image = url.starts_with?("https://pbs.twimg.com") ? twitter(url) : url
    Image.new(
      url: image,
      artist: artist,
      uploader: uploader,
      type: int_type
    ).insert
    {200 => {"OK" => "Inserted succefully"}}.to_json
  end
end
