require 'rack-flash'
require "rack/flash/test"

class LandmarksController < ApplicationController

  get '/landmarks' do
    @landmarks = Landmark.all
    
    erb :'landmarks/index'
  end

  get '/landmarks/new' do
    erb :'landmarks/new'
  end

  post '/landmarks' do
    landmark = Landmark.create(
      name: params[:landmark][:name], 
      year_completed: params[:landmark][:year_completed]
      )

      flash[:message] = "Successfully created landmark."
      redirect "landmarks/#{landmark.id}"
  end

  get '/landmarks/:id/edit' do
    @landmark = Landmark.find(params[:id])
    @landmarks = Landmark.all
    @titles = Title.all

    erb :'landmarks/edit'
  end

  patch '/landmarks/:id' do
    Landmark.update(
      params[:id], 
      name: params[:landmark][:name], 
      year_completed: params[:landmark][:year_completed]
      )

      flash[:message] = "Successfully updated landmark."
      redirect "landmarks/#{params[:id]}"
  end

  get '/landmarks/:id' do
    @landmark = Landmark.find(params[:id])

    erb :'landmarks/show'
  end

end
