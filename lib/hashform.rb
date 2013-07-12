class HashFormObject
  def initialize(hash = {})
    @hash = hash
  end

  def method_missing(sym, *args, &block)
    begin
      hash = @hash
      regex_is_hash_accessed_by_key = /^([a-zA-Z0-9_\-]*)\[(.*)\]$/
      while pattern = "#{sym}".match(regex_is_hash_accessed_by_key)
        hash = hash[pattern[1]]
        sym = pattern[2]
      end
    rescue
    end
    hash && hash[sym] || ''
  end
end

module HashForm
  def form_for_hash(hash, as, url, html_options, &proc)
    object = HashFormObject.new hash
    form_for object, as: as, url: url, html: html_options, &proc
  end
end
