module PaymentsHelper

  def payment_debit(payment)
    debit_link, debit_object = '', ''

    case payment.debit.class.to_s  
    when 'User'
      debit_link =  user_link(payment.debit)
      debit_object = User.find(payment.debit_id)
    when 'Group'
      debit_link =   group_link(payment.debit)
      debit_object = Group.find(payment.debit_id)
    when 'Schedule'
      debit_link =  schedule_link(payment.debit)
      debit_object = Schedule.find(payment.debit_id)
    when 'Marker'
      debit_link =  marker_link(payment.debit)
      debit_object = Marker.find(payment.debit_id)   
    end
    return debit_link, debit_object
  end

  def payment_credit(payment)
    credit_link, credit_object = '', ''

    case payment.credit.class.to_s
    when 'User'
      credit_link =  user_link(payment.credit)
      credit_object = User.find(payment.credit_id)
    when 'Group'
      credit_link =   group_link(payment.credit)
      credit_object = Group.find(payment.credit_id)
    when 'Schedule'
      credit_link =  schedule_link(payment.credit)
      credit_object = Schedule.find(payment.credit_id)
    when 'Marker'
      credit_link =  marker_link(payment.credit)
      credit_object = Marker.find(payment.credit_id)   
    end
    return credit_link, credit_object
  end

  def payment_item(payment)
    item_link, item_boject = '', ''

    case payment.item.class.to_s
    when 'User'
      item_link =  user_link(payment.item)
      item_object = User.find(payment.item_id)
    when 'Group'
      item_link =   group_link(payment.item)
      item_object = Group.find(payment.item_id)
    when 'Schedule'
      item_link =  schedule_link(payment.item)
      item_object = Schedule.find(payment.item_id)
    when 'Marker'
      item_link =  marker_link(payment.item)
      item_object = Marker.find(payment.item_id)  
    end
    return item_link, item_object
  end
  
end

