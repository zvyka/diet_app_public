module ApplicationHelper
  
  # Logo
  def logo
    logo = image_tag("new_logo_5.png", :alt => "Team DIET", :class => "logo_style")
  end
  
  # Return a title on a per-page basis.
  def title
    base_title = "Team DIET Tracker"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
  
  #sorting columns
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}
  end

  def link_to_add_fields(name, f, type)
    new_object = f.object.send "build_#{type}"
    id = "new_#{type}"
    fields = f.send("#{type}_fields", new_object, :child_index => id) do |builder|
      render(type.to_s + "_fields", :f => builder)
    end
    # link_to(name, '#', :class => "add_fields", :data => {:id => id, :fields => fields.gsub("\n", "")})
    link_to_function(name, "add_fields(this, \"#{type}\", \"#{escape_javascript(fields)}\")")
  end

  def link_to_remove_fields(name)
    link_to_function(name, "remove_fields(this)")
  end
end
