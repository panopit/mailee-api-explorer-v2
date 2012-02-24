module ApplicationHelper
  def hiddens resource, action
    render partial: 'explorer/forms/hiddens', locals: {resource: resource, action: action}
  end
end
