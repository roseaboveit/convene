# Breakout Rooms are temporary, isolated places for folks to talk within a
# {Room}.
class BreakoutRoom < ApplicationRecord
  # The {Room} the Breakout Room is in
  belongs_to :room

  # Human-friendly description of the room.
  attribute :name, :string

  # URI-friendly description of the room.
  attribute :slug, :string
  validates :slug, uniqueness: { scope: :room_id }

  # Make uri-friendly slug unique to the {#room}
  extend FriendlyId
  friendly_id :name, use: :scoped, scope: :room

  # A Breakout Room's Publicity Level indicates who can know the breakout room
  # exists, as well as who may enter it.
  # `listed` - The room is accessible by anyone in the room
  # `internal` - The room is only accessible to space members and owners.
  attribute :publicity_level
  validates :publicity_level, presence: true, inclusion: { in: ['listed', 'internal', :listed, :internal] }

  # Once a Breakout Room expires, it is no longer enterable, and the current
  # occupants are sent back to the {Room}
  attribute :expires_on, :datetime
end
