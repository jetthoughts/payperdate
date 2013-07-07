module ActAsEnumeration
  def act_as_enumeration(options)
    (class << self; self; end).instance_eval do
      labels = {}
      names_humanize = {}
      names_titleized = {}
      values = []

      options.each do |name, value|
        name = name.to_s

        labels[value] = name
        names_humanize[value] = name.humanize
        names_titleized[value] = name.humanize.titleize
        values << value

        self.send(:define_method, name) { value }
        self.send(:define_method, "#{name}?") { |param_value| param_value == value }
      end

      self.send(:define_method, :list) { options }
      self.send(:define_method, :select_list) { options.sort_by { |x| x[1] }.collect { |x| [name_titleized(x[1]), x[1]] } }
      self.send(:define_method, :values) { values }
      self.send(:define_method, :labels) { labels }
      self.send(:define_method, :names) { names_humanize }
      self.send(:define_method, :names_titleized) { names_titleized }
      self.send(:define_method, :label) { |v| labels[v] }
      self.send(:define_method, :name) { |v| names_humanize[v] }
      self.send(:define_method, :name_titleized) { |v| names_titleized[v] }
      self.send(:define_method, :value) { |t| t ? options[t.to_sym] : 0 }
    end
  end
end