module Bara_pictures
  error 404 do
    error = "404 page not found."
    error_fun = "found"
    render "src/views/error.ecr"
  end

  error 403 do
    error = "403 Forbidden."
    error_fun = "allowed.includes(\"me\")."
    render "src/views/error.ecr"
  end
end
