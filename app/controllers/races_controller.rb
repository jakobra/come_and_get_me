class RacesController < ApplicationController
  before_filter :login_required, :except => [:index, :show]
  
  # GET /races/1
  # GET /races/1.xml
  def show
    @race = Race.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @race}
    end
  end
  
  # GET /races/1/edit
  def edit
    @race = Race.find(params[:id])
  end
  
  # POST /races
  # POST /races.xml
  def create
    @training = Training.find(params[:training_id])
    @race = @training.races.build(params[:race])
    
    respond_to do |format|
      if @race.save
        flash[:notice] = 'Race was successfully created.'
        format.html { redirect_to(@training) }
        format.xml  { render :xml => @race, :status => :created, :location => @race }
        format.js
      else
        format.html { render :template => "trainings/show" }
        format.xml { render :xml => @race.errors, :status => :unprocessable_entity }
        format.js
      end
    end
  end
  
  # PUT /races/1
  # PUT /races/1.xml
  def update
    @race = Race.find(params[:id])

    respond_to do |format|
      if @race.update_attributes(params[:race])
        flash[:notice] = t("races.update.updated")
        format.html { redirect_to(training_path(@race.training)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @race.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /races/1
  # DELETE /races/1.xml
  def destroy
    @race = Race.find(params[:id])
    @race.destroy

    respond_to do |format|
      format.html { redirect_to(training_url(@race.training)) }
      format.xml  { head :ok }
    end
  end

end
