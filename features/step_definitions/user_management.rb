Given /^the following users exist:$/ do |item_list|
  item_list.hashes.each do |item|
    User.create!(item)
  end  
end

Given /^the following priviledges exist:$/ do |item_list|
  item_list.hashes.each do |item|
    Priviledge.create!(item)
  end  
end

Given /^the following priviledges_users exist:$/ do |item_list|
  item_list.hashes.each do |item|
    priviledge = Priviledge.find_by_id(item[:priviledge_id])
    user = User.find_by_id(item[:user_id])
    priviledge.users << user
    user.priviledges << priviledge
    priviledge.save!
    user.save!
  end
end

Then /^I should see names and studentIDs of the following users: (.*)$/ do |lst|
  if lst.class == String
    user_list = lst.split(/[, "]+/)
    user_list.each do |user|
      id = User.find_by_name(user).id
      if page.respond_to? :should
        page.should have_content(user)
      else
        assert page.has_content?(user)
      end
      if page.respond_to? :should
        page.should have_content(id)
      else
        assert page.has_content?(id)
      end
    end
  end
end

When /^I follow detail of (.*)$/ do |user|
  page.find_by_id(user+"_detail").click
end

When /^I follow "(.*)" in switch of priviledge (.*)/ do |sign, priviledge|
  page.find_by_id(priviledge+"_switch").find_link(sign).click
end

And /^I should see all priviledges displayed$/ do
  Priviledge.all.each do |priviledge|
    if page.respond_to? :should
        page.should have_content(priviledge.name)
      else
        assert page.has_content?(priviledge.name)
      end
  end
end

And /^I should see "(.*)" displayed in the following priviledges: (.*)$/ do |sign, lst|
  if lst.class == String
    lst.split(/[, "]+/).each do |priviledge|
      block = page.find_by_id(priviledge+"_switch")
      if block.respond_to? :should
        block.should have_content(sign)
      else
        assert block.has_content?(sign)
      end
    end
  end
end
