require File.dirname(__FILE__) + '/spec_helper'

describe 'The Hello World Dataset' do

  include Rack::Test::Methods

  def app
    repository = RDF::Repository.load(fixture('hello.nt'))
    Trinity::Application.new(repository)
  end

  context "at the root" do

    before :all do
      get '/'
    end

    it "should be http 200" do
      last_response.status.should be 200
    end

  end

  context "/hello" do
    before :all do
      get '/hello'
    end

    it "should have a content type of application/xhtml+xml" do
      last_response.should be_ok_and_of_type 'application/xhtml+xml'
    end

    it "should include the text 'Hello, World!'" do 
      last_response.body.should include 'Hello, world!'
    end
  end

  context "/hello.txt" do

    before :all do
      get '/hello.txt'
    end

    it "should have a content-type of text/plain" do
      last_response.should be_ok_and_of_type 'text/plain'
    end

    it "should have 2 statements about hello" do
      last_response.should only_be_about "http://example.org:80/hello", 2
    end

  end

  context "a non-existent page" do
    before :all do
      get '/doesnt-exist'
    end

    it "should be a http 404" do
      last_response.status.should be 404
    end
  end

end

