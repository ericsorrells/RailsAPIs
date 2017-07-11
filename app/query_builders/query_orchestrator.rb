class QueryOrchestrator
  puts 'QUERY ORCHESTRATOR:'
  ACTIONS = [:paginate, :sort, :filter, :eager_load]

  def initialize(scope:, params:, request:, response:, actions: :all)
    @scope = scope
    @params = params
    @request = request
    @response = response
    @actions = actions == :all ? ACTIONS : action
  end

  def run
    @actions.each do |action|
      unless ACTIONS.include?(action)
        raise InvalidBuilderAction, "#{action} not permitted."
      end
      @scope = send(action)
    end
    @scope
  end

  private
  def paginate
    puts 'QUERY ORCH: paginate'
    current_url = @request.base_url + @request.path
    paginator = Paginator.new(@scope, @request.query_parameters, current_url)
    @response.headers['Link'] = paginator.links
    paginator.paginate
  end

  def sort
    puts 'QUERY ORCH: sort'
    Sorter.new(@scope, @params).sort
  end

  def filter
    puts 'QUERY ORCH: filter'
    Filter.new(@scope, @params.to_unsafe_hash).filter
  end

  def eager_load
    puts 'QUERY ORCH: eager loader'
    EagerLoader.new(@scope, @params).load
  end
end
