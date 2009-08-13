module PaymentsHelper
end


# module PaymentsHelper
#   
#   def payment_debit(payment)
#     payment.debit
#   end
#   
#   def payment_credit(payment)
#     payment.credit
#   end  
#   
# private
#   
#     # Return the debit_type of payment.
#     # We switch on the class.to_s because the class itself is quite long
#     # (due to ActiveRecord).
#     def payment_debit_type(payment)
#       payment.debit.class.to_s      
#     end
# 
#   # Return the credit_type of payment.
#   # We switch on the class.to_s because the class itself is quite long
#   # (due to ActiveRecord).
#   def payment_credit_type(payment)
#     payment.credit.class.to_s      
#   end
# end
