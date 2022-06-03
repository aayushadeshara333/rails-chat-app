class ApplicationController < ActionController::Base
  include Pagy::Backend
  before_action :turbo_frame_request_variant

  before_action :configure_permitted_parameters, if: :devise_controller?

  def self.render_with_signed_in_user(user, *args)
    ActionController::Renderer::RACK_KEY_TRANSLATION['warden'] ||= 'warden'
    proxy = Warden::Proxy.new({}, Warden::Manager.new({})).tap{|i| i.set_user(user, scope: :user, run_callbacks: false) }
    renderer = self.renderer.new('warden' => proxy)
    renderer.render(*args)
  end
  
  def after_sign_out_path_for(resources)
    root_path
  end
  
  private
  
  def turbo_frame_request_variant
    request.variant = :turbo_frame if turbo_frame_request?
  end
  protected

  def configure_permitted_parameters
    attributes = [:name, :email]
    devise_parameter_sanitizer.permit(:sign_up, keys: attributes)
    devise_parameter_sanitizer.permit(:account_update, keys: attributes)
  end
end
