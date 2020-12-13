require 'net/http'

module Api
  module V1
    class RatesController < ApplicationController
      def index
        res = GetRates.new(checked_params).call

        if res.success
          render json: res.entry,
                 status: :ok
        else
          render json: res.body, status: :unprocessable_entity
        end
      end

      private

      def checked_params
        params.require(:base)
        params.require(:other)
        params.permit(:date, :base, :other)
              .merge(other: other)
      end

      def other
        params['other'].split(',').first.strip
      end
    end
  end
end
