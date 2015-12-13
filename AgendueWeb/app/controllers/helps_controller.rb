class HelpsController < ApplicationController
  before_action :set_help, only: [:show, :edit, :update, :destroy]

  # GET /helps
  # GET /helps.json
  def index
    @helps = Help.all
    @projects = Array.new()
    @tasks = Array.new()
    @agendueplus = Array.new()
    @other = Array.new()
    @helps.sort!  { |a,b| a.title.downcase <=> b.title.downcase }
    @helps.each do |help|
      if help.category.downcase == 'projects'
        @projects << help
      elsif help.category.downcase == 'tasks'
        @tasks << help
      elsif help.category.downcase == 'agendueplus'
        @agendueplus << help
      else
        @other << help
      end
    end
    @iseditor = useriseditor


  end

  # GET /helps/1
  # GET /helps/1.json
  def show
    @iseditor = useriseditor
  end

  # GET /helps/new
  def new
    if useriseditor
      @help = Help.new
    else
      redirect_to root_path
    end
  end

  # GET /helps/1/edit
  def edit
    if !useriseditor
      redirect_to root_path
    end
  end

  # POST /helps
  # POST /helps.json
  def create
    if useriseditor
      @help = Help.new(help_params)

      respond_to do |format|
        if @help.save
          format.html { redirect_to @help, alert: 'Help was successfully created.' }
          format.json { render action: 'show', status: :created, location: @help }
        else
          format.html { render action: 'new' }
          format.json { render json: @help.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_path
    end


  end

  # PATCH/PUT /helps/1
  # PATCH/PUT /helps/1.json
  def update
    if useriseditor
      respond_to do |format|
        if @help.update(help_params)
          format.html { redirect_to @help, alert: 'Help was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @help.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_path
    end
  end

  # DELETE /helps/1
  # DELETE /helps/1.json
  def destroy
    if useriseditor
        @help.destroy
      respond_to do |format|
        format.html { redirect_to helps_url }
        format.json { head :no_content }
      end
    else
      redirect_to root_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_help
      @help = Help.find(params[:id])
    end

    def useriseditor
        if session[:userid]
          user = User.find(session[:userid])
          if user
            if user.name == ""

              return true
            else
              return false
            end
          end
        end

    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def help_params
      params.require(:help).permit(:title, :content, :category)
    end
end
