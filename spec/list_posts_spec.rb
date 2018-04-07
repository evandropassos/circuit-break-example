require 'list_posts'

describe 'list_posts' do
    it "when execute success" do
        posts = ListPosts.instance.execute
        expect(posts.length).to_not eq(0)
    end

    it "when to_cache received" do
        expect(ListPosts.instance).to receive(:to_cache)
        ListPosts.instance.execute
    end

    it "when circuit is open" do

        ListPosts.instance.circuit_breaker.timeout = 0.1
        ListPosts.instance.execute

        expect(ListPosts.instance.circuit_breaker.state).to eq('open')
    end
end
