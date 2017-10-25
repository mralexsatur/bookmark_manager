ENV["RACK_ENV"] ||= "development"

require 'sinatra/base'
require_relative 'models/link'
require_relative 'data_mapper_setup'

class BookmarkManager < Sinatra::Base

  enable :sessions

  get '/testing' do
    'Testing Infrastructure OK'
  end

  get '/' do
    erb :'links/signin'
  end

  post '/signin' do
    $user = (params[:username])
    redirect '/links'
  end


  get '/links' do
    @links = Link.all
    @user = $user
    erb :'links/index'
  end

  get '/new' do
    erb :'links/new'
  end

  post '/new' do
    link = Link.create(url: (params[:url]), title: (params[:title]))
    params[:tags].split.each do |tag|
      link.tags << Tag.first_or_create(name: tag)
    end
    link.save
    redirect '/links'
  end

  get '/tags/:name' do
    tag = Tag.first(name: params[:name])
    @links = tag ? tag.links : []
    erb :'links/index'
  end

end
