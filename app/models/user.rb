class User < ActiveRecord::Base
  def full_name
    "#{first_name} #{last_name}"
  end

  def self.cached_find(id)
    Rails.cache.fetch(['user', id], expires_in: 5.minutes) { find(id) }
  end

  after_commit :flush_cache

  private

  def flush_cache
    Rails.cache.delete(['user', id])
  end
end
