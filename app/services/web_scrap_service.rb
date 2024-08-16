USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3"

class WebScrapService
  attr_accessor :attempt, :doc

  def initialize(attempt)
    @attempt = attempt
    @doc = get_page_content
    @attempt.success = false if @doc.nil?
  end

  def get_page_content
    begin
      response = Faraday.get(@attempt.url) do |req|
        req.headers['User-Agent'] = USER_AGENT
      end
      Nokogiri::HTML.parse(response.body)
    rescue
      nil
    end
  end

  def set_brand_and_model
    split_url = @attempt.url.split('/')
    @attempt.brand = split_url[4]
    @attempt.model = split_url[5]
  end

  def parse_price
    return if @doc.nil?

    price = @doc.css('#vehicleSendProposalPrice')
    if price.text.empty?
      @attempt.success = false
    else
      @attempt.success = true
      @attempt.price = price.text.gsub(/[R\$]|\./, '').to_f
    end
  end

  def run
    set_brand_and_model
    parse_price
    @attempt.save
  end
end
