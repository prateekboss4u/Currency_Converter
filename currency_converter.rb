#require 'net/http'
require 'json'
require 'faraday'

class CurrencyConverter
    #FOREX_DATA = { "INR": 1, "GBP": 100.50, "EUR": 89.25, "USD": 81.86, "JPY": 1.62, "CHF": 90.52 }
    API_KEY = "A4UUB4XKNzVTxcJJYNBENbakxSdsJbvG"
    
    private
    def api_initiation
        conn = Faraday.new(url: "https://api.apilayer.com", headers: { 'Content-Type' => 'application/json', 'apikey' => API_KEY} )
        response = conn.get("/exchangerates_data/latest?base=INR")
        json_response = JSON.parse(response.body)
        json_response
    end
  
    def initialize
        @api_data = api_initiation
        @base_currency = validate_user_currency(input_user_base_currency)
        @foreign_currency = validate_user_currency(input_user_foreign_currency)
        @amount = input_user_amount

      
        puts convert_currency(@base_currency, @foreign_currency, @amount).to_f
    end
  
    def input_user_base_currency
        puts "What is your base currrency?"
        base_input = gets.chomp
    end
  
    def input_user_foreign_currency
        puts "What is your foreign currency?"
        foreign_input = gets.chomp
    end
  
    def input_user_amount
        puts "Please enter the amount:"
        amount_input = gets.chomp.to_f
    end
  
    def convert_currency(base_currency, foreign_currency, amount)
        if base_currency == 'INR'
            result = amount * @api_data['rates'][foreign_currency]
        elsif foreign_currency == 'INR'
            result = amount / @api_data['rates'][base_currency]
        else
            result = @api_data['rates'][foreign_currency]/@api_data['rates'][base_currency] * amount
        end
        result
    end
  
    private
    
    def validate_user_currency(currency)
        if @api_data['rates'].key?(currency)
            currency
        else
            puts "Sorry! We don't support this currency yet." 
            exit
        end
    end

  end
  
  CurrencyConverter.new
  
