class ListPosts
  include Singleton
  attr_accessor :circuit_breaker
  API_POSTS_URL = 'https://jsonplaceholder.typicode.com/posts'

  def initialize
    @circuit_breaker = CircuitBreakage::Breaker.new
    @circuit_breaker.failure_threshold = 1
    @circuit_breaker.duration =  3
    @circuit_breaker.timeout =  2

  end

  def execute
    posts = []

    begin
      @circuit_breaker.call do
        posts = request_posts
        to_cache posts
      end
    rescue CircuitBreakage::CircuitOpen
      posts = posts_cached
    rescue CircuitBreakage::CircuitTimeout
      posts = posts_cached
    end

    posts
  end


  def to_cache(posts)
    Rails.cache.write('posts', posts)
  end

  def posts_cached
    Rails.cache.read('posts')
  end

  def request_posts
    response = RestClient.get API_POSTS_URL
    JSON.parse response.body, symbolize_names: true
  end
end
