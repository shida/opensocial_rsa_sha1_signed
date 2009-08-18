# OpensocialRsaSha1Signed
module OpenSocial
  module Authentication
    module RsaSha1Signed

      def self.included(base)
        base.class_eval do
          include InstanceMethods
        end
      end

      module InstanceMethods
        def opensocial_signed_required

          require 'oauth'
          require 'oauth/signature/rsa/sha1'
          require 'oauth/request_proxy/action_controller_request'

          cert    = OPENSOCIAL_CERTIFICATES[params[:oauth_consumer_key]]
          app_url = OPENSOCIAL_APP_URLS[params[:oauth_consumer_key]]

          authrized = false

          if params[:oauth_signature_method] == 'RSA-SHA1' &&
              ! cert.blank? &&
              params[:opensocial_app_url] == app_url

            consumer = OAuth::Consumer.new(nil,
                                           cert,
                                           {:signature_method=>'RSA-SHA1'})
            begin
              signature = OAuth::Signature.build(request) do
                [nil, consumer.secret]
              end
              if signature.verify
                authrized = true
              end
            rescue OAuth::Signature::UnknownSignatureMethod => e
            end
          end

          unless authrized
            render :text => '401 Unauthorized', :status => :unauthorized
            return false
          end
        end
      end
    end
  end
end

