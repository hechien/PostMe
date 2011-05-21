require 'sinatra/base'

class API < Sinatra::Base
  
  get '/API/posts.json' do
    posts = Post.select([:id, :title, :body])
    
    content_type :json
    posts.to_json
  end
  
  get '/API/posts/:id.json' do
    post = Post.select([:id, :title, :body]).find(params[:id], :include => [:comments])
    comments = post.comments
    
    status_code = 404
    returnJSON  = {
      :message => "Post not found."
    }
    
    if post.present?
      status_code = 200
      returnJSON = {
        :post => post,
        :comments => comments
      }
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
  
  get '/API/comments' do
    
    comments = Comment.select([:id, :author, :body, :post_id])
    content_type :json
    comments.to_json
    
  end
  
  get '/API/posts/:post_id/comments.json' do
    
    comments = Comment.select([:id, :author, :body, :post_id])
    
    content_type :json
    comments.to_json
    
  end
  
  post '/API/posts/:post_id/comments.json' do
    
    request.body.rewind
    json = JSON.parse(request.body.read)
    
    post_id = json["post_id"].to_i
    comment = json["comment"]
    
    status_code = 404
    returnJSON = {
      :message => "Post not found."
    }
    
    post = Post.select([:id]).find(post_id)
    
    if post.present?
      status_code = 422
      returnJSON = {
        :message => "Unprocessing entity."
      }
      
      comment = post.comments.new(comment)
      if comment.save
        status_code = 201
        returnJSON = comment
      end
      
    end
    
    
    content_type :json
    status status_code
    returnJSON.to_json
    
  end
  
end