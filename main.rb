require 'optparse'
require 'json'
require_relative 'database'

db = Database.new


options = {}
result = {}

OptionParser.new do |opt|
  opt.on('--user_id USER_ID') { |o| options[:user_id] = o }
  opt.on('--loyalty_card_id LOYALTY_CARD_ID') { |o| options[:loyalty_card_id] = o }
end.parse!


if options[:user_id]

  userId = options[:user_id].to_i
  userRewards = db.getUserRewards(userId)
  userRewards.each do |reward| 
    cardId = reward[:id].to_i
    loyaltyCard = db.getLoyaltyCard(cardId).to_h
    reward[:name] = loyaltyCard["name"]
  end
  
  totalPoints = userRewards.sum { |reward| reward[:points] }   


  result = {
    id: userId,
    total_points: totalPoints,
    loyalty_cards: userRewards
  }
end

puts JSON.pretty_generate(result)