require 'net/http'

module Api
  module V1
    class RatesController < ApplicationController
      def index
        res = FixerRequest.new(checked_params).call

        if res.success
          render json: res.body, statuts: :ok
        else
          render json: res.body, status: :unprocessable_entity
        end
      end

      private

      def checked_params
        params.permit(:date, :base, :other)
      end
    end
  end
end
