module FeesHelper

  def fee_debit(fee)
    debit_link, debit_object = '', ''

    case fee.debit.class.to_s  
    when 'User'
      debit_link =  user_link(fee.debit)
      debit_object = User.find(fee.debit_id)
    when 'Group'
      debit_link =   group_link(fee.debit)
      debit_object = Group.find(fee.debit_id)
    when 'Schedule'
      debit_link =  schedule_link(fee.debit)
      debit_object = Schedule.find(fee.debit_id)
    when 'Marker'
      debit_link =  marker_link(fee.debit)
      debit_object = Marker.find(fee.debit_id)
    when 'Challenge'
      debit_link =  item_name_link(
      fee.debit)
      debit_object = Challenge.find(fee.debit_id)
    end
    return debit_link, debit_object
  end

  def fee_credit(fee)
    credit_link, credit_object = '', ''

    case fee.credit.class.to_s
    when 'User'
      credit_link =  user_link(fee.credit)
      credit_object = User.find(fee.credit_id)
    when 'Group'
      credit_link =   group_link(fee.credit)
      credit_object = Group.find(fee.credit_id)
    when 'Schedule'
      credit_link =  schedule_link(fee.credit)
      credit_object = Schedule.find(fee.credit_id)
    when 'Marker'
      credit_link =  marker_link(fee.credit)
      credit_object = Marker.find(fee.credit_id)
    when 'Challenge'
      credit_link =  item_name_link(
      fee.credit)
      credit_object = Challenge.find(fee.credit_id)
    end
    return credit_link, credit_object
  end

  def fee_item(fee)
    item_link, item_object = '', ''

    case fee.item.class.to_s
    when 'User'
      item_link =  user_link(fee.item)
      item_object = User.find(fee.item_id)
    when 'Group'
      item_link =   group_link(fee.item)
      item_object = Group.find(fee.item_id)
    when 'Schedule'
      item_link =  schedule_link(fee.item)
      item_object = Schedule.find(fee.item_id)
    when 'Marker'
      item_link =  marker_link(fee.item)
      item_object = Marker.find(fee.item_id)  
    when 'Challenge'
      item_link =  item_name_link(
      fee.item)
      item_object = Challenge.find(fee.item_id)
    end
    return item_link, item_object
  end
  
  def fee_group_user(group, user, is_subscriber)
    fees, payments, debit_fee, debit_payment = [], [], [], []
		
    Fee.debit_user_item_schedule(user, group, fees, is_subscriber)
    Payment.debit_user_item_schedule(user, group, payments)	
    debit_fee = Fee.sum_debit_amount_fee(fees)
    debit_payment = Payment.sum_debit_payment(payments)
    return fees, payments, debit_fee, debit_payment
  end
end

