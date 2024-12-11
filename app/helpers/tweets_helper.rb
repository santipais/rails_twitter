# frozen_string_literal: true

module TweetsHelper
  def posted_ago(tweet)
    elapsed_time = Time.zone.now - tweet.created_at

    case elapsed_time
    when 0..59
      "#{elapsed_time.to_i}s"
    when 60..3599
      "#{(elapsed_time / 60).to_i}m"
    when 3600..86_399
      "#{(elapsed_time / 3600).to_i}hs"
    else
      "#{(elapsed_time / 86_400).to_i}d"
    end
  end
end
