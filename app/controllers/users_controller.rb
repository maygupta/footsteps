class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token  
  
  include SadhnaCardHelper

  def new
    @user = User.new
  end

  def update_rounds
    current_user.name = params[:name]
    current_user.target_rounds = params[:target_rounds]
    current_user.target_book = params[:target_book]
    current_user.target_book_qty = params[:target_book_qty]
    current_user.target_book_unit = params[:target_book_unit]
    current_user.save

    redirect_to :back
  end

  def edit

  end

  def index
    @users = User.all
  end

  def badges
    user = current_user
    if params[:id].present? && current_user.role == 'admin'
      user = User.find(params[:id])
    end
      
    cards = user.sadhna_cards
    @unlocked_badges = []
    @locked_badges = []

    target_rounds = user.target_rounds
    if target_rounds == nil
      target_rounds = 16
    end

    read_mins = 0
    read_pages = 0
    sb_pages = 0
    
    cards.each do |c|
      c.sadhna_card_books.each do |b|
        if b.unit == 'Mins'
          read_mins += b.qty
        elsif b.unit == 'Hrs'
          read_mins += b.qty*60
        else
          print b.book
          print books[0]
          if b.book == books[0]
            sb_pages += b.qty
          end
        end
      end
    end

    @level_1_badges = [
      ["Chanted 108 total Japa Rounds", cards.sum(:japa_rounds) >= 108, cards.sum(:japa_rounds)/1.08],
      ["Read for 24 hours", read_mins >= 24*60, read_mins*100/(24*60)],
      ["Read 500 pages of #{books[0]}", sb_pages >= 500, sb_pages*100/500],
      ["Heard for 24 hours", cards.pluck(:hearing).sum(&:to_i) >= 24*60, cards.pluck(:hearing).sum(&:to_i)/(24*0.6)],
      ["Served for 24 hours", cards.pluck(:service).sum(&:to_i) >= 24*60, cards.pluck(:service).sum(&:to_i)/(24*0.6)],
      ["Recited 108 verses of Bhagavad Gita", cards.pluck(:verses).sum(&:to_i)>= 108, cards.pluck(:verses).sum(&:to_i)/1.08],
      ["Read CHAD every day for 7 days", chad_min(user.sadhna_cards, 7) >= 7, chad_min(user.sadhna_cards, 7)*100/7],
      ["Chanted #{target_rounds} rounds every day for 7 days", chanted_minimum(user.sadhna_cards, target_rounds, 7) >= 7, chanted_minimum(user.sadhna_cards, target_rounds, 7)*100/7],
    ]

    @level_2_badges = [
      ["Chanted 1008 total Japa Rounds", cards.sum(:japa_rounds) >= 1008, cards.sum(:japa_rounds)/10.08],
      ["Read for 108 hours", read_mins >= 108*60, read_mins/(108*0.6)],
      ["Read 2000 pages of #{books[0]}", sb_pages >= 2000, sb_pages/20],
      ["Heard for 108 hours", cards.pluck(:hearing).sum(&:to_i) >= 108*60, cards.pluck(:hearing).sum(&:to_i)/(108*0.6)],
      ["Served for 108 hours", cards.pluck(:service).sum(&:to_i)>= 108*60, cards.pluck(:service).sum(&:to_i)/(108*0.6)],
      ["Recited 1008 verses of Bhagavad Gita", cards.pluck(:verses).sum(&:to_i)>= 1008, cards.pluck(:verses).sum(&:to_i)/10.08],
      ["Read CHAD every day for 30 days", chad_min(user.sadhna_cards, 30) >= 30, chad_min(user.sadhna_cards, 30)*100/30],
      ["Chanted #{target_rounds} rounds every day for 30 days", chanted_minimum(user.sadhna_cards, target_rounds, 30) >= 30, chanted_minimum(user.sadhna_cards, target_rounds, 30)*100/30],
    ]
    
    @level_3_badges = [
      ["Chanted 3000 total Japa Rounds", cards.sum(:japa_rounds) >= 3000, cards.sum(:japa_rounds)/30],
      ["Read 5000 pages of #{books[0]}", sb_pages >= 5000, sb_pages/50],
      ["Read for 360 hours", read_mins >= 24*15*60, read_mins/(24*15*0.6)],
      ["Heard for 360 hours", cards.pluck(:hearing).sum(&:to_i) >= 24*15*60, cards.pluck(:hearing).sum(&:to_i) * 100 / (24*15*60)],
      ["Served for 360 hours", cards.pluck(:service).sum(&:to_i)>= 24*15*60, cards.pluck(:service).sum(&:to_i) * 100 / (24*15*60)],
      ["Recited 3000 verses of Bhagavad Gita", cards.pluck(:verses).sum(&:to_i)>= 3000, cards.pluck(:verses).sum(&:to_i)/30],
      ["Read CHAD every day for 90 days", chad_min(user.sadhna_cards, 90) >= 90, chad_min(user.sadhna_cards, 90)*100/90],
      ["Chanted #{target_rounds} rounds every day for 90 days", chanted_minimum(user.sadhna_cards, target_rounds, 90) >= 90, chanted_minimum(user.sadhna_cards, target_rounds, 90)*100/90],
    ]
    
    @level_4_badges = [
      ["Chanted 10,000 total Japa Rounds", cards.sum(:japa_rounds) >= 10000, cards.sum(:japa_rounds)/100],
      ["Completed #{books[0]}", sb_pages >= 14625, sb_pages/146.25],
      ["Read for 720 hours", read_mins >= 24*30*60, read_mins/(24*30*0.6)],
      ["Heard for 720 hours", cards.pluck(:hearing).sum(&:to_i) >= 24*30*60, cards.pluck(:hearing).sum(&:to_i) * 100 / (24*30*60)],
      ["Served for 720 hours", cards.pluck(:service).sum(&:to_i)>= 24*30*60, cards.pluck(:service).sum(&:to_i) * 100 / (24*30*60)],
      ["Recited 10,000 verses of Bhagavad Gita", cards.pluck(:verses).sum(&:to_i)>= 10000, cards.pluck(:verses).sum(&:to_i)/100],
      ["Read CHAD every day for 365 days", chad_min(user.sadhna_cards, 365) >= 365, chad_min(user.sadhna_cards, 365)*100/365],
      ["Chanted #{target_rounds} rounds every day for 365 days", chanted_minimum(user.sadhna_cards, target_rounds, 365) >= 365, chanted_minimum(user.sadhna_cards, target_rounds, 365)*100/365],
    ]
    
    if user.target_book.present? and user.target_book_unit.present? and user.target_book_qty.present?
      book = user.target_book
      qty = user.target_book_qty
      unit = user.target_book_unit
      max_count = read_min(user.sadhna_cards, book,qty,unit, 365)
      
      @level_1_badges.push(["Read #{qty} #{unit} of #{book} every day for 7 days", max_count >= 7, (max_count*100)/7])
      @level_2_badges.push(["Read #{qty} #{unit} of #{book} every day for 30 days", max_count >= 30, (max_count*100)/30])
      @level_3_badges.push(["Read #{qty} #{unit} of #{book} every day for 90 days", max_count >= 90, (max_count*100)/90])
      @level_4_badges.push(["Read #{qty} #{unit} of #{book} every day for 365 days", max_count >= 365, (max_count*100)/365])
      
    end

    [@level_1_badges, @level_2_badges, @level_3_badges, @level_4_badges].each do |badges|
      badges.each do |badge|
        if badge[1] == true
          @unlocked_badges.push(badge)
        else
          @locked_badges.push(badge)
        end
      end
    end
  end

  def show
    @user = User.find(params[:id])

    @total_rounds = 0
    @total_reading_hours = 0
    @total_hearing_hours = 0
    @total_service_hours = 0
    @total_reading_pages = 0
    @total_sadhna_cards = 0
    @total_chad_verses = 0
    @total_days_gt_target = 0

    @current_month_rounds = 0
    @current_month_reading_hours = 0
    @current_month_reading_pages = 0   
    @current_month_hearing_hours = 0
    @current_month_service_hours = 0
    @current_month_sadhna_cards = 0
    @current_chad_verses = 0
    @current_days_gt_target = 0

    @months = [["01", "Jan"], ["02", "Feb"], ["03", "March"], ["04", "April"], 
    ["05", "May"], ["06", "June"], ["07", "July"], ["08", "August"], ["09", "Sept"], 
    ["10", "Oct"], ["11", "Nov"], ["12", "Dec"]]
    
    if params[:month].present? and params[:year].present?
      @month = params[:month]
      @year = params[:year]
      @month_name = @months.select {|x| x[0] == @month}[0][1]
    else
      @month = Date.today.strftime("%m")
      @month_name = Date.today.strftime("%B")
      @year =  Date.today.strftime("%Y")
    end

    @years = []
    count = 0
    start = 1989
    while count < 50
      count += 1
      if start+count <= @year.to_i
        @years.push(start + count)
      end
    end

    sadhna_cards = @user.sadhna_cards
    current_month_sadhna_cards = @user.sadhna_cards.where('extract(year from date) = ? AND extract(month  from date) = ? 
      ', @year, @month)
    target_rounds = if @user.target_rounds.present? then @user.target_rounds else 16 end

    sadhna_cards.each do |sc|
      @total_rounds += sc.japa_rounds
      if sc.japa_rounds > target_rounds
        @total_days_gt_target += 1
      end
      @total_chad_verses += if sc.verses.present? then sc.verses else 0 end
      @total_service_hours +=  if sc.service.present? then sc.service.to_i else 0 end
      @total_hearing_hours += if sc.hearing.present? then sc.hearing.to_i else 0 end
      sc.sadhna_card_books.each do |book|
        if book.unit == 'Mins'
          @total_reading_hours += if book.qty.present? then book.qty.to_i else 0 end
        elsif book.unit == 'Hrs'
          @total_reading_hours += if book.qty.present? then book.qty.to_i*60 else 0 end
        else
          @total_reading_pages += if book.qty.present? then book.qty.to_i else 0 end
        end
      end
    end
    @total_service_hours = (@total_service_hours/60).to_s + "h " +  (@total_service_hours % 60).to_s + "m"
    @total_reading_hours = (@total_reading_hours/60).to_s + "h " +  (@total_reading_hours % 60).to_s + "m"
    @total_hearing_hours = (@total_hearing_hours/60).to_s + "h " +  (@total_hearing_hours % 60).to_s + "m"
    @total_sadhna_cards = sadhna_cards.count

    current_month_sadhna_cards.each do |sc|
      @current_month_rounds += sc.japa_rounds
      if sc.japa_rounds > target_rounds
        @current_days_gt_target += 1
      end
      @current_chad_verses += if sc.verses.present? then sc.verses else 0 end
      @current_month_service_hours +=  if sc.service.present? then sc.service.to_i else 0 end
      @current_month_hearing_hours += if sc.hearing.present? then sc.hearing.to_i else 0 end
      sc.sadhna_card_books.each do |book|
        if book.unit == 'Mins'
          @current_month_reading_hours += if book.qty.present? then book.qty.to_i else 0 end
        elsif book.unit == 'Hrs'
          @current_month_reading_hours += if book.qty.present? then book.qty.to_i*60 else 0 end
        else
          @current_month_reading_pages += if book.qty.present? then book.qty.to_i else 0 end
        end
      end
    end
    @current_month_service_hours = (@current_month_service_hours/60).to_s + "h " +  (@current_month_service_hours % 60).to_s + "m"
    @current_month_reading_hours = (@current_month_reading_hours/60).to_s + "h " +  (@current_month_reading_hours % 60).to_s + "m"
    @current_month_hearing_hours = (@current_month_hearing_hours/60).to_s + "h " +  (@current_month_hearing_hours % 60).to_s + "m"
    @current_month_sadhna_cards = current_month_sadhna_cards.count
  end

  def report
    @user = User.find(params[:id])

    if current_user != @user && current_user.role != 'admin'
      render "_error"
      return
    end

    if params[:month].present? and params[:year].present?
      @month = params[:month]
      @year = params[:year]
    else
      @month = Date.today.strftime("%m")
      @year =  Date.today.strftime("%Y")
    end


    valid_columns = {
      "date" => "Date",
      "japa_rounds" => "Japa Rounds", 
      "reading" => "Reading Time",
      "reading_book" => "Book Read",
      "chad" => "CHAD (Chapter A Day)",
      "wakeup" => "Wake Up time", 
      "rest_time" => "Rest time", 
      "hearing" => "Hearing Time", 
      "service" => "Seva time",
      "service_text" => "Service executed",
      "comments" => "Comments"
    }

    @sadhna_cards = @user.sadhna_cards.where('extract(year  from date) = ? AND extract(month  from date) = ? 
      ', @year, @month).order(date: :asc)


    @sadhna_cards_by_week = @sadhna_cards.each_slice(7).to_a
  end

  def read_min(cards, book, unit, qty, days)
    if !book or !qty or !unit
      return false
    end
    cards = cards.order(date: :desc)
    max_count = 0
    count = 0
    cards.each do |card|
      if has_book(card.sadhna_card_books, book, unit, qty)
        count += 1
        if count == days
          return count
        end
      else
        if count > max_count
          max_count = count
        end
        count = 0
      end
    end
    if count > max_count
      max_count = count
    end

    return max_count
  end

  def has_book(sc_book, book, unit, qty)
    if sc_book.present?
      p sc_book, book, unit, qty
      sc_book.each do |x|
        p book, x.book, x.book == book
        p unit, x.unit, x.unit == unit
        p qty, x.qty, x.qty == qty
        if x.book == book and x.unit == unit and x.qty >= qty
          return true
        end
      end
    end

    return false
  end

  def chad_min(cards, days)
    cards = cards.order(date: :desc)
    max_count = 0
    count = 0
    cards.each do |card|
      if card.chad.present? and card.chad != "0"
        count += 1
        if count == days
          return count
        end
      else
        if count > max_count
          max_count = count
        end
        count = 0
      end
    end
    if count > max_count
      max_count = count
    end

    return max_count
  end

  def chanted_minimum(cards, rounds, days)
    unless rounds.present?
      return 0
    end
    cards = cards.order(date: :desc)
    max_count = 0
    count = 0
    cards.each do |card|
      if card.japa_rounds >= rounds
        count += 1
        if count == days
          return count
        end
      else
        if count > max_count
          max_count = count
        end
        count = 0
      end
    end
    if count > max_count
      max_count = count
    end

    print "max_count=#{max_count}"
    return max_count
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "You signed up successfully"
      flash[:color]= "valid"
    else
      flash[:notice] = "Form is invalid"
      flash[:color]= "invalid"
    end
    render "new"
  end

end
