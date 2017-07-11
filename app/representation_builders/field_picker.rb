class FieldPicker
  puts 'FIELD PICKER:'
  def initialize(presenter)
    @presenter = presenter
  end

  def pick
    build_fields
    @presenter
  end

  def fields
    @fields ||= validate_fields
  end

  private
    # loop through all fields, and check that they are a valid field as
    # defined by pickable
    def validate_fields
      return pickable if @presenter.params[:fields].blank?

      fields = if !@presenter.params[:fields].blank?
                 @presenter.params[:fields].split(',')
               else
                 []
               end

      return pickable if fields.blank?

      fields.each do |field|
        error!(field) unless pickable.include?(field)
      end
      fields
    end

    def build_fields
      fields.each do |field|
        target = @presenter.respond_to?(field) ? @presenter : @presenter.object
        @presenter.data[field] = target.send(field) if target
      end
    end

    def error!(field)
      build_attributes = @presenter.class.build_attributes.join(',')
      raise RepresentationBuilderError.new("fields=#{field}"),
        "Invalid Field Pick. Allowed field: (#{build_attributes})"
    end

    #returns list of all valid fields
    def pickable
      @pickable ||= @presenter.class.build_attributes
    end
end
