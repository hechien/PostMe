require 'sinatra/base'

class API < Sinatra::Base
  
  get '/API/posts.json' do
    posts = Post.select([:id, :title, :body])
    
    content_type :json
    posts.to_json
  end
  
  get '/API/posts/:id.json' do
    post = Post.select([:id, :title, :body]).find(params[:id])
    
    status_code = 404
    returnJSON  = {
      :message => "Post not found."
    }
    
    if post.present?
      status_code = 200
      returnJSON = post
    end
    
    content_type :json
    status status_code
    returnJSON.to_json
  end
  
  post '/API/posts.json' do
    request.body.rewind
    json = JSON.parse(request.body.read)
    
    title = json["title"]
    body  = json["body"]
    
    post = Post.new({
      :title => title,
      :body => body
    })
    
    status_code = 422
    returnJSON  = {
      :message => "Unprocessing entity."
    }
    
    if post.save
      status_code = 201
      returnJSON = post
    end
    
    status status_code
    
    content_type :json
    returnJSON.to_json
  end
  
  put '/API/posts/:id.json' do
    
    request.body.rewind
    json = JSON.parse(request.body.read)
    title = json["title"]
    body  = json["body"]
    post = Post.select([:id]).find(params[:id])
    changed_parameters = {
      :title => title,
      :body => body
    }
    
    status_code = 422
    returnJSON = {
      :message => "Unprocessing entity."
    }
    
    if post.update_attributes(changed_parameters)
      status_code = 200
      returnJSON = post
    end
    
    content_type :json
    status status_code
    returnJSON.to_json
    
  end
  
  delete '/API/posts/:id.json' do
    
    post = Post.destroy(params[:id])
    
    content_type :json
    {:message => "OK"}.to_json
  end
  
end