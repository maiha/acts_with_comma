
ActiveRecord::Base.send :extend, ActsWithComma::DecodeComma
ActionView::Base.send :include,  ActsWithComma::EncodeComma
