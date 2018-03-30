class SadhnaCardsController < ApplicationController

  def new
    @sadhna_card = SadhnaCard.new
    @custom_method = "post"
    @custom_path = "/sadhna_cards"
  end  

  def index
    @sadhna_cards = SadhnaCard.all.order(id: :desc)
  end

  def create
    print sadhna_card_params
    @sadhna_card = SadhnaCard.new(sadhna_card_params)
 
    if @sadhna_card.save
      render :json => {id: @sadhna_card.id}, :status => :ok
    else
      render 'new'
    end
  end

  def show
    @sadhna_card = SadhnaCard.find(params[:id])
  end

  def edit

    @sadhna_card = SadhnaCard.find(params[:id])
    print @sadhna_card.wakeup.to_time
  end

  def update
    @sadhna_card = SadhnaCard.find(params[:id])
   
    if @sadhna_card.update(sadhna_card_params)
      render :json => {id: @sadhna_card.id}, :status => :ok
    else
      render 'edit'
    end
  end

  private

  def sadhna_card_update_params
    { 
      :japa_rounds => params[:japa_rounds], 
      :hearing => params[:hearing], 
      :wakeup => params[:wake_up],
      :rest_time => params[:slept_at],
      :service => params[:service], 
      :chad => params[:chad], 
      :reading => params[:reading]
    }
  end

  def sadhna_card_params
    { 
      :date => Time.zone.now.to_date,
      :japa_rounds => params[:japa_rounds], 
      :hearing => params[:hearing], 
      :wakeup => params[:wake_up],
      :rest_time => params[:slept_at],
      :service => params[:service], 
      :chad => params[:chad], 
      :reading => params[:reading]
    }
  end
end
