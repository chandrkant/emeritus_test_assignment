# frozen_string_literal: true

module ApplicationHelper
  def bootstrap_class_for(flash_type)
    case flash_type
    when 'success'
      'success' # Green
    when 'error'
      'danger' # Red
    when 'alert'
      'warning' # Yellow
    when 'notice'
      'info' # Blue
    else
      flash_type.to_s
    end
  end

  def generate_password_suggestion
    [*('a'..'z'), *('0'..'9')].shuffle[0, 8].join
  end
end
