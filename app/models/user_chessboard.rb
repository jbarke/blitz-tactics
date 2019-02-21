# custom user chessboard colors
#
class UserChessboard < ActiveRecord::Base
  belongs_to :user

  HEX_REGEX = /\A#[0-9A-F]{6}\z/

  COLOR_FIELDS = [
    :light_square_color,
    :dark_square_color,
    :selected_square_color,
    :opponent_from_square_color,
    :opponent_to_square_color,
  ]

  before_validation :nullify_blank_colors
  before_validation :capitalize_hex_colors

  COLOR_FIELDS.each do |color|
    validates color, format: HEX_REGEX, allow_nil: true
  end

  # returns nil if no styles defined, CSS string otherwise
  def to_css
    styles = []
    if light_square_color
      styles << "
        .chessboard .square.light {
          background: #{light_square_color} !important;
        }
        .chessboard .square .square-label.dark {
          color: #{light_square_color} !important;
        }
      "
    end
    if dark_square_color
      styles << "
        .chessboard .square.dark {
          background: #{dark_square_color} !important;
        }
        .chessboard .square .square-label.light {
          color: #{dark_square_color} !important;
        }
      "
    end
    if selected_square_color
      styles << "
        .chessboard .square[data-selected] {
          background: #{selected_square_color} !important;
        }
      "
    end
    if opponent_from_square_color
      styles << "
        .chessboard .square[data-from] {
          background: #{opponent_from_square_color} !important;
        }
      "
    end
    if opponent_to_square_color
      styles << "
        .chessboard .square[data-to] {
          background: #{opponent_to_square_color} !important;
        }
      "
    end
    return unless styles.length > 0
    styles.join("\n")
  end

  private

  def nullify_blank_colors
    COLOR_FIELDS.each do |field|
      send("#{field}=", nil) unless field.present?
    end
  end

  def capitalize_hex_colors
    COLOR_FIELDS.each do |field|
      send("#{field}=", send(field).upcase) if field.present?
    end
  end
end
