require 'list_posts'
module Api::V1
  class PostsController < ApplicationController

    def index
      posts = ListPosts.instance.execute
      render json: posts
    end

  end
end
