class FieldPicker
  def initialize(presenter)
    @presenter = presenter
    @fields = @presenter.params[:fields]
  end

  def pick
    (validate_fields || pickable).each do |field|
      value = (@presenter.respond_to?(field) ? @presenter : @presenter.object).send(field)
      @presenter.data[field] = value
    end
    @presenter
  end

  private
    # loop through all fields, and check that they are a valid field as
    # defined by pickable
    def validate_fields
      return nil if @fields.blank?
      validated = @fields.split(',').reject { |f| !pickable.include?(f) }
      validated.any? ? validated : nil
    end

    #returns list of all valid fields
    def pickable
      @pickable ||= @presenter.class.build_attributes
    end
end
