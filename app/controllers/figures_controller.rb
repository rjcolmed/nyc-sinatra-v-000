require 'rack-flash'
require "rack/flash/test"

class FiguresController < ApplicationController

  get '/figures' do
    @figures = Figure.all

    erb :'figures/index'
  end

  get '/figures/new' do
    @titles =  Title.all
    @landmarks = Landmark.all

    erb :'figures/new'
  end

  post '/figures' do
    figure = Figure.new(name: params[:figure][:name])

    case
    when params[:figure][:landmark_ids]
      params[:figure][:landmark_ids].each { |id| figure.landmarks << Landmark.find(id) }
    when params[:figure][:title_ids]
      params[:figure][:title_ids].each { |id| figure.titles << Title.find(id) }
    when !params[:title][:name].empty?
      figure.titles << Title.find_or_create_by(name: params[:title][:name])
    when !params[:landmark][:name].empty?
      figure.landmarks << Landmark.find_or_create_by(name: params[:landmark][:name])
    end

    figure.save
    
    flash[:message] = "Successfully created figure."
    redirect "/figures/#{figure.id}"
  end

  get '/figures/:id' do
    @figure = Figure.find(params[:id])

    erb :'figures/show'
  end

  get '/figures/:id/edit' do
    @figure = Figure.find(params[:id])
    @titles = Title.all
    @landmarks = Landmark.all

    erb :'figures/edit'
  end

  patch '/figures/:id' do
    figure = Figure.find(params[:id])

    figure.update(params[:figure])

    case
    when params[:figure][:landmark_ids]
      params[:figure][:landmark_ids].each { |id| figure.landmarks << Landmark.find(id) }
    when params[:figure][:title_ids]
      params[:figure][:title_ids].each { |id| figure.titles << Title.find(id) }
    when !params[:title][:name].empty?
      figure.titles << Title.find_or_create_by(name: params[:title][:name])
    when !params[:landmark][:name].empty?
      figure.landmarks << Landmark.find_or_create_by(name: params[:landmark][:name])
    end

    figure.save

    flash[:message] = "Successfully updated figure."
    redirect :"figures/#{figure.id}"
  end

  delete '/figures/:id' do
    Figure.find(params[:id]).destroy

    redirect :'/figures/index'
  end

end