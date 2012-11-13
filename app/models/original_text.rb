class OriginalText < ActiveRecord::Base
  attr_accessible :body, :status, :parsed_body, :workday_date, :messages_count
  serialize :parsed_body
  has_one :workday
  before_save :parse_text

  def create_messages
    workday_id = Workday.create!(skype_date: workday_date).id
    parsed_body.each do |hash|
      Message.create(hash.merge!(:workday_id => workday_id))
    end
  end

  private

  def parse_text
    tmp_body = []
    body.split(/(\[.*\])/).each_with_index do |text,i|
      unless i%2 == 1
        member_id = nil
        MemberAlias.all.each do |ma|
          if text.sub!(ma.real_name,"")
            member_id =  ma.member_id
            break
          end
        end
        tmp_body << {:member_id => member_id, :body => text}
      end
    end
    self.parsed_body = tmp_body
    self.messages_count = tmp_body.count
  end

end
