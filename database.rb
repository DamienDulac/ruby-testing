require 'json'

class Database

    @@data
    def initialize()
        file = File.read("./input.json");
        @@data = JSON.parse(file);
    end

    def getUserRewards(userId)
        userRewards = @@data["rewards"].select {|reward| reward["user_id"] == userId } 

        usersRewardsGroupById = userRewards.group_by { |reward| reward['loyalty_card_id'] }.map do |_,newReward| 
            r = newReward.inject do |h1,h2|
              h1.merge(h2) do |key, oldValue, currentValue|
                if ["loyalty_card_id", "user_id"].include? key 
                  oldValue 
                else 
                  oldValue + currentValue
                end
              end
            end
            {:id => r["loyalty_card_id"], :points => r["points"]}
          end
          
          return usersRewardsGroupById
    end

    def getLoyaltyCard(cardId)
        return @@data["loyalty_cards"].find {|reward| reward["id"] == cardId } 
    end
end
