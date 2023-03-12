module ApplicationHelper
  def label_showing_errors(f,field,record,css_class=nil,label_override=nil)
    label_css = begin
                  css = [css_class].compact
                  if record.errors[field].any?
                    css << "text-red-800"
                    css << "font-semibold"
                  else
                    css << "font-medium"
                  end
                  css.join(" ")
                end
    f.label field, (label_override || field.to_s.humanize), class: label_css
  end

  def emoji(emoji_instance_or_char,description_or_nil=nil, css_class: nil)
    emoji_instance = if emoji_instance_or_char.kind_of?(Emoji)
                       emoji_instance_or_char
                     else
                       Emoji.new(char: emoji_instance_or_char,description: description_or_nil)
                     end
    content_tag :span, class: css_class, role: "img", description: emoji_instance.description do
      emoji_instance.char
    end
  end
end
