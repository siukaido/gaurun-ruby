require 'virtus'

module Gaurun
  class Notification
    attr_accessor :ios, :android

    def initialize(message: '')
      @ios     = Gaurun::Notification::IOS.new(message: message)
      @android = Gaurun::Notification::Android.new(message: message)
    end

    def payload
      notifications = [
        @ios.payload,
        @android.payload,
      ].delete_if { |v| v.empty? }

      return nil if notifications.empty?
      {
        notifications: notifications,
      }
    end

    class PlatformAbstract
      include Virtus.model

      attribute :token, Array[String]
      attribute :message, String
      attribute :extend, Hash

      def payload(platform)
        return {} if token.nil? || token.empty?

        attributes.merge(
          token: token.uniq,
          platform: platform,
          extend: expand_extend
        ).delete_if { |_, v| v.nil? }
      end

      private

      def expand_extend
        return nil if extend.nil?

        extend.map do |k, v|
          {
            key: k.to_s,
            val: v.to_s,
          }
        end
      end
    end

    class IOS < PlatformAbstract
      attribute :title, String
      attribute :subtitle, String
      attribute :badge, Integer
      attribute :category, String
      attribute :sound, String
      attribute :expiry, Integer
      attribute :content_available, Boolean
      attribute :mutable_content, Boolean

      def payload
        super(Gaurun::PLATFORM_IOS)
      end
    end

    class Android < PlatformAbstract
      attribute :collapse_key, String
      attribute :delay_while_idle, Boolean
      attribute :time_to_live, Integer

      def payload
        super(Gaurun::PLATFORM_ANDROID)
      end
    end
  end
end
