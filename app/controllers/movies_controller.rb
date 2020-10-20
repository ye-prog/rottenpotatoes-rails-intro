class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
     if params[:movietitle] != nil || params[:release_date] != nil || params[:ratings] != nil || !session.has_key?(:params)
       session[:params] = params
      ratings = params[:ratings]
    if params[:movietitle] != nil 
       @movies = Movie.with_ratings(ratings).order("title")
       @title_color = "hilite"
       @release_date_color = nil
    elsif params[:release_date] != nil
      @movies = Movie.with_ratings(ratings).order("release_date")
      @release_date_color = "hilite"
      @title_color = nil
    else
      @movies = Movie.with_ratings(ratings)
      @release_date_color = nil
      @title_color = nil
    end
    @all_ratings = Movie.all_ratings
      if ratings != nil
        @ratings_to_show = ratings.keys
      else 
        @ratings_to_show = []
      end
   else
      ratings = session[:params][:ratings]
    if session[:params][:movietitle] != nil 
       @movies = Movie.with_ratings(ratings).order("title")
       @title_color = "hilite"
       @release_date_color = nil
    elsif session[:params][:release_date] != nil
      @movies = Movie.with_ratings(ratings).order("release_date")
      @release_date_color = "hilite"
      @title_color = nil
    else
      @movies = Movie.with_ratings(ratings)
      @release_date_color = nil
      @title_color = nil
    end
    @all_ratings = Movie.all_ratings
      if ratings != nil
        @ratings_to_show = ratings.keys
      else 
        @ratings_to_show = []
      end
     end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
