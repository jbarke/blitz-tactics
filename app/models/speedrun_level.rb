class SpeedrunLevel < ActiveRecord::Base
  LEVELS_DIR = Rails.root.join("data/speedruns")

  NAMES = %w( quick endurance marathon )

  has_many :speedrun_puzzles, dependent: :destroy
  has_many :completed_speedruns, dependent: :destroy

  validates :name,
    presence: true,
    uniqueness: true

  NAMES.each do |name|
    scope name, -> { find_or_create_by(name: name) }
  end

  def self.today
    Date.today
  end

  def self.todays_date
    today.strftime "%b %-d, %Y"
  end

  def self.todays_level
    find_or_create_by(name: today.to_s)
  end

  def self.yesterday
    Date.yesterday
  end

  def self.yesterdays_level
    find_by(name: yesterday.to_s)
  end

  def self.two_days_ago_level
    find_by(name: 2.days.ago.to_date.to_s)
  end

  def self.first_level
    find_by(name: 'quick')
  end

  def puzzles
    # speedrun_puzzles.order('id ASC')
    open(LEVELS_DIR.join("speedrun-#{name}.json"), 'r') do |f|
      JSON.parse(f.read)
    end
  end

  def first_puzzle
    Puzzle.find(puzzles.first["id"])
  end

  def num_puzzles
    @num_puzzles ||= speedrun_puzzles.count
  end
end
