require 'sinatra'
require 'data_mapper'


DataMapper.setup(:default, 'sqlite:football.db')

class Player
  include DataMapper::Resource

  property :name, String
  property :id, Serial

  belongs_to :team

end

class Team
  include DataMapper::Resource

  property :id, Serial
  property :name, String

  has n, :players

end

DataMapper.auto_upgrade!

get '/' do
  @teams = Team.all
  @title = 'All teams'
  erb :'team/home'
end

post '/' do
  team = Team.new
  team.name = params[:name]
  team.save
  redirect '/'
end

get '/:id' do
  @team = Team.get params[:id]
  @title = 'Edit team'
  erb :'team/edit'
end

put '/:id' do
  team = Team.get params[:id]
  team.name = params[:name]
  team.save
  redirect to('/')
end

get '/:id/delete' do
  @team = Team.get params[:id]
  @title = 'Delete team'
  erb :'team/delete'
end

delete '/:id' do
  team = Team.get params[:id]
  team.destroy
  redirect '/'
end

get '/:id/players' do
  @team = Team.get(params[:id])
  @players = Player.all
  @title = 'All players'
  erb :'player/home'
end

post '/:id/players' do
  team = Team.get(params[:id])
  player = Player.new
  player.name = params[:name]
  player.team = team
  player.save
  redirect '/:id/players'
end

put '/:id/players' do
  player = Player.get(params[:id])
  player.name = params[:name]
  player.team = Team.get(params[:id])
  player.save
  redirect '/:id/players'
end



