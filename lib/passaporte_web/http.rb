# encoding: utf-8
require 'base64'
module PassaporteWeb

  class Http # :nodoc:

    def self.get(path='/', params={}, type='application')
      get_or_delete(:get, path, params, type)
    end

    def self.put(path='/', body={}, params={}, type='application')
      put_or_post(:put, path, body, params, type)
    end

    def self.post(path='/', body={}, params={}, type='application')
      put_or_post(:post, path, body, params, type)
    end

    def self.delete(path='/', params={}, type='application')
      get_or_delete(:delete, path, params, type)
    end

    def self.custom_auth_get(user, password, path='/', params={})
      credentials = "Basic #{::Base64.strict_encode64("#{user}:#{password}")}"
      custom_params = common_params('application').merge({authorization: credentials})
      RestClient.get(
        pw_url(path),
        {params: params}.merge(custom_params)
      )
    end

    private

    def self.put_or_post(method, path, body, params, type)
      RestClient.send(
        method,
        pw_url(path),
        encoded_body(body),
        {params: params}.merge(common_params(type))
      )
    end

    def self.get_or_delete(method, path, params, type)
      RestClient.send(
        method,
        pw_url(path),
        {params: params}.merge(common_params(type))
      )
    end

    def self.pw_url(path)
      "#{PassaporteWeb.configuration.url}#{path}"
    end

    def self.common_params(type)
      {
        authorization: (type == 'application' ? PassaporteWeb.configuration.application_credentials : PassaporteWeb.configuration.user_credentials),
        content_type: :json,
        accept: :json,
        user_agent: PassaporteWeb.configuration.user_agent
      }
    end

    def self.encoded_body(body)
      body.is_a?(Hash) ? MultiJson.encode(body) : body
    end

  end

end
