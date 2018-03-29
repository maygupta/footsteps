class SadhnaCardsController < ApplicationController

  def new
    @sadhna_card = SadhnaCard.new
    @custom_method = "post"
    @custom_path = "/sadhna_cards"
  end  

  def index
    @sadhna_cards = SadhnaCard.all
  end

  def create
    print sadhna_card_params
    @sadhna_card = SadhnaCard.new(sadhna_card_params)
 
    if @sadhna_card.save
      redirect_to '/sadhna_cards'
    else
      render 'new'
    end
  end

  def edit
    @sadhna_card = SadhnaCard.find(params[:id])
  end

  def update
    @sadhna_card = SadhnaCard.find(params[:id])
   
    if @sadhna_card.update(sadhna_card_params)
      redirect_to @sadhna_card
    else
      render 'edit'
    end
  end

  private

  def sadhna_card_params
    { 
      :date => Date.today.strftime("%Y-%M-%d"),
      :japa_rounds => params[:japa_rounds], 
      :hearing => params[:hearing], 
      :wakeup => params[:wake_up],
      :rest_time => params[:slept_at],
      :service => params[:service], 
      :chad => params[:chad_chapter], 
      :reading => params[:reading]
    }
  end
end
