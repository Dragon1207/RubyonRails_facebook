module StaticPagesHelper
  def resource
    @resource ||= User.new
  end

  def resource_name
    :user
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def resource_class
    Struct.new(:omniauth_providers).new(['facebook'])
  end
end
