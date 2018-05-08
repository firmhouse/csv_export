require "csv"

class CsvExport
  class Error < StandardError
  end

  def initialize(*headers)
    raise Error, "You must specify export headers" if headers.blank?
    @headers = headers
    @human_headers = @headers.map { |h| h.to_s.humanize }
    @rows = []
    @rows << @human_headers
  end

  def <<(values)
    @rows << values
  end

  def render_collection(collection)
    render if collection.blank?

    @headers.each do |h|
      unless collection.first.respond_to?(h)
        raise Error, "#{h} is not defined on the records in your collection"
      end
    end

    collection.each do |record|
      @rows << @headers.map { |h| record.send(h) }
    end

    render
  end

  def render
    CSV.generate headers: true, col_sep: ";" do |csv|
      @rows.each do |row|
        csv << row
      end
    end
  end
end
