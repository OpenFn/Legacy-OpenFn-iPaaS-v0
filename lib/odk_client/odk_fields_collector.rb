class OdkClient::OdkFieldsCollector
  def initialize
    @list = []
  end

  def add(descriptor)
    return if descriptor[:path].empty?
    @list.select { |item| item[:path] == descriptor[:path] }.
      tap { |matches| @list << descriptor unless matches.any? }.
      each { |match| match.merge!(descriptor) }
  end

  def each(&block)
    @list.each(&block)
  end

  def sort_by_grouping
    @list.group_by { |x| x[:path][0] }.
      inject([]) { |memo,i| memo + i[1].sort {|p| p[:path].length } }.
      inject([]) { |memo,p| memo << p.merge({path: "/#{p[:path].join("/")}"}) }
  end
end

