class LocationsController < ApplicationController
def index
  if params[:search].present?
    @locations = Location.near(params[:search], 50, :order => :distance)
  else
    @locations = Location.all
  end
end

  def show
    @location = Location.find(params[:id])
  end

  def new
    @location = Location.new
  end

  def create
    @location = Location.new(params[:location])
    if @location.save
#      if @location.errors.full_messages.any?
#        @location.errors.full_messages.each do |error_message|
#          error_message if @location.errors.full_messages.first == error_message
#          flash[:notice] = "Had an error, #{error_message.message}"
#        end
#      end
      redirect_to @location, :notice => "Successfully created location."

    else
      render :action => 'new'
    end
  end

  def import
    Location.import(params[:file])
    redirect_to root_url, notice => "Data Imported Successfully"
  end

  def edit
    @location = Location.find(params[:id])
  end

  def update
    @location = Location.find(params[:id])
    if @location.update_attributes(params[:location])
      redirect_to @location, :notice  => "Successfully updated location."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @location = Location.find(params[:id])
    @location.destroy
    redirect_to locations_url, :notice => "Successfully destroyed location."
  end
end
