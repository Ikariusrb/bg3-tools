 # frozen_string_literal: true

 class FindEquipment
  def call
    equip_links_from("/w/index.php?title=Category:Equipment")
  end

  def equip_links_from(url)
    links = []
    next_page = url
    while next_page do
      document = fetch_document(next_page)
      all_href = document.xpath("//div[@id='mw-pages']").xpath(".//a")
      next_page = all_href.find { |link| link.text == "next page" }&.attributes&.dig("href")&.value
      links += all_href.reject do |link|
        next true if link.text == "next page"
        next true if link.text == "previous page"
        # next true if link.text.plural?
        next true if link.attributes["href"].value.include? "Category"
        false
      end
    end
    links.map { |a|  [ a.text, a.attributes["href"]&.value ] }
  end

  def fetch_document(url)
    parser.get("https://bg3.wiki" + url)
  end

  def parser
    @parser ||= Mechanize.new
  end
 end
