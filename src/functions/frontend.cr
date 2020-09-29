module Bara_pictures
  get "/" do |env|
    title = "bara.pictures"
    res = random_image(0)
    halt env, status_code: 404, response: "Not Found" unless res.has_key?(200)
    image = res[200]
    render "src/views/home.ecr", "src/views/layout.ecr"
  end

  get "/api" do |res|
    title = "Docs"
    render "src/views/docs.ecr", "src/views/layout.ecr"
  end

  get "/takedown" do |res|
    title = "Takedown"
    render "src/views/takedown.ecr", "src/views/layout.ecr"
  end
end
