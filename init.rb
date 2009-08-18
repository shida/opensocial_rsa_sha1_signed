# Include hook code here
require "opensocial_rsa_sha1_signed"
ActionController::Base.send(:include, OpenSocial::Authentication::RsaSha1Signed)
