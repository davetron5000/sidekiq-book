module ApplicationHelper
  # Used to render a <label> tag that is styled with errors if the field
  # it is labeling has errors
  #
  # f - the yielded form object
  # field - the name of the field or attribute
  # record - the active record/model that could have errors on field
  # css_class - CSS classes to add to the label in either state
  # label_override - set this to override the label's text
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

  # Renders a reasonable accessible <span> tag containing an emoji, with markup appropriate for 
  # screen readers (I hope :). The idea is to avoid adding emojis without descriptions by making it
  # easy to add both.
  #
  # emoji_instance_or_char - either an Emoji instance or a single character string containing an emoji
  # description_or_nil - if emoji_instance_or_char is a single character string, this is the description of the emoji
  # css_class - CSS classes to add to the span
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
