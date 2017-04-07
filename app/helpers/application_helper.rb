module ApplicationHelper

  def simple_date(date)
    return "" if date.nil?
    date.strftime('%m/%d/%y')
  end

  def simple_time(date)
    return "" if date.nil?
    date.strftime('%I:%M%p')
  end

  def display_status(status)
    status_class = nil
    status_color = nil

    if status == STATUS_SUCCESS
      status_class = 'glyphicon glyphicon-ok-sign'
      status_color = "#52A304"
    elsif status == STATUS_FAILURE
      status_class = 'glyphicon glyphicon-remove-sign'
      status_color = "red"
    end

    "<span title=#{status} class=\"#{status_class}\" style='color:#{status_color}'></span>".html_safe
  end

  def stringify_duration(time_in_seconds)
    return '' if time_in_seconds.nil?

    ts = time_in_seconds.floor
    days = ts / 1.day
    ts %= 1.day
    hours = ts / 1.hour
    ts %= 1.hour
    minutes = ts / 1.minute
    ts %= 1.minute
    seconds = ts

    if days > 0
      "#{days}d #{hours}h"
    elsif hours > 0
      "#{hours}h #{minutes}m"
    else
      "#{minutes}m #{seconds}s"
    end
  end

  def empty_form_object
    ''
  end

end
