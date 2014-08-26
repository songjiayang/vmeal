# encoding: utf-8
class StoreUser < ActiveRecord::Base
  has_one :store
  before_save :encrypt_password
  SECRET = Digest::SHA1.hexdigest("weidaxue.me")
  #店家密码加密
  def encrypt password
    encryptor = ActiveSupport::MessageEncryptor.new(SECRET)
    enpassword = encryptor.encrypt_and_sign(password)
  end
  
  #店家密码解密
  def decrypt password
    encryptor = ActiveSupport::MessageEncryptor.new(SECRET)
    depassword = encryptor.decrypt_and_verify(password)
  end
  
  private
  
  def encrypt_password
    self.password = encrypt(self.password)
  end
end
