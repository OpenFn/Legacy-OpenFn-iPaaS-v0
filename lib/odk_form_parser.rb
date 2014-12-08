require 'lib/element_emitter'

class OdkFormParser < ElementEmitter

  # The instance tag gives us the exact hieracy and path of the inputs on
  # the form.
  # We build the path as we move through the tree. And emit as soon as
  # we know we have hit a leaf node.

  # <instance>
  #   <XLSForm_SRI_Baseline_Final_v14_CH id="SRI_Baseline_Final_NewUnits">
  #     <Details>
  #       <Name_of_Survey_Recipient/>
  #       <Name_of_Head_of_Family/>
  #       <Project_Name/>
  handler :instance, {
    start_element: ->(name) { 
      if name == :instance
        @index = 0
        @current_path = []
      end

      if @in_instance_section
        @current_path[@index] = name
        @index += 1
      end
      @in_instance_section = true if name == :instance 
    },
    end_element: ->(name) {
      @in_instance_section = false if name == :instance
      if @in_instance_section
        emit({ path: @current_path.dup.map(&:to_s) })
        @current_path.pop
        @index -= 1
      end
    }
  }

  # The bind elements can give us the type of the node
  # <bind nodeset="/XLSForm_SRI_Baseline_Final_v14_CH/Details/Name_of_Survey_Recipient" required="true()" type="string"/>
  # <bind nodeset="/XLSForm_SRI_Baseline_Final_v14_CH/Details/Name_of_Head_of_Family" required="true()" type="string"/>
  #
  # They exist on their own, so we can reliably emit the descriptor when
  # we hit the end of the element.
  handler :bind, {
    start_element: ->(name) { @bind_element = {} },
    end_element: ->(name) { 
      puts @column.inspect if @bind_element == {}
      puts @line.inspect if @bind_element == {}
      puts name.inspect if @bind_element == {}
      emit(@bind_element)
      @bind_element = nil
    },
    attr: ->(name,value) {
      @bind_element[:type] = value if name == :type
      @bind_element[:path] = path_to_array(value) if name == :nodeset
    },
    error: ->(*args) {
      raise args.inspect
    } 
  }

  # Using the form layout, we look out for a repeat element and start
  # gathering up all `select1` and `input` tags, and the `repeat` element
  # itself.

  # <group appearance="field-list" ref="/XLSForm_SRI_Baseline_Final_v14_CH/Details">
  #   <label ref="jr:itext('/XLSForm_SRI_Baseline_Final_v14_CH/Details:label')"/>
  #   <input ref="/XLSForm_SRI_Baseline_Final_v14_CH/Details/Name_of_Survey_Recipient">
  #     <label ref="jr:itext('/XLSForm_SRI_Baseline_Final_v14_CH/Details/Name_of_Survey_Recipient:label')"/>
  #   </input>
  handler :repeat, {
    start_element: -> (name) {
      @previous_element = @current_element
      emit(@repeat_element) if [:select1, :repeat, :input].include?(@previous_element)

      @current_element = name
      @repeat_element = {repeat: true} if [:select1, :repeat, :input].include?(@current_element)
    },
    attr: ->(name,value) {
      if [:select1,:repeat,:input].include?(@current_element)
        @repeat_element[:path] = path_to_array(value) if [:ref,:nodeset].include?(name)
      end
    }
  }

  def path_to_array(path)
    path.split('/').reject(&:empty?)
  end

end
