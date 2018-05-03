namespace :migrate_books do

  desc "Migrate Books"
  task :run => :environment do
    SadhnaCard.all.each do |sc|
      if sc.reading.present?
        sc_book = SadhnaCardBook.new
        sc_book.qty = sc.reading
        sc_book.book = sc.reading_book
        sc_book.unit = sc.reading_type
        sc_book.sadhna_card = sc
        sc_book.save
      end
    end
  end

end